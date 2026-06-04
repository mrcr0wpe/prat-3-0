--[[
    @File:      Keybindings.lua
    @Project:   Prat-3.0

    BR: Registra nomes e funções auxiliares dos atalhos de teclado do Prat.
        - Localiza os nomes exibidos no painel de atalhos do WoW
        - Mantém correspondência com os bindings definidos em Bindings.xml
        - Atalhos para canais principais e canais numerados
        - Atalho para copiar a janela de bate-papo selecionada
        - Atalho para alternar para a próxima guia de bate-papo
        - Integração com o sistema global de atalhos de teclado do WoW

    EN: Registers labels and helper functions for Prat keyboard shortcuts.
        - Localizes labels shown in WoW's keybindings panel
        - Matches bindings defined in Bindings.xml
        - Bindings for main channels and numbered channels
        - Binding for copying the selected chat window
        - Binding for switching to the next chat tab
        - Integration with WoW's global keybinding system

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
		BR: Criação do módulo auxiliar de atalhos de teclado
		EN: Creation of the keyboard shortcuts helper module
	------------------------------------------------]]--
	local module = Prat:NewModule("KeyBindings")

	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	--[[------------------------------------------------
		BR: Registra os nomes exibidos no painel de atalhos do WoW.

		IMPORTANTE:
		Estas variáveis precisam corresponder aos nomes definidos em Bindings.xml.
		Exemplo:
		<Binding name="PRAT_GUILD"> usa BINDING_NAME_PRAT_GUILD.

		EN: Registers the labels shown in WoW's keybindings panel.

		IMPORTANT:
		These variables must match the names defined in Bindings.xml.
		Example:
		<Binding name="PRAT_GUILD"> uses BINDING_NAME_PRAT_GUILD.
	------------------------------------------------]]--
	Prat:SetModuleInit(module, function()
		BINDING_HEADER_Prat = PL["binding_header_name"]

		BINDING_NAME_PRAT_OFFICER = PL["officer_channel_name"]
		BINDING_NAME_PRAT_GUILD = PL["guild_channel_name"]
		BINDING_NAME_PRAT_PARTY = PL["party_channel_name"]
		BINDING_NAME_PRAT_RAID = PL["raid_channel_name"]
		BINDING_NAME_PRAT_RAIDWARN = PL["raid_warning_channel_name"]
		BINDING_NAME_PRAT_INSTANCE = PL["instance_channel_name"]
		BINDING_NAME_PRAT_SAY = PL["say_name"]
		BINDING_NAME_PRAT_YELL = PL["yell_name"]
		BINDING_NAME_PRAT_WHISPER = PL["whisper_name"]

		BINDING_NAME_PRAT_CHANNEL_ONE = (PL["channel_name_format"]):format(1)
		BINDING_NAME_PRAT_CHANNEL_TWO = (PL["channel_name_format"]):format(2)
		BINDING_NAME_PRAT_CHANNEL_THREE = (PL["channel_name_format"]):format(3)
		BINDING_NAME_PRAT_CHANNEL_FOUR = (PL["channel_name_format"]):format(4)
		BINDING_NAME_PRAT_CHANNEL_FIVE = (PL["channel_name_format"]):format(5)
		BINDING_NAME_PRAT_CHANNEL_SIX = (PL["channel_name_format"]):format(6)
		BINDING_NAME_PRAT_CHANNEL_SEVEN = (PL["channel_name_format"]):format(7)
		BINDING_NAME_PRAT_CHANNEL_EIGHT = (PL["channel_name_format"]):format(8)
		BINDING_NAME_PRAT_CHANNEL_NINE = (PL["channel_name_format"]):format(9)

		BINDING_NAME_PRAT_SMARTGROUP = PL["smart_group_channel_name"]
		BINDING_NAME_PRAT_NEXTTAB = PL["next_chat_tab_name"]
		BINDING_NAME_PRAT_COPYSELECTED = PL["copy_selected_chat_frame_name"]
		BINDING_NAME_PRAT_TELLTARGET = PL["tell_target_name"]
		BINDING_NAME_PRAT_SCROLLBOTTOM = PL["scroll_to_bottom_name"]
		BINDING_NAME_PRAT_SCROLLTOP = PL["scroll_to_top_name"]
	end)

	--[[------------------------------------------------
		BR: Retorna a descrição localizada do módulo para o controle de módulos.
		EN: Returns the localized module description for module control.
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Alterna para a próxima guia dockada do bate-papo.

		Usado pelo binding PRAT_NEXTTAB definido em Bindings.xml.
		Se não houver guia selecionada ou lista de janelas dockadas, a função encerra
		sem erro para evitar problemas em estados incomuns da interface.

		EN: Switches to the next docked chat tab.

		Used by the PRAT_NEXTTAB binding defined in Bindings.xml.
		If there is no selected tab or docked window list, the function exits
		without error to avoid issues in unusual UI states.
	------------------------------------------------]]--
	function module:CycleChatTabs()
		if not FCFDock_GetSelectedWindow or not FCFDock_GetChatFrames then
			return
		end

		local current = FCFDock_GetSelectedWindow(GENERAL_CHAT_DOCK)
		local dockedFrames = FCFDock_GetChatFrames(GENERAL_CHAT_DOCK)

		if not current or not dockedFrames then
			return
		end

		local index
		for i, frame in ipairs(dockedFrames) do
			if frame == current then
				index = i
				break
			end
		end

		if not index then
			return
		end

		index = index + 1
		if not dockedFrames[index] then
			index = 1
		end

		if dockedFrames[index] then
			FCFDock_SelectWindow(GENERAL_CHAT_DOCK, dockedFrames[index])
		end
	end

	return
end) -- Prat:AddModuleToLoad
