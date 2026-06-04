--[[
    @File:      Clear.lua
    @Project:   Prat-3.0

    BR: Comandos para limpar uma ou todas as janelas de chat.
        - /clear e /cls limpam a janela atual
        - /clearall e /clsall limpam todas as janelas de chat
        - Usa a API Clear nativa dos chatframes
        - Não apaga configurações, canais ou histórico persistente

    EN: Commands to clear one or all chat windows.
        - /clear and /cls clear the current window
        - /clearall and /clsall clear all chat windows
        - Uses the native chatframe Clear API
        - Does not delete settings, channels or persistent history

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade com constantes antigas e modernas de janelas de chat
    EN: Compatibility with old and modern chat window constants
------------------------------------------------]]--
local num_chat_windows = NUM_CHAT_WINDOWS or Constants.ChatFrameConstants.MaxChatWindows

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo de limpeza do chat
		EN: Creation of the chat clearing module
	------------------------------------------------]]--
	local module = Prat:NewModule("Clear")

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
		}
	})

	--[[------------------------------------------------
		BR: Configuração da interface do módulo
		EN: Module interface configuration
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

			commands = {
				name = PL["commands_tab_name"],
				desc = PL["commands_tab_desc"],
				type = "group",
				order = 100,
				args = {
					commands_help = {
						name = PL["commands_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					current_window = {
						name = PL["current_window_commands"],
						type = "description",
						order = 20,
						width = "full",
					},

					all_windows = {
						name = PL["all_windows_commands"],
						type = "description",
						order = 30,
						width = "full",
					},

					important = {
						name = PL["important_note"],
						type = "description",
						order = 40,
						width = "full",
					},
				}
			},
		}
	})

	--[[------------------------------------------------
		BR: Registra comandos slash para limpeza do chat
		EN: Registers slash commands for chat clearing
	------------------------------------------------]]--
	function module:OnModuleEnable()
		Prat.RegisterChatCommand("clear", function()
			module:clear(SELECTED_CHAT_FRAME)
		end)

		Prat.RegisterChatCommand("cls", function()
			module:clear(SELECTED_CHAT_FRAME)
		end)

		Prat.RegisterChatCommand("clearall", function()
			module:clear_all()
		end)

		Prat.RegisterChatCommand("clsall", function()
			module:clear_all()
		end)
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Limpa uma janela de chat válida
		EN: Clears a valid chat window
	------------------------------------------------]]--
	function module:clear(chat_frame)
		if not self.db.profile.on or not chat_frame or not chat_frame.GetObjectType then
			return
		end

		local frame_type = chat_frame:GetObjectType()

		if frame_type == "Frame" and chat_frame.Clear then
			chat_frame:Clear()
		end
	end

	--[[------------------------------------------------
		BR: Limpa todas as janelas de chat existentes
		EN: Clears all existing chat windows
	------------------------------------------------]]--
	function module:clear_all()
		for i = 1, num_chat_windows do
			self:clear(_G["ChatFrame" .. i])
		end
	end

	--[[------------------------------------------------
		BR: Alias legado para reduzir risco com chamadas antigas
		EN: Legacy alias to reduce risk from older calls
	------------------------------------------------]]--
	module.clearAll = module.clear_all
	module.ClearAll = module.clear_all

	return
end) -- Prat:AddModuleToLoad
