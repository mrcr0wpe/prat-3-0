--[[
    @File:      Buttons.lua
    @Project:   Prat-3.0

    BR: Controle dos botões das janelas de bate-papo.
        - Exibição/ocultação das setas de navegação
        - Controle do menu de bate-papo e menu social
        - Controle dos botões de minimizar, voz e canal
        - Exibição do lembrete de rolagem para baixo
        - Compatibilidade entre Retail e clientes Classic

    EN: Chat window button control.
        - Showing/hiding navigation arrows
        - Chat menu and social menu control
        - Minimize, voice and channel button control
        - Scroll-down reminder display
        - Compatibility between Retail and Classic clients

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
		BR: Criação do módulo de controle dos botões do bate-papo
		EN: Creation of the chat button control module
	------------------------------------------------]]--
	local module = Prat:NewModule("Buttons", "AceHook-3.0")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			scroll_reminder = true,
			show_buttons = true,
			show_bnet = true,
			show_menu = true,
			show_minimize = true,
			show_voice = true,
			show_channel = true,
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
		args = {
			description = {
				name = PL["full_description"],
				type = "description",
				order = 10,
				width = "full",
			},

			spacer_after_description = {
				type = "description",
				name = "\n",
				order = 15,
				width = "full",
			},

			navigation_header = {
				name = PL["navigation_header"],
				type = "header",
				order = 20,
			},

			show_buttons = {
				name = PL["show_arrows_name"],
				desc = PL["show_arrows_desc"],
				type = "toggle",
				width = "full",
				order = 30
			},

			scroll_reminder = {
				name = PL["scroll_reminder_name"],
				desc = PL["scroll_reminder_desc"],
				type = "toggle",
				width = "full",
				order = 40
			},

			spacer_before_interface = {
				type = "description",
				name = "\n",
				order = 45,
				width = "full",
			},

			interface_header = {
				name = PL["interface_header"],
				type = "header",
				order = 50,
			},

			show_bnet = {
				name = PL["show_bnet_name"],
				desc = PL["show_bnet_desc"],
				type = "toggle",
				width = "full",
				order = 60
			},

			show_menu = {
				name = PL["show_menu_name"],
				desc = PL["show_menu_desc"],
				type = "toggle",
				width = "full",
				order = 70
			},

			show_minimize = {
				name = PL["show_minimize_name"],
				desc = PL["show_minimize_desc"],
				type = "toggle",
				width = "full",
				order = 80
			},

			show_voice = {
				name = PL["show_voice_name"],
				desc = PL["show_voice_desc"],
				type = "toggle",
				width = "full",
				order = 90,
				hidden = not Prat.IsRetail,
			},

			show_channel = {
				name = PL["show_channel_name"],
				desc = PL["show_channel_desc"],
				type = "toggle",
				width = "full",
				order = 100,
			},
		}
	})

	--[[------------------------------------------------
		BR: Retorna a descrição localizada do módulo
		EN: Returns the localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	function module:migrate_profile()
		local profile = self.db and self.db.profile
		if not profile then
			return
		end

		local migrations = {
			scrollReminder = "scroll_reminder",
			showButtons = "show_buttons",
			showBnet = "show_bnet",
			showMenu = "show_menu",
			showminimize = "show_minimize",
			showvoice = "show_voice",
			showchannel = "show_channel",
		}

		for old_key, new_key in pairs(migrations) do
			if profile[new_key] == nil and profile[old_key] ~= nil then
				profile[new_key] = profile[old_key]
			end
			profile[old_key] = nil
		end
	end


	--[[------------------------------------------------
		BR: Oculta botões quando o módulo controla sua visibilidade
		EN: Hides buttons when the module controls their visibility
	------------------------------------------------]]--
	local function hide(self)
		if not self.override then
			self:Hide()
		end
		self.override = nil
	end

	--[[------------------------------------------------
		BR: Ativação do módulo, desativando conflitos e aplicando configurações
		EN: Module activation, conflict disabling and settings application
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:migrate_profile()

		local original_buttons = Prat:GetModule("OriginalButtons")
		if original_buttons then
			self.disabled_original_buttons = true
			original_buttons.db.profile.on = false
			original_buttons:Disable()
			LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")
		end

		self:apply_all_settings()

		Prat.RegisterChatEvent(self, Prat.Events.POST_ADDMESSAGE)

		self:SecureHook("FCF_SetButtonSide")
	end

	--[[------------------------------------------------
		BR: Aplica todas as configurações visuais dos botões
		EN: Applies all visual button settings
	------------------------------------------------]]--
	function module:apply_all_settings()
		if not self.db.profile.show_buttons then
			self:hide_navigation_buttons()
		else
			self:show_navigation_buttons()
		end

		self:update_menu_buttons()

		self:adjust_minimize_buttons()

		self:update_voice_buttons()

		self:update_channel_button()

		self:update_reminder()

		self:adjust_button_frames()
		self:mark_button_frames_dirty()
	end

	--[[------------------------------------------------
		BR: Marca frames de botões para recálculo de layout
		EN: Marks button frames for layout recalculation
	------------------------------------------------]]--
	function module:mark_button_frames_dirty()
		for _, frame in pairs(Prat.Frames) do
			if frame.buttonFrame and frame.buttonFrame.IsLayoutFrame and frame.buttonFrame:IsLayoutFrame() then
				frame.buttonFrame:MarkDirty()
			end
		end
	end

	--[[------------------------------------------------
		BR: Desativação do módulo e restauração dos botões padrão
		EN: Module deactivation and default button restoration
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:disable_bottom_button()
		self:show_navigation_buttons()

		Prat.UnregisterAllChatEvents(self)
	end

	--[[------------------------------------------------
		BR: Atualiza o lembrete de rolagem para baixo
		EN: Updates the scroll-down reminder
	------------------------------------------------]]--
	function module:update_reminder()
		local v = self.db.profile.scroll_reminder
		if v then
			module:enable_bottom_button()
		elseif self.buttons_enabled then
			module:disable_bottom_button()
		end
	end

	function module:OnValueChanged()
		self:apply_all_settings()
	end

	--[[------------------------------------------------
		BR: Atualiza a visibilidade do menu de bate-papo e menu social
		EN: Updates chat menu and social menu visibility
	------------------------------------------------]]--
	function module:update_menu_buttons()
		local social_button = _G.QuickJoinToastButton or _G.FriendsMicroButton
		if social_button then
			if self.db.profile.show_bnet then
				social_button:Show()
			else
				social_button:Hide()
			end
		end

		if self.db.profile.show_menu then
			ChatFrameMenuButton:SetScript("OnShow", nil)
			ChatFrameMenuButton:Show()
		else
			ChatFrameMenuButton:SetScript("OnShow", hide)
			ChatFrameMenuButton:Hide()
		end
	end

	--[[------------------------------------------------
		BR: Atualiza a visibilidade dos botões de voz
		EN: Updates voice button visibility
	------------------------------------------------]]--
	function module:update_voice_buttons()
		if ChatFrameToggleVoiceDeafenButton and ChatFrameToggleVoiceMuteButton then
			if self.db.profile.show_voice then
				ChatFrameToggleVoiceDeafenButton:SetScript("OnShow", nil)
				ChatFrameToggleVoiceMuteButton:SetScript("OnShow", nil)

				if C_VoiceChat.IsLoggedIn() then
					ChatFrameToggleVoiceDeafenButton:Show()
					ChatFrameToggleVoiceMuteButton:Show()
				end
			else
				ChatFrameToggleVoiceDeafenButton:SetScript("OnShow", hide)
				ChatFrameToggleVoiceDeafenButton:Hide()

				ChatFrameToggleVoiceMuteButton:SetScript("OnShow", hide)
				ChatFrameToggleVoiceMuteButton:Hide()
			end
		end
	end

	--[[------------------------------------------------
		BR: Atualiza a visibilidade do botão de canal
		EN: Updates channel button visibility
	------------------------------------------------]]--
	function module:update_channel_button()
		if self.db.profile.show_channel then
			ChatFrameChannelButton:SetScript("OnShow", nil)
			ChatFrameChannelButton:Show()
		else
			ChatFrameChannelButton:SetScript("OnShow", hide)
			ChatFrameChannelButton:Hide()
		end
	end

	--[[------------------------------------------------
		BR: Oculta botões de navegação das janelas de bate-papo
		EN: Hides chat window navigation buttons
	------------------------------------------------]]--
	function module:hide_navigation_buttons()
		self:update_menu_buttons()

		local up_button, down_button, bottom_button

		for name, frame in pairs(Prat.Frames) do
			if not Prat.IsRetail then
				up_button = _G[name .. "ButtonFrameUpButton"]
				up_button:SetScript("OnShow", hide)
				up_button:Hide()
				down_button = _G[name .. "ButtonFrameDownButton"]
				down_button:SetScript("OnShow", hide)
				down_button:Hide()
				bottom_button = _G[name .. "ButtonFrameBottomButton"]
				bottom_button:SetScript("OnShow", hide)
				bottom_button:Hide()
				--bottom_button:SetParent(frame)

				bottom_button:SetScript("OnClick", function()
					frame:ScrollToBottom()
				end)
			end
			self:FCF_SetButtonSide(frame)
		end

		self:adjust_minimize_buttons()
	end

	--[[------------------------------------------------
		BR: Ajusta frames de botões conforme elementos visíveis
		EN: Adjusts button frames according to visible elements
	------------------------------------------------]]--
	function module:adjust_button_frames()
		for name, _ in pairs(Prat.Frames) do
			local f = _G[name .. "ButtonFrame"]

			local has_children = false
			for _, child in ipairs({ f:GetChildren() }) do
				if child:IsShown() then
					has_children = true
					break
				end
			end

			if has_children then
				f:SetScript("OnShow", nil)
				f:Show()
				f:SetWidth(29)
			else
				f:SetScript("OnShow", hide)
				f:Hide()
				f:SetWidth(0.1)
			end
		end
	end

	--[[------------------------------------------------
		BR: Reposiciona e controla os botões de minimizar
		EN: Repositions and controls minimize buttons
	------------------------------------------------]]--
	function module:adjust_minimize_buttons()
		for name, frame in pairs(Prat.Frames) do
			local min = _G[name .. "ButtonFrameMinimizeButton"] or _G[name .. "MinimizeButton"]

			if min then

				if self.db.profile.show_minimize then
					min:ClearAllPoints()

					min:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", 2, 2)
					--min:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", -32, -4);

					min:SetParent(_G[frame:GetName() .. "Tab"])

					min:SetScript("OnShow",
						function(mself)
							if frame.isDocked then
								mself:Hide()
							end
						end)

					min:SetScript("OnClick",
						function()
							FCF_MinimizeFrame(frame, strupper(frame.buttonSide))
						end)

					min:Show()
				else
					min:SetScript("OnShow", hide)
					min:Hide()
				end
			end
		end
	end

	--[[------------------------------------------------
		BR: Restaura/exibe botões de navegação das janelas de bate-papo
		EN: Restores/displays chat window navigation buttons
	------------------------------------------------]]--
	function module:show_navigation_buttons()
		self:Unhook("FCF_SetButtonSide")
		self:update_menu_buttons()
		local up_button, down_button, bottom_button

		for name, frame in pairs(Prat.Frames) do
			if not Prat.IsRetail then
				up_button = _G[name .. "ButtonFrameUpButton"]
				up_button:SetScript("OnShow", nil)
				up_button:Show()
				down_button = _G[name .. "ButtonFrameDownButton"]
				down_button:SetScript("OnShow", nil)
				down_button:Show()
				bottom_button = _G[name .. "ButtonFrameBottomButton"]
				bottom_button:SetScript("OnShow", nil)
				bottom_button:SetShown(self.db.profile.show_buttons)
				bottom_button:SetParent(_G[name .. "ButtonFrame"])
			end

			self:FCF_SetButtonSide(frame)
		end

		self:adjust_minimize_buttons()
	end

	--[[------------------------------------------------
		BR: Ajusta a posição dos botões conforme o lado configurado do chat
		EN: Adjusts button position according to the configured chat side
	------------------------------------------------]]--
	function module:FCF_SetButtonSide(chatFrame)
		local f = _G[chatFrame:GetName() .. "ButtonFrameBottomButton"]
		local bf = _G[chatFrame:GetName() .. "ButtonFrame"]

		if not Prat.IsRetail then
			if self.db.profile.show_buttons then
				f:ClearAllPoints()
				f:SetPoint("BOTTOM", bf, "BOTTOM", 0, 0)
			else
				f:ClearAllPoints()
				f:SetPoint("BOTTOMRIGHT", chatFrame, "BOTTOMRIGHT", 2, 2)
			end
		end
	end

	--[[------------------------------------------------
		BR: Habilita o botão de retorno ao fim da janela de bate-papo
		EN: Enables the return-to-bottom chat button
	------------------------------------------------]]--
	function module:enable_bottom_button()
		if self.buttons_enabled then
			return
		end
		self.buttons_enabled = true
		for name, f in pairs(Prat.Frames) do
			self:SecureHook(f, "ScrollUp")
			self:SecureHook(f, "ScrollToTop", "ScrollUp")
			self:SecureHook(f, "PageUp", "ScrollUp")

			self:SecureHook(f, "ScrollDown")
			self:SecureHook(f, "ScrollToBottom", "ScrollDownForce")
			self:SecureHook(f, "PageDown", "ScrollDown")

			local button = _G[name .. "ButtonFrameBottomButton"]

			if button then
				if f:GetScrollOffset() ~= 0 then
					button.override = true
					button:Show()
				else
					button:Hide()
				end
			end
		end
	end

	--[[------------------------------------------------
		BR: Desabilita o botão de retorno ao fim da janela de bate-papo
		EN: Disables the return-to-bottom chat button
	------------------------------------------------]]--
	function module:disable_bottom_button()
		if not self.buttons_enabled then
			return
		end
		self.buttons_enabled = false
		for name, f in pairs(Prat.Frames) do
			if f then
				self:Unhook(f, "ScrollUp")
				self:Unhook(f, "ScrollToTop")
				self:Unhook(f, "PageUp")
				self:Unhook(f, "ScrollDown")
				self:Unhook(f, "ScrollToBottom")
				self:Unhook(f, "PageDown")
				local button = _G[name .. "ButtonFrameBottomButton"]
				if button then
					button:Hide()
				end
			end
		end
	end

	function module:ScrollUp(frame)
		local button = _G[frame:GetName() .. "ButtonFrameBottomButton"]
		if button then
			button.override = true
			button:Show()
		end
		self:mark_button_frames_dirty()
	end

	function module:ScrollDown(frame)
		if frame:GetScrollOffset() == 0 then
			local button = _G[frame:GetName() .. "ButtonFrameBottomButton"]
			if button then
				button:Hide()
			end
		end
		self:mark_button_frames_dirty()
	end

	function module:ScrollDownForce(frame)
		local button = _G[frame:GetName() .. "ButtonFrameBottomButton"]
		if button then
			button:Hide()
		end
		self:mark_button_frames_dirty()
	end

	--function module:AddMessage(frame, text, ...)
	--[[------------------------------------------------
		BR: Atualiza o botão inferior após novas mensagens no chat
		EN: Updates the bottom button after new chat messages
	------------------------------------------------]]--
	function module:Prat_PostAddMessage(_, _, frame)
		local button = _G[frame:GetName() .. "ButtonFrameBottomButton"]

		if not button then
			return
		end
		if frame:GetScrollOffset() > 0 then
			button.override = true
			button:Show()
		else
			button:Hide()
		end
		self:mark_button_frames_dirty()
	end

	-- BR: Aliases legados para compatibilidade interna/externa.
	-- EN: Legacy aliases for internal/external compatibility.
	module.ApplyAllSettings = module.apply_all_settings
	module.MarkButtonFramesDirty = module.mark_button_frames_dirty
	module.UpdateReminder = module.update_reminder
	module.UpdateMenuButtons = module.update_menu_buttons
	module.UpdateVoiceButtons = module.update_voice_buttons
	module.UpdateChannelButton = module.update_channel_button
	module.AdjustMinimizeButtons = module.adjust_minimize_buttons
	module.AdjustButtonFrames = module.adjust_button_frames
	module.EnableBottomButton = module.enable_bottom_button
	module.DisableBottomButton = module.disable_bottom_button
	module.HideButtons = module.hide_navigation_buttons
	module.ShowButtons = module.show_navigation_buttons

	return
end) -- Prat:AddModuleToLoad
