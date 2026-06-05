--[[
    @File:      Font.lua
    @Project:   Prat-3.0

    BR: Controle das fontes das janelas de chat.
        - Fonte, tamanho, contorno e modo monocromático
        - Tamanho separado por janela, whisper tabs e pet battle tab
        - Restauração automática de tamanho/fonte
        - Cor de sombra do texto
        - Integração com LibSharedMedia e hooks da Blizzard

    EN: Chat window font control.
        - Font face, size, outline and monochrome mode
        - Separate size per chat frame, whisper tabs and pet battle tab
        - Automatic size/font restoration
        - Text shadow color
        - LibSharedMedia integration and Blizzard hooks

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade com APIs antigas e modernas de CVars
    EN: Compatibility with old and modern CVar APIs
------------------------------------------------]]--
local GetCVar = _G.GetCVar or _G.C_CVar.GetCVar

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo de controle de fontes do chat
		EN: Creation of the chat font control module
	------------------------------------------------]]--
	local module = Prat:NewModule("Font", "AceHook-3.0", "AceEvent-3.0")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL
	
	--[[------------------------------------------------
		BR: Migração leve de nomes antigos de perfil para snake_case
		EN: Lightweight migration from old profile names to snake_case
	------------------------------------------------]]--
	local function migrate_profile(profile)
		if not profile then
			return
		end

		local migrations = {
			fontface = "font_face",
			rememberfont = "remember_font",
			outlinemode = "outline_mode",
			shadowcolor = "shadow_color",
		}

		for old_key, new_key in pairs(migrations) do
			if profile[new_key] == nil and profile[old_key] ~= nil then
				profile[new_key] = profile[old_key]
			end
		end

		profile.size = profile.size or {}
		if profile.size.whisper_tabs == nil and profile.size.WhisperTabs ~= nil then
			profile.size.whisper_tabs = profile.size.WhisperTabs
		end
		if profile.size.pet_battle_tab == nil and profile.size.PetBattleTab ~= nil then
			profile.size.pet_battle_tab = profile.size.PetBattleTab
		end
	end

	Prat:SetModuleDefaults(module, {
		profile = {
			on = true,
			font_face = "",
			remember_font = false,
			size = { ["*"] = 12 },
			outline_mode = "",
			monochrome = false,
			shadow_color = {
				r = 0,
				g = 0,
				b = 0,
				a = 1,
			},
		}
	})

	--[[------------------------------------------------
		BR: Modelo reutilizável para tamanho de fonte por janela
		EN: Reusable template for per-frame font size
	------------------------------------------------]]--
	local frame_option = {
		name = function(info)
			return Prat.FrameList[info[#info]] or ""
		end,
		desc = PL["font_size_desc"],
		type = "range",
		get = "get_sub_value",
		set = "set_sub_value",
		min = 4,
		max = 100,
		step = 1,
		width = 1.20,
		hidden = function(info)
			return Prat.FrameList[info[#info]] == nil
		end,
	}
	--[[------------------------------------------------
		BR: Opção específica para tamanho das abas de whisper
		EN: Specific option for whisper tab size
	------------------------------------------------]]--
	local whisper_tabs_option = {
		name = PL["whisper_tabs"],
		desc = PL["font_size_desc"],
		type = "range",
		get = "get_sub_value",
		set = "set_sub_value",
		min = 4,
		max = 100,
		step = 1,
		width = 1.20,
		hidden = function()
			return GetCVar("whisperTabs") == "inline"
		end,
	}
	--[[------------------------------------------------
		BR: Opção específica para tamanho da aba de batalha de mascotes
		EN: Specific option for pet battle tab size
	------------------------------------------------]]--
	local pet_battle_tab_option = {
		name = PL["pet_battle_tab"],
		desc = PL["font_size_desc"],
		type = "range",
		get = "get_sub_value",
		set = "set_sub_value",
		min = 4,
		max = 100,
		step = 1,
		width = 1.20,
		hidden = not Prat.IsRetail and not Prat.IsMop,
		order = 900,
	}

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

			font_family_group = {
				type = "group",
				name = PL["font_family_group_name"],
				desc = PL["font_family_group_desc"],
				order = 20,
				args = {
					font_family_help = {
						name = PL["font_family_help"],
						type = "description",
						order = 1,
						width = "full",
					},

					font_face = {
						name = PL["font_face_name"],
						desc = PL["font_face_desc"],
						type = "select",
						dialogControl = "LSM30_Font",
						values = AceGUIWidgetLSMlists.font,
						order = 10,
						width = 1.45,
					},

					remember_font = {
						type = "toggle",
						name = PL["remember_font_name"],
						desc = PL["remember_font_desc"],
						order = 20,
						width = "full",
					},
				},
			},

			size = {
				type = "group",
				name = PL["font_size_group_name"],
				desc = PL["font_size_group_desc"],
				order = 30,
				args = {
					size_help = {
						name = PL["size_help"],
						type = "description",
						order = 1,
						width = "full",
					},

					ChatFrame1 = frame_option,
					ChatFrame2 = frame_option,

					size_spacer_1 = {
						type = "description",
						name = "\n",
						order = 25,
						width = "full",
					},

					ChatFrame3 = frame_option,
					ChatFrame4 = frame_option,

					size_spacer_2 = {
						type = "description",
						name = "\n",
						order = 55,
						width = "full",
					},

					ChatFrame5 = frame_option,
					whisper_tabs = whisper_tabs_option,
					pet_battle_tab = pet_battle_tab_option,
				}
			},

			font_style_group = {
				type = "group",
				name = PL["font_style_group_name"],
				desc = PL["font_style_group_desc"],
				order = 40,
				args = {
					font_style_help = {
						name = PL["font_style_help"],
						type = "description",
						order = 1,
						width = "full",
					},

					outline_mode = {
						name = PL["outline_mode_name"],
						desc = PL["outline_mode_desc"],
						type = "select",
						order = 10,
						width = 1.20,
						values = {
							[""] = PL["outline_none"],
							["OUTLINE"] = PL["outline_normal"],
							["THICKOUTLINE"] = PL["outline_thick"],
						},
					},

					monochrome = {
						type = "toggle",
						name = PL["monochrome_name"],
						desc = PL["monochrome_desc"],
						order = 20,
						width = "full",
					},

					shadow_color = {
						name = PL["shadow_color_name"],
						desc = PL["shadow_color_desc"],
						type = "color",
						order = 30,
						width = "full",
						get = "GetColorValue",
						set = "SetColorValue",
					},
				}
			},
		}
	})

	--[[------------------------------------------------
		BR: Ativação do módulo, registro de eventos e aplicação das fontes
		EN: Module activation, event registration and font application
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db and self.db.profile)

		self:RegisterEvent("PLAYER_ENTERING_WORLD")

		self.old_size = {}
		for k, cf in pairs(Prat.Frames) do
			local _, s, _ = cf:GetFont()
			self.old_size[k] = s
		end

		if not self.db.profile.remember_font then
			self.db.profile.font_face = nil
		end

		self:configure_all_chat_frames()

		self:SecureHook("FCF_SetChatWindowFontSize")

		Prat.Media.RegisterCallback(self, "Libshared_media_registered", "shared_media_registered")
		Prat.Media.RegisterCallback(self, "LibSharedMedia_SetGlobal", "shared_media_registered")

		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
	end

	--[[------------------------------------------------
		BR: Retorna a descrição localizada do módulo
		EN: Returns the localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Reaplica fonte quando a mídia selecionada é registrada/alterada
		EN: Reapplies font when selected media is registered/changed
	------------------------------------------------]]--
	function module:shared_media_registered(mediatype, name)
		if mediatype == "font" then
			if name == self.db.profile.font_face then
				self:configure_all_chat_frames()
			end
		end
	end

	--[[------------------------------------------------
		BR: Reaplica configurações quando janelas de chat mudam
		EN: Reapplies settings when chat frames change
	------------------------------------------------]]--
	function module:Prat_FramesUpdated()
		self:configure_all_chat_frames()
	end

	--[[------------------------------------------------
		BR: Garante aplicação das fontes após entrada no mundo
		EN: Ensures font application after entering the world
	------------------------------------------------]]--
	function module:PLAYER_ENTERING_WORLD()
		self:configure_all_chat_frames()
		self:UnregisterAllEvents()
	end

	--[[------------------------------------------------
		BR: Desativação do módulo e restauração dos tamanhos antigos
		EN: Module deactivation and restoration of previous sizes
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:UnhookAll()
		Prat.Media.UnregisterAllCallbacks(self)

		for k, cf in pairs(Prat.Frames) do
			self:set_font_size(cf, self.old_size[k] or 12)
		end
		self:set_font_mode("")
	end

	--[[------------------------------------------------
		BR: Lê valores aninhados usados pelas opções por janela
		EN: Reads nested values used by per-frame options
	------------------------------------------------]]--
	function module:get_sub_value(info)
		return self.db.profile[info[#info - 1]][info[#info]]
	end

	function module:set_sub_value(info, b)
		self.db.profile[info[#info - 1]][info[#info]] = b
		self:OnValueChanged(info, b)
	end

	--[[------------------------------------------------
		BR: Identificadores auxiliares para abas especiais de chat
		EN: Helper identifiers for special chat tabs
	------------------------------------------------]]--
	local function is_whisper_frame(frame)
		return frame.chatType == "WHISPER" or frame.chatType == "BN_WHISPER"
	end

	local function is_pet_battle_frame(frame)
		return frame.chatType == "PET_BATTLE_COMBAT_LOG"
	end

	--[[------------------------------------------------
		BR: Aplica fonte, tamanho e efeitos em todas as janelas de chat
		EN: Applies font, size and effects to all chat frames
	------------------------------------------------]]--
	function module:configure_all_chat_frames()
		local db = self.db.profile

		if db.font_face then
			self:set_font(db.font_face)
		end

		for k, v in pairs(Prat.Frames) do
			if is_whisper_frame(v) then
				self:set_font_size(v, db.size.whisper_tabs)
			elseif is_pet_battle_frame(v) then
				self:set_font_size(v, db.size.pet_battle_tab)
			else
				self:set_font_size(v, db.size[k])
			end
		end

		if not db.monochrome then
			self:set_font_mode(db.outline_mode)
		else
			self:set_font_mode(db.outline_mode .. ", MONOCHROME")
		end
	end

	--[[------------------------------------------------
		BR: Define o tamanho da fonte de uma janela de chat
		EN: Sets the font size of a chat frame
	------------------------------------------------]]--
	function module:set_font_size(cf, size)
		if not size then
			return
		end

		FCF_SetChatWindowFontSize(module, cf, size)
	end

	--[[------------------------------------------------
		BR: Aplica a fonte selecionada em todas as janelas de chat
		EN: Applies the selected font to all chat frames
	------------------------------------------------]]--
	function module:set_font(font)
		local font_file = Prat.Media:Fetch(Prat.Media.MediaType.FONT, font)
		for _, cf in pairs(Prat.Frames) do
			local _, s, m = cf:GetFont()
			cf:SetFont(font_file, s, m)
		end
	end

	--[[------------------------------------------------
		BR: Aplica contorno, monocromia e sombra do texto
		EN: Applies outline, monochrome and text shadow
	------------------------------------------------]]--
	function module:set_font_mode(mode, monochrome)
		for _, cf in pairs(Prat.Frames) do
			local f, s, _ = cf:GetFont()
			cf:SetFont(f, s, mode)

			if monochrome then
				local c = self.db.profile.shadow_color
				cf:SetShadowColor(c.r, c.g, c.b, c.a)
			end
		end
	end

	--[[------------------------------------------------
		BR: Retorna a cor atual da sombra do texto
		EN: Returns the current text shadow color
	------------------------------------------------]]--
	function module:get_shadow_color()
		local h = self.db.profile.shadow_color or {}
		return h.r or 1.0, h.g or 1.0, h.b or 1.0
	end

	--[[------------------------------------------------
		BR: Atualiza a cor da sombra e reaplica as fontes
		EN: Updates shadow color and reapplies fonts
	------------------------------------------------]]--
	function module:set_shadow_color(r, g, b)
		local db = self.db.profile
		db.shadow_color = db.shadow_color or {}
		local h = db.shadow_color
		h.r, h.g, h.b = r, g, b
		self:configure_all_chat_frames()
	end

	--[[------------------------------------------------
		BR: Captura alterações externas no tamanho da fonte feitas pela Blizzard
		EN: Captures external Blizzard font size changes
	------------------------------------------------]]--
	function module:FCF_SetChatWindowFontSize(fcfself, chatFrame, font_size)
		if not font_size then
			-- font_size should never be nil
			return
		end
		if fcfself == module then
			return
		end

		if not chatFrame then
			chatFrame = FCF_GetCurrentChatFrame();
		end
		if self.db and self.db.profile.on then
			if is_whisper_frame(chatFrame) then
				self.db.profile.size.whisper_tabs = font_size
			elseif is_pet_battle_frame(chatFrame) then
				self.db.profile.size.pet_battle_tab = font_size
			else
				self.db.profile.size[chatFrame:GetName()] = font_size
			end
		end
	end

	module.OnValueChanged = module.configure_all_chat_frames
	module.OnSubValueChanged = module.configure_all_chat_frames
	module.OnColorValueChanged = module.configure_all_chat_frames

	--[[------------------------------------------------
		BR: Aliases legados para integrações internas/externas antigas
		EN: Legacy aliases for older internal/external integrations
	------------------------------------------------]]--
	module.ConfigureAllChatFrames = module.configure_all_chat_frames
	module.SetFontSize = module.set_font_size
	module.SetFont = module.set_font
	module.SetFontMode = module.set_font_mode
	module.GetShadowClr = module.get_shadow_color
	module.SetShadowClr = module.set_shadow_color
	module.GetSubValue = module.get_sub_value
	module.SetSubValue = module.set_sub_value
	return
end)
