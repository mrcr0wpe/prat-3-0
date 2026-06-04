--[[
    @File:      ChatTabs.lua
    @Project:   Prat-3.0

    BR: Controle visual e comportamental das abas do chat.
        - Transparência das abas
        - Visibilidade individual/global
        - Flash e destaque por mensagem
        - Alteração de cor das fontes
        - Controle de timeout e persistência
        - Tamanho da fonte das abas
        - Texturas e efeitos visuais

    EN: Visual and behavioral control of chat tabs.
        - Tab transparency
        - Individual/global visibility
        - Flashing and message highlighting
        - Font color changes
        - Timeout and persistence control
        - Tab font sizing
        - Textures and visual effects

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Registro tardio do módulo de abas do chat
    EN: Deferred registration of the chat tabs module
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo responsável pelas abas do chat
		EN: Creation of the module responsible for chat tabs
	------------------------------------------------]]--
	local module = Prat:NewModule("ChatTabs", "AceHook-3.0")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	module.highlight_tabs_plugin = {}

	--[[------------------------------------------------
		BR: Valores padrão do módulo
		EN: Module default values
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = false,
			display_mode = {},
			highlight_tabs = {
				["*"] = {
					flash = false,
					flash_color = {
						r = 124 / 255,
						g = 239 / 255,
						b = 232 / 255,
						a = 0.7,
					},
					change_font = false,
					font_color = {
						r = 221 / 255,
						g = 27 / 255,
						b = 24 / 255,
						a = 1,
					}
				},
			},
			disable_flash = false,
			inactive_alpha = 0,
			active_alpha = 0,
			prevent_drag = false,
			show_tab_textures = true,

			forever_alert = false,
			alert_timeout = 3.2,
			tab_font_size = 12,
		}
	})


	--[[------------------------------------------------
		BR: Migra nomes antigos do profile para o padrão snake_case
		EN: Migrates old profile keys to the snake_case standard
	------------------------------------------------]]--
	function module:migrate_profile()
		local profile = self.db and self.db.profile
		if not profile then
			return
		end

		local profile_key_map = {
			displaymode = "display_mode",
			highlighttabs = "highlight_tabs",
			disableflash = "disable_flash",
			notactivealpha = "inactive_alpha",
			activealpha = "active_alpha",
			preventdrag = "prevent_drag",
			showtabtextures = "show_tab_textures",
			foreveralert = "forever_alert",
			keephighlightinactive = "keep_highlight_inactive",
			alerttimeout = "alert_timeout",
			tabfontsize = "tab_font_size",
		}

		for old_key, new_key in pairs(profile_key_map) do
			if profile[new_key] == nil and profile[old_key] ~= nil then
				profile[new_key] = profile[old_key]
			end
			profile[old_key] = nil
		end

		if profile.highlight_tabs then
			for _, settings in pairs(profile.highlight_tabs) do
				if type(settings) == "table" then
					if settings.flash_color == nil and settings.flashcolor ~= nil then
						settings.flash_color = settings.flashcolor
					end
					settings.flashcolor = nil

					if settings.change_font == nil and settings.changefont ~= nil then
						settings.change_font = settings.changefont
					end
					settings.changefont = nil

					if settings.font_color == nil and settings.fontcolor ~= nil then
						settings.font_color = settings.fontcolor
					end
					settings.fontcolor = nil
				end
			end
		end
	end

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

			visibility_group = {
				type = "group",
				name = PL["visibility_tab_name"],
				desc = PL["visibility_tab_desc"],
				order = 20,
				args = {
					visibility_help = {
						name = PL["visibility_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					display_mode = {
						name = PL["display_mode_name"],
						desc = PL["display_mode_desc"],
						type = "multiselect",
						tristate = true,
						order = 20,
						values = Prat.FrameList,
						get = "GetSubValue",
						set = "SetSubValue",
					},

					spacer_after_display_mode = {
						type = "description",
						name = "\n",
						order = 25,
						width = "full",
					},

					active_alpha = {
						name = PL["active_alpha_name"],
						desc = PL["active_alpha_desc"],
						type = "range",
						order = 30,
						width = 1.25,
						min = 0.0,
						max = 1,
						step = 0.1,
					},

					inactive_alpha = {
						name = PL["inactive_alpha_name"],
						desc = PL["inactive_alpha_desc"],
						type = "range",
						order = 40,
						width = 1.25,
						min = 0.0,
						max = 1,
						step = 0.1,
					},

					show_tab_textures = {
						name = PL["show_tab_textures_name"],
						desc = PL["show_tab_textures_desc"],
						type = "toggle",
						width = "full",
						order = 50,
					},

					tab_font_size = {
						name = PL["tab_font_size_name"],
						desc = PL["tab_font_size_desc"],
						type = "range",
						order = 60,
						width = 1.25,
						min = 8,
						max = 24,
						step = 1,
					},
				},
			},

			alerts_group = {
				name = PL["alerts_tab_name"],
				desc = PL["alerts_tab_desc"],
				type = "group",
				order = 30,
				args = {
					alerts_help = {
						name = PL["alerts_help"],
						type = "description",
						order = 1,
						width = "full",
					},

					disable_flash = {
						name = PL["disable_flash_name"],
						desc = PL["disable_flash_desc"],
						type = "toggle",
						width = "full",
						order = 10,
					},

					forever_alert = {
						name = PL["forever_alert_name"],
						desc = PL["forever_alert_desc"],
						type = "toggle",
						width = "full",
						order = 20,
					},

					keep_highlight_inactive = {
						name = PL["keep_highlight_inactive_name"],
						desc = PL["keep_highlight_inactive_desc"],
						type = "toggle",
						width = "full",
						order = 30,
					},

					alert_timeout = {
						name = PL["alert_timeout_name"],
						desc = PL["alert_timeout_desc"],
						type = "range",
						width = 1.25,
						order = 40,
						min = 0.1,
						max = 15,
					},
				},
			},

			per_window_group = {
				name = PL["per_window_header"],
				desc = PL["per_window_help"],
				type = "group",
				order = 40,
				plugins = module.highlight_tabs_plugin,
				args = {
					per_window_help = {
						name = PL["per_window_help"],
						type = "description",
						order = 10,
						width = "full",
					},
				},
			},
		}
	})

