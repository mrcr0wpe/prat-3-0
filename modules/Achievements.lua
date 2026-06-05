--[[
    @File:      Achievements.lua
    @Project:   Prat-3.0

    BR: Personalizações relacionadas a conquistas (Achievements).
        - Exibição da data de conclusão
        - Sistema de mensagens de parabéns
        - Link clicável de congratulação
        - Ocultação de mensagens de conquista

    EN: Achievement related customizations.
        - Achievement completion date display
        - Congratulation message system
        - Clickable grats link
        - Achievement message hiding

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local SendChatMessage = C_ChatInfo.SendChatMessage or SendChatMessage

Prat:AddModuleToLoad(function()
	local module = Prat:NewModule("Achievements")
	local PL = module.PL
	local repeat_prevention = {}

	--[[------------------------------------------------
		BR: Configuração dos valores padrão do módulo
		EN: Module default values configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			dont_show_achievements = false,
			show_completed_date = true,
			show_grats_link = false,
			custom_grats = true,
			custom_grats_text = PL["custom_grats_default"]
		}
	})

	--[[------------------------------------------------
		BR: Configuração das opções da interface do módulo
		EN: Module interface options configuration
	------------------------------------------------]]--
	Prat:SetModuleOptions(module.name, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		childGroups = "tab",
		args = {
			overview = {
				type = "group",
				name = PL["overview_tab_name"],
				desc = PL["overview_tab_desc"],
				order = 10,
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

			display_group = {
				type = "group",
				name = PL["display_tab_name"],
				desc = PL["display_tab_desc"],
				order = 20,
				args = {
					display_help = {
						type = "description",
						name = PL["display_help"],
						order = 10,
						width = "full",
					},

					dont_show_achievements = {
						name = PL["dont_show_achievements_name"],
						desc = PL["dont_show_achievements_desc"],
						type = "toggle",
						order = 20,
						width = "full",
					},

					show_completed_date = {
						name = PL["show_completed_date_name"],
						desc = PL["show_completed_date_desc"],
						type = "toggle",
						order = 30,
						width = "full",
					},
				},
			},

			quick_response_group = {
				type = "group",
				name = PL["quick_response_tab_name"],
				desc = PL["quick_response_tab_desc"],
				order = 30,
				args = {
					quick_response_help = {
						type = "description",
						name = PL["quick_response_help"],
						order = 10,
						width = "full",
					},

					show_grats_link = {
						name = PL["show_grats_link_name"],
						desc = PL["show_grats_link_desc"],
						type = "toggle",
						order = 20,
						width = "full",
					},

					custom_grats = {
						name = PL["custom_grats_name"],
						desc = PL["custom_grats_desc"],
						type = "toggle",
						order = 30,
						width = "full",
					},

					custom_grats_text = {
						name = PL["custom_grats_text_name"],
						desc = PL["custom_grats_text_desc"],
						type = "input",
						order = 40,
						width = "full",
						disabled = function()
							return not module.db.profile.custom_grats
						end
					},

					custom_grats_text_example = {
						type = "description",
						name = PL["custom_grats_text_example"],
						order = 50,
						width = "full",
					},
				},
			},
		}
	})

	--[[------------------------------------------------
		BR: Mensagens usadas quando o jogador também possui a conquista
		EN: Messages used when the player also has the achievement
	------------------------------------------------]]--
	local grats_variants_have = {
		PL["grats_have_1"],
		PL["grats_have_2"],
		PL["grats_have_3"],
		PL["grats_have_4"],
		PL["grats_have_5"],
		PL["grats_have_6"],
		PL["grats_have_7"],
		PL["grats_have_8"],
		PL["grats_have_9"],
		PL["grats_have_10"],
	}
	--[[------------------------------------------------
		BR: Mensagens usadas quando o jogador ainda não possui a conquista
		EN: Messages used when the player does not have the achievement yet
	------------------------------------------------]]--
	local grats_variants_dont_have = {
		PL["grats_donthave_1"],
		PL["grats_donthave_2"],
		PL["grats_donthave_3"],
		PL["grats_donthave_4"],
		PL["grats_donthave_5"],
		PL["grats_donthave_6"],
		PL["grats_donthave_7"],
		PL["grats_donthave_8"],
		PL["grats_donthave_9"],
		PL["grats_donthave_10"],
	}

	--[[------------------------------------------------
		BR: Aplica coloração branca a pequenos trechos adicionados ao chat
		EN: Applies white coloring to small text fragments added to chat
	------------------------------------------------]]--
	local function white(text)
		return Prat.CLR:Colorize("ffffff", text)
	end

	--[[------------------------------------------------
		BR: Padrão usado para identificar links de conquistas nas mensagens
		EN: Pattern used to identify achievement links in chat messages
	------------------------------------------------]]--
	local regexp = "(|cffffff00|Hachievement:([0-9]+):(.+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+):([%-0-9]+)|h%[([^]]+)%]|h|r)"
	local grats_link_type = "gratsl"

	--[[------------------------------------------------
		BR: Cria o link clicável usado para enviar uma mensagem de parabéns
		EN: Builds the clickable link used to send a congratulation message
	------------------------------------------------]]--
	local function build_grats_link(name, group, channel, achievement_id)
		if type(name) ~= "nil" and type(group) ~= "nil" then
			return Prat.BuildLink(grats_link_type, ("%s:%s:%s:%s"):format(name, group, channel or "", tostring(achievement_id)), PL["grats_link"], "2080a0")
		end

		return ""
	end

	--[[------------------------------------------------
		BR: Adiciona data de conclusão e link de parabéns às conquistas exibidas
		EN: Adds completion date and grats link to displayed achievements
	------------------------------------------------]]--
	local function show_our_completion(text, their_id, their_player_guid, their_done)
		local chat_type = Prat.CurrentMessage.CHATTYPE
		if chat_type == "WHISPER_INFORM" then
			return
		end

		if their_player_guid == "0000000000000000" or tostring(their_player_guid):len() <= 3 then
			return
		end

		local _, _, _, completed, month, day, year = GetAchievementInfo(their_id)

		local _, _, _, _, _, their_name, _ = GetPlayerInfoByGUID(their_player_guid)
		local group = Prat.CurrentMessage.CHATGROUP
		local channel_num = Prat.CurrentMessage.CHATTARGET

		if group == "CHANNEL" and not tonumber(channel_num) then
			return
		end

		if completed then
			return Prat:RegisterMatch(text .. module:add_date(day, month, year) .. (their_done and module:add_grats(their_name, group, channel_num, their_id, Prat.CurrentMessage)) or "")
		elseif their_done then
			return Prat:RegisterMatch(text .. module:add_grats(their_name, group, channel_num, their_id, Prat.CurrentMessage))
		end
	end

	--[[------------------------------------------------
		BR: Registro do padrão de captura usado pelo processamento do chat
		EN: Registration of the capture pattern used by chat processing
	------------------------------------------------]]--
	Prat:SetModulePatterns(module, {
		{ pattern = regexp, matchfunc = show_our_completion, priority = 42 },
	})

	--[[------------------------------------------------
		BR: Ativação do módulo e registro dos eventos necessários
		EN: Module activation and required event registration
	------------------------------------------------]]--
	function module:OnModuleEnable()
		Prat.EnableProcessingForEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
		Prat.EnableProcessingForEvent("CHAT_MSG_ACHIEVEMENT")
		Prat.RegisterChatEvent(self, "Prat_FrameMessage")
		Prat.RegisterLinkType({ linkid = grats_link_type, linkfunc = self.on_grats_link, handler = self }, self.name)
	end

	--[[------------------------------------------------
		BR: Desativação do módulo e limpeza dos eventos registrados
		EN: Module deactivation and registered event cleanup
	------------------------------------------------]]--
	function module:OnModuleDisable()
		Prat.UnregisterAllChatEvents(self)
	end

	--[[------------------------------------------------
		BR: Adiciona o link de parabéns quando a opção estiver ativa
		EN: Adds the grats link when the option is enabled
	------------------------------------------------]]--
	function module:add_grats(name, group, channel, achievement_id)
		if self.db.profile.show_grats_link then
			return " " .. build_grats_link(name, group, channel, achievement_id)
		end

		return ""
	end

	--[[------------------------------------------------
		BR: Adiciona a data de conclusão da conquista à mensagem
		EN: Adds the achievement completion date to the message
	------------------------------------------------]]--
	function module:add_date(day, month, year)
		if self.db.profile.show_completed_date then
			return " " .. white("(") .. PL["completed"]:format(FormatShortDate(day, month, year)) .. white(")")
		end

		return ""
	end

	--[[------------------------------------------------
		BR: Processa o clique no link de parabéns e envia a mensagem apropriada
		EN: Handles grats link clicks and sends the appropriate message
	------------------------------------------------]]--
	function module:on_grats_link(link)
		if Prat.IsRetail and InCombatLockdown() then
			return false
		end

		local their_name, group, _, id = strsub(link, grats_link_type:len() + 2):match("([^:]*):([^:]*):([^:]*):([^:]*)")

		local grats

		if self.db.profile.custom_grats then
			grats = self.db.profile.custom_grats_text
		else
			id = tonumber(id)

			local _, _, _, _, _, _, _, _, _, _, _, _, was_earned_by_me = GetAchievementInfo(id)

			local grats_variants = was_earned_by_me and grats_variants_have or grats_variants_dont_have

			local last = repeat_prevention[was_earned_by_me and 1 or 2]
			local next = math.random(#grats_variants)

			while next == last do
				next = math.random(#grats_variants)
			end

			grats = grats_variants[next]
			repeat_prevention[was_earned_by_me and 1 or 2] = last
		end

		if group == "WHISPER" or not Prat.CanSendChatMessage(group) then
			SendChatMessage(grats:format(their_name), "WHISPER", nil, their_name)
		elseif Prat.CanSendChatMessage(group) then
			SendChatMessage(grats:format(their_name), group)
		end

		return false
	end

	--[[------------------------------------------------
		BR: Bloqueia mensagens de conquista da guilda quando a opção estiver ativa
		EN: Blocks guild achievement messages when the option is enabled
	------------------------------------------------]]--
	function module:Prat_FrameMessage(_, message, _, event)
		if self.db.profile.dont_show_achievements and event == "CHAT_MSG_GUILD_ACHIEVEMENT" then
			message.DONOTPROCESS = true
		end
	end
end)
