--[[
    @File:      OriginalButtons.lua
    @Project:   Prat-3.0

    BR: Controle legado dos botões originais das janelas de bate-papo.
        - Exibição/ocultação das setas originais do bate-papo
        - Controle do menu de bate-papo
        - Botão de retorno para o final da conversa
        - Posicionamento e transparência dos botões
        - Compatibilidade com comportamento clássico das janelas de bate-papo

    EN: Legacy control of original chat window buttons.
        - Showing/hiding original chat arrows
        - Chat menu control
        - Scroll-to-bottom reminder button
        - Button positioning and transparency
        - Compatibility with classic ChatFrame behavior

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade com constantes antigas e modernas de janelas de bate-papo
    EN: Compatibility with old and modern chat window constants
------------------------------------------------]]--
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS or Constants.ChatFrameConstants.MaxChatWindows

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo legado dos botões originais
		EN: Creation of the legacy original buttons module
	------------------------------------------------]]--
	local module = Prat:NewModule("OriginalButtons", "AceHook-3.0")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	--[[------------------------------------------------
		BR: Configuração dos valores padrão do módulo
		EN: Module default values configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = false,
			chat_menu = false,
			chat_arrows = { ["*"] = true },
			position = "RIGHTINSIDE",
			reminder = true,
			alpha = 1.0,
			button_frame = false,
			friends_button = false,
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

			windows_header = {
				name = PL["windows_header"],
				type = "header",
				order = 20,
			},

			chat_arrows = {
				type = "multiselect",
				name = PL["chat_arrows_name"],
				desc = PL["chat_arrows_desc"],
				order = 30,
				width = "full",
				get = "GetSubValue",
				set = "SetSubValue",
				values = Prat.FrameList,
			},

			spacer_after_windows = {
				type = "description",
				name = "\n",
				order = 35,
				width = "full",
			},

			elements_header = {
				name = PL["elements_header"],
				type = "header",
				order = 40,
			},

			chat_menu = {
				type = "toggle",
				name = PL["chat_menu_name"],
				desc = PL["chat_menu_desc"],
				order = 50,
				width = "full",
				get = function()
					return module.db.profile.chat_menu
				end,
				set = function(_, v)
					module.db.profile.chat_menu = v
					module:chat_menu(v)
				end,
			},

			reminder = {
				type = "toggle",
				name = PL["reminder_name"],
				desc = PL["reminder_desc"],
				order = 60,
				width = "full",
				get = function()
					return module.db.profile.reminder
				end,
				set = function(_, v)
					module.db.profile.reminder = v
				end,
			},

			button_frame = {
				type = "toggle",
				name = PL["button_frame_name"],
				desc = PL["button_frame_desc"],
				order = 70,
				width = "full",
				get = function()
					return module.db.profile.button_frame
				end,
				set = function(_, v)
					module.db.profile.button_frame = v
					module:configure_all_frames()
				end,
			},

			spacer_before_appearance = {
				type = "description",
				name = "\n",
				order = 75,
				width = "full",
			},

			appearance_header = {
				name = PL["appearance_header"],
				type = "header",
				order = 80,
			},

			position = {
				type = "select",
				name = PL["position_name"],
				desc = PL["position_desc"],
				order = 90,
				width = 1.35,
				get = function()
					return module.db.profile.position
				end,
				set = function(_, v)
					module.db.profile.position = v
					module:configure_all_frames()
				end,
				values = {
					["DEFAULT"] = PL["position_default"],
					["RIGHTINSIDE"] = PL["position_right_inside"],
					["RIGHTOUTSIDE"] = PL["position_right_outside"],
				}
			},

			alpha = {
				type = "range",
				name = PL["alpha_name"],
				desc = PL["alpha_desc"],
				order = 100,
				width = 1.35,
				min = 0.1,
				max = 1,
				step = 0.1,
				get = function()
					return module.db.profile.alpha
				end,
				set = function(_, v)
					module.db.profile.alpha = v
					module:configure_all_frames()
				end,
			},

			spacer_before_warning = {
				type = "description",
				name = "\n",
				order = 105,
				width = "full",
			},

			warning = {
				name = PL["conflict_warning"],
				type = "description",
				order = 110,
				width = "full",
			},
		}
	})

	--[[------------------------------------------------
		BR: Migra chaves antigas de profile para o padrão snake_case
		EN: Migrates old profile keys to the snake_case standard
	------------------------------------------------]]--
	local function migrate_profile(profile)
		if not profile then
			return
		end

		if profile.chatmenu ~= nil and profile.chat_menu == nil then
			profile.chat_menu = profile.chatmenu
		end
		profile.chatmenu = nil

		if profile.chatarrows ~= nil and profile.chat_arrows == nil then
			profile.chat_arrows = profile.chatarrows
		end
		profile.chatarrows = nil

		if profile.buttonframe ~= nil and profile.button_frame == nil then
			profile.button_frame = profile.buttonframe
		end
		profile.buttonframe = nil

		if profile.friendsbutton ~= nil and profile.friends_button == nil then
			profile.friends_button = profile.friendsbutton
		end
		profile.friendsbutton = nil

		profile.chat_arrows = profile.chat_arrows or { ["*"] = true }
		if profile.chat_menu == nil then
			profile.chat_menu = false
		end
		if profile.button_frame == nil then
			profile.button_frame = false
		end
		if profile.friends_button == nil then
			profile.friends_button = false
		end
	end

	--[[------------------------------------------------
		BR: Oculta elementos quando o módulo controla sua visibilidade
		EN: Hides elements when the module controls their visibility
	------------------------------------------------]]--
	local function hide(self)
		self:Hide()
	end

	--[[------------------------------------------------
		BR: Aplica alterações individuais de setas por janela
		EN: Applies individual arrow changes per chat frame
	------------------------------------------------]]--
	function module:OnSubValueChanged(_, val, b)
		self:chat_button(_G[val]:GetID(), b)
	end

	--[[------------------------------------------------
		BR: Ativa o módulo e desativa o módulo moderno Buttons em caso de conflito
		EN: Enables the module and disables the modern Buttons module on conflict
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db.profile)

		local buttons3 = Prat:GetModule("Buttons")
		if buttons3 then
			self.disabled_buttons_module = true
			buttons3.db.profile.on = false
			buttons3:Disable()
			LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")
		end
		-- stub variables for frame handling
		self.frames = {}
		self.reminders = {}
		for name, frame in pairs(Prat.Frames) do
			local i = frame:GetID()
			table.insert(self.reminders, self:make_reminder(i))
			self:chat_button(i, self.db.profile.chat_arrows[name])
			self:button_frame(i, self.db.profile.button_frame)
		end
		self:chat_menu(self.db.profile.chat_menu)
		if QuickJoinToastButton then
			QuickJoinToastButton:Hide()
		end

		self.on_update_interval = 0.05
		self.last_update = 0
		-- hook functions
		if _G.ChatFrame_OnUpdate then
			self:SecureHook("ChatFrame_OnUpdate", "chat_frame_on_update_hook")
		else
			for _, v in pairs(Prat.Frames) do
				if v and v.OnUpdate then
					self:SecureHook(v, "OnUpdate", "chat_frame_on_update_hook")
				end
			end
		end
		self:SecureHook("FCF_SetTemporaryWindowType")
	end

	--[[------------------------------------------------
		BR: Restaura botões originais e remove hooks
		EN: Restores original buttons and removes hooks
	------------------------------------------------]]--
	function module:OnModuleDisable()
		-- show chat_menu
		self:chat_menu(true)
		-- show all the chat_buttons
		for i = 1, NUM_CHAT_WINDOWS do
			self:chat_button(i, true)
		end
		-- unhook functions
		self:UnhookAll()
	end

	--[[------------------------------------------------
		BR: Retorna a descrição localizada do módulo
		EN: Returns the localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Reaplica botões quando uma janela temporária é criada
		EN: Reapplies buttons when a temporary chat frame is created
	------------------------------------------------]]--
	function module:FCF_SetTemporaryWindowType(chatFrame)
		local i = chatFrame:GetID()

		self:chat_button(i, self.db.profile.chat_arrows[chatFrame:GetName()])
		self:button_frame(i, self.db.profile.button_frame)
	end

	--[[------------------------------------------------
		BR: Aplica configurações de botões em todas as janelas de bate-papo
		EN: Applies button settings to all chat frames
	------------------------------------------------]]--
	function module:configure_all_frames()
		for name, frame in pairs(Prat.Frames) do
			local i = frame:GetID()
			self:chat_button(i, self.db.profile.chat_arrows[name])
			self:button_frame(i, self.db.profile.button_frame)
		end
		self:chat_menu(self.db.profile.chat_menu)

		if QuickJoinToastButton then
			QuickJoinToastButton:Hide()
		end
	end

	--[[------------------------------------------------
		BR: Controla a atualização periódica dos botões e lembretes
		EN: Controls periodic button and reminder updates
	------------------------------------------------]]--
	function module:chat_frame_on_update_hook(this, elapsed)
		if not this:IsVisible() and not this:IsShown() then
			return
		end
		self.last_update = self.last_update + elapsed

		while (self.last_update > self.on_update_interval) do
			self:chat_frame_on_update(this, elapsed)
			self.last_update = self.last_update - self.on_update_interval;
		end
	end

	do
		local anims

		--[[------------------------------------------------
			BR: Atualiza o estado das setas e do botão de retorno
			EN: Updates arrow state and scroll reminder
		------------------------------------------------]]--
		function module:chat_frame_on_update(this)
			if (not this:IsShown()) then
				return ;
			end

			local id = this:GetID()
			local prof = self.db.profile
			local show = prof.chat_arrows[this:GetName()]

			self:chat_button(id, show)
			--self:chat_frame_on_updateTextFlow(this, elapsed)

			-- This is all code for the 'reminder' from here on
			if show then
				return
			end
			if not prof.reminder then
				return
			end
			local remind = _G[this:GetName() .. "ScrollDownReminder"];
			local flash = _G[this:GetName() .. "ScrollDownReminderFlash"];
			if (not flash) then
				return
			end
			if not anims then
				anims = {}
			end
			if not anims[flash] then
				anims[flash] = flash:CreateAnimationGroup()

				local fade1 = anims[flash]:CreateAnimation("Alpha")
				fade1:SetDuration(0.1)
				fade1:SetToAlpha(1)
				fade1:SetEndDelay(0.5)
				fade1:SetOrder(1)

				local fade2 = anims[flash]:CreateAnimation("Alpha")
				fade2:SetDuration(0.1)
				fade2:SetToAlpha(-1)
				fade2:SetEndDelay(0.5)
				fade2:SetOrder(2)
			end
			if (this:AtBottom()) then
				if (remind:IsShown()) then
					remind:Hide();
					anims[flash]:Stop()
				end
				return ;
			else
				if (remind:IsShown()) then
					return
				end
				remind:Show()
				flash:Show()
				flash:SetAlpha(0)
				anims[flash]:SetLooping("REPEAT")
				anims[flash]:Play()
			end
		end
	end

	--[[------------------------------------------------
		BR: Mostra ou oculta a moldura de botões da janela
		EN: Shows or hides the chat frame button frame
	------------------------------------------------]]--
	function module:button_frame(id, visible)
		local f = _G["ChatFrame" .. id .. "ButtonFrame"]

		if visible then
			f:SetScript("OnShow", nil)
			f:Show()
			f:SetWidth(29)
		else
			f:SetScript("OnShow", hide)
			f:Hide()

			f:SetWidth(0.1)
		end
	end

	--[[------------------------------------------------
		BR: Posiciona e controla a visibilidade do menu de bate-papo
		EN: Positions and controls chat menu visibility
	------------------------------------------------]]--
	function module:chat_menu(visible)
		local ChatFrameMenuButton = ChatFrameMenuButton
		-- define variables used
		local f = self.frames[1]
		if not f then
			self.frames[1] = {}
			f = self.frames[1]
		end
		f.scroll_buttons = f.scroll_buttons or {}
		f.scroll_buttons.up = _G["ChatFrame1ButtonFrameUpButton"]
		-- chat_menu position:
		-- position chat_menu under the UpButton for chatframe1 if button position is set to "RIGHTINSIDE"
		-- otherwise position chat_menu above the UpButton for chatframe1
		ChatFrameMenuButton:ClearAllPoints()
		if self.db.profile.position == "RIGHTINSIDE" then
			ChatFrameMenuButton:SetPoint("TOP", f.scroll_buttons.up, "BOTTOM")
		else
			ChatFrameMenuButton:SetPoint("BOTTOM", f.scroll_buttons.up, "TOP")
		end
		-- chat_menu alpha:
		-- set alpha of the chat_menu based on the alpha setting
		ChatFrameMenuButton:SetAlpha(self.db.profile.alpha)
		-- chat_menu visibility
		-- show buttons based on show settings
		if visible then
			ChatFrameMenuButton:SetScript("OnShow", nil)
			ChatFrameMenuButton:Show()
		else
			ChatFrameMenuButton:Hide()
			ChatFrameMenuButton:SetScript("OnShow", hide)
		end
	end

	--[[------------------------------------------------
		BR: Posiciona, mostra ou oculta os botões de rolagem do bate-papo
		EN: Positions, shows or hides chat scroll buttons
	------------------------------------------------]]--
	function module:chat_button(id, visible)
		-- define variables used
		local f = self.frames[id]
		--local id = this:GetID()
		if not f then
			self.frames[id] = {}
			f = self.frames[id]
		end

		f.scroll_buttons = f.scroll_buttons or {}
		f.cf = f.cf or _G["ChatFrame" .. id]
		f.scroll_buttons.up = f.scroll_buttons.up or _G["ChatFrame" .. id .. "ButtonFrameUpButton"]
		f.scroll_buttons.down = f.scroll_buttons.down or _G["ChatFrame" .. id .. "ButtonFrameDownButton"]
		f.scroll_buttons.bottom = f.scroll_buttons.bottom or _G["ChatFrame" .. id .. "ButtonFrameBottomButton"]
		f.scroll_buttons.min = f.scroll_buttons.min or _G["ChatFrame" .. id .. "ButtonFrameMinimizeButton"] or _G["ChatFrame" .. id .. "MinimizeButton"]

		if f.scroll_buttons.up then
			f.scroll_buttons.up:SetParent(f.cf)
			f.scroll_buttons.down:SetParent(f.cf)
			f.scroll_buttons.bottom:SetParent(f.cf)
			f.scroll_buttons.min:SetParent(_G[f.cf:GetName() .. "Tab"])

			f.scroll_buttons.min:SetScript("OnShow",
				function(minSelf)
					if f.cf.isDocked then
						minSelf:Hide()
					end
				end)

			f.scroll_buttons.min:SetScript("OnClick",
				function()
					FCF_MinimizeFrame(f.cf, strupper(f.cf.buttonSide))
				end)

			f.scroll_buttons.up:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.IG_CHAT_SCROLL_UP);
				f.cf:ScrollUp()
			end)
			f.scroll_buttons.down:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.IG_CHAT_SCROLL_DOWN);
				f.cf:ScrollDown()
			end)
			f.scroll_buttons.bottom:SetScript("OnClick", function()
				PlaySound(SOUNDKIT.IG_CHAT_BOTTOM);
				f.cf:ScrollToBottom()
			end)
		end

		f.scroll_buttons_height = (f.scroll_buttons_height and f.scroll_buttons_height > 0) and f.scroll_buttons_height or ((f.scroll_buttons.up and f.scroll_buttons.down and f.scroll_buttons.bottom) and
			(f.scroll_buttons.up:GetHeight() + f.scroll_buttons.down:GetHeight() + f.scroll_buttons.bottom:GetHeight()) or 0)
		f.scroll_reminder = f.scroll_reminder or self:make_reminder(id)
		f.scroll_reminder_flash = f.scroll_reminder_flash or _G["ChatFrame" .. id .. "ScrollDownReminderFlash"]

		-- chat_buttons position:
		-- position of the chat_buttons based on position setting
		if f.scroll_buttons.bottom and f.scroll_buttons.up then
			f.scroll_buttons.bottom:ClearAllPoints()
			f.scroll_buttons.up:ClearAllPoints()
			if self.db.profile.position == "RIGHTINSIDE" then
				f.scroll_buttons.bottom:SetPoint("BOTTOMRIGHT", f.cf, "BOTTOMRIGHT", 0, -4)
				f.scroll_buttons.up:SetPoint("TOPRIGHT", f.cf, "TOPRIGHT", 0, -4)
			elseif self.db.profile.position == "RIGHTOUTSIDE" then
				f.scroll_buttons.bottom:SetPoint("BOTTOMLEFT", f.cf, "BOTTOMRIGHT", 0, -4)
				f.scroll_buttons.up:SetPoint("BOTTOM", f.scroll_buttons.down, "TOP", 0, -2)
			else
				f.scroll_buttons.bottom:SetPoint("BOTTOMLEFT", f.cf, "BOTTOMLEFT", -32, -4)
				f.scroll_buttons.up:SetPoint("BOTTOM", f.scroll_buttons.down, "TOP", 0, -2)
			end
		end

		-- chat_buttons alpha:
		-- set alpha of the chat_buttons based on the alpha setting
		for _, v in pairs(f.scroll_buttons) do
			v:SetAlpha(self.db.profile.alpha)
		end
		-- chat_buttons visibility:
		-- show buttons based on visible value passed to function
		if f.cf then
			if visible and (f.cf:GetHeight() > f.scroll_buttons_height) then
				for k, _ in pairs(f.scroll_buttons) do
					f.scroll_buttons[k]:Show()
				end
			else
				for k, _ in pairs(f.scroll_buttons) do
					f.scroll_buttons[k]:Hide()
				end
				-- reminder visibility:
				-- show the reminder button (if enabled) when not at the bottom of the chatframe
				if (not f.cf:AtBottom()) and self.db.profile.reminder and (f.cf:GetHeight() > f.scroll_reminder:GetHeight()) then
					local b = f.scroll_reminder
					b:ClearAllPoints()
					if f.cf:GetJustifyH() == "RIGHT" then
						b:SetPoint("LEFT", f.cf, "LEFT", 0, 0)
						b:SetPoint("RIGHT", f.cf, "LEFT", 32, 0)
						b:SetPoint("TOP", f.cf, "BOTTOM", 0, 28)
						b:SetPoint("BOTTOM", f.cf, "BOTTOM", 0, 0)
					elseif f.cf:GetJustifyH() == "LEFT" then
						b:SetPoint("RIGHT", f.cf, "RIGHT", 0, 0)
						b:SetPoint("LEFT", f.cf, "RIGHT", -32, 0)
						b:SetPoint("TOP", f.cf, "BOTTOM", 0, 28)
						b:SetPoint("BOTTOM", f.cf, "BOTTOM", 0, 0)
					end

					f.scroll_reminder:Show()
					f.scroll_reminder_flash:Show()
				else
					f.scroll_reminder:Hide()
					f.scroll_reminder_flash:Hide()
				end
			end
		end
	end

	-- create a "reminder" button
	--[[------------------------------------------------
		BR: Cria o botão de retorno para voltar ao final da conversa
		EN: Creates the reminder button to return to the chat bottom
	------------------------------------------------]]--
	function module:make_reminder(id)
		-- define variables used
		local cf = _G["ChatFrame" .. id]
		local b = _G["ChatFrame" .. id .. "ScrollDownReminder"]
		if b then
			return b
		end
		b = CreateFrame("Button", "ChatFrame" .. id .. "ScrollDownReminder", cf)
		-- define the parameters for the button
		b:SetFrameStrata("BACKGROUND")
		b:SetWidth(24)
		b:SetHeight(24)
		b:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollEnd-Up")
		b:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollEnd-Down")
		b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
		b:SetPoint("RIGHT", cf, "RIGHT", 0, 0)
		b:SetPoint("LEFT", cf, "RIGHT", -32, 0)
		b:SetPoint("TOP", cf, "BOTTOM", 0, 28)
		b:SetPoint("BOTTOM", cf, "BOTTOM", 0, 0)
		b:SetScript("OnClick", function()
			PlaySound(SOUNDKIT.IG_CHAT_BOTTOM);
			cf:ScrollToBottom()
		end)
		-- hide the button by default
		b:Hide()
		-- add a flash texture for the reminder button
		self:add_flash_texture(b)

		return b
	end

	-- create a "flash" texture
	--[[------------------------------------------------
		BR: Adiciona textura de flash ao botão de lembrete
		EN: Adds flash texture to the reminder button
	------------------------------------------------]]--
	function module:add_flash_texture(frame)
		-- define variables used
		local t = frame:CreateTexture(frame:GetName() .. "Flash", "OVERLAY")
		-- define the parameters for the texture
		t:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-BlinkHilight")
		t:SetPoint("CENTER", frame, "CENTER", 0, 1)
		t:SetBlendMode("ADD")
		t:SetAlpha(0.5)
		-- hide the texture by default
		t:Hide()
	end


	--[[------------------------------------------------
		BR: Aliases legados para reduzir risco com chamadas antigas
		EN: Legacy aliases to reduce risk from older calls
	------------------------------------------------]]--
	module.ConfigureAllFrames = module.configure_all_frames
	module.ChatFrame_OnUpdateHook = module.chat_frame_on_update_hook
	module.ChatFrame_OnUpdate = module.chat_frame_on_update
	module.ButtonFrame = module.button_frame
	module.ChatMenu = module.chat_menu
	module.chatbutton = module.chat_button
	module.MakeReminder = module.make_reminder
	module.AddFlashTexture = module.add_flash_texture

	return
end) -- Prat:AddModuleToLoad