-- ============================================================================
-- BR: Atualiza as opções dinâmicas de destaque/flashing para cada janela
-- EN: Rebuilds dynamic highlight/flashing options for each window
-- ============================================================================
	function module:update_highlight_tabs_config()
		local get_toggle = function(info)
			return self.db.profile.highlight_tabs[info[#info - 1]][info[#info]]
		end
		local set_toggle = function(info, value)
			self.db.profile.highlight_tabs[info[#info - 1]][info[#info]] = value
		end
		local get_color = function(info)
			local color = self.db.profile.highlight_tabs[info[#info - 1]][info[#info]]
			return color.r, color.g, color.b, color.a
		end
		local set_color = function(info, r, g, b, a)
			self.db.profile.highlight_tabs[info[#info - 1]][info[#info]] = {
				r = r,
				g = g,
				b = b,
				a = a,
			}
		end
		local ordered_frames = {}
		for _, frame in pairs(Prat.Frames) do
			if (frame.isDocked == 1) or frame:IsShown() then
				table.insert(ordered_frames, frame)
			end
		end
		table.sort(ordered_frames, function(a, b)
			return a:GetID() < b:GetID()
		end)
		for index, frame in pairs(ordered_frames) do
			local raw = frame:GetName()
			local name = frame.name
			self.highlight_tabs_plugin[raw] = {
				[raw] = {
					name = name,
					type = "group",
					inline = true,
					order = 20 + (index * 10),
					args = {
						--[[------------------------------------------------
							BR: Flash visual da aba para esta janela
							EN: Visual tab flash for this window
						------------------------------------------------]]--
						row1 = {
							name = PL["flash_row_name"],
							desc = PL["flash_row_desc"],
							type = "group",
							inline = true,
							order = 1,
							args = {
								flash = {
									name = PL["set_flash_name"],
									desc = PL["set_flash_desc"],
									order = 10,
									type = "toggle",
									width = 1.65,
								},
								flash_color = {
									name = PL["flash_color_name"],
									desc = PL["flash_color_desc"],
									type = "color",
									order = 20,
									get = get_color,
									set = set_color,
									width = 0.6,
								},
							},
						},
						--[[------------------------------------------------
							BR: Alteração temporária da cor do texto da aba
							EN: Temporary tab text color change
						------------------------------------------------]]--
						row2 = {
							name = PL["font_row_name"],
							desc = PL["font_row_desc"],
							type = "group",
							inline = true,
							order = 2,
							args = {
								change_font = {
									name = PL["change_font_name"],
									desc = PL["change_font_desc"],
									order = 30,
									type = "toggle",
									width = 1.65,
								},
								font_color = {
									name = PL["font_color_name"],
									desc = PL["font_color_desc"],
									type = "color",
									order = 40,
									get = get_color,
									set = set_color,
									width = 0.6,
								},
							},
						},
					},
				}
			}
		end
	end

	--[[------------------------------------------------
		BR: Instala hooks e ativa gerenciamento das abas
		EN: Installs hooks and enables tab management
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:migrate_profile()

		self:SecureHook("FCF_StartAlertFlash")
		self:SecureHook("FCFTab_UpdateAlpha")
		self:SecureHook("FCF_StopAlertFlash")

		self:hooked_mode(true)
		self.chat_tabTexture = {}
		self.chatAlertTimers = {}
		self.chatAlertCleanupActions = {}

		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_REMOVED)
		self:update_all_tabs()
		self:update_highlight_tabs_config()
	end

	--[[------------------------------------------------
		BR: Remove hooks e restaura comportamento padrão
		EN: Removes hooks and restores default behavior
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:remove_hooks()
	end

	--[[------------------------------------------------
		BR: Atualiza configuração quando frames são alterados
		EN: Updates configuration when frames change
	------------------------------------------------]]--
	function module:Prat_FramesUpdated()
		self:update_highlight_tabs_config()
		for _, v in pairs(Prat.Frames) do
			self:show_hide_tab_textures(v)
		end
	end

	--[[------------------------------------------------
		BR: Atualiza configuração quando frames são removidos
		EN: Updates configuration when frames are removed
	------------------------------------------------]]--
	function module:Prat_FramesRemoved()
		self:update_highlight_tabs_config()
	end
	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Alterna instalação/remoção de hooks globais
		EN: Toggles installation/removal of global hooks
	------------------------------------------------]]--
	function module:hooked_mode(hooked)
		if hooked then
			self:RawHook("FCF_Close", true)
			self:install_hooks()
		else
			self:remove_hooks()
		end
	end

	local need_to_hook = {}

	--[[------------------------------------------------
		BR: Instala hooks individuais nas abas e chatframes
		EN: Installs per-tab and per-chatframe hooks
	------------------------------------------------]]--
	function module:install_hooks()
		for frameName, chat_frame in pairs(Prat.Frames) do
			local tab_button = _G[frameName .. "Tab"]
			self:HookScript(tab_button, "OnShow", "OnTabShow")
			self:SecureHook(chat_frame, "AddMessage")
			if tab_button:IsShown() then
				self:HookScript(tab_button, "OnHide", "OnTabHide")
				need_to_hook[tab_button] = nil
			else
				need_to_hook[tab_button] = true
			end
		end
	end

	--[[------------------------------------------------
		BR: Remove hooks instalados pelo módulo
		EN: Removes hooks installed by the module
	------------------------------------------------]]--
	function module:remove_hooks()
		for k, _ in pairs(Prat.Frames) do
			local cftab = _G[k .. "Tab"]
			cftab:SetScript("OnShow", function()
				return
			end)
			cftab:SetScript("OnHide", function()
				return
			end)
		end
		-- unhook functions
		self:UnhookAll()
	end

	--[[------------------------------------------------
		BR: Atualiza todas as abas após alteração de configuração
		EN: Updates all tabs after configuration changes
	------------------------------------------------]]--
	function module:OnValueChanged()
		self:update_all_tabs()
	end

	function module:OnSubValueChanged()
		self:update_all_tabs()
	end

	local chat_tab_textures_retail = {
		"Left", "Right", "Middle",
		"HighlightLeft", "HighlightRight", "HighlightMiddle",
		"ActiveLeft", "ActiveRight", "ActiveMiddle",
	}
	local chat_tab_textures_selected_retail = {
		"ActiveLeft", "ActiveRight", "ActiveMiddle",
	}
	local chat_tab_textures_classic = {
		"Left", "Right", "Middle",
		"HighlightLeft", "HighlightRight", "HighlightMiddle",
		"SelectedLeft", "SelectedRight", "SelectedMiddle",
	}
	local chat_tab_textures_selected_classic = {
		"SelectedLeft", "SelectedRight", "SelectedMiddle",
	}

	--[[------------------------------------------------
		BR: Mostra ou esconde texturas das abas
		EN: Shows or hides tab textures
	------------------------------------------------]]--
	function module:show_hide_tab_textures(tab)
		local tab_button = _G[tab:GetName() .. "Tab"]
		local alpha = self.db.profile.show_tab_textures and 1 or 0
		if Prat.IsRetail then
			for _, field in ipairs(chat_tab_textures_retail) do
				tab_button[field]:SetShown(self.db.profile.show_tab_textures)
			end
			for _, field in ipairs(chat_tab_textures_selected_retail) do
				tab_button[field]:SetAlpha(alpha)
			end
		else
			for _, field in ipairs(chat_tab_textures_classic) do
				_G[tab_button:GetName() .. field]:SetShown(self.db.profile.show_tab_textures)
			end
			for _, field in ipairs(chat_tab_textures_selected_classic) do
				_G[tab_button:GetName() .. field]:SetAlpha(alpha)
			end
		end
	end

	--[[------------------------------------------------
		BR: Reaplica alpha, visibilidade e estilos das abas
		EN: Reapplies tab alpha, visibility and styles
	------------------------------------------------]]--
	function module:update_all_tabs()
		CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = self.db.profile.active_alpha;
		CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = self.db.profile.inactive_alpha;
		for k, v in pairs(Prat.Frames) do
			local tab_button = _G[k .. "Tab"]
			if FCF_IsValidChatFrame(v) then
				tab_button:Show()
				tab_button:Hide()
				FCFTab_UpdateAlpha(v)
			end
			self:show_hide_tab_textures(v)
		end
		self:update_tab_font_sizes()
	end

	--[[------------------------------------------------
		BR: Controla visibilidade da aba ao aparecer
		EN: Controls tab visibility when shown
	------------------------------------------------]]--
	function module:OnTabShow(tab)
		if need_to_hook[tab] then
			self:HookScript(tab, "OnHide", "OnTabHide")
			need_to_hook[tab] = nil
		end

		if self.db.profile.display_mode["ChatFrame" .. tab:GetID()] == false then
			tab:Hide()
		end
	end

	--[[------------------------------------------------
		BR: Controla visibilidade da aba ao ocultar
		EN: Controls tab visibility when hidden
	------------------------------------------------]]--
	function module:OnTabHide(tab)
		if self.db.profile.display_mode["ChatFrame" .. tab:GetID()] == true then
			tab:Show()
		end
	end

	function module:OnTabDragStart(this, ...)
		local p = self.db.profile

		if p.prevent_drag and p.on then
			return
		end

		self.hooks[this].OnDragStart(this, ...)
	end

	--[[------------------------------------------------
		BR: Intercepta início do flash de alerta
		EN: Intercepts alert flash start
	------------------------------------------------]]--
	function module:FCF_StartAlertFlash(this)
		if self.db.profile.disable_flash then
			FCF_StopAlertFlash(this)
		end
	end

	--[[------------------------------------------------
		BR: Atualiza alpha da aba conforme estado do frame
		EN: Updates tab alpha according to frame state
	------------------------------------------------]]--
	function module:FCFTab_UpdateAlpha(chat_frame)
		local chat_tab = _G[chat_frame:GetName() .. "Tab"]

		if chat_tab.alerting then
			return
		elseif self.chatAlertCleanupActions[chat_frame:GetName()] then
			chat_tab.noMouseAlpha = 1
			chat_tab.mouseAlpha = 1
			chat_tab:SetAlpha(1)
			return
		end

		if FCF_IsValidChatFrame(chat_frame) then
			if SELECTED_CHAT_FRAME:GetID() == chat_frame:GetID() then
				chat_tab:SetAlpha(self.db.profile.active_alpha)
				chat_tab.noMouseAlpha = self.db.profile.active_alpha
				chat_tab.mouseAlpha = self.db.profile.active_alpha
			else
				chat_tab:SetAlpha(self.db.profile.inactive_alpha)
				chat_tab.noMouseAlpha = self.db.profile.inactive_alpha
				chat_tab.mouseAlpha = self.db.profile.inactive_alpha
			end
		end
	end

	function module:FCF_Close(frame, fallback)
		local tab = _G[frame:GetName() .. "Tab"]

		if tab then
			self:Unhook(tab, "OnHide")
			need_to_hook[tab] = true
		end

		self.hooks.FCF_Close(frame, fallback)
	end

	function module:FCF_StopAlertFlash(frame)
		if FCF_IsValidChatFrame(frame) then
			FCFTab_UpdateAlpha(frame)
		end
	end

	--[[------------------------------------------------
		BR: Dispara efeitos visuais quando novas mensagens chegam
		EN: Triggers visual effects when new messages arrive
	------------------------------------------------]]--
	function module:AddMessage(chat_frame)
		local old_actions = self.chatAlertCleanupActions[chat_frame:GetName()]
		self.chatAlertCleanupActions[chat_frame:GetName()] = nil
		if old_actions then
			for _, a in ipairs(old_actions) do
				a()
			end
		end
		if self.chatAlertTimers[chat_frame:GetName()] then
			self.chatAlertTimers[chat_frame:GetName()]:Cancel()
		end

		local actions = {}
		if self.db.profile.highlight_tabs[chat_frame:GetName()].flash then
			table.insert(actions, self:do_flash(chat_frame))
		end
		if self.db.profile.highlight_tabs[chat_frame:GetName()].change_font then
			table.insert(actions, self:do_font_color_change(chat_frame))
		end
		if #actions > 0 then
			table.insert(actions, self:keep_tab_button_visible(chat_frame))
		end

		if #actions > 0 then
			self.chatAlertCleanupActions[chat_frame:GetName()] = actions
			local active_chat_frame = SELECTED_CHAT_FRAME
			if not self.db.profile.forever_alert or (self.db.profile.keep_highlight_inactive and active_chat_frame:GetID() == chat_frame:GetID()) then
				self.chatAlertTimers[chat_frame:GetName()] = C_Timer.NewTimer(self.db.profile.alert_timeout, function()
					self.chatAlertTimers[chat_frame:GetName()] = nil
					for _, a in ipairs(actions) do
						a()
					end
					self.chatAlertCleanupActions[chat_frame:GetName()] = nil
				end)
			else
				local tab_button = _G[chat_frame:GetName() .. "Tab"]
				if not self:IsHooked(tab_button, "OnClick") then
					self:HookScript(tab_button, "OnClick", function(tab_button_self)
						local frameName = "ChatFrame" .. tab_button_self:GetID()
						if self.chatAlertCleanupActions[frameName] then
							for _, a in ipairs(self.chatAlertCleanupActions[frameName]) do
								a()
							end
							self.chatAlertCleanupActions[frameName] = nil
						end
					end)
				end
			end
		end
	end

	--[[------------------------------------------------
		BR: Mantém aba visível durante alertas ativos
		EN: Keeps tab visible during active alerts
	------------------------------------------------]]--
	function module:keep_tab_button_visible(chat_frame)
		local tab_button = _G[chat_frame:GetName() .. "Tab"]
		tab_button:SetAlpha(1)
		tab_button.noMouseAlpha = 1
		tab_button.mouseAlpha = 1
		UIFrameFadeRemoveFrame(tab_button)
		return function()
			if chat_frame.hasBeenFaded then
				tab_button.noMouseAlpha = self.db.profile.active_alpha
				tab_button.mouseAlpha = self.db.profile.active_alpha
			else
				tab_button.noMouseAlpha = self.db.profile.inactive_alpha
				tab_button.mouseAlpha = self.db.profile.inactive_alpha
				UIFrameFadeOut(tab_button, 0.2, tab_button:GetAlpha(), tab_button.mouseAlpha)
			end
		end
	end

	--[[------------------------------------------------
		BR: Executa efeito visual de flash na aba
		EN: Executes flashing visual effect on the tab
	------------------------------------------------]]--
	function module:do_flash(chat_frame)
		local tab_button = _G[chat_frame:GetName() .. "Tab"]

		if not self.chat_tabTexture[chat_frame:GetName()] then
			self.chat_tabTexture[chat_frame:GetName()] = tab_button:CreateTexture()
			local texture = self.chat_tabTexture[chat_frame:GetName()]
			texture:SetTexture([[Interface\AddOns\Prat-3.0\textures\button-flash]])
			texture:SetPoint("BOTTOM", 0, -8)
			texture:SetHeight(32)
			texture:SetWidth(tab_button:GetWidth())
			texture.animation = texture:CreateAnimationGroup()
			local alpha = texture.animation:CreateAnimation("Alpha")
			alpha:SetFromAlpha(0)
			alpha:SetToAlpha(1)
			alpha:SetTargetParent()
			alpha:SetDuration(0.4)
			alpha:SetOrder(1)
			local alpha2 = texture.animation:CreateAnimation("Alpha")
			alpha2:SetFromAlpha(1)
			alpha2:SetToAlpha(0)
			alpha2:SetTargetParent()
			alpha2:SetDuration(0.4)
			alpha2:SetOrder(2)
			texture.animation:SetLooping("REPEAT")
		end

		local color = self.db.profile.highlight_tabs[chat_frame:GetName()].flash_color
		local highlight = self.chat_tabTexture[chat_frame:GetName()]
		highlight:SetVertexColor(color.r, color.g, color.b, color.a)
		highlight:Show()
		highlight.animation:Restart()

		return function()
			if chat_frame.hasBeenFaded then
				tab_button.noMouseAlpha = self.db.profile.active_alpha
				tab_button.mouseAlpha = self.db.profile.active_alpha
			else
				tab_button.noMouseAlpha = self.db.profile.inactive_alpha
				tab_button.mouseAlpha = self.db.profile.inactive_alpha
				UIFrameFadeOut(tab_button, 0.2, tab_button:GetAlpha(), tab_button.mouseAlpha)
			end
			highlight:Hide()
		end
	end

	--[[------------------------------------------------
		BR: Altera temporariamente a cor do texto da aba
		EN: Temporarily changes the tab text color
	------------------------------------------------]]--
	function module:do_font_color_change(chat_frame)
		local tab_button = _G[chat_frame:GetName() .. "Tab"]
		local oldR, oldG, oldB, oldA = tab_button:GetFontString():GetTextColor()
		local color = self.db.profile.highlight_tabs[chat_frame:GetName()].font_color
		tab_button:GetFontString():SetTextColor(color.r, color.g, color.b, color.a)

		return function()
			tab_button:GetFontString():SetTextColor(oldR, oldG, oldB, oldA)
		end
	end

	--[[------------------------------------------------
		BR: Atualiza tamanho da fonte das abas
		EN: Updates tab font sizes
	------------------------------------------------]]--
	function module:update_tab_font_sizes()
		for k, _ in pairs(Prat.Frames) do
			local tab_button = _G[k .. "Tab"]
			if tab_button and tab_button:GetFontString() then
				local font_string = tab_button:GetFontString()
				local current_font, _, current_flags = font_string:GetFont()
				font_string:SetFont(current_font, self.db.profile.tab_font_size, current_flags)
			end
		end
	end


	--[[------------------------------------------------
		BR: Aliases legados para reduzir risco com referências antigas
		EN: Legacy aliases to reduce risk with older references
	------------------------------------------------]]--
	module.UpdateHighlightTabsConfig = module.update_highlight_tabs_config
	module.HookedMode = module.hooked_mode
	module.InstallHooks = module.install_hooks
	module.RemoveHooks = module.remove_hooks
	module.ShowHideTabTextures = module.show_hide_tab_textures
	module.UpdateAllTabs = module.update_all_tabs
	module.KeepTabButtonVisible = module.keep_tab_button_visible
	module.DoFlash = module.do_flash
	module.DoFontColorChange = module.do_font_color_change
	module.UpdateTabFontSizes = module.update_tab_font_sizes

	return
end) -- Prat:AddModuleToLoad