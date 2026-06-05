--[[
    @File:      NewcomersChat.lua
    @Project:   Prat-3.0

    BR: Configura ícones e labels para Guides e Newcomers no chat.
        - Módulo exclusivo para Retail
        - Marca mensagens de Guides e Newcomers
        - Suporte a ícone de Newcomer
        - Suporte a ícone e label de Guide
        - Opções separadas para canal Newcomers e chat normal
        - Integração com o sistema moderno de Mentorship da Blizzard

    EN: Configures icons and labels for Guides and Newcomers in chat.
        - Retail-only module
        - Marks Guide and Newcomer messages
        - Newcomer icon support
        - Guide icon and label support
        - Separate options for Newcomers channel and normal chat
        - Integration with Blizzard's modern Mentorship system

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Este módulo depende de APIs modernas exclusivas do Retail
    EN: This module depends on modern Retail-only APIs
------------------------------------------------]]--
if not Prat.IsRetail then
	return
end

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo de marcações do Newcomers Chat
		EN: Creation of the Newcomers Chat marker module
	------------------------------------------------]]--
	local module = Prat:NewModule("NewcomersChat")

	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	--[[------------------------------------------------
		BR: Valores padrão do módulo
		EN: Module default values
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			as_newcomer = {
				newcomer_icon = {
					in_newcomers_chat = false,
					in_normal_chat = false,
				},
				guide_icon = {
					in_newcomers_chat = true,
					in_normal_chat = false,
				},
				guide_label = {
					in_newcomers_chat = true,
					in_normal_chat = false,
				},
			},
			as_guide = {
				newcomer_icon = {
					in_newcomers_chat = true,
					in_normal_chat = true,
				},
				guide_icon = {
					in_newcomers_chat = true,
					in_normal_chat = false,
				},
				guide_label = {
					in_newcomers_chat = true,
					in_normal_chat = false,
				},
			},
		},
	})

	--[[------------------------------------------------
		BR: Migra chaves antigas de profile para snake_case
		EN: Migrates old profile keys to snake_case
	------------------------------------------------]]--
	local function migrate_profile(profile)
		if not profile then
			return
		end

		if profile.asNewcomer ~= nil and profile.as_newcomer == nil then
			profile.as_newcomer = profile.asNewcomer
		end
		profile.asNewcomer = nil

		if profile.asGuide ~= nil and profile.as_guide == nil then
			profile.as_guide = profile.asGuide
		end
		profile.asGuide = nil

		local function migrate_perspective(perspective)
			if not perspective then
				return
			end

			if perspective.newcomerIcon ~= nil and perspective.newcomer_icon == nil then
				perspective.newcomer_icon = perspective.newcomerIcon
			end
			perspective.newcomerIcon = nil

			if perspective.guideIcon ~= nil and perspective.guide_icon == nil then
				perspective.guide_icon = perspective.guideIcon
			end
			perspective.guideIcon = nil

			if perspective.guideLabel ~= nil and perspective.guide_label == nil then
				perspective.guide_label = perspective.guideLabel
			end
			perspective.guideLabel = nil

			local function migrate_location(location)
				if not location then
					return
				end

				if location.inNewcomersChat ~= nil and location.in_newcomers_chat == nil then
					location.in_newcomers_chat = location.inNewcomersChat
				end
				location.inNewcomersChat = nil

				if location.inNormalChat ~= nil and location.in_normal_chat == nil then
					location.in_normal_chat = location.inNormalChat
				end
				location.inNormalChat = nil
			end

			migrate_location(perspective.newcomer_icon)
			migrate_location(perspective.guide_icon)
			migrate_location(perspective.guide_label)
		end

		profile.as_newcomer = profile.as_newcomer or {}
		profile.as_guide = profile.as_guide or {}

		profile.as_newcomer.newcomer_icon = profile.as_newcomer.newcomer_icon or {}
		profile.as_newcomer.guide_icon = profile.as_newcomer.guide_icon or {}
		profile.as_newcomer.guide_label = profile.as_newcomer.guide_label or {}

		profile.as_guide.newcomer_icon = profile.as_guide.newcomer_icon or {}
		profile.as_guide.guide_icon = profile.as_guide.guide_icon or {}
		profile.as_guide.guide_label = profile.as_guide.guide_label or {}

		migrate_perspective(profile.as_newcomer)
		migrate_perspective(profile.as_guide)

		if profile.as_newcomer.newcomer_icon.in_newcomers_chat == nil then
			profile.as_newcomer.newcomer_icon.in_newcomers_chat = false
		end
		if profile.as_newcomer.newcomer_icon.in_normal_chat == nil then
			profile.as_newcomer.newcomer_icon.in_normal_chat = false
		end
		if profile.as_newcomer.guide_icon.in_newcomers_chat == nil then
			profile.as_newcomer.guide_icon.in_newcomers_chat = true
		end
		if profile.as_newcomer.guide_icon.in_normal_chat == nil then
			profile.as_newcomer.guide_icon.in_normal_chat = false
		end
		if profile.as_newcomer.guide_label.in_newcomers_chat == nil then
			profile.as_newcomer.guide_label.in_newcomers_chat = true
		end
		if profile.as_newcomer.guide_label.in_normal_chat == nil then
			profile.as_newcomer.guide_label.in_normal_chat = false
		end

		if profile.as_guide.newcomer_icon.in_newcomers_chat == nil then
			profile.as_guide.newcomer_icon.in_newcomers_chat = true
		end
		if profile.as_guide.newcomer_icon.in_normal_chat == nil then
			profile.as_guide.newcomer_icon.in_normal_chat = true
		end
		if profile.as_guide.guide_icon.in_newcomers_chat == nil then
			profile.as_guide.guide_icon.in_newcomers_chat = true
		end
		if profile.as_guide.guide_icon.in_normal_chat == nil then
			profile.as_guide.guide_icon.in_normal_chat = false
		end
		if profile.as_guide.guide_label.in_newcomers_chat == nil then
			profile.as_guide.guide_label.in_newcomers_chat = true
		end
		if profile.as_guide.guide_label.in_normal_chat == nil then
			profile.as_guide.guide_label.in_normal_chat = false
		end
	end

	--[[------------------------------------------------
		BR: Cria grupo de opções reutilizável para canal de novatos/bate-papo normal
		EN: Creates reusable option group for newcomers channel/normal chat
	------------------------------------------------]]--
	local function create_display_location_group(name, description, order)
		return {
			name = name or "",
			desc = description or "",
			type = "group",
			inline = true,
			order = order,
			args = {
				in_newcomers_chat = {
					name = PL["in_newcomers_chat_name"],
					desc = PL["in_newcomers_chat_desc"],
					type = "toggle",
					order = 10,
					width = 1.25,
				},

				location_spacer = {
					type = "description",
					name = " ",
					order = 15,
					width = 0.15,
				},

				in_normal_chat = {
					name = PL["in_normal_chat_name"],
					desc = PL["in_normal_chat_desc"],
					type = "toggle",
					order = 20,
					width = 1.25,
				},
			}
		}
	end

	--[[------------------------------------------------
		BR: Cria aba de configuração para visualização como Novato ou Guia
		EN: Creates configuration tab for Newcomer or Guide perspective
	------------------------------------------------]]--
	local function create_perspective_tab(name, description, help_text)
		return {
			name = name or "",
			desc = description or "",
			type = "group",
			args = {
				perspective_help = {
					type = "description",
					name = help_text or "",
					order = 5,
					width = "full",
				},

				newcomer_icon = create_display_location_group(
					PL["newcomer_icon_group_name"],
					PL["newcomer_icon_group_desc"],
					10
				),

				guide_icon = create_display_location_group(
					PL["guide_icon_group_name"],
					PL["guide_icon_group_desc"],
					20
				),

				guide_label = create_display_location_group(
					PL["guide_label_group_name"],
					PL["guide_label_group_desc"],
					30
				),
			},
		}
	end

	--[[------------------------------------------------
		BR: Interface de configuração do módulo
		EN: Module configuration interface
	------------------------------------------------]]--
	Prat:SetModuleOptions(module, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		childGroups = "tab",
		get = function(info)
			migrate_profile(module.db.profile)
			return module.db.profile[info[#info - 2]][info[#info - 1]][info[#info]]
		end,
		set = function(info, value)
			migrate_profile(module.db.profile)
			module.db.profile[info[#info - 2]][info[#info - 1]][info[#info]] = value
		end,
		args = {
			overview = {
				type = "group",
				name = PL["overview_tab_name"],
				desc = PL["overview_tab_desc"],
				order = 10,
				args = {
					full_description = {
						type = "description",
						name = PL["full_description"],
						order = 10,
						width = "full",
					},

					quick_guide_header = {
						type = "header",
						name = PL["quick_guide_header"],
						order = 20,
					},

					quick_guide = {
						type = "description",
						name = PL["quick_guide"],
						order = 30,
						width = "full",
					},
				},
			},

			as_newcomer = create_perspective_tab(
				PL["as_newcomer_tab_name"],
				PL["as_newcomer_tab_desc"],
				PL["as_newcomer_help"]
			),

			as_guide = create_perspective_tab(
				PL["as_guide_tab_name"],
				PL["as_guide_tab_desc"],
				PL["as_guide_help"]
			),
		}
	})

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Registra processamento das mensagens do chat
		EN: Registers chat message processing
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db.profile)
		Prat.RegisterChatEvent(self, "Prat_FrameMessage")
	end

	--[[------------------------------------------------
		BR: Remove eventos registrados pelo módulo
		EN: Removes events registered by the module
	------------------------------------------------]]--
	function module:OnModuleDisable()
		Prat.UnregisterAllChatEvents(self)
	end

	--[[------------------------------------------------
		BR: Atlas/texturas e label usados na marcação visual
		EN: Atlas/textures and label used for visual marking
	------------------------------------------------]]--
	local guide_icon_markup = "|A:newplayerchat-chaticon-guide:0:0:0:0|a"
	local guide_text = "|cff81b558" .. PL["guide_label_text"] .. "|r"
	local newcomer_icon_markup = "|A:newplayerchat-chaticon-newcomer:0:0:0:0|a"

	--[[------------------------------------------------
		BR: Aplica ícones/labels conforme status e canal da mensagem
		EN: Applies icons/labels according to status and message channel
	------------------------------------------------]]--
	function module:apply_settings(settings, sender_status, message)
		message.FLAG = ""

		local rule_set = C_ChatInfo.GetChannelRulesetForChannelID(message.ARGS[7])
		if rule_set == Enum.ChatChannelRuleset.Mentor then
			if sender_status == "GUIDE" then
				if settings.guide_icon.in_newcomers_chat then
					message.FLAG = guide_icon_markup
				end
				if settings.guide_label.in_newcomers_chat then
					message.FLAG = message.FLAG .. guide_text
				end
				if settings.guide_icon.in_newcomers_chat or settings.guide_label.in_newcomers_chat then
					message.FLAG = message.FLAG .. " "
				end
			elseif sender_status == "NEWCOMER" then
				if settings.newcomer_icon.in_newcomers_chat then
					message.FLAG = newcomer_icon_markup
				end
			end

		else
			if sender_status == "GUIDE" then
				if settings.guide_icon.in_normal_chat then
					message.FLAG = guide_icon_markup
				end
				if settings.guide_label.in_normal_chat then
					message.FLAG = message.FLAG .. guide_text
				end
				if settings.guide_icon.in_normal_chat or settings.guide_label.in_normal_chat then
					message.FLAG = message.FLAG .. " "
				end
			elseif sender_status == "NEWCOMER" then
				if settings.newcomer_icon.in_normal_chat then
					message.FLAG = newcomer_icon_markup
				end
			end
		end
	end

	--[[------------------------------------------------
		BR: Detecta status Guide/Newcomer e aplica perfil adequado
		EN: Detects Guide/Newcomer status and applies proper profile
	------------------------------------------------]]--
	function module:Prat_FrameMessage(_, message)
		migrate_profile(self.db.profile)

		local sender_status = message.ARGS[6] or ""

		if sender_status ~= "GUIDE" and sender_status ~= "NEWCOMER" then
			return
		end

		if IsActivePlayerGuide() then
			self:apply_settings(self.db.profile.as_guide, sender_status, message)
		elseif C_PlayerMentorship.IsActivePlayerConsideredNewcomer() then
			self:apply_settings(self.db.profile.as_newcomer, sender_status, message)
		end
	end

	--[[------------------------------------------------
		BR: Alias legado para reduzir risco com chamadas antigas
		EN: Legacy alias to reduce risk from older calls
	------------------------------------------------]]--
	module.ApplySettings = module.apply_settings

	return
end) -- Prat:AddModuleToLoad
