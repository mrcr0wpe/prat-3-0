--[[
    @File:      AddonMessages.lua
    @Project:   Prat-3.0

    BR: Exibição diagnóstica de mensagens internas enviadas por addons.
        - Captura mensagens CHAT_MSG_ADDON
        - Exibição opcional por janela de chat
        - Formatação visual com cores para prefixo, mensagem, canal e remetente
        - Útil apenas para diagnóstico de comunicação entre addons
        - Arquivo mantido por compatibilidade/histórico, mas normalmente desativado no include

    EN: Diagnostic display of internal messages sent by addons.
        - Captures CHAT_MSG_ADDON messages
        - Optional display per chat window
        - Visual formatting with colors for prefix, message, channel and sender
        - Useful only for addon communication diagnostics
        - File kept for compatibility/history, but normally disabled in the include

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
		BR: Nome interno preservado por compatibilidade com o módulo original
		EN: Internal name preserved for compatibility with the original module
	------------------------------------------------]]--
	local module = Prat:NewModule("AddonMsgs", "AceEvent-3.0")

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
			show = {},
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

			windows = {
				name = PL["windows_tab_name"],
				desc = PL["windows_tab_desc"],
				type = "group",
				order = 100,
				args = {
					windows_help = {
						name = PL["windows_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					show = {
						name = PL["show_name"],
						desc = PL["show_desc"],
						type = "multiselect",
						values = Prat.HookedFrameList,
						get = "GetSubValue",
						set = "SetSubValue",
						order = 20,
						width = "full",
					},
				},
			},

			diagnostic = {
				name = PL["diagnostic_tab_name"],
				desc = PL["diagnostic_tab_desc"],
				type = "group",
				order = 200,
				args = {
					diagnostic_help = {
						name = PL["diagnostic_help"],
						type = "description",
						order = 10,
						width = "full",
					},
				},
			},
		}
	})

	--[[------------------------------------------------
		BR: Registra evento de mensagens internas de addons
		EN: Registers internal addon message event
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:RegisterEvent("CHAT_MSG_ADDON", "chat_msg_addon")
	end

	--[[------------------------------------------------
		BR: Remove evento registrado
		EN: Removes registered event
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:UnregisterEvent("CHAT_MSG_ADDON")
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Utilitário de cores usado para destacar partes da mensagem
		EN: Color utility used to highlight message parts
	------------------------------------------------]]--
	local CLR = Prat.CLR

	local function color_prefix(text)
		return CLR:Colorize("ffff40", text)
	end

	local function color_payload(text)
		return CLR:Colorize("a0a0a0", text)
	end

	local function color_channel(text)
		return CLR:Colorize("40ff40", text)
	end

	local function color_sender(text)
		return CLR:Colorize("4040ff", text)
	end

	--[[------------------------------------------------
		BR: Exibe mensagens ocultas do canal de addons nas janelas habilitadas
		EN: Displays hidden addon-channel messages in enabled chat windows
	------------------------------------------------]]--
	function module:chat_msg_addon(prefix, payload, channel, sender)
		for frame_name, chat_frame in pairs(Prat.HookedFrames) do
			if self.db.profile.show[frame_name] then
				chat_frame:AddMessage(
					"[" .. color_prefix(tostring(prefix or "")) .. "]" ..
					"[" .. color_payload(tostring(payload or "")) .. "]" ..
					"[" .. color_channel(tostring(channel or "")) .. "]" ..
					"[" .. color_sender(tostring(sender or "")) .. "]"
				)
			end
		end
	end

	--[[------------------------------------------------
		BR: Alias legado para reduzir risco com callbacks antigos
		EN: Legacy alias to reduce risk from older callbacks
	------------------------------------------------]]--
	module.CHAT_MSG_ADDON = module.chat_msg_addon

	return
end) -- Prat:AddModuleToLoad
