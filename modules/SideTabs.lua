--[[
    @File:      SideTabs.lua
    @Project:   Prat-3.0

    BR: Reposicionamento e personalização das abas laterais do bate-papo.
        - Abas laterais para janelas acopladas e desacopladas
        - Suporte a posicionamento à esquerda ou à direita
        - Ajustes de deslocamento, espaçamento, largura, altura e escala
        - Normalização opcional de escala da interface
        - Personalização de fonte, tamanho, cor e pele simples
        - Rótulos por janela com texto padrão, personalizado, ícones ou formas
        - Preservação do comportamento de fade/hover da interface Blizzard
        - Restauração segura do layout original ao desativar o módulo

    EN: Repositioning and customization of side chat tabs.
        - Side tabs for docked and undocked chat frames
        - Left or right side positioning support
        - Offset, spacing, width, height and scale controls
        - Optional UI scale normalization
        - Font, size, color and simple skin customization
        - Per-frame labels with default text, custom text, icons or shapes
        - Preservation of Blizzard UI fade/hover behavior
        - Safe restoration of the original layout when the module is disabled

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
	    BR: Registra o módulo somente quando o Prat carregar seus módulos internos.
	    EN: Registers the module only when Prat loads its internal modules.
	------------------------------------------------]]--
	local module = Prat:NewModule("SideTabs", "AceHook-3.0")
	local PL = module.PL


	--[[------------------------------------------------
	    BR: Define os valores padrão do módulo, incluindo posição, tamanho, aparência e rótulos.
	    EN: Defines module defaults, including position, size, appearance, and labels.
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module, {
		profile = {
			on = false,
			side = "LEFT", -- LEFT | RIGHT
			x_offset = -2,
			y_offset = -2,
			spacing = 2,
			tab_width = 110,
			tab_height = 22,
			tab_scale = 1.0,
			normalize_ui_scale = false,
			font_face = "",
			font_size = 0,
			font_color = {
				r = 1,
				g = 1,
				b = 1,
				a = 1,
			},
			labels_enabled = false,
			label_mode = { ["*"] = "default" },
			custom_label = { ["*"] = "" },
			label_preset = { ["*"] = "STAR" },
			label_shape = { ["*"] = "SQUARE" },
			label_color = {
				["*"] = {
					r = 1,
					g = 1,
					b = 1,
					a = 1,
				},
			},
			undocked = true,
			simple_skin = false,
		}
	})

	--[[------------------------------------------------
	    BR: Extrai o nome do ChatFrame a partir do caminho de opções do AceConfig.
	    EN: Extracts the ChatFrame name from the AceConfig option path.
	------------------------------------------------]]--
	local function get_info_frame_name(info)
		for i = #info, 1, -1 do
			local v = info[i]
			if type(v) == "string" and v:match("^ChatFrame%d+$") then
				return v
			end
		end
		return
	end

	--[[------------------------------------------------
	    BR: Cria dinamicamente o grupo de opções de rótulo para cada janela de bate-papo.
	    EN: Dynamically creates the label option group for each chat frame.
	------------------------------------------------]]--
	local function make_tab_label_option(order)
		return {
			name = function(info)
				return Prat.FrameList[info[#info]] or info[#info]
			end,
			desc = PL["tab_label_frame_help"],
			type = "group",
			order = order,
			args = {
				label_mode = {
					name = PL["label_mode_name"],
					desc = PL["label_mode_desc"],
					type = "select",
					order = 100,
					values = {
						["default"] = PL["label_mode_default"],
						["preset"] = PL["label_mode_preset"],
						["shape"] = PL["label_mode_shape"],
						["custom"] = PL["label_mode_custom"],
					},
					sorting = { "default", "preset", "shape", "custom" },
					get = "get_tab_label_value",
					set = "set_tab_label_value",
				},
				label_preset = {
					name = PL["label_preset_name"],
					desc = PL["label_preset_desc"],
					type = "select",
					order = 110,
					values = {
						["STAR"] = PL["preset_star"],
						["CIRCLE"] = PL["preset_circle"],
						["DIAMOND"] = PL["preset_diamond"],
						["TRIANGLE"] = PL["preset_triangle"],
						["MOON"] = PL["preset_moon"],
						["SKULL"] = PL["preset_skull"],
					},
					hidden = function(info)
						local frame_name = get_info_frame_name(info)
						if not frame_name then
							return true
						end
						return (module.db.profile.label_mode and module.db.profile.label_mode[frame_name]) ~= "preset"
					end,
					get = "get_tab_label_value",
					set = "set_tab_label_value",
				},
				label_shape = {
					name = PL["label_shape_name"],
					desc = PL["label_shape_desc"],
					type = "select",
					order = 120,
					values = {
						["SQUARE"] = PL["shape_square"],
						["CIRCLE"] = PL["shape_circle"],
					},
					hidden = function(info)
						local frame_name = get_info_frame_name(info)
						if not frame_name then
							return true
						end
						return (module.db.profile.label_mode and module.db.profile.label_mode[frame_name]) ~= "shape"
					end,
					get = "get_tab_label_value",
					set = "set_tab_label_value",
				},
				label_color = {
					name = PL["label_color_name"],
					desc = PL["label_color_desc"],
					type = "color",
					hasAlpha = true,
					order = 130,
					hidden = function(info)
						local frame_name = get_info_frame_name(info)
						if not frame_name then
							return true
						end
						return (module.db.profile.label_mode and module.db.profile.label_mode[frame_name]) ~= "shape"
					end,
					get = "get_tab_label_color_value",
					set = "set_tab_label_color_value",
				},
				custom_label = {
					name = PL["custom_label_name"],
					desc = PL["custom_label_desc"],
					type = "input",
					width = "full",
					order = 140,
					hidden = function(info)
						local frame_name = get_info_frame_name(info)
						if not frame_name then
							return true
						end
						return (module.db.profile.label_mode and module.db.profile.label_mode[frame_name]) ~= "custom"
					end,
					get = "get_tab_label_value",
					set = "set_tab_label_value",
				},
			},
		}
	end

	--[[------------------------------------------------
	    BR: Organiza a interface do módulo em abas lógicas dentro das opções do Prat.
	    EN: Organizes the module UI into logical tabs inside Prat options.
	------------------------------------------------]]--
	Prat:SetModuleOptions(module, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		childGroups = "tab",
		args = {
			position = {
				name = PL["position_tab_name"],
				desc = PL["position_tab_desc"],
				type = "group",
				order = 100,
				args = {
					help = {
						type = "description",
						name = PL["position_help"],
						order = 10,
						width = "full",
					},

					layout_group = {
						name = PL["layout_group_name"],
						desc = PL["layout_group_desc"],
						type = "group",
						inline = true,
						order = 20,
						args = {
							side = {
								name = PL["side_name"],
								desc = PL["side_desc"],
								type = "select",
								order = 100,
								width = 1.20,
								values = {
									LEFT = PL["side_left"],
									RIGHT = PL["side_right"],
								},
							},

							x_offset = {
								name = PL["x_offset_name"],
								desc = PL["x_offset_desc"],
								type = "range",
								order = 110,
								width = 1.20,
								min = -40,
								max = 40,
								step = 1,
							},

							y_offset = {
								name = PL["y_offset_name"],
								desc = PL["y_offset_desc"],
								type = "range",
								order = 120,
								width = 1.20,
								min = -40,
								max = 40,
								step = 1,
							},

							spacing = {
								name = PL["spacing_name"],
								desc = PL["spacing_desc"],
								type = "range",
								order = 130,
								width = 1.20,
								min = 0,
								max = 20,
								step = 1,
							},
						},
					},
				},
			},

			size = {
				name = PL["size_tab_name"],
				desc = PL["size_tab_desc"],
				type = "group",
				order = 200,
				args = {
					help = {
						type = "description",
						name = PL["size_help"],
						order = 10,
						width = "full",
					},

					sizing_group = {
						name = PL["sizing_group_name"],
						desc = PL["sizing_group_desc"],
						type = "group",
						inline = true,
						order = 20,
						args = {
							tab_width = {
								name = PL["tab_width_name"],
								desc = PL["tab_width_desc"],
								type = "range",
								order = 140,
								width = 1.25,
								min = 10,
								max = 200,
								step = 1,
							},

							tab_height = {
								name = PL["tab_height_name"],
								desc = PL["tab_height_desc"],
								type = "range",
								order = 145,
								width = 1.25,
								min = 14,
								max = 40,
								step = 1,
							},

							tab_scale = {
								name = PL["tab_scale_name"],
								desc = PL["tab_scale_desc"],
								type = "range",
								order = 146,
								width = 1.25,
								min = 0.7,
								max = 1.5,
								step = 0.05,
							},

							normalize_ui_scale = {
								name = PL["normalize_ui_scale_name"],
								desc = PL["normalize_ui_scale_desc"],
								type = "toggle",
								order = 147,
								width = 1.45,
							},
						},
					},
				},
			},

			text = {
				name = PL["text_tab_name"],
				desc = PL["text_tab_desc"],
				type = "group",
				order = 300,
				args = {
					help = {
						type = "description",
						name = PL["text_help"],
						order = 10,
						width = "full",
					},

					text_group = {
						name = PL["text_group_name"],
						desc = PL["text_group_desc"],
						type = "group",
						inline = true,
						order = 20,
						args = {
							font_face = {
								name = PL["font_face_name"],
								desc = PL["font_face_desc"],
								type = "select",
								dialogControl = "LSM30_Font",
								values = (AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font) or {},
								order = 170,
								width = 1.35,
							},

							font_size = {
								name = PL["font_size_name"],
								desc = PL["font_size_desc"],
								type = "range",
								order = 171,
								width = 1.25,
								min = 4,
								max = 32,
								step = 1,
							},

							font_color = {
								name = PL["font_color_name"],
								desc = PL["font_color_desc"],
								type = "color",
								hasAlpha = true,
								order = 172,
								width = 1.25,
								get = "GetColorValue",
								set = "SetColorValue",
							},
						},
					},
				},
			},

			visual = {
				name = PL["visual_tab_name"],
				desc = PL["visual_tab_desc"],
				type = "group",
				order = 400,
				args = {
					help = {
						type = "description",
						name = PL["visual_help"],
						order = 10,
						width = "full",
					},

					behavior_group = {
						name = PL["behavior_group_name"],
						desc = PL["behavior_group_desc"],
						type = "group",
						inline = true,
						order = 20,
						args = {
							undocked = {
								name = PL["undocked_name"],
								desc = PL["undocked_desc"],
								type = "toggle",
								order = 150,
								width = 1.60,
							},

							simple_skin = {
								name = PL["simple_skin_name"],
								desc = PL["simple_skin_desc"],
								type = "toggle",
								order = 160,
								width = 1.60,
							},
						},
					},
				},
			},

			tab_labels = {
				name = PL["tab_labels_tab_name"],
				desc = PL["tab_labels_group_desc"],
				type = "group",
				childGroups = "tree",
				order = 500,
				args = {
					labels_enabled = {
						name = PL["labels_enabled_name"],
						desc = PL["labels_enabled_desc"],
						type = "toggle",
						order = 10,
						width = 1.70,
					},

					help = {
						type = "description",
						order = 20,
						width = "full",
						name = PL["tab_labels_help"],
					},

					ChatFrame1 = make_tab_label_option(101),
					ChatFrame2 = make_tab_label_option(102),
					ChatFrame3 = make_tab_label_option(103),
					ChatFrame4 = make_tab_label_option(104),
					ChatFrame5 = make_tab_label_option(105),
					ChatFrame6 = make_tab_label_option(106),
					ChatFrame7 = make_tab_label_option(107),
					ChatFrame8 = make_tab_label_option(108),
					ChatFrame9 = make_tab_label_option(109),
					ChatFrame10 = make_tab_label_option(110),
				},
			},
		}
	})

	--[[------------------------------------------------
	    BR: Verifica se o mouse está sobre a aba ou sobre elementos internos dela.
	    EN: Checks whether the mouse is over the tab or one of its inner elements.
	------------------------------------------------]]--
	local function is_tab_hovered(tab)
		if not tab or not tab:IsShown() then
			return false
		end

		if tab:IsMouseOver() then
			return true
		end

		if tab.Text and tab.Text:IsMouseOver() then
			return true
		end

		if tab.conversationIcon and tab.conversationIcon:IsShown() and tab.conversationIcon:IsMouseOver() then
			return true
		end

		return false
	end

	--[[------------------------------------------------
	    BR: Confere se alguma aba acoplada está sob o cursor para preservar o fade correto.
	    EN: Checks whether any docked tab is hovered to preserve proper fade behavior.
	------------------------------------------------]]--
	local function is_any_docked_tab_hovered()
		for _, frame in ipairs(FCFDock_GetChatFrames(GENERAL_CHAT_DOCK)) do
			local tab = _G[frame:GetName() .. "Tab"]
			if is_tab_hovered(tab) then
				return true
			end
		end

		return false
	end

	--[[------------------------------------------------
	    BR: Aplica ou remove a aparência simples das abas sem substituir a lógica original da Blizzard.
	    EN: Applies or removes the simple tab skin without replacing Blizzard's original logic.
	------------------------------------------------]]--
	function module:apply_skin(tab, simple)
		if not tab then
			return
		end

		simple = simple or self.db.profile.simple_skin

		if tab.Left then
			tab.Left:SetShown(not simple)
		end
		if tab.Middle then
			tab.Middle:SetShown(not simple)
		end
		if tab.Right then
			tab.Right:SetShown(not simple)
		end
		if tab.ActiveLeft then
			tab.ActiveLeft:SetShown(not simple)
		end
		if tab.ActiveMiddle then
			tab.ActiveMiddle:SetShown(not simple)
		end
		if tab.ActiveRight then
			tab.ActiveRight:SetShown(not simple)
		end

		if simple then
			if not tab.prat_side_tabs_bg then
				local bg = tab:CreateTexture(nil, "BACKGROUND")
				bg:SetAllPoints(tab)
				bg:SetColorTexture(0, 0, 0, 0.35)
				tab.prat_side_tabs_bg = bg
			end
			tab.prat_side_tabs_bg:Show()
		elseif tab.prat_side_tabs_bg then
			tab.prat_side_tabs_bg:Hide()
		end
	end

	--[[------------------------------------------------
	    BR: Guarda o estilo original do texto antes de aplicar fonte, tamanho e cor personalizados.
	    EN: Stores the original text style before applying custom font, size, and color.
	------------------------------------------------]]--
	function module:apply_text_style(tab)
		if not tab then
			return
		end

		local fs = tab.Text or tab:GetFontString()
		if not fs then
			return
		end

		if not tab.prat_side_tabs_text_defaults then
			local f, s, m = fs:GetFont()
			local r, g, b, a = fs:GetTextColor()
			tab.prat_side_tabs_text_defaults = {
				font = f,
				size = s,
				mode = m,
				r = r,
				g = g,
				b = b,
				a = a,
			}
		end

		local defaults = tab.prat_side_tabs_text_defaults
		local p = self.db.profile

		local font_file = defaults.font
		if p.font_face and p.font_face ~= "" then
			font_file = Prat.Media:Fetch(Prat.Media.MediaType.FONT, p.font_face) or defaults.font
		end

		local font_size = defaults.size
		if p.font_size and p.font_size > 0 then
			font_size = p.font_size
		end

		fs:SetFont(font_file, font_size, defaults.mode)

		local c = p.font_color or defaults
		fs:SetTextColor(c.r or 1, c.g or 1, c.b or 1, c.a or 1)
	end

	--[[------------------------------------------------
	    BR: Restaura fonte e cor originais quando o módulo é desativado ou reiniciado.
	    EN: Restores original font and color when the module is disabled or reset.
	------------------------------------------------]]--
	function module:restore_text_style(tab)
		if not tab or not tab.prat_side_tabs_text_defaults then
			return
		end

		local fs = tab.Text or tab:GetFontString()
		if not fs then
			return
		end

		local d = tab.prat_side_tabs_text_defaults
		fs:SetFont(d.font, d.size, d.mode)
		fs:SetTextColor(d.r, d.g, d.b, d.a)
	end

	--[[------------------------------------------------
	    BR: Ícones predefinidos usados como rótulos curtos para as abas.
	    EN: Preset icons used as short labels for tabs.
	------------------------------------------------]]--
	local preset_labels = {
		STAR = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:14:14:0:0|t",
		CIRCLE = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:14:14:0:0|t",
		DIAMOND = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:14:14:0:0|t",
		TRIANGLE = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:14:14:0:0|t",
		MOON = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_5:14:14:0:0|t",
		SKULL = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_8:14:14:0:0|t",
	}

	--[[------------------------------------------------
	    BR: Garante a textura reutilizável usada pelos rótulos em forma geométrica.
	    EN: Ensures the reusable texture used by geometric shape labels.
	------------------------------------------------]]--
	local function ensure_shape_texture(tab)
		if not tab.prat_side_tabs_shape_tex then
			local tex = tab:CreateTexture(nil, "OVERLAY")
			tex:SetPoint("CENTER", tab, "CENTER", 0, 0)
			tex:SetTexture("Interface\\Buttons\\WHITE8X8")
			tab.prat_side_tabs_shape_tex = tex
		end

		return tab.prat_side_tabs_shape_tex
	end

	--[[------------------------------------------------
	    BR: Cria a máscara circular usada para desenhar círculos preenchidos.
	    EN: Creates the circular mask used to draw filled circles.
	------------------------------------------------]]--
	local function ensure_shape_circle_mask(tab)
		if not tab.prat_side_tabs_shape_mask then
			local mask = tab:CreateMaskTexture(nil, "OVERLAY")
			mask:SetPoint("CENTER", tab, "CENTER", 0, 0)
			-- This is a built-in circular alpha mask used by Blizzard UI.
			mask:SetTexture("Interface\\CharacterFrame\\TempPortraitAlphaMask", "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
			tab.prat_side_tabs_shape_mask = mask
		end

		return tab.prat_side_tabs_shape_mask
	end

	--[[------------------------------------------------
	    BR: Oculta o rótulo geométrico quando outro modo de rótulo está ativo.
	    EN: Hides the geometric label when another label mode is active.
	------------------------------------------------]]--
	local function hide_shape_texture(tab)
		if tab and tab.prat_side_tabs_shape_tex then
			tab.prat_side_tabs_shape_tex:Hide()
		end
	end

	--[[------------------------------------------------
	    BR: Aplica rótulos visuais simples, como quadrado ou círculo colorido.
	    EN: Applies simple visual labels, such as a colored square or circle.
	------------------------------------------------]]--
	function module:apply_shape_label(tab, shape, color)
		if not tab then
			return
		end

		local tex = ensure_shape_texture(tab)
		local mask = ensure_shape_circle_mask(tab)
		local fs = tab.Text or tab:GetFontString()
		local font_size_value = 12
		if fs then
			local _, s = fs:GetFont()
			font_size_value = s or 12
		end
		local shape_size = math.max(8, math.floor(font_size_value * 0.9 + 0.5))

		tex:SetTexture("Interface\\Buttons\\WHITE8X8")
		tex:SetSize(shape_size, shape_size)

		if shape == "CIRCLE" then
			-- Filled/tintable circle using a circular alpha mask (no border ring).
			mask:SetSize(shape_size, shape_size)
			tex:RemoveMaskTexture(mask)
			tex:AddMaskTexture(mask)
		else
			tex:RemoveMaskTexture(mask)
		end

		tex:SetVertexColor(color.r or 1, color.g or 1, color.b or 1, color.a or 1)
		tex:Show()
	end

	--[[------------------------------------------------
	    BR: Lê valores individuais de rótulo por ChatFrame nas opções do perfil.
	    EN: Reads per-ChatFrame label values from the profile options.
	------------------------------------------------]]--
	function module:get_tab_label_value(info)
		local key = info[#info]
		local frame_name = get_info_frame_name(info)
		if not frame_name then
			return nil
		end
		local profile = self.db and self.db.profile
		if not profile then
			return nil
		end
		local section = profile[key]
		if not section then
			return nil
		end
		return section[frame_name]
	end

	--[[------------------------------------------------
	    BR: Salva valores individuais de rótulo e agenda reaplicação do layout.
	    EN: Saves per-tab label values and schedules the layout to be reapplied.
	------------------------------------------------]]--
	function module:set_tab_label_value(info, value)
		local key = info[#info]
		local frame_name = get_info_frame_name(info)
		if not frame_name then
			return
		end
		local profile = self.db and self.db.profile
		if not profile then
			return
		end
		profile[key] = profile[key] or {}
		profile[key][frame_name] = value
		self:OnValueChanged()
	end

	--[[------------------------------------------------
	    BR: Retorna a cor configurada para o rótulo geométrico da aba.
	    EN: Returns the configured color for the tab's geometric label.
	------------------------------------------------]]--
	function module:get_tab_label_color_value(info)
		local frame_name = get_info_frame_name(info)
		if not frame_name then
			return 1, 1, 1, 1
		end
		local profile = self.db and self.db.profile
		if not profile then
			return 1, 1, 1, 1
		end

		local section = profile.label_color or {}
		local c = section[frame_name] or { r = 1, g = 1, b = 1, a = 1 }
		return c.r, c.g, c.b, c.a
	end

	--[[------------------------------------------------
	    BR: Salva a cor do rótulo geométrico preservando estrutura por janela.
	    EN: Saves the geometric label color while preserving the per-frame structure.
	------------------------------------------------]]--
	function module:set_tab_label_color_value(info, r, g, b, a)
		local frame_name = get_info_frame_name(info)
		if not frame_name then
			return
		end
		local profile = self.db and self.db.profile
		if not profile then
			return
		end

		profile.label_color = profile.label_color or {}
		profile.label_color[frame_name] = profile.label_color[frame_name] or {}
		local c = profile.label_color[frame_name]
		c.r, c.g, c.b, c.a = r, g, b, a
		self:OnValueChanged()
	end

	--[[------------------------------------------------
	    BR: Decide qual rótulo exibir em cada aba: padrão, personalizado, ícone ou forma.
	    EN: Decides which label to show on each tab: default, custom, icon, or shape.
	------------------------------------------------]]--
	function module:apply_tab_label(frame, tab)
		if not frame or not tab then
			return
		end

		if not tab.prat_side_tabs_default_text then
			tab.prat_side_tabs_default_text = tab:GetText()
		end

		if not self.db.profile.labels_enabled then
			hide_shape_texture(tab)
			tab:SetText(frame.name or tab.prat_side_tabs_default_text or "")
			return
		end

		local frame_name = frame:GetName()
		local mode = self.db.profile.label_mode[frame_name] or "default"

		if mode == "default" then
			hide_shape_texture(tab)
			tab:SetText(frame.name or tab.prat_side_tabs_default_text or "")
			return
		end

		if mode == "custom" then
			hide_shape_texture(tab)
			local custom = self.db.profile.custom_label[frame_name]
			if custom and custom ~= "" then
				tab:SetText(custom)
			else
				tab:SetText(frame.name or tab.prat_side_tabs_default_text or "")
			end
			return
		end

		if mode == "preset" then
			hide_shape_texture(tab)
			local preset = self.db.profile.label_preset[frame_name] or "STAR"
			tab:SetText(preset_labels[preset] or preset_labels.STAR)
			return
		end

		if mode == "shape" then
			local shape = self.db.profile.label_shape[frame_name] or "SQUARE"
			local color = self.db.profile.label_color[frame_name] or { r = 1, g = 1, b = 1, a = 1 }
			tab:SetText(" ")
			self:apply_shape_label(tab, shape, color)
			return
		end

		hide_shape_texture(tab)
		tab:SetText(frame.name or tab.prat_side_tabs_default_text or "")
	end

	--[[------------------------------------------------
	    BR: Restaura o texto original da aba ao desativar recursos de rótulo.
	    EN: Restores the original tab text when label features are disabled.
	------------------------------------------------]]--
	function module:restore_tab_label(frame, tab)
		if not frame or not tab then
			return
		end
		hide_shape_texture(tab)
		tab:SetText(frame.name or tab.prat_side_tabs_default_text or "")
	end

	--[[------------------------------------------------
	    BR: Centraliza o texto dentro da aba lateral e guarda o layout original.
	    EN: Centers text inside the side tab and stores the original layout.
	------------------------------------------------]]--
	function module:apply_text_layout(tab)
		if not tab then
			return
		end

		local fs = tab.Text or tab:GetFontString()
		if not fs then
			return
		end

		if not tab.prat_side_tabs_text_layout_defaults then
			tab.prat_side_tabs_text_layout_defaults = {
				points = {},
				justifyH = fs:GetJustifyH(),
				justifyV = fs:GetJustifyV(),
				width = fs:GetWidth(),
			}

			for i = 1, fs:GetNumPoints() do
				local p, rel, rp, x, y = fs:GetPoint(i)
				tab.prat_side_tabs_text_layout_defaults.points[i] = { p, rel, rp, x, y }
			end
		end

		fs:ClearAllPoints()
		fs:SetPoint("CENTER", tab, "CENTER", 0, 0)
		fs:SetJustifyH("CENTER")
		fs:SetJustifyV("MIDDLE")
		fs:SetWidth(math.max(1, tab:GetWidth() - 4))
	end

	--[[------------------------------------------------
	    BR: Reaplica os pontos, alinhamentos e largura originais do texto.
	    EN: Reapplies the original text points, alignment, and width.
	------------------------------------------------]]--
	function module:restore_text_layout(tab)
		if not tab or not tab.prat_side_tabs_text_layout_defaults then
			return
		end

		local fs = tab.Text or tab:GetFontString()
		if not fs then
			return
		end

		local d = tab.prat_side_tabs_text_layout_defaults
		fs:ClearAllPoints()
		if d.points and #d.points > 0 then
			for _, point in ipairs(d.points) do
				fs:SetPoint(point[1], point[2], point[3], point[4], point[5])
			end
		end

		if d.justifyH then
			fs:SetJustifyH(d.justifyH)
		end
		if d.justifyV then
			fs:SetJustifyV(d.justifyV)
		end
		if d.width and d.width > 0 then
			fs:SetWidth(d.width)
		end
	end

	--[[------------------------------------------------
	    BR: Reposiciona a aba ao lado da janela, preservando escala, fade e hierarquia visual.
	    EN: Reanchors the tab beside the frame while preserving scale, fade, and visual hierarchy.
	------------------------------------------------]]--
	function module:anchor_tab(tab, anchor, prev_tab, frame)
		if not tab or not anchor then
			return prev_tab
		end

		local p = self.db.profile
		local side = p.side

		if tab.prat_side_tabs_default_height == nil then
			tab.prat_side_tabs_default_height = tab:GetHeight()
		end
		if tab.prat_side_tabs_default_scale == nil then
			tab.prat_side_tabs_default_scale = tab:GetScale()
		end

		-- Use the chat frame's parent to avoid dock clipping while staying in the
		-- normal UI fade hierarchy used by addons like Immersion.
		local desired_parent = (frame and frame:GetParent()) or UIParent

		-- Ensure tabs participate in parent alpha/scale changes (Immersion-style
		-- UI fading relies on this behavior).
		if tab:GetParent() ~= desired_parent then
			tab:SetParent(desired_parent)
		end

		-- Ensure side tabs inherit parent alpha/scale transitions.
		tab:SetIgnoreParentAlpha(false)
		tab:SetIgnoreParentScale(false)

		local normalize = 1
		if p.normalize_ui_scale then
			local parent_scale = desired_parent:GetEffectiveScale() or UIParent:GetEffectiveScale() or 1
			normalize = 1 / math.max(parent_scale, 0.01)
		end

		local x_offset = p.x_offset * normalize
		local y_offset = p.y_offset * normalize
		local spacing = p.spacing * normalize
		local tab_width = p.tab_width * normalize
		local tab_height = p.tab_height * normalize

		tab:ClearAllPoints()

		if side == "LEFT" then
			--[[------------------------------------------------
			    BR: Ancora pelo lado esquerdo para a largura crescer para a direita.
			    EN: Anchor from the left side so width grows to the right.
			------------------------------------------------]]--
			if prev_tab then
				tab:SetPoint("TOPLEFT", prev_tab, "BOTTOMLEFT", 0, -spacing)
			else
				tab:SetPoint("TOPLEFT", anchor, "TOPLEFT", x_offset, y_offset)
			end
		else
			if prev_tab then
				tab:SetPoint("TOPLEFT", prev_tab, "BOTTOMLEFT", 0, -spacing)
			else
				tab:SetPoint("TOPLEFT", anchor, "TOPRIGHT", x_offset, y_offset)
			end
		end

		if PanelTemplates_TabResize then
			PanelTemplates_TabResize(tab, 0, tab_width)
		end
		tab:SetHeight(tab_height)
		tab:SetScale(p.tab_scale)
		self:apply_text_layout(tab)
		self:apply_tab_label(frame or FCF_GetChatFrameByID(tab:GetID()), tab)
		self:apply_skin(tab)
		self:apply_text_style(tab)
		if FCF_CheckShowChatFrame then
			FCF_CheckShowChatFrame(tab)
		end

		return tab
	end

	--[[------------------------------------------------
	    BR: Reorganiza as abas das janelas acopladas ao dock principal do bate-papo.
	    EN: Reorganizes tabs from frames docked to the main chat dock.
	------------------------------------------------]]--
	function module:layout_docked_tabs()
		local anchor = GENERAL_CHAT_DOCK.primary.Background or GENERAL_CHAT_DOCK.primary
		local prev_tab = nil

		for _, frame in ipairs(FCFDock_GetChatFrames(GENERAL_CHAT_DOCK)) do
			local tab = _G[frame:GetName() .. "Tab"]
			if tab then
				prev_tab = self:anchor_tab(tab, anchor, prev_tab, frame)
			end
		end
	end

	--[[------------------------------------------------
	    BR: Reorganiza abas de janelas desacopladas quando essa opção está ativa.
	    EN: Reorganizes tabs from undocked frames when this option is enabled.
	------------------------------------------------]]--
	function module:layout_undocked_tabs()
		if not self.db.profile.undocked then
			return
		end

		for _, frame in pairs(Prat.Frames) do
			if frame and not frame.isDocked then
				local tab = _G[frame:GetName() .. "Tab"]
				if tab and tab:IsShown() then
					self:anchor_tab(tab, frame.Background or frame, nil, frame)
				end
			end
		end
	end

	--[[------------------------------------------------
	    BR: Ponto central de reaplicação do layout das abas laterais.
	    EN: Central entry point for reapplying the side tab layout.
	------------------------------------------------]]--
	function module:apply_all()
		if not self:IsEnabled() then
			return
		end

		self:layout_docked_tabs()
		self:layout_undocked_tabs()
	end

	--[[------------------------------------------------
	    BR: Mantém a visibilidade das abas quando o cursor está sobre abas reposicionadas.
	    EN: Keeps tabs visible while the cursor is over reanchored tabs.
	------------------------------------------------]]--
	function module:fcf_on_update(elapsed)
		-- Blizzard's hover fade logic checks the chat frame/top region, not moved side tabs.
		-- Keep fade timers alive while the cursor is over a side tab.
		for _, frame_name in ipairs(CHAT_FRAMES) do
			local chat_frame = _G[frame_name]
			local chat_tab = _G[frame_name .. "Tab"]
			if chat_frame and chat_tab and chat_frame:IsShown() and chat_tab:IsShown() and chat_tab:IsMouseOver() then
				chat_frame.mouseOutTime = 0
				chat_frame.mouseInTime = (chat_frame.mouseInTime or 0) + (elapsed or 0)
				if not chat_frame.hasBeenFaded and chat_frame.mouseInTime > CHAT_TAB_SHOW_DELAY then
					FCF_FadeInChatFrame(chat_frame)
				end
			end
		end
	end

	--[[------------------------------------------------
	    BR: Intercepta o fade-out para não esconder a aba enquanto ela ainda está em uso.
	    EN: Intercepts fade-out so the tab is not hidden while still being used.
	------------------------------------------------]]--
	function module:fcf_fade_out_chat_frame(chat_frame)
		if not chat_frame then
			return
		end

		if chat_frame.isDocked and is_any_docked_tab_hovered() then
			-- Any hovered docked tab should keep docked chat tabs visible.
			chat_frame.mouseOutTime = 0
			FCF_FadeInChatFrame(chat_frame)
			return
		end

		local chat_tab = _G[chat_frame:GetName() .. "Tab"]
		if not is_tab_hovered(chat_tab) then
			return
		end

		-- Preserve default behavior semantics while hovered over a moved side tab.
		chat_frame.mouseOutTime = 0
		FCF_FadeInChatFrame(chat_frame)
	end

	--[[------------------------------------------------
	    BR: Evita reaplicações repetidas no mesmo ciclo e aguarda o próximo frame.
	    EN: Prevents repeated reapplications in the same cycle and waits for the next frame.
	------------------------------------------------]]--
	function module:queue_apply()
		if self._pending_apply then
			return
		end

		self._pending_apply = true
		C_Timer.After(0, function()
			self._pending_apply = nil
			if self:IsEnabled() then
				self:apply_all()
			end
		end)
	end

	--[[------------------------------------------------
	    BR: Restaura altura, escala, rótulos, layout, pele e texto originais das abas.
	    EN: Restores original tab height, scale, labels, layout, skin, and text.
	------------------------------------------------]]--
	function module:restore_defaults()
		FCF_DockUpdate()

		for _, frame in pairs(Prat.Frames) do
			if not frame.isDocked then
				FCF_SetTabPosition(frame, 0)
			end
			local tab = _G[frame:GetName() .. "Tab"]
			if tab then
				if tab.prat_side_tabs_default_height ~= nil then
					tab:SetHeight(tab.prat_side_tabs_default_height)
				end
				if tab.prat_side_tabs_default_scale ~= nil then
					tab:SetScale(tab.prat_side_tabs_default_scale)
				end
				self:restore_tab_label(frame, tab)
				self:restore_text_layout(tab)
				self:apply_skin(tab, false)
				self:restore_text_style(tab)
			end
		end
	end

	--[[------------------------------------------------
	    BR: Instala hooks seguros nos eventos da Blizzard que reposicionam ou atualizam abas.
	    EN: Installs secure hooks on Blizzard events that reanchor or update tabs.
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:SecureHook("FCF_DockUpdate", "queue_apply")
		self:SecureHook("FCFDock_UpdateTabs", "queue_apply")
		self:SecureHook("FloatingChatFrame_Update", "queue_apply")
		self:SecureHook("FCF_SetTabPosition", "queue_apply")
		self:SecureHook("FCF_OnUpdate", "fcf_on_update")
		self:SecureHook("FCF_FadeOutChatFrame", "fcf_fade_out_chat_frame")

		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)

		-- Apply immediately and once again on the next frame to catch startup reanchors.
		self:apply_all()
		self:queue_apply()
	end

	--[[------------------------------------------------
	    BR: Remove hooks/eventos e devolve as abas ao comportamento padrão.
	    EN: Removes hooks/events and returns tabs to default behavior.
	------------------------------------------------]]--
	function module:OnModuleDisable()
		Prat.UnregisterAllChatEvents(self)
		self:UnhookAll()
		self:restore_defaults()
	end

	--[[------------------------------------------------
	    BR: Reage ao evento interno do Prat quando a lista de janelas é atualizada.
	    EN: Responds to Prat's internal event when the frame list is updated.
	------------------------------------------------]]--
	function module:Prat_FramesUpdated()
		self:queue_apply()
	end

	--[[------------------------------------------------
	    BR: Reaplica ou restaura o módulo sempre que uma opção é alterada.
	    EN: Reapplies or restores the module whenever an option changes.
	------------------------------------------------]]--
	function module:OnValueChanged()
		if self.db.profile.on then
			self:queue_apply()
		else
			self:restore_defaults()
		end
	end

	--[[------------------------------------------------
	    BR: Reutiliza o mesmo fluxo de atualização para alterações de cor.
	    EN: Reuses the same update flow for color changes.
	------------------------------------------------]]--
	module.OnColorValueChanged = module.OnValueChanged

	return
end) -- Prat:AddModuleToLoad
