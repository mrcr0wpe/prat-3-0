--[[
    @File:      ChannelSticky.lua
    @Project:   Prat-3.0

    BR: Memória dos tipos de bate-papo.
        - Memorização por tipo de bate-papo
        - Continuação automática no último tipo usado
        - Grupo visual para reduzir redundância nas opções
        - Comando Grupo Inteligente para escolher o melhor bate-papo de grupo
        - Atualização dinâmica das opções conforme cores/canais
        - Compatibilidade com Retail e clientes clássicos

    EN: Chat type memory control.
        - Memory per chat type
        - Automatic continuation of the last used chat type
        - Visual group to reduce option redundancy
        - Smart Group command to choose the best group chat type
        - Dynamic option updates based on colors/channels
        - Compatibility with Retail and classic clients

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo Memória de Canal com eventos, timers e hooks
		EN: Creation of the Channel Memory module with events, timers and hooks
	------------------------------------------------]]--
	local module = Prat:NewModule("ChannelSticky", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	--[[------------------------------------------------
		BR: Tipos de bate-papo que podem ter memória de canal
		EN: Chat types that can use channel memory
	------------------------------------------------]]--
	local chat_types = {
		"SAY",
		"WHISPER",
		"YELL",
		"PARTY",
		"GUILD",
		"OFFICER",
		"RAID",
		"RAID_WARNING",
		"INSTANCE_CHAT",
		"CHANNEL",
		"EMOTE",
		"BN_WHISPER",
		"BN_CONVERSATION",
	}

	--[[------------------------------------------------
		BR: Rótulos curtos para tipos com nomes longos na interface
		EN: Short labels for chat types with long interface names
	------------------------------------------------]]--
	local short_chat_type_labels = {
		BN_WHISPER = PL["bn_whisper_short"],
		BN_CONVERSATION = PL["bn_conversation_short"],
	}

	--[[------------------------------------------------
		BR: Configuração dos valores padrão do módulo
		EN: Module default values configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module, {
		profile = {
			on = true,
			say = true,
			whisper = true,
			yell = true,
			party = true,
			guild = true,
			officer = true,
			raid = true,
			raid_warning = true,
			instance_chat = true,
			channel = true,
			emote = true,
			smart_group = true,
			bn_whisper = true,
			bn_conversation = true,
		}
	})

	--[[------------------------------------------------
		BR: Contêiner dinâmico para opções por tipo de bate-papo
		EN: Dynamic container for options per chat type
	------------------------------------------------]]--
	local chat_type_plugins = {
		chat_types = {
			channel_memory_group = {
				type = "group",
				name = PL["memory_group_name"],
				desc = PL["memory_group_desc"],
				inline = true,
				order = 100,
				args = {
					memory_group_help = {
						type = "description",
						name = PL["memory_group_help"],
						order = 5,
						width = "full",
					},
				},
			}
		}
	}

	--[[------------------------------------------------
		BR: Configuração das opções da interface do módulo
		EN: Module interface options configuration
	------------------------------------------------]]--
	Prat:SetModuleOptions(module, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		plugins = chat_type_plugins,
		args = {
			description = {
				type = "description",
				name = PL["full_description"],
				order = 10,
				width = "full",
			},

			spacer_after_description = {
				type = "description",
				name = "\n",
				order = 15,
				width = "full",
			},

			smart_group_group = {
				type = "group",
				name = PL["smart_group_group_name"],
				desc = PL["smart_group_group_desc"],
				inline = true,
				order = 200,
				args = {
					smart_group_help = {
						type = "description",
						name = PL["smart_group_group_help"],
						order = 10,
						width = "full",
					},

					smart_group = {
						name = PL["smart_group_name"],
						desc = PL["smart_group_desc"],
						type = "toggle",
						width = "full",
						order = 20,
					}
				}
			}
		}
	})

	--[[------------------------------------------------
		BR: Ativação do módulo e aplicação dos estados salvos
		EN: Module activation and application of saved states
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:build_channel_memory_options()

		self:RegisterEvent("UPDATE_CHAT_COLOR")

		local profile = self.db.profile

		self:set_channel_memory("SAY", profile.say)
		self:set_channel_memory("WHISPER", profile.whisper)
		self:set_channel_memory("YELL", profile.yell)
		self:set_channel_memory("PARTY", profile.party)
		self:set_channel_memory("GUILD", profile.guild)
		self:set_channel_memory("OFFICER", profile.officer)
		self:set_channel_memory("RAID", profile.raid)
		self:set_channel_memory("RAID_WARNING", profile.raid_warning)
		self:set_channel_memory("INSTANCE_CHAT", profile.instance_chat)
		self:set_channel_memory("CHANNEL", profile.channel)
		self:set_channel_memory("EMOTE", profile.emote)
		self:set_channel_memory("BN_WHISPER", profile.bn_whisper)
		self:set_channel_memory("BN_CONVERSATION", profile.bn_conversation)

		if profile.smart_group then
			self:register_smart_group(true)
		end
	end

	--[[------------------------------------------------
		BR: Desativação do módulo e restauração dos tipos não memorizados
		EN: Module deactivation and restoration of non-memorized types
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:set_channel_memory("SAY", false)
		self:set_channel_memory("WHISPER", false)
		self:set_channel_memory("YELL", false)
		self:set_channel_memory("PARTY", false)
		self:set_channel_memory("GUILD", false)
		self:set_channel_memory("OFFICER", false)
		self:set_channel_memory("RAID", false)
		self:set_channel_memory("RAID_WARNING", false)
		self:set_channel_memory("INSTANCE_CHAT", false)
		self:set_channel_memory("CHANNEL", false)
		self:set_channel_memory("EMOTE", false)
		self:set_channel_memory("BN_WHISPER", false)
		self:set_channel_memory("BN_CONVERSATION", false)

		self:UnregisterAllEvents()
		self:UnhookAll()

		self:register_smart_group(false)
	end

	--[[------------------------------------------------
		BR: Retorna a descrição localizada do módulo
		EN: Returns the localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Agenda reconstrução das opções quando as cores mudam
		EN: Schedules option rebuilding when chat colors change
	------------------------------------------------]]--
	function module:UPDATE_CHAT_COLOR()
		self:ScheduleTimer("build_channel_memory_options", 1)
	end

	--[[------------------------------------------------
		BR: Ajusta o Grupo Inteligente antes do envio no fluxo Retail
		EN: Adjusts Smart Group before sending in the Retail flow
	------------------------------------------------]]--
	function module:chat_edit_send_text_retail(editBox)
		if editBox:GetAttribute("chatType") == "SMARTGROUP" then
			editBox:SetAttribute("chatType", self:get_smart_group_chat_type())
		end
	end

	--[[------------------------------------------------
		BR: Ajusta o Grupo Inteligente no fluxo clássico de envio
		EN: Adjusts Smart Group in the classic send flow
	------------------------------------------------]]--
	function module:ChatEdit_SendText(editBox)
		if self.group_say then
			editBox:SetAttribute("chatType", "SMARTGROUP")
			self.group_say = nil
		end
	end

	--[[------------------------------------------------
		BR: Ativa ou desativa a memória de um tipo de bate-papo
		EN: Enables or disables memory for a chat type
	------------------------------------------------]]--
	function module:set_channel_memory(chat_type, enabled)
		local chat_type_info = ChatTypeInfo[chat_type:upper()]
		if chat_type_info then
			chat_type_info.sticky = enabled and 1 or 0
		end
	end

	--[[------------------------------------------------
		BR: Utilitário de cores usado para destacar tipos nas opções
		EN: Color utility used to highlight chat types in options
	------------------------------------------------]]--
	local CLR = Prat.CLR

	local function colorize_chat_type_label(text, chat_type)
		return CLR:Colorize(module:get_chat_color(chat_type), text)
	end

	--[[------------------------------------------------
		BR: Retorna o nome exibido de um tipo de bate-papo
		EN: Returns the display label for a chat type
	------------------------------------------------]]--
	function module:get_chat_type_label(chat_type)
		if short_chat_type_labels[chat_type] then
			return short_chat_type_labels[chat_type]
		elseif chat_type == "INSTANCE_CHAT" then
			return _G["INSTANCE_CHAT"]
		elseif chat_type ~= "CHANNEL" then
			return _G["CHAT_MSG_" .. chat_type]
		else
			return PL["channel_name"]
		end
	end

	--[[------------------------------------------------
		BR: Reconstrói dinamicamente a lista de opções por tipo
		EN: Dynamically rebuilds the option list per chat type
	------------------------------------------------]]--
	function module:build_channel_memory_options()
		local group_args = chat_type_plugins["chat_types"].channel_memory_group.args

		for index, chat_type in ipairs(chat_types) do
			local profile_key = chat_type:lower()
			local chat_label = self:get_chat_type_label(chat_type)
			local display_label = colorize_chat_type_label((PL["remember_type_name"]):format(chat_label), chat_type)

			group_args[profile_key] = group_args[profile_key] or {
				type = "toggle",
			}

			group_args[profile_key].name = display_label
			group_args[profile_key].desc = (PL["remember_type_desc"]):format(chat_label)
			group_args[profile_key].order = index * 10
			group_args[profile_key].width = 1

			if index % 2 == 1 then
				local spacer_key = profile_key .. "_spacer"

				group_args[spacer_key] = group_args[spacer_key] or {
					type = "description",
					name = " ",
				}

				group_args[spacer_key].order = (index * 10) + 1
				group_args[spacer_key].width = 0.3
			end
		end
	end

	--[[------------------------------------------------
		BR: Aplica alterações feitas pelo usuário nas opções
		EN: Applies user changes made in the module options
	------------------------------------------------]]--
	function module:OnValueChanged(info, enabled)
		local option_key = info[#info]

		if option_key == "smart_group" then
			self:register_smart_group(enabled)
		else
			self:set_channel_memory(option_key, enabled)
		end
	end

	--[[------------------------------------------------
		BR: Recupera a cor hexadecimal de um tipo de bate-papo
		EN: Retrieves the hexadecimal color of a chat type
	------------------------------------------------]]--
	function module:get_chat_color(chat_type)
		local chat_type_info = ChatTypeInfo[chat_type]
		if not chat_type_info then
			return CLR.COLOR_NONE
		end
		return CLR:GetHexColor(chat_type_info)
	end

	--[[------------------------------------------------
		BR: Registra ou remove o comando Grupo Inteligente e seus hooks
		EN: Registers or removes the Smart Group command and hooks
	------------------------------------------------]]--
	function module:register_smart_group(enabled)
		if not self.smart_group and enabled then
			Prat.RegisterChatEvent(self, Prat.Events.OUTBOUND)

			if ChatFrame1EditBox and ChatFrame1EditBox.OnPreSendText then
				EventRegistry:RegisterCallback("ChatFrame.OnEditBoxPreSendText", function(_, editBox)
					local success, ret = pcall(function()
						module:chat_edit_send_text_retail(editBox)
					end)

					if not success then
						geterrorhandler()(ret)
					end
				end)
			else
				self:SecureHook("ChatEdit_SendText")
			end

			self.smart_group = true

			SLASH_SMARTGROUP1 = "/smart"
			SLASH_SMARTGROUP2 = "/smrt"
			ChatTypeInfo["SMARTGROUP"] = { r = 0.5, g = 0.9, b = 0.9, sticky = 1 }
			CHAT_SMARTGROUP_SEND = "SmartGroup:\32"
			CHAT_SMARTGROUP_GET = "SmartGroup: %1\32"
		else
			Prat.UnregisterAllChatEvents(self)
			self:UnhookAll()

			self.smart_group = false

			SLASH_SMARTGROUP1 = nil
			SLASH_SMARTGROUP2 = nil
			ChatTypeInfo["SMARTGROUP"] = nil
			CHAT_SMARTGROUP_SEND = nil
			CHAT_SMARTGROUP_GET = nil
		end
	end

	--[[------------------------------------------------
		BR: Escolhe automaticamente o melhor tipo de bate-papo em grupo
		EN: Automatically chooses the best available group chat type
	------------------------------------------------]]--
	function module:get_smart_group_chat_type()
		if IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			local _, instanceType = IsInInstance()

			if instanceType == "arena" then
				return "PARTY"
			else
				return "INSTANCE_CHAT"
			end
		elseif IsInRaid() then
			return "RAID"
		elseif IsInGroup() then
			return "PARTY"
		else
			return "SAY"
		end
	end

	--[[------------------------------------------------
		BR: Substitui SMARTGROUP pelo tipo real antes do envio
		EN: Replaces SMARTGROUP with the real type before sending
	------------------------------------------------]]--
	function module:Prat_OutboundChat(_, message)
		if message.CTYPE == "SMARTGROUP" then
			self.group_say = true
			message.CTYPE = self:get_smart_group_chat_type()
		end
	end

	return
end)
