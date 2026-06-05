--[[
    @File:      PopupMessage.lua
    @Project:   Prat-3.0

    BR: Exibição de mensagens importantes em popup.
        - Detecta mensagens contendo o nome do jogador
        - Suporta nomes monitorados configuráveis
        - Exibe mensagens via LibSink e popup próprio
        - Suporte a configuração por janela de chat
        - Animação visual com fade in/out
        - Proteção contra duplicação e recursão

    EN: Important message display through popup.
        - Detects messages containing the player's name
        - Supports configurable monitored names
        - Displays messages through LibSink and its own popup
        - Per-chat-window configuration support
        - Visual fade in/out animation
        - Duplication and recursion protection

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
		BR: Criação do módulo de popup com saída via LibSink
		EN: Creation of the popup module with LibSink output
	------------------------------------------------]]--
	local module = Prat:NewModule("PopupMessage", "LibSink-2.0")

	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	local events_emotes = {
		["CHAT_MSG_BG_SYSTEM_ALLIANCE"] = true,
		["CHAT_MSG_BG_SYSTEM_HORDE"] = true,
		["CHAT_MSG_BG_SYSTEM_NEUTRAL"] = true,
		["CHAT_MSG_EMOTE"] = true,
		["CHAT_MSG_TEXT_EMOTE"] = true,
		["CHAT_MSG_MONSTER_EMOTE"] = true,
		["CHAT_MSG_MONSTER_SAY"] = true,
		["CHAT_MSG_MONSTER_WHISPER"] = true,
		["CHAT_MSG_MONSTER_YELL"] = true,
		["CHAT_MSG_RAID_BOSS_EMOTE"] = true,
	}

	--[[------------------------------------------------
		BR: Eventos de sistema ignorados para evitar spam de popup
		EN: System events ignored to avoid popup spam
	------------------------------------------------]]--
	local events_ignore = {
		["CHAT_MSG_CHANNEL_NOTICE_USER"] = true,
		["CHAT_MSG_SYSTEM"] = true,
		["CHAT_MSG_PING"] = true,
	}

	--[[------------------------------------------------
		BR: Configuração dos valores padrão do módulo
		EN: Module default values configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = false,
			show_all = false,
			show = { ChatFrame1 = true },
			frame_alpha = 1.0,
			nicknames = {},
			sink_options = { ["sink20OutputSink"] = "Popup" },
		}
	})

	--[[------------------------------------------------
		BR: Opções dinâmicas de saída fornecidas pelo LibSink
		EN: Dynamic output options provided by LibSink
	------------------------------------------------]]--
	local plugin_options = { sink = {} }

	--[[------------------------------------------------
		BR: Construção da interface de configuração do módulo
		EN: Module configuration interface construction
	------------------------------------------------]]--
	Prat:SetModuleOptions(module, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		childGroups = "tab",
		args = {
			overview = {
				name = PL["overview_tab_name"],
				desc = PL["overview_tab_desc"],
				type = "group",
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

			output = {
				name = PL["output_tab_name"],
				desc = PL["output_tab_desc"],
				type = "group",
				plugins = plugin_options,
				order = 100,
				args = {
					output_help = {
						type = "description",
						name = PL["output_help"],
						order = 10,
						width = "full",
					},
				},
			},

			windows = {
				name = PL["windows_tab_name"],
				desc = PL["windows_tab_desc"],
				type = "group",
				order = 200,
				args = {
					windows_help = {
						type = "description",
						name = PL["windows_help"],
						order = 10,
						width = "full",
					},

					show_all = {
						name = PL["show_all_name"],
						desc = PL["show_all_desc"],
						type = "toggle",
						order = 20,
						width = "full",
					},

					show = {
						name = PL["show_name"],
						desc = PL["show_desc"],
						type = "multiselect",
						order = 30,
						width = "full",
						values = Prat.HookedFrameList,
						get = "GetSubValue",
						set = "SetSubValue"
					},
				},
			},

			names = {
				name = PL["names_tab_name"],
				desc = PL["names_tab_desc"],
				type = "group",
				order = 300,
				args = {
					names_help = {
						type = "description",
						name = PL["names_help"],
						order = 10,
						width = "full",
					},

					names_group = {
						name = PL["names_group_name"],
						desc = PL["names_group_desc"],
						type = "group",
						inline = true,
						order = 20,
						args = {
							add_nick = {
								name = PL["add_name"],
								desc = PL["add_desc"],
								type = "input",
								order = 10,
								width = 1.60,
								usage = PL["add_usage"],
								get = false,
								set = function(info, name)
									info.handler:add_nickname(name)
								end
							},

							remove_nick = {
								name = PL["remove_name"],
								desc = PL["remove_desc"],
								type = "select",
								order = 20,
								width = 1.60,
								get = function()
									return ""
								end,
								values = function(info)
									return info.handler.db.profile.nicknames
								end,
								disabled = function(info)
									return #info.handler.db.profile.nicknames == 0
								end,
								set = function(info, value)
									info.handler:remove_nickname(value)
								end
							},

							clear_nick = {
								name = PL["clear_name"],
								desc = PL["clear_desc"],
								type = "execute",
								order = 30,
								width = 1.30,
								disabled = function(info)
									return #info.handler.db.profile.nicknames == 0
								end,
								func = "clear_nickname",
							},
						},
					},
				},
			},

			appearance = {
				name = PL["appearance_tab_name"],
				desc = PL["appearance_tab_desc"],
				type = "group",
				order = 400,
				args = {
					appearance_help = {
						type = "description",
						name = PL["appearance_help"],
						order = 10,
						width = "full",
					},

					frame_alpha = {
						name = PL["frame_alpha_name"],
						desc = PL["frame_alpha_desc"],
						type = "range",
						order = 20,
						min = 0,
						max = 1,
						step = 0.05,
						isPercent = true,
					},
				},
			},
		},
	})

	--[[------------------------------------------------
		BR: Migra chaves antigas de profile para o padrão snake_case
		EN: Migrates old profile keys to the snake_case standard
	------------------------------------------------]]--
	local function migrate_profile(profile)
		if not profile then
			return
		end

		if profile.showall ~= nil and profile.show_all == nil then
			profile.show_all = profile.showall
		end
		profile.showall = nil

		if profile.framealpha ~= nil and profile.frame_alpha == nil then
			profile.frame_alpha = profile.framealpha
		end
		profile.framealpha = nil

		if profile.nickname ~= nil and profile.nicknames == nil then
			profile.nicknames = profile.nickname
		end
		profile.nickname = nil

		if profile.sinkoptions ~= nil and profile.sink_options == nil then
			profile.sink_options = profile.sinkoptions
		end
		profile.sinkoptions = nil

		profile.show = profile.show or {}
		profile.nicknames = profile.nicknames or {}
		profile.sink_options = profile.sink_options or { ["sink20OutputSink"] = "Popup" }
		if profile.frame_alpha == nil then
			profile.frame_alpha = 1.0
		end
		if profile.show_all == nil then
			profile.show_all = false
		end
	end

	--[[------------------------------------------------
		BR: Registra saída Popup no LibSink e prepara opções de sink
		EN: Registers Popup output in LibSink and prepares sink options
	------------------------------------------------]]--
	Prat:SetModuleInit(module,
		function(self)
			migrate_profile(self.db.profile)

			self:RegisterSink(PL["popup_sink_name"],
				PL["module_name"],
				PL["popup_sink_desc"],
				"Popup")
			self:SetSinkStorage(self.db.profile.sink_options)

			plugin_options.sink["output"] = self:GetSinkAce3OptionsDataTable()
			plugin_options.sink["output"].name = PL["sink_group_name"]
			plugin_options.sink["output"].desc = PL["sink_group_desc"]
			plugin_options.sink["output"].inline = true

			self.db.profile.show = self.db.profile.show or {}
		end)

	--[[------------------------------------------------
		BR: Ativa processamento de mensagens e compila padrões de nomes
		EN: Enables message processing and compiles name patterns
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db.profile)

		Prat.RegisterChatEvent(self, Prat.Events.POST_ADDMESSAGE)

		self.nick_patterns = {}
		for _, name in ipairs(self.db.profile.nicknames) do
			self.nick_patterns[name] = Prat.GetNamePattern(name)
		end
		self.nickpat = self.nick_patterns -- Legacy runtime compatibility.

		self.player_name = Prat.GetNamePattern(UnitName("player"))
		self.playerName = self.player_name -- Legacy runtime compatibility.
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	-- /dump module.moduleOptions.args.output.get():find("Default")
	-- /script module.moduleOptions.args.output.set("PopupMessage")
	-- /dump module.db.profile
	-- /script module.db.profile.sink10OutputSink = nil

	--[[------------------------------------------------
		BR: Exibe popup visual com animação e cor da mensagem
		EN: Displays visual popup with animation and message color
	------------------------------------------------]]--
	function module:Popup(_, text, r, g, b)
		if Prat_PopupFrame.anim then
			Prat_PopupFrame.anim:Stop()
		else
			Prat_PopupFrame.anim = Prat_PopupFrame:CreateAnimationGroup()
			Prat_PopupFrame.anim:SetScript("OnFinished", function()
				Prat_PopupFrameText:Hide()
			end)

			local fade_in = Prat_PopupFrame.anim:CreateAnimation("Alpha")
			fade_in:SetDuration(1)
			fade_in:SetToAlpha(module.db.profile.frame_alpha or 1)
			fade_in:SetEndDelay(4)
			fade_in:SetOrder(1)

			local fade_out = Prat_PopupFrame.anim:CreateAnimation("Alpha")
			fade_out:SetDuration(5)
			fade_out:SetToAlpha(0)
			fade_out:SetOrder(2)
		end

		Prat_PopupFrameText:SetTextColor(r, g, b)
		Prat_PopupFrameText:SetText(text)

		local font, _, style = ChatFrame1:GetFont()
		local _, font_size = GameFontNormal:GetFont()
		Prat_PopupFrameText:SetFont(font, font_size, style)
		Prat_PopupFrameText:SetNonSpaceWrap(false)
		Prat_PopupFrame:SetWidth(math.min(math.max(64, Prat_PopupFrameText:GetStringWidth() + 20), 520))
		Prat_PopupFrame:SetHeight(64)
		Prat_PopupFrame:SetBackdropBorderColor(r, g, b)

		Prat_PopupFrameText:ClearAllPoints()
		Prat_PopupFrameText:SetPoint("TOPLEFT", Prat_PopupFrame, "TOPLEFT", 10, 10)
		Prat_PopupFrameText:SetPoint("BOTTOMRIGHT", Prat_PopupFrame, "BOTTOMRIGHT", -10, -10)
		Prat_PopupFrameText:Show()

		Prat_PopupFrame:SetAlpha(0)
		Prat_PopupFrame:Show()
		Prat_PopupFrame.anim:Play()
	end

	--[[------------------------------------------------
		BR: Flag de debug herdada; em build normal permanece nil
		EN: Inherited debug flag; remains nil in normal build
	------------------------------------------------]]--
	local DEBUG
	--[==[@debug@
	DEBUG = true
	--@end-debug@]==]

	--[[------------------------------------------------
		BR: Analisa mensagens após entrada no chat e dispara popup se necessário
		EN: Analyzes messages after chat insertion and triggers popup if needed
	------------------------------------------------]]--
	function module:Prat_PostAddMessage(_, message, frame, event, _, r, g, b)
		if self.pouring then
			return
		end

		if message.LINE_ID and
			message.LINE_ID == self.last_event and
			self.last_event_type == event then
			return
		end

		if not (events_emotes[event] or events_ignore[event]) then
			if self.db.profile.show_all or self.db.profile.show[frame:GetName()] then
				if DEBUG or not (message.ORG.PLAYER and self.player_name and message.ORG.PLAYER:match(self.player_name)) then
					self:check_text(message.ORG.MESSAGE, message.OUTPUT, event, r, g, b, message.LINE_ID)
				end
			end
		end
	end

	--[[------------------------------------------------
		BR: Adiciona nickname/nome alternativo à lista monitorada
		EN: Adds an alternate monitored name to the monitored list
	------------------------------------------------]]--
	function module:add_nickname(name)
		if not name or name == "" then
			return
		end

		for _, existing_name in ipairs(self.db.profile.nicknames) do
			if existing_name:lower() == name:lower() then
				return
			end
		end

		tinsert(self.db.profile.nicknames, name)

		self.nick_patterns[name] = Prat.GetNamePattern(name)
		self.nickpat = self.nick_patterns
	end

	--[[------------------------------------------------
		BR: Remove nome monitorado pelo índice selecionado
		EN: Removes a monitored name by selected index
	------------------------------------------------]]--
	function module:remove_nickname(idx)
		local name = self.db.profile.nicknames[idx]
		if name then
			self.nick_patterns[name] = nil
		end
		tremove(self.db.profile.nicknames, idx)
		self.nickpat = self.nick_patterns
	end

	--[[------------------------------------------------
		BR: Limpa todos os nomes monitorados configurados
		EN: Clears all configured monitored names
	------------------------------------------------]]--
	function module:clear_nickname()
		local nicknames = self.db.profile.nicknames
		while #nicknames > 0 do
			self.nick_patterns[nicknames[#nicknames]] = nil
			nicknames[#nicknames] = nil
		end
		self.nickpat = self.nick_patterns
	end

	--[[------------------------------------------------
		BR: Verifica nome do jogador/nomes monitorados e envia mensagem ao sink
		EN: Checks player name/monitored names and sends message to the sink
	------------------------------------------------]]--
	function module:check_text(text, display_text, event, r, g, b, event_id)
		if not text or text == "" then
			return
		end

		local show = false

		if self.player_name and text:match(self.player_name) then
			show = true
		else
			for _, pattern in pairs(self.nick_patterns) do
				if pattern:len() > 0 and text:match(pattern) then
					show = true
					break
				end
			end
		end

		if show then
			self.last_event_type = event
			self.last_event = event_id
			self.lasteventtype = event -- Legacy runtime compatibility.
			self.lastevent = event_id -- Legacy runtime compatibility.

			self.pouring = true
			self:Pour(display_text or text, r, g, b)
			Prat:PlaySound("popup")
			self.pouring = nil
		end
	end

	--[[------------------------------------------------
		BR: Aliases legados para reduzir risco com chamadas antigas
		EN: Legacy aliases to reduce risk from older calls
	------------------------------------------------]]--
	module.AddNickname = module.add_nickname
	module.RemoveNickname = module.remove_nickname
	module.ClearNickname = module.clear_nickname
	module.CheckText = module.check_text

	return
end) -- Prat:AddModuleToLoad
