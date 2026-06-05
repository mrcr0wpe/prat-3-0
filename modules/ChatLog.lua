--[[
    @File:      ChatLog.lua
    @Project:   Prat-3.0

    BR: Controle automático dos registros de chat e combate.
        - Ativação/desativação do log de chat
        - Ativação/desativação do log de combate
        - Mensagens opcionais de feedback ao usuário
        - Integração com as APIs LoggingChat e LoggingCombat

    EN: Automatic chat and combat logging control.
        - Chat log enabling/disabling
        - Combat log enabling/disabling
        - Optional user feedback messages
        - Integration with LoggingChat and LoggingCombat APIs

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
		BR: Criação do módulo de controle dos logs do jogo
		EN: Creation of the game log control module
	------------------------------------------------]]--
	local module = Prat:NewModule("ChatLog")

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
			on = false,
			chat = false,
			combat = false,
			quiet = true,
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
				name = PL["overview_tab_name"],
				desc = PL["overview_tab_desc"],
				type = "group",
				order = 10,
				args = {
					full_description = {
						name = PL["full_description"],
						type = "description",
						order = 10,
						width = "full",
					},

					quick_guide_header = {
						name = PL["quick_guide_header"],
						type = "header",
						order = 20,
					},

					quick_guide = {
						name = PL["quick_guide"],
						type = "description",
						order = 30,
						width = "full",
					},
				},
			},

			logs = {
				name = PL["logs_tab_name"],
				desc = PL["logs_tab_desc"],
				type = "group",
				order = 100,
				args = {
					logs_help = {
						name = PL["logs_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					chat = {
						name = PL["chat_log_name"],
						desc = PL["chat_log_desc"],
						type = "toggle",
						order = 20,
						width = "full",
						set = "set_chat_log",
					},

					combat = {
						name = PL["combat_log_name"],
						desc = PL["combat_log_desc"],
						type = "toggle",
						order = 30,
						width = "full",
						set = "set_combat_log",
					},
				},
			},

			behavior = {
				name = PL["behavior_tab_name"],
				desc = PL["behavior_tab_desc"],
				type = "group",
				order = 200,
				args = {
					behavior_help = {
						name = PL["behavior_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					quiet = {
						name = PL["quiet_name"],
						desc = PL["quiet_desc"],
						type = "toggle",
						order = 20,
						width = "full",
					},

					important = {
						name = PL["important_note"],
						type = "description",
						order = 30,
						width = "full",
					},
				},
			},
		}
	})

	--[[------------------------------------------------
		BR: Aplica os estados salvos dos logs ao habilitar o módulo
		EN: Applies saved log states when enabling the module
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:set_chat_log(nil, self.db.profile.chat)
		self:set_combat_log(nil, self.db.profile.combat)
	end

	--[[------------------------------------------------
		BR: Retorna a descrição localizada do módulo
		EN: Returns the localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Ativa ou desativa o registro do chat
		EN: Enables or disables chat logging
	------------------------------------------------]]--
	function module:set_chat_log(_, value)
		value = not not value
		self.db.profile.chat = value

		if value then
			LoggingChat(true)
			self:print_feedback(PL["chat_log_enabled"])
			self:print_feedback(PL["chat_log_path"])
		else
			LoggingChat(false)
			self:print_feedback(PL["chat_log_disabled"])
		end
	end

	--[[------------------------------------------------
		BR: Ativa ou desativa o registro de combate
		EN: Enables or disables combat logging
	------------------------------------------------]]--
	function module:set_combat_log(_, value)
		value = not not value
		self.db.profile.combat = value

		if value then
			LoggingCombat(true)
			self:print_feedback(PL["combat_log_enabled"])
			self:print_feedback(PL["combat_log_path"])
		else
			LoggingCombat(false)
			self:print_feedback(PL["combat_log_disabled"])
		end
	end

	--[[------------------------------------------------
		BR: Exibe mensagens somente quando o modo silencioso estiver desativado
		EN: Displays messages only when quiet mode is disabled
	------------------------------------------------]]--
	function module:print_feedback(text)
		if self.db.profile.quiet then
			return
		end

		Prat:Print(text)
	end

	--[[------------------------------------------------
		BR: Aliases legados para reduzir risco com chamadas antigas
		EN: Legacy aliases to reduce risk from older calls
	------------------------------------------------]]--
	module.SetChatLog = module.set_chat_log
	module.SetCombatLog = module.set_combat_log
	module.Print = module.print_feedback

	return
end) -- Prat:AddModuleToLoad
