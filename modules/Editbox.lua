--[[
    @File:      Editbox.lua
    @Project:   Prat-3.0

    BR: Personalização da caixa de edição do chat.
        - Posição superior, inferior ou flutuante
        - Texturas, cores, bordas e fonte da caixa de texto
        - Redimensionamento e movimentação da editbox
        - Histórico por setas e comportamento com tecla Alt
        - Compatibilidade com ChatFrameUtil e clientes antigos

    EN: Chat edit box customization.
        - Top, bottom or free-floating positioning
        - Textures, colors, borders and edit box font
        - Edit box resizing and movement
        - Arrow history and Alt-key behavior
        - Compatibility with ChatFrameUtil and older clients

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Origem histórica do módulo
    EN: Historical module origin
------------------------------------------------]]--
-- This is the editbox module from Chatter by Antiarc

--[[------------------------------------------------
    BR: Compatibilidade com APIs antigas e modernas de CVars
    EN: Compatibility with old and modern CVar APIs
------------------------------------------------]]--
local GetCVar = _G.GetCVar or _G.C_CVar.GetCVar

--[[------------------------------------------------
    BR: Compatibilidade com utilitários antigos e modernos do ChatFrame
    EN: Compatibility with old and modern ChatFrame utilities
------------------------------------------------]]--
local ChatEdit_ChooseBoxForSend = _G.ChatEdit_ChooseBoxForSend or _G.ChatFrameUtil.ChooseBoxForSend
local ChatEdit_DeactivateChat = _G.ChatEdit_DeactivateChat or _G.ChatFrameUtil.DeactivateChat

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo Editbox com suporte a hooks
		EN: Creation of the Editbox module with hook support
	------------------------------------------------]]--
	local module = Prat:NewModule("Editbox", "AceHook-3.0")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL
	local Media = Prat.Media
	local backgrounds, borders, fonts = {}, {}, {}
	local CreateFrame = _G.CreateFrame
	local max = _G.max
	local pairs = _G.pairs

	--[[------------------------------------------------
		BR: Pontos válidos para fixar ou soltar a caixa de edição
		EN: Valid points for attaching or freeing the edit box
	------------------------------------------------]]--
	local valid_attach_points = {
		TOP = PL["attach_top"],
		BOTTOM = PL["attach_bottom"],
		FREE = PL["attach_free"],
		LOCK = PL["attach_locked"]
	}

	--[[------------------------------------------------
		BR: Aplica chamadas em todas as caixas de edição do chat
		EN: Applies method calls to all chat edit boxes
	------------------------------------------------]]--
	local function update_edit_box(method, ...)
		for i = 1, #CHAT_FRAMES do
			local f = _G["ChatFrame" .. i .. "EditBox"]
			f[method](f, ...)
		end
	end

	--[[------------------------------------------------
		BR: Configuração das opções da interface do módulo
		EN: Module interface options configuration
	------------------------------------------------]]--
	Prat:SetModuleOptions(module, {
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

			placement_group = {
				type = "group",
				name = PL["placement_group_name"],
				desc = PL["placement_group_desc"],
				order = 20,
				args = {
					placement_help = {
						name = PL["placement_help"],
						type = "description",
						order = 1,
						width = "full",
					},

					attach = {
						type = "select",
						name = PL["attach_name"],
						desc = PL["attach_desc"],
						order = 10,
						width = 1.25,
						values = valid_attach_points,
						get = function()
							return module.db.profile.attach
						end,
						set = function(_, v)
							module.db.profile.attach = v
							module:set_attach()
						end
					},

					font = {
						type = "select",
						name = PL["font_name"],
						desc = PL["font_desc"],
						order = 20,
						width = 1.25,
						values = fonts,
						get = function()
							return module.db.profile.font
						end,
						set = function(_, v)
							module.db.profile.font = v
							for i = 1, #CHAT_FRAMES do
								local ff = _G["ChatFrame" .. i .. "EditBox"]
								local header = _G[ff:GetName() .. "Header"]
								local _, s, m = ff:GetFont()
								local font = Media:Fetch("font", v)
								ff:SetFont(font, s, m)
								header:SetFont(font, s, m)
							end
						end
					},
				},
			},

			appearance_group = {
				type = "group",
				name = PL["appearance_tab_name"],
				desc = PL["appearance_tab_desc"],
				order = 30,
				args = {
					appearance_help = {
						name = PL["appearance_help"],
						type = "description",
						order = 1,
						width = "full",
					},

					background = {
						type = "select",
						name = PL["background_name"],
						desc = PL["background_desc"],
						order = 10,
						width = 1.25,
						values = backgrounds,
						get = function()
							return module.db.profile.background
						end,
						set = function(_, v)
							module.db.profile.background = v
							module:set_backdrop()
						end
					},

					border = {
						type = "select",
						name = PL["border_name"],
						desc = PL["border_desc"],
						order = 20,
						width = 1.25,
						values = borders,
						get = function()
							return module.db.profile.border
						end,
						set = function(_, v)
							module.db.profile.border = v
							module:set_backdrop()
						end
					},

					spacer_after_media = {
						type = "description",
						name = "\n",
						order = 25,
						width = "full",
					},

					color_by_channel = {
						type = "toggle",
						name = PL["color_by_channel_name"],
						desc = PL["color_by_channel_desc"],
						order = 30,
						width = "full",
						get = function()
							return module.db.profile.color_by_channel
						end,
						set = function(_, v)
							module.db.profile.color_by_channel = v
							if v then
								module:SecureHook("ChatEdit_UpdateHeader", "set_border_by_channel", true)
							else
								if module:IsHooked("ChatEdit_UpdateHeader") then
									module:Unhook("ChatEdit_UpdateHeader")
									local c = module.db.profile.border_color
									for _, frame in ipairs(module.frames) do
										frame:SetBackdropBorderColor(c.r, c.g, c.b, c.a)
									end
								end
							end
						end
					},

					border_color = {
						type = "color",
						name = PL["border_color_name"],
						desc = PL["border_color_desc"],
						order = 40,
						width = 1.25,
						hasAlpha = true,
						get = function()
							local c = module.db.profile.border_color
							return c.r, c.g, c.b, c.a
						end,
						set = function(_, r, g, b, a)
							local c = module.db.profile.border_color
							c.r, c.g, c.b, c.a = r, g, b, a
							module:set_backdrop()
						end
					},

					background_color = {
						type = "color",
						name = PL["background_color_name"],
						desc = PL["background_color_desc"],
						order = 50,
						width = 1.25,
						hasAlpha = true,
						get = function()
							local c = module.db.profile.background_color
							return c.r, c.g, c.b, c.a
						end,
						set = function(_, r, g, b, a)
							local c = module.db.profile.background_color
							c.r, c.g, c.b, c.a = r, g, b, a
							module:set_backdrop()
						end
					},
				},
			},

			border_group = {
				type = "group",
				name = PL["border_group_name"],
				desc = PL["border_group_desc"],
				order = 40,
				args = {
					border_help = {
						name = PL["border_help"],
						type = "description",
						order = 1,
						width = "full",
					},

					edge_size = {
						type = "range",
						name = PL["edge_size_name"],
						desc = PL["edge_size_desc"],
						order = 10,
						width = 1.25,
						min = 1,
						max = 64,
						step = 1,
						bigStep = 1,
						get = function()
							return module.db.profile.edge_size
						end,
						set = function(_, v)
							module.db.profile.edge_size = v
							module:set_backdrop()
						end
					},

					inset = {
						type = "range",
						name = PL["inset_name"],
						desc = PL["inset_desc"],
						order = 20,
						width = 1.25,
						min = 1,
						max = 64,
						step = 1,
						bigStep = 1,
						get = function()
							return module.db.profile.inset
						end,
						set = function(_, v)
							module.db.profile.inset = v
							module:set_backdrop()
						end
					},

					tile_size = {
						type = "range",
						name = PL["tile_size_name"],
						desc = PL["tile_size_desc"],
						order = 30,
						width = 1.25,
						min = 1,
						max = 64,
						step = 1,
						bigStep = 1,
						get = function()
							return module.db.profile.tile_size
						end,
						set = function(_, v)
							module.db.profile.tile_size = v
							module:set_backdrop()
						end
					},
				},
			},

			behavior_group = {
				type = "group",
				name = PL["behavior_tab_name"],
				desc = PL["behavior_tab_desc"],
				order = 50,
				args = {
					behavior_help = {
						name = PL["behavior_help"],
						type = "description",
						order = 1,
						width = "full",
					},

					use_alt_key = {
						type = "toggle",
						name = PL["use_alt_key_name"],
						desc = PL["use_alt_key_desc"],
						order = 10,
						width = "full",
						get = function()
							return module.db.profile.use_alt_key
						end,
						set = function(_, v)
							module.db.profile.use_alt_key = v
							update_edit_box("SetAltArrowKeyMode", v)
						end,
					},
				},
			},
		}
	})

	--[[------------------------------------------------
		BR: Configuração dos valores padrão do módulo
		EN: Module default values configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			background = "Blizzard Tooltip",
			border = "Blizzard Tooltip",
			background_color = { r = 0, g = 0, b = 0, a = 1 },
			border_color = { r = 1, g = 1, b = 1, a = 1 },
			inset = 3,
			edge_size = 12,
			tile_size = 16,
			height = 22,
			attach = "BOTTOM",
			color_by_channel = true,
			use_alt_key = false,
			font = (function()
				for i = 1, #CHAT_FRAMES do
					local ff = _G["ChatFrame" .. i .. "EditBox"]
					local f = ff:GetFont()
					for k, v in pairs(Media:HashTable("font")) do
						if v == f then
							return k
						end
					end
				end
			end)()
		}
	})

	--[[------------------------------------------------
		BR: Atualiza listas de mídia disponíveis para seleção
		EN: Updates available media lists for selection
	------------------------------------------------]]--
	function module:LibSharedMedia_Registered()
		for _, v in pairs(Media:List("background")) do
			backgrounds[v] = v
		end
		for _, v in pairs(Media:List("border")) do
			borders[v] = v
		end
		for _, v in pairs(Media:List("font")) do
			fonts[v] = v
		end
	end


	--[[------------------------------------------------
		BR: Migra opções antigas de perfil para o padrão snake_case
		EN: Migrates old profile options to the snake_case standard
	------------------------------------------------]]--
	local function migrate_profile(profile)
		if not profile then
			return
		end

		local migrations = {
			backgroundColor = "background_color",
			borderColor = "border_color",
			edgeSize = "edge_size",
			tileSize = "tile_size",
			colorByChannel = "color_by_channel",
			useAltKey = "use_alt_key",
			editX = "edit_x",
			editY = "edit_y",
			editW = "edit_w",
		}

		for old_key, new_key in pairs(migrations) do
			if profile[new_key] == nil and profile[old_key] ~= nil then
				profile[new_key] = profile[old_key]
			end
		end
	end

	--[[------------------------------------------------
		BR: Cria a moldura visual personalizada da editbox
		EN: Creates the custom visual frame for the edit box
	------------------------------------------------]]--
	local function make_prat_editbox(self, i)
		if not self.frames[i] then
			local parent = _G["ChatFrame" .. i .. "EditBox"]

			local frame = CreateFrame("Frame", nil, parent, BackdropTemplateMixin and "BackdropTemplate")
			frame:SetFrameStrata("DIALOG")
			frame:SetFrameLevel(parent:GetFrameLevel() - 1)
			frame:SetAllPoints(parent)
			frame:Hide()
			parent.prat_frame = frame
			self.frames[i] = frame

			parent.left_drag = CreateFrame("Frame", nil, parent)
			parent.left_drag:SetWidth(15)
			parent.left_drag:SetPoint("TOPLEFT", parent, "TOPLEFT")
			parent.left_drag:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT")
			parent.left_drag.left = true

			parent.right_drag = CreateFrame("Frame", nil, parent)
			parent.right_drag:SetWidth(15)
			parent.right_drag:SetPoint("TOPRIGHT", parent, "TOPRIGHT")
			parent.right_drag:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT")
		end
	end

	--[[------------------------------------------------
		BR: Inicialização do módulo e preparação das editboxes existentes
		EN: Module initialization and preparation of existing edit boxes
	------------------------------------------------]]--
	Prat:SetModuleInit(module,
		function(self)

			Media.RegisterCallback(module, "LibSharedMedia_Registered")
			self.frames = {}

			self:LibSharedMedia_Registered()

			for i = 1, #CHAT_FRAMES do
				make_prat_editbox(self, i)
			end
		end)

	--[[------------------------------------------------
		BR: Controla histórico por setas quando Alt não é exigido
		EN: Controls arrow-key history when Alt is not required
	------------------------------------------------]]--
	local function on_arrow_pressed(self, key)
		-- We cannot call SetText while in lockdown
		if C_ChatInfo and C_ChatInfo.InChatMessagingLockdown and C_ChatInfo.InChatMessagingLockdown() then
			return
		end
		if #self.history_lines == 0 then
			return
		end

		if key == "DOWN" then
			self.history_index = self.history_index - 1

			if self.history_index < 1 then
				self.history_index = #self.history_lines
			end
		elseif key == "UP" then
			self.history_index = self.history_index + 1

			if self.history_index > #self.history_lines then
				self.history_index = 1
			end
		else
			return -- We don't want to interfere with LEFT/RIGHT because the tab-complete stuff might use it; we're already killing the other two.
		end

		self:SetText(self.history_lines[self.history_index])
	end

	--[[------------------------------------------------
		BR: Habilita o histórico por setas na editbox informada
		EN: Enables arrow-key history on the given edit box
	------------------------------------------------]]--
	local function enable_arrow_keys(e)
		e.history_lines = e.history_lines or {}
		e.history_index = e.history_index or 0
		e:HookScript("OnArrowPressed", on_arrow_pressed)
	end

	--[[------------------------------------------------
		BR: Atualiza a editbox quando uma janela de chat é criada/alterada
		EN: Updates the edit box when a chat frame is created/changed
	------------------------------------------------]]--
	function module:Prat_FramesUpdated(_, _, chatFrame)
		migrate_profile(self.db and self.db.profile)
		local i = chatFrame:GetID()
		local f = _G["ChatFrame" .. i .. "EditBox"]
		_G["ChatFrame" .. i .. "EditBoxLeft"]:Hide()
		_G["ChatFrame" .. i .. "EditBoxRight"]:Hide()
		_G["ChatFrame" .. i .. "EditBoxMid"]:Hide()
		if f.focusLeft then
			f.focusLeft:SetAlpha(0)
		end
		if f.focusRight then
			f.focusRight:SetAlpha(0)
		end
		if f.focusMid then
			f.focusMid:SetAlpha(0)
		end
		f:Hide()

		make_prat_editbox(self, i)
		self.frames[i]:Show()

		local _, s, m = f:GetFont()
		f:SetFont(Media:Fetch("font", self.db.profile.font), s, m)

		local header = _G[f:GetName() .. "Header"]
		local _, s2, m2 = header:GetFont()
		header:SetFont(Media:Fetch("font", self.db.profile.font), s2, m2)

		f:SetAltArrowKeyMode(module.db.profile.use_alt_key and 1 or nil)
		if (not module.db.profile.use_alt_key) then
			enable_arrow_keys(f)
		end
		self:set_backdrop()
		self:update_height()
		self:set_attach(nil, self.db.profile.edit_x, self.db.profile.edit_y, self.db.profile.edit_w)
	end

	--[[------------------------------------------------
		BR: Ativação do módulo, criação visual e instalação dos hooks
		EN: Module activation, visual setup and hook installation
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db and self.db.profile)
		self:LibSharedMedia_Registered()

		for i = 1, #CHAT_FRAMES do
			local f = _G["ChatFrame" .. i .. "EditBox"]
			_G["ChatFrame" .. i .. "EditBoxLeft"]:Hide()
			_G["ChatFrame" .. i .. "EditBoxRight"]:Hide()
			_G["ChatFrame" .. i .. "EditBoxMid"]:Hide()
			if f.focusLeft then
				f.focusLeft:SetAlpha(0)
			end
			if f.focusRight then
				f.focusRight:SetAlpha(0)
			end
			if f.focusMid then
				f.focusMid:SetAlpha(0)
			end
			f:Hide()

			-- Prevent an error in FloatingChatFrame FCF_FadeOutChatFrame() (blizz bug)
			f:SetAlpha(f:GetAlpha() or 0)

			make_prat_editbox(self, i) -- For new temporary chat frames created between init and now
			self.frames[i]:Show()
			local _, s, m = f:GetFont()
			f:SetFont(Media:Fetch("font", self.db.profile.font), s, m)

			local header = _G[f:GetName() .. "Header"]
			local _, s2, m2 = header:GetFont()
			header:SetFont(Media:Fetch("font", self.db.profile.font), s2, m2)

			f:SetAltArrowKeyMode(module.db.profile.use_alt_key and 1 or nil)
			if (not module.db.profile.use_alt_key) then
				enable_arrow_keys(f)
			end
		end

		self:set_backdrop()

		self:set_attach(nil, self.db.profile.edit_x, self.db.profile.edit_y, self.db.profile.edit_w)

		if _G.ChatFrameUtil then
			if _G.ChatFrameUtil.DeactivateChat then
				self:SecureHook(_G.ChatFrameUtil, "DeactivateChat", "ChatEdit_DeactivateChat")
			end
			if _G.ChatFrameUtil.SetLastActiveWindow then
				self:SecureHook(_G.ChatFrameUtil, "SetLastActiveWindow", "ChatEdit_SetLastActiveWindow")
			end
			if _G.ChatFrameUtil.OpenChat then
				self:SecureHook(_G.ChatFrameUtil, "OpenChat", "ChatFrame_OpenChat")
			end
		else
			self:SecureHook("ChatEdit_DeactivateChat")
			self:SecureHook("ChatEdit_SetLastActiveWindow")
			self:SecureHook("ChatFrame_OpenChat")
		end

		self:set_backdrop()
		self:update_height()
		if self.db.profile.color_by_channel then
			if _G.ChatFrameEditBoxBaseMixin and _G.ChatFrameEditBoxBaseMixin.UpdateHeader then
				self:SecureHook(_G.ChatFrameEditBoxBaseMixin, "UpdateHeader", "set_border_by_channel")
			else
				self:SecureHook("ChatEdit_UpdateHeader", "set_border_by_channel", true)
			end
		end
		self:SecureHook("FCF_FadeInChatFrame")

		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
	end

	--[[------------------------------------------------
		BR: Reinicia índice do histórico ao abrir a caixa de chat
		EN: Resets history index when opening the chat edit box
	------------------------------------------------]]--
	function module:ChatFrame_OpenChat(_, chatFrame)
		if not self.db.profile.use_alt_key then
			local frame = ChatEdit_ChooseBoxForSend(chatFrame)

			frame.history_index = 0
		end
	end

	--[[------------------------------------------------
		BR: Corrige comportamento visual da editbox em estilos modernos de chat
		EN: Fixes edit box visual behavior in modern chat styles
	------------------------------------------------]]--
	function module:FCF_FadeInChatFrame(frame)
		if self.db.profile.attach == "TOP" and GetCVar("chatStyle") ~= "classic" then
			local chatFrame = _G["ChatFrame" .. frame:GetID()];
			ChatEdit_DeactivateChat(chatFrame.editBox)
			chatFrame.editBox:Hide()
		end
	end

	--[[------------------------------------------------
		BR: Desativação do módulo e restauração da editbox padrão da Blizzard
		EN: Module deactivation and Blizzard default edit box restoration
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:set_attach("BOTTOM") -- clear move/resize handlers
		for i = 1, #CHAT_FRAMES do
			local f = _G["ChatFrame" .. i .. "EditBox"]
			_G["ChatFrame" .. i .. "EditBoxLeft"]:Show()
			_G["ChatFrame" .. i .. "EditBoxRight"]:Show()
			_G["ChatFrame" .. i .. "EditBoxMid"]:Show()
			if f.focusLeft then
				f.focusLeft:SetAlpha(1)
			end
			if f.focusRight then
				f.focusRight:SetAlpha(1)
			end
			if f.focusMid then
				f.focusMid:SetAlpha(1)
			end
			f:SetAltArrowKeyMode(true)
			f:EnableMouse(true)
			f.prat_frame:Hide()
			-- restore Blizz size/position
			f:ClearAllPoints()
			f:SetHeight(32)
			f:SetPoint("TOPLEFT", f.chatFrame, "BOTTOMLEFT", -5, -2)
			if Prat.IsClassic then
				f:SetPoint("TOPRIGHT", f.chatFrame, "BOTTOMRIGHT", 5, -2)
			else
				f:SetPoint("RIGHT", f.chatFrame.ScrollBar, "RIGHT", 5, 0)
			end
		end
	end

	--[[------------------------------------------------
		BR: Retorna a descrição localizada do módulo
		EN: Returns the localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	-- changed the Hide to SetAlpha(0), the new ChatSystem OnHide handlers go though some looping
	-- when in IM style and Classic style, cause heavy delays on the chat edit box.
	--[[------------------------------------------------
		BR: Controla transparência da editbox ao alternar janela ativa
		EN: Controls edit box transparency when changing active window
	------------------------------------------------]]--
	function module:ChatEdit_SetLastActiveWindow(frame)
		if frame:IsShown() then
			frame:SetAlpha(0)
		else
			frame:SetAlpha(1)
		end
		frame:EnableMouse(true)
	end

	--[[------------------------------------------------
		BR: Esconde visualmente a editbox ao desativar o chat
		EN: Visually hides the edit box when deactivating chat
	------------------------------------------------]]--
	function module:ChatEdit_DeactivateChat(frame)
		if frame:IsShown() then
			frame:SetAlpha(0)
			frame:EnableMouse(false)
		end
	end

	--[[------------------------------------------------
		BR: Aplica textura, borda e cores à moldura da editbox
		EN: Applies texture, border and colors to the edit box frame
	------------------------------------------------]]--
	function module:set_backdrop()
		for _, frame in ipairs(self.frames) do
			frame:SetBackdrop({
				bgFile = Media:Fetch("background", self.db.profile.background),
				edgeFile = Media:Fetch("border", self.db.profile.border),
				tile = true,
				tileSize = self.db.profile.tile_size,
				edgeSize = self.db.profile.edge_size,
				insets = {
					left = self.db.profile.inset,
					right = self.db.profile.inset,
					top = self.db.profile.inset,
					bottom = self.db.profile.inset
				}
			})
			local c = self.db.profile.background_color
			frame:SetBackdropColor(c.r, c.g, c.b, c.a)

			local c2 = self.db.profile.border_color
			frame:SetBackdropBorderColor(c2.r, c2.g, c2.b, c2.a)
		end
	end

	--[[------------------------------------------------
		BR: Colore a borda da editbox conforme o canal ativo
		EN: Colors the edit box border according to the active channel
	------------------------------------------------]]--
	function module:set_border_by_channel()
		for index, frame in ipairs(self.frames) do
			local f = _G["ChatFrame" .. index .. "EditBox"]
			local attr = f:GetAttribute("chatType")
			if attr == "CHANNEL" then
				local chan = f:GetAttribute("channelTarget")
				if chan == 0 then
					local c = self.db.profile.border_color
					frame:SetBackdropBorderColor(c.r, c.g, c.b, c.a)
				elseif chan and ChatTypeInfo["CHANNEL" .. chan] then
					local r, g, b = GetMessageTypeColor("CHANNEL" .. chan)
					frame:SetBackdropBorderColor(r, g, b, 1)
				end
			else
				local r, g, b = GetMessageTypeColor(attr)
				frame:SetBackdropBorderColor(r, g, b, 1)
			end
		end
	end

	do
		--[[------------------------------------------------
		BR: Funções internas para movimentação e redimensionamento livre
		EN: Internal functions for free movement and resizing
	------------------------------------------------]]--
	local function start_moving(self)
			self:StartMoving()
		end

		local function stop_moving(self)
			self:StopMovingOrSizing()
			module.db.profile.edit_x = self:GetLeft()
			module.db.profile.edit_y = self:GetTop()
			module.db.profile.edit_w = self:GetRight() - self:GetLeft()
		end

		local chat_frame_height
		local function constrain_height(self)
			self:GetParent():SetHeight(chat_frame_height)
		end

		local function start_dragging(self)
			chat_frame_height = self:GetParent():GetHeight()
			self:GetParent():StartSizing(not self.left and "TOPRIGHT" or "TOPLEFT")
			self:SetScript("OnUpdate", constrain_height)
		end

		local function stop_dragging(self)
			local parent = self:GetParent()
			parent:StopMovingOrSizing()
			self:SetScript("OnUpdate", nil)
			module.db.profile.edit_x = parent:GetLeft()
			module.db.profile.edit_y = parent:GetTop()
			module.db.profile.edit_w = parent:GetWidth()
		end

		--[[------------------------------------------------
			BR: Posiciona, trava ou libera a editbox conforme configuração
			EN: Positions, locks or frees the edit box according to settings
		------------------------------------------------]]--
		function module:set_attach(val, x, y, w)
			for i = 1, #CHAT_FRAMES do
				local frame = _G["ChatFrame" .. i .. "EditBox"]
				val = val or self.db.profile.attach
				if not x and val == "FREE" then
					if self.db.profile.edit_x and self.db.profile.edit_y then
						x, y, w = self.db.profile.edit_x, self.db.profile.edit_y, self.db.profile.edit_w
					else
						x, y, w = frame:GetLeft(), frame:GetTop(), max(frame:GetWidth(), (frame:GetRight() or 0) - (frame:GetLeft() or 0))
					end
				end
				if not w or w < 10 then
					w = 100
				end
				frame:ClearAllPoints()
				if val ~= "FREE" then
					frame:SetMovable(false)
					frame.left_drag:EnableMouse(false)
					frame.right_drag:EnableMouse(false)
					frame:SetScript("OnMouseDown", nil)
					frame:SetScript("OnMouseUp", nil)
					frame.left_drag:EnableMouse(false)
					frame.right_drag:EnableMouse(false)
					frame.left_drag:SetScript("OnMouseDown", nil)
					frame.right_drag:SetScript("OnMouseDown", nil)
					frame.left_drag:SetScript("OnMouseUp", nil)
					frame.right_drag:SetScript("OnMouseUp", nil)
				end

				local scrollbar_width = frame.chatFrame.ScrollBar and frame.chatFrame.ScrollBar:GetWidth() or 0
				if val == "TOP" then
					frame:SetPoint("BOTTOMLEFT", frame.chatFrame, "TOPLEFT", 0, 3)
					frame:SetPoint("BOTTOMRIGHT", frame.chatFrame, "TOPRIGHT", scrollbar_width, 3)
				elseif val == "BOTTOM" then
					frame:SetPoint("TOPLEFT", frame.chatFrame, "BOTTOMLEFT", 0, -8)
					frame:SetPoint("TOPRIGHT", frame.chatFrame, "BOTTOMRIGHT", scrollbar_width, -8)
				elseif val == "FREE" then
					frame:EnableMouse(true)
					frame:SetMovable(true)
					frame:SetResizable(true)
					frame:SetScript("OnMouseDown", start_moving)
					frame:SetScript("OnMouseUp", stop_moving)
					frame:SetWidth(w)
					frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x, y)
					local minWidth, minHeight = 40, 1
					if frame.SetResizeBounds then
						frame:SetResizeBounds(minWidth, minHeight)
					else
						frame:SetMinResize(minWidth, minHeight)
					end

					frame.left_drag:EnableMouse(true)
					frame.right_drag:EnableMouse(true)

					frame.left_drag:SetScript("OnMouseDown", start_dragging)
					frame.right_drag:SetScript("OnMouseDown", start_dragging)

					frame.left_drag:SetScript("OnMouseUp", stop_dragging)
					frame.right_drag:SetScript("OnMouseUp", stop_dragging)
				elseif val == "LOCK" then
					frame:SetWidth(self.db.profile.edit_w or w)
					frame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", self.db.profile.edit_x or x, self.db.profile.edit_y or y)
				end
			end
		end
	end

	--[[------------------------------------------------
		BR: Atualiza a altura das caixas de edição
		EN: Updates edit box height
	------------------------------------------------]]--
	function module:update_height()
		for i, _ in ipairs(self.frames) do
			local ff = _G["ChatFrame" .. i .. "EditBox"]
			ff:SetHeight(module.db.profile.height)
		end
	end


	--[[------------------------------------------------
		BR: Aliases legados para reduzir risco com referências antigas
		EN: Legacy aliases to reduce risk with older references
	------------------------------------------------]]--
	module.SetBackdrop = module.set_backdrop
	module.SetBorderByChannel = module.set_border_by_channel
	module.SetAttach = module.set_attach
	module.UpdateHeight = module.update_height

	return
end) -- Prat:AddModuleToLoad
