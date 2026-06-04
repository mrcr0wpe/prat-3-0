--[[
    @File:      Paragraph.lua
    @Project:   Prat-3.0

    BR: Controle de alinhamento e espaçamento do chat.
        - Alinhamento horizontal por janela
        - Espaçamento entre linhas
        - Configuração independente por frame
        - Aplicação dinâmica nas janelas do chat

    EN: Chat alignment and spacing control.
        - Per-window horizontal alignment
        - Line spacing adjustment
        - Independent frame configuration
        - Dynamic application to chat windows

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
		BR: Criação do módulo responsável pelo alinhamento do chat
		EN: Creation of the module responsible for chat alignment
	------------------------------------------------]]--
	local module = Prat:NewModule("Paragraph")

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
			justification = { ["*"] = "LEFT" },
			spacing = 0,
		}
	})

	do
		--[[------------------------------------------------
			BR: Cria opção individual de alinhamento por janela
			EN: Creates an individual alignment option per window
		------------------------------------------------]]--
		local function make_alignment_option(order)
			return {
				name = function(info)
					return Prat.FrameList[info[#info]] or ""
				end,
				desc = PL["alignment_option_desc"],
				type = "select",
				order = order,
				width = 0.8,
				get = function(info)
					return info.handler.db.profile.justification[info[#info]]
				end,
				set = function(info, value)
					info.handler.db.profile.justification[info[#info]] = value
					info.handler:OnValueChanged(info, value)
				end,
				values = {
					LEFT = PL["align_left"],
					CENTER = PL["align_center"],
					RIGHT = PL["align_right"],
				},
				sorting = { "LEFT", "CENTER", "RIGHT" },
				hidden = function(info)
					return Prat.FrameList[info[#info]] == nil
				end,
			}
		end

		--[[------------------------------------------------
			BR: Construção da interface de configuração do módulo
			EN: Module configuration interface construction
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

				alignment = {
					name = PL["alignment_tab_name"],
					desc = PL["alignment_tab_desc"],
					type = "group",
					order = 100,
					args = {
						alignment_help = {
							type = "description",
							name = PL["alignment_help"],
							order = 10,
							width = "full",
						},

						alignment_group = {
							name = PL["alignment_group_name"],
							desc = PL["alignment_group_desc"],
							type = "group",
							inline = true,
							order = 20,
							args = {
								ChatFrame1 = make_alignment_option(10),
								ChatFrame2 = make_alignment_option(20),
								ChatFrame3 = make_alignment_option(30),
								ChatFrame4 = make_alignment_option(40),
								ChatFrame5 = make_alignment_option(50),
								ChatFrame6 = make_alignment_option(60),
								ChatFrame7 = make_alignment_option(70),
								ChatFrame8 = make_alignment_option(80),
								ChatFrame9 = make_alignment_option(90),
								ChatFrame10 = make_alignment_option(100),
							},
						},
					},
				},

				spacing = {
					name = PL["spacing_tab_name"],
					desc = PL["spacing_tab_desc"],
					type = "group",
					order = 200,
					args = {
						spacing_help = {
							type = "description",
							name = PL["spacing_help"],
							order = 10,
							width = "full",
						},

						spacing = {
							name = PL["spacing_name"],
							desc = PL["spacing_desc"],
							type = "range",
							min = 0,
							max = 20,
							step = 1,
							order = 20,
							width = 1.60,
						},

						warning = {
							type = "description",
							name = PL["alignment_warning"],
							order = 30,
							width = "full",
						},
					},
				},
			},
		})
	end

	--[[------------------------------------------------
		BR: Aplica alinhamento/espaçamento e registra atualização de frames
		EN: Applies alignment/spacing and registers frame updates
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:configure_all_chat_frames(true)
		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
	end

	--[[------------------------------------------------
		BR: Restaura alinhamento padrão ao desabilitar o módulo
		EN: Restores default alignment when disabling the module
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:configure_all_chat_frames(false)
	end

	--[[------------------------------------------------
		BR: Reaplica alterações após mudanças nas opções
		EN: Reapplies changes after option modifications
	------------------------------------------------]]--
	function module:OnValueChanged()
		self:configure_all_chat_frames(true)
	end

	--[[------------------------------------------------
		BR: Reconfigura novos frames adicionados ao chat
		EN: Reconfigures new frames added to chat
	------------------------------------------------]]--
	function module:Prat_FramesUpdated()
		self:configure_all_chat_frames(true)
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Aplica alinhamento e espaçamento em todos os frames do chat
		EN: Applies alignment and spacing to all chat frames
	------------------------------------------------]]--
	function module:configure_all_chat_frames(enable)
		local profile = self.db.profile

		for frame_name, frame in pairs(Prat.Frames) do
			frame:SetJustifyH(enable and profile.justification[frame_name] or "LEFT")
			frame:SetSpacing(profile.spacing)
		end
	end

	--[[------------------------------------------------
		BR: Alias legado para chamadas antigas ou convenções internas do Prat
		EN: Legacy alias for older calls or internal Prat conventions
	------------------------------------------------]]--
	module.ConfigureAllChatFrames = module.configure_all_chat_frames

	return
end) -- Prat:AddModuleToLoad
