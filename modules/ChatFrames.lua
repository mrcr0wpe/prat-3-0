--[[
    @File:      ChatFrames.lua
    @Project:   Prat-3.0

    BR: Controle estrutural das janelas de chat.
        - Limites mínimos e máximos de largura/altura
        - Clamp/posicionamento próximo às bordas da tela
        - Transparência estática e alpha padrão do chat
        - Recriação e restauração das texturas de fundo
        - Integração com docking, undocking e Edit Mode

    EN: Structural control of chat frames.
        - Minimum and maximum width/height limits
        - Clamp/positioning near screen edges
        - Static transparency and default chat alpha
        - Background texture recreation and restoration
        - Integration with docking, undocking and Edit Mode

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
		BR: Criação do módulo estrutural das janelas de chat
		EN: Creation of the structural chat frame module
	------------------------------------------------]]--
	local module = Prat:NewModule("Frames", "AceHook-3.0")

	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	--[[------------------------------------------------
		BR: Remove insets de clamp cedo, antes da Blizzard reposicionar as janelas
		EN: Removes clamp insets early, before Blizzard repositions the windows
	------------------------------------------------]]--
	for i = 1, num_chat_windows do
		local frame = _G["ChatFrame" .. i]
		if frame then
			frame:SetClampRectInsets(0, 0, 0, 0)
		end
	end

	--[[------------------------------------------------
		BR: Valores padrão do módulo
		EN: Module default values
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			min_chat_width = 160,
			min_chat_width_default = 160,
			max_chat_width = 800,
			max_chat_width_default = 800,
			min_chat_height = 120,
			min_chat_height_default = 120,
			max_chat_height = 600,
			max_chat_height_default = 600,
			main_chat_on_load = true,
			remove_clamp = true,
			frame_alpha_static = false,
			default_frame_alpha = 0.25,
			frame_metrics = {
				["*"] = {
					width = 430,
					height = 120,
				}
			}
		}
	})

	--[[------------------------------------------------
		BR: Migra chaves antigas de profile para snake_case
		EN: Migrates old profile keys to snake_case
	------------------------------------------------]]--
	local function migrate_profile(profile)
		if not profile then
			return
		end

		local migrations = {
			minchatwidth = "min_chat_width",
			minchatwidthdefault = "min_chat_width_default",
			maxchatwidth = "max_chat_width",
			maxchatwidthdefault = "max_chat_width_default",
			minchatheight = "min_chat_height",
			minchatheightdefault = "min_chat_height_default",
			maxchatheight = "max_chat_height",
			maxchatheightdefault = "max_chat_height_default",
			mainchatonload = "main_chat_on_load",
			removeclamp = "remove_clamp",
			framealphastatic = "frame_alpha_static",
			defaultframealpha = "default_frame_alpha",
			framemetrics = "frame_metrics",
		}

		for old_key, new_key in pairs(migrations) do
			if profile[old_key] ~= nil and profile[new_key] == nil then
				profile[new_key] = profile[old_key]
			end
			profile[old_key] = nil
		end

		if profile.min_chat_width == nil then
			profile.min_chat_width = 160
		end
		if profile.max_chat_width == nil then
			profile.max_chat_width = 800
		end
		if profile.min_chat_height == nil then
			profile.min_chat_height = 120
		end
		if profile.max_chat_height == nil then
			profile.max_chat_height = 600
		end
		if profile.remove_clamp == nil then
			profile.remove_clamp = true
		end
		if profile.frame_alpha_static == nil then
			profile.frame_alpha_static = false
		end
		if profile.default_frame_alpha == nil then
			profile.default_frame_alpha = 0.25
		end
		if profile.frame_metrics == nil then
			profile.frame_metrics = {
				["*"] = {
					width = 430,
					height = 120,
				}
			}
		end
	end

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

			size_limits = {
				type = "group",
				name = PL["size_limits_tab_name"],
				desc = PL["size_limits_tab_desc"],
				order = 100,
				args = {
					size_limits_help = {
						type = "description",
						name = PL["size_limits_help"],
						order = 10,
						width = "full",
					},

					min_chat_height = {
						type = "range",
						name = PL["min_chat_height_name"],
						desc = PL["min_chat_height_desc"],
						order = 20,
						width = 1.2,
						min = 25,
						max = 1024,
						step = 1,
					},

					max_chat_height = {
						type = "range",
						name = PL["max_chat_height_name"],
						desc = PL["max_chat_height_desc"],
						order = 30,
						width = 1.2,
						min = 25,
						max = 1024,
						step = 1,
					},

					min_chat_width = {
						type = "range",
						name = PL["min_chat_width_name"],
						desc = PL["min_chat_width_desc"],
						order = 40,
						width = 1.2,
						min = 25,
						max = 1024,
						step = 1,
					},

					max_chat_width = {
						type = "range",
						name = PL["max_chat_width_name"],
						desc = PL["max_chat_width_desc"],
						order = 50,
						width = 1.2,
						min = 25,
						max = 1024,
						step = 1,
					},
				}
			},

			position_opacity = {
				type = "group",
				name = PL["position_opacity_tab_name"],
				desc = PL["position_opacity_tab_desc"],
				order = 200,
				args = {
					position_opacity_help = {
						type = "description",
						name = PL["position_opacity_help"],
						order = 10,
						width = "full",
					},

					remove_clamp = {
						type = "toggle",
						name = PL["remove_clamp_name"],
						desc = PL["remove_clamp_desc"],
						order = 20,
						width = 1.25,
					},

					frame_alpha_static = {
						type = "toggle",
						name = PL["frame_alpha_static_name"],
						desc = PL["frame_alpha_static_desc"],
						order = 30,
						width = 1.25,
					},

					default_frame_alpha = {
						type = "range",
						name = PL["default_frame_alpha_name"],
						desc = PL["default_frame_alpha_desc"],
						order = 40,
						width = 1.25,
						min = 0.0,
						max = 1,
						step = 0.01,
					},
				}
			},
		}
	})

	--[[------------------------------------------------
		BR: Inicializa limites padrão reais da janela principal
		EN: Initializes real default bounds from the main chat frame
	------------------------------------------------]]--
	Prat:SetModuleInit(module, function(self)
		migrate_profile(self.db.profile)
		self:get_defaults()
	end)

	--[[------------------------------------------------
		BR: Ativação do módulo, aplicação dos parâmetros e instalação dos hooks
		EN: Module activation, parameter application and hook installation
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db.profile)

		CHAT_FRAME_BUTTON_FRAME_MIN_ALPHA = 0
		self:configure_all_chat_frames(true)

		self:SecureHook("FCF_DockFrame", "fcf_dock_frame")
		self:SecureHook("FCF_UnDockFrame", "fcf_undock_frame")
		self:SecureHook("FloatingChatFrame_UpdateBackgroundAnchors", "floating_chat_frame_update_background_anchors")

		self:SecureHook("FCF_SetWindowAlpha", "fcf_set_window_alpha")
		self:SecureHook("FCF_SetWindowColor", "fcf_set_window_color")

		if not Prat.IsClassic then
			local previous_set_clamp_rect_insets = ChatFrame1.SetClampRectInsets
			self:SecureHook(ChatFrame1, "SetClampRectInsets", function(frame)
				-- BR: SetClampRectInsets pode ser protegido em combate.
				-- EN: SetClampRectInsets may be protected while in combat.
				if _G.InCombatLockdown() then
					return
				end

				if self.db.profile.on and self.db.profile.remove_clamp then
					previous_set_clamp_rect_insets(frame, 0, 0, 0, 0)
				end
			end)
		end
	end

	--[[------------------------------------------------
		BR: Desativação do módulo e restauração de parâmetros padrão
		EN: Module deactivation and restoration of default parameters
	------------------------------------------------]]--
	function module:OnModuleDisable()
		CHAT_FRAME_BUTTON_FRAME_MIN_ALPHA = 0.2
		self:configure_all_chat_frames(false)
	end

	--[[------------------------------------------------
		BR: Retorna a descrição localizada do módulo
		EN: Returns the localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Registra frame atualizado e reaplica fonte quando âncoras/fundo mudam
		EN: Registers updated frame and reapplies font when anchors/background change
	------------------------------------------------]]--
	function module:floating_chat_frame_update_background_anchors(frame)
		if self.db.profile.remove_clamp then
			frame:SetClampRectInsets(0, 0, 0, 0)
		end

		Prat.Frames[frame:GetName()] = frame

		local font_module = Prat:GetModule("Font")
		if font_module then
			font_module:ConfigureAllChatFrames()
		end
	end

	--[[------------------------------------------------
		BR: Reaplica parâmetros quando uma janela é acoplada
		EN: Reapplies parameters when a frame is docked
	------------------------------------------------]]--
	function module:fcf_dock_frame(frame)
		if self.db.profile.remove_clamp then
			frame:SetClampRectInsets(0, 0, 0, 0)
		end

		Prat.Frames[frame:GetName()] = frame

		local font_module = Prat:GetModule("Font")
		if font_module then
			font_module:ConfigureAllChatFrames()
		end
	end

	--[[------------------------------------------------
		BR: Reaplica parâmetros quando uma janela é desacoplada
		EN: Reapplies parameters when a frame is undocked
	------------------------------------------------]]--
	function module:fcf_undock_frame(frame)
		if self.db.profile.remove_clamp then
			frame:SetClampRectInsets(0, 0, 0, 0)
		end

		Prat.Frames[frame:GetName()] = frame

		local font_module = Prat:GetModule("Font")
		if font_module then
			font_module:ConfigureAllChatFrames()
		end
	end

	--[[------------------------------------------------
		BR: Aplica parâmetros estruturais em todas as janelas de chat
		EN: Applies structural parameters to all chat frames
	------------------------------------------------]]--
	function module:configure_all_chat_frames(enabled)
		for _, frame in pairs(Prat.Frames) do
			self:set_parameters(frame, enabled)
		end
	end

	--[[------------------------------------------------
		BR: Recria texturas de fundo para controle próprio do Prat
		EN: Recreates background textures for Prat-controlled handling
	------------------------------------------------]]--
	function module:recreate_background_textures(frame)
		if frame.PratTextures then
			return
		end

		frame.PratTextures = {}

		for _, name in ipairs(CHAT_FRAME_TEXTURES) do
			local texture = _G[frame:GetName() .. name]
			if texture then
				local layer, sublevel = texture:GetDrawLayer()
				local new_texture = texture:GetParent():CreateTexture(nil, layer, nil, sublevel)

				for i = 1, texture:GetNumPoints() do
					new_texture:SetPoint(texture:GetPoint(i))
				end

				new_texture:SetTexture(texture:GetTexture())
				new_texture:SetTexCoord(texture:GetTexCoord())
				new_texture:SetSize(texture:GetSize())

				table.insert(frame.PratTextures, new_texture)
				texture:Hide()
			end
		end
	end

	--[[------------------------------------------------
		BR: Esconde texturas recriadas e restaura as originais
		EN: Hides recreated textures and restores original textures
	------------------------------------------------]]--
	function module:hide_prat_textures(frame)
		if frame.PratTextures then
			for _, name in ipairs(CHAT_FRAME_TEXTURES) do
				local texture = _G[frame:GetName() .. name]
				if texture then
					texture:Show()
				end
			end

			for _, texture in ipairs(frame.PratTextures) do
				texture:Hide()
			end
		end
	end

	--[[------------------------------------------------
		BR: Exibe texturas recriadas com cor e alpha atuais do chat
		EN: Shows recreated textures with current chat color and alpha
	------------------------------------------------]]--
	function module:restore_prat_textures(frame)
		if not frame.PratTextures then
			self:recreate_background_textures(frame)
		end

		for _, name in ipairs(CHAT_FRAME_TEXTURES) do
			local texture = _G[frame:GetName() .. name]
			if texture then
				texture:Hide()
			end
		end

		local _, _, r, g, b, a = FCF_GetChatWindowInfo(frame:GetID())

		for _, texture in ipairs(frame.PratTextures) do
			texture:Show()
			texture:SetVertexColor(r, g, b)
			texture:SetAlpha(a)
		end
	end

	--[[------------------------------------------------
		BR: Captura limites padrão reais da primeira janela de chat
		EN: Captures real default bounds from the first chat frame
	------------------------------------------------]]--
	function module:get_defaults()
		local frame = _G["ChatFrame1"]
		local profile = self.db.profile

		local min_width_default, min_height_default, max_width_default, max_height_default

		if frame.GetResizeBounds then
			min_width_default, min_height_default, max_width_default, max_height_default = frame:GetResizeBounds()
		else
			min_width_default, min_height_default = frame:GetMinResize()
			max_width_default, max_height_default = frame:GetMaxResize()
		end

		profile.min_chat_width_default = min_width_default
		profile.max_chat_width_default = max_width_default
		profile.min_chat_height_default = min_height_default
		profile.max_chat_height_default = max_height_default
		profile.initialized = true
	end

	--[[------------------------------------------------
		BR: Sincroniza cor das texturas próprias com a cor da janela
		EN: Syncs Prat textures with the chat frame color
	------------------------------------------------]]--
	function module:fcf_set_window_color(frame, r, g, b)
		if frame.PratTextures then
			for _, texture in ipairs(frame.PratTextures) do
				texture:SetVertexColor(r, g, b)
			end
		end
	end

	--[[------------------------------------------------
		BR: Sincroniza alpha das texturas próprias com a janela
		EN: Syncs Prat texture alpha with the chat frame
	------------------------------------------------]]--
	function module:fcf_set_window_alpha(frame)
		local _, _, _, _, _, a = FCF_GetChatWindowInfo(frame:GetID())

		if frame.PratTextures then
			for _, texture in ipairs(frame.PratTextures) do
				texture:SetAlpha(a)
			end
		end
	end

	--[[------------------------------------------------
		BR: Aplica limites, alpha, clamp e texturas em uma janela
		EN: Applies bounds, alpha, clamp and textures to one frame
	------------------------------------------------]]--
	function module:set_parameters(frame, enabled)
		local profile = self.db.profile

		local min_width, min_height, max_width, max_height

		if enabled then
			if profile.frame_alpha_static then
				self:restore_prat_textures(frame)
			else
				self:hide_prat_textures(frame)
			end

			DEFAULT_CHATFRAME_ALPHA = profile.default_frame_alpha

			min_width, min_height = profile.min_chat_width, profile.min_chat_height
			max_width, max_height = profile.max_chat_width, profile.max_chat_height

			if profile.remove_clamp then
				if not Prat.IsClassic then
					frame:SetClampedToScreen(false)
				end

				frame:SetClampRectInsets(0, 0, 0, 0)

				if not Prat.IsClassic then
					EventRegistry:RegisterCallback("EditMode.Enter", function()
						frame:SetClampedToScreen(true)
						EventRegistry:UnregisterCallback("EditMode.Enter", frame)
					end, frame)
				end
			end

			if frame.ScrollBar then
				frame.ScrollBar:SetAlpha(0)
			end
		else
			self:hide_prat_textures(frame)

			DEFAULT_CHATFRAME_ALPHA = 0.25

			min_width, min_height = profile.min_chat_width_default, profile.min_chat_height_default
			max_width, max_height = profile.max_chat_width_default, profile.max_chat_height_default
		end

		if frame.SetResizeBounds then
			frame:SetResizeBounds(min_width, min_height, max_width, max_height)
		else
			frame:SetMinResize(min_width, min_height)
			frame:SetMaxResize(max_width, max_height)
		end
	end

	--[[------------------------------------------------
		BR: Reaplica parâmetros após alterações feitas pelo usuário
		EN: Reapplies parameters after user changes
	------------------------------------------------]]--
	function module:OnValueChanged()
		self:configure_all_chat_frames(true)
	end

	--[[------------------------------------------------
		BR: Aliases legados para reduzir risco com chamadas antigas ou convenções internas
		EN: Legacy aliases to reduce risk from older calls or internal conventions
	------------------------------------------------]]--
	module.ConfigureAllChatFrames = module.configure_all_chat_frames
	module.RecreateBackgroundTextures = module.recreate_background_textures
	module.HidePratTextures = module.hide_prat_textures
	module.RestorePratTextures = module.restore_prat_textures
	module.GetDefaults = module.get_defaults
	module.SetParameters = module.set_parameters

	module.FloatingChatFrame_UpdateBackgroundAnchors = module.floating_chat_frame_update_background_anchors
	module.FCF_DockFrame = module.fcf_dock_frame
	module.FCF_UnDockFrame = module.fcf_undock_frame
	module.FCF_SetWindowColor = module.fcf_set_window_color
	module.FCF_SetWindowAlpha = module.fcf_set_window_alpha

	return
end) -- Prat:AddModuleToLoad
