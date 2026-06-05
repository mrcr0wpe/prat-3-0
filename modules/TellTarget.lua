--[[
    @File:      TellTarget.lua
    @Project:   Prat-3.0

    BR: Comando /tt para enviar sussurro ao alvo atual.
        - Detecta /tt na barra de digitação do chat
        - Usa o jogador selecionado como destinatário
        - Suporta nome com reino quando necessário
        - Atualiza a editbox para WHISPER
        - Mantém compatibilidade com Bindings.xml

    EN: /tt command to whisper the current target.
        - Detects /tt in the chat edit box
        - Uses the selected player as the recipient
        - Supports realm-qualified names when needed
        - Updates the edit box to WHISPER
        - Keeps compatibility with Bindings.xml

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade com APIs antigas e modernas para iniciar whisper
    EN: Compatibility with old and modern APIs for starting whispers
------------------------------------------------]]--
local chat_frame_send_tell = _G.ChatFrame_SendTell or _G.ChatFrameUtil.SendTell

--[[------------------------------------------------
    BR: Compatibilidade com atualização do cabeçalho da editbox
    EN: Compatibility with edit box header update
------------------------------------------------]]--
local chat_edit_update_header = _G.ChatEdit_UpdateHeader or _G.ChatFrameEditBoxMixin.UpdateHeader

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo TellTarget com suporte a hooks
		EN: Creation of the TellTarget module with hook support
	------------------------------------------------]]--
	local module = Prat:NewModule("TellTarget", "AceHook-3.0")

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
		}
	})

	--[[------------------------------------------------
		BR: Interface de configuração do módulo
		EN: Module configuration interface
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

			commands = {
				type = "group",
				name = PL["commands_tab_name"],
				desc = PL["commands_tab_desc"],
				order = 100,
				args = {
					commands_help = {
						type = "description",
						name = PL["commands_help"],
						order = 10,
						width = "full",
					},

					examples_header = {
						type = "header",
						name = PL["examples_header"],
						order = 20,
					},

					example_text = {
						type = "description",
						name = PL["example_text"],
						order = 30,
						width = "full",
					},
				},
			},
		}
	})

	--[[------------------------------------------------
		BR: Instala hook seguro na editbox principal do chat
		EN: Installs secure hook on the main chat edit box
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:SecureHookScript(_G.ChatFrame1EditBox, "OnTextChanged", "on_text_changed")
	end

	--[[------------------------------------------------
		BR: Remove hooks instalados pelo módulo
		EN: Removes hooks installed by the module
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:UnhookAll()
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Detecta o comando /tt digitado na editbox
		EN: Detects the /tt command typed in the edit box
	------------------------------------------------]]--
	function module:on_text_changed(edit_box)
		local command, msg = edit_box:GetText():match("^(/%S+)%s(.*)$")
		if command == "/tt" or command == PL["/tt"] then
			self:send_tell_to_target(edit_box.chatFrame, msg, edit_box)
		end
	end

	--[[------------------------------------------------
		BR: Define o alvo atual como destinatário do whisper
		EN: Sets the current target as the whisper recipient
	------------------------------------------------]]--
	function module:send_tell_to_target(frame, text, edit_box)
		if frame == nil then
			frame = DEFAULT_CHAT_FRAME
		end

		local unit_name, realm, full_name

		if UnitIsPlayer("target") then
			unit_name, realm = UnitName("target")
			if unit_name then
				if realm and UnitRealmRelationship("target") ~= LE_REALM_RELATION_SAME then
					full_name = unit_name .. "-" .. realm
				else
					full_name = unit_name
				end
			end
		end

		local target = full_name and full_name:gsub(" ", "")

		if not target or target == "" then
			Prat:Print(PL["no_target_message"])
			return
		end

		if edit_box then
			edit_box:SetAttribute("chatType", "WHISPER")
			edit_box:SetAttribute("tellTarget", target)
			edit_box:SetText(text or "")
			chat_edit_update_header(edit_box)
		else
			chat_frame_send_tell(target, frame)
		end
	end

	--[[------------------------------------------------
		BR: Aliases legados/externos para Bindings.xml e convenções antigas
		EN: Legacy/external aliases for Bindings.xml and older conventions
	------------------------------------------------]]--
	module.OnTextChanged = module.on_text_changed
	module.SendTellToTarget = module.send_tell_to_target

	return
end)
