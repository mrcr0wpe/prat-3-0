--[[
    @File:      Scroll.lua
    @Project:   Prat-3.0

    BR: Controle de rolagem das janelas de chat.
        - Suporte ao mousewheel por janela
        - Velocidade normal e modificada por Shift
        - Ctrl + mousewheel para topo/fim
        - TheLowDown: retorno automático ao fim do chat
        - Controle legado de direção de inserção do texto

    EN: Chat window scrolling control.
        - Per-frame mousewheel support
        - Normal and Shift-modified scroll speed
        - Ctrl + mousewheel for top/bottom jumps
        - TheLowDown: automatic return to chat bottom
        - Legacy text insertion direction control

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
		BR: Criação do módulo de rolagem com suporte a hooks e timers
		EN: Creation of the scrolling module with hook and timer support
	------------------------------------------------]]--
	local module = Prat:NewModule("Scroll", "AceHook-3.0", "AceTimer-3.0")

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
			mousewheel = { ["*"] = true },
			normal_scroll_speed = 1,
			shift_scroll_speed = 3,
			low_down = { ["*"] = true },
			low_down_delay = 20,
			scroll_direction = "BOTTOM",
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
			normscrollspeed = "normal_scroll_speed",
			ctrlscrollspeed = "shift_scroll_speed",
			lowdown = "low_down",
			lowdowndelay = "low_down_delay",
			scrolldirection = "scroll_direction",
		}

		for old_key, new_key in pairs(migrations) do
			if profile[old_key] ~= nil and profile[new_key] == nil then
				profile[new_key] = profile[old_key]
			end
			profile[old_key] = nil
		end

		if profile.mousewheel == nil then
			profile.mousewheel = { ["*"] = true }
		end
		if profile.low_down == nil then
			profile.low_down = { ["*"] = true }
		end
		if profile.normal_scroll_speed == nil then
			profile.normal_scroll_speed = 1
		end
		if profile.shift_scroll_speed == nil then
			profile.shift_scroll_speed = 3
		end
		if profile.low_down_delay == nil then
			profile.low_down_delay = 20
		end
		if profile.scroll_direction == nil then
			profile.scroll_direction = "BOTTOM"
		end
	end

	--[[------------------------------------------------
		BR: Configuração das opções da interface do módulo
		EN: Module interface options configuration
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
						name = PL["full_description"],
						type = "description",
						order = 10,
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

			mousewheel = {
				type = "group",
				name = PL["mousewheel_tab_name"],
				desc = PL["mousewheel_tab_desc"],
				order = 100,
				args = {
					mousewheel_help = {
						name = PL["mousewheel_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					mousewheel = {
						name = PL["mousewheel_name"],
						desc = PL["mousewheel_desc"],
						type = "multiselect",
						order = 20,
						width = "full",
						values = Prat.HookedFrameList,
						get = "GetSubValue",
						set = "SetSubValue",
					},

					normal_scroll_speed = {
						name = PL["normal_scroll_speed_name"],
						desc = PL["normal_scroll_speed_desc"],
						type = "range",
						order = 30,
						width = 1.25,
						min = 1,
						max = 21,
						step = 1,
					},

					shift_scroll_speed = {
						name = PL["shift_scroll_speed_name"],
						desc = PL["shift_scroll_speed_desc"],
						type = "range",
						order = 40,
						width = 1.25,
						min = 3,
						max = 21,
						step = 3,
					},
				}
			},

			low_down = {
				type = "group",
				name = PL["low_down_tab_name"],
				desc = PL["low_down_tab_desc"],
				order = 200,
				args = {
					low_down_help = {
						name = PL["low_down_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					low_down = {
						name = PL["low_down_name"],
						desc = PL["low_down_desc"],
						type = "multiselect",
						order = 20,
						width = "full",
						values = Prat.HookedFrameList,
						get = "GetSubValue",
						set = "SetSubValue",
					},

					low_down_delay = {
						name = PL["low_down_delay_name"],
						desc = PL["low_down_delay_desc"],
						type = "range",
						order = 30,
						width = 1.25,
						min = 1,
						max = 60,
						step = 1,
					},
				}
			},

			advanced = {
				type = "group",
				name = PL["advanced_tab_name"],
				desc = PL["advanced_tab_desc"],
				order = 300,
				args = {
					advanced_help = {
						name = PL["advanced_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					scroll_direction = {
						type = "select",
						name = PL["scroll_direction_name"],
						desc = PL["scroll_direction_desc"],
						order = 20,
						values = {
							TOP = PL["scroll_direction_top"],
							BOTTOM = PL["scroll_direction_bottom"],
						},
						hidden = true, -- Blizz Bug DISABLED 10172010
					},
				},
			},
		}
	})

	--[[------------------------------------------------
		BR: Ativação do módulo e registro de atualização de frames
		EN: Module activation and frame update registration
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db.profile)

		self:configure_all_frames()
		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
	end

	--[[------------------------------------------------
		BR: Desativação do módulo e remoção de mousewheel/lowdown
		EN: Module deactivation and removal of mousewheel/lowdown behavior
	------------------------------------------------]]--
	function module:OnModuleDisable()
		for _, frame in pairs(Prat.Frames) do
			self:mouse_wheel(frame, false)
			if not IsCombatLog(frame) then
				self:low_down(frame, false)
			end
		end

		self:set_scroll_direction("BOTTOM")
	end

	--[[------------------------------------------------
		BR: Reaplica configurações quando os frames do chat mudam
		EN: Reapplies settings when chat frames change
	------------------------------------------------]]--
	function module:Prat_FramesUpdated()
		self:configure_all_frames()
	end

	--[[------------------------------------------------
		BR: Reaplica configurações ao alterar opções por janela
		EN: Reapplies settings when per-frame options change
	------------------------------------------------]]--
	function module:OnSubValueChanged()
		self:configure_all_frames()
	end

	--[[------------------------------------------------
		BR: Retorna a descrição localizada do módulo
		EN: Returns the localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Aplica mousewheel e TheLowDown em todas as janelas
		EN: Applies mousewheel and TheLowDown to all frames
	------------------------------------------------]]--
	function module:configure_all_frames()
		migrate_profile(self.db.profile)

		for frame_name, frame in pairs(Prat.Frames) do
			self:mouse_wheel(frame, self.db.profile.mousewheel[frame_name])
			if not IsCombatLog(frame) then
				self:low_down(frame, self.db.profile.low_down[frame_name])
			end
		end

		self:set_scroll_direction(self.db.profile.scroll_direction)
	end

	do
		--[[------------------------------------------------
			BR: Executa rolagem normal, modificada ou salto topo/fim
			EN: Performs normal, modified or top/bottom jump scrolling
		------------------------------------------------]]--
		local function scroll_frame(chat_frame, up)
			if IsControlKeyDown() then
				if up then
					chat_frame:ScrollToTop()
				else
					chat_frame:ScrollToBottom()
				end
			else
				if IsShiftKeyDown() then
					for _ = 1, module.db.profile.shift_scroll_speed do
						if up then
							chat_frame:ScrollUp()
						else
							chat_frame:ScrollDown()
						end
					end
				else
					for _ = 1, module.db.profile.normal_scroll_speed do
						if up then
							chat_frame:ScrollUp()
						else
							chat_frame:ScrollDown()
						end
					end
				end
			end
		end

		--[[------------------------------------------------
			BR: Liga ou desliga o mousewheel em uma janela de chat
			EN: Enables or disables mousewheel on a chat frame
		------------------------------------------------]]--
		function module:mouse_wheel(chat_frame, enabled)
			if enabled then
				chat_frame:SetScript("OnMouseWheel", function(frame, delta)
					scroll_frame(frame, delta > 0)
				end)
				chat_frame:EnableMouseWheel(true)
			else
				chat_frame:SetScript("OnMouseWheel", nil)
				chat_frame:EnableMouseWheel(false)
			end
		end
	end

	--[[------------------------------------------------
		BR: Timers usados pelo TheLowDown para retorno automático ao fim
		EN: Timers used by TheLowDown for automatic return to bottom
	------------------------------------------------]]--
	local timers = {}

	--[[------------------------------------------------
		BR: Reinicia o timer de retorno ao fim após rolagem manual
		EN: Restarts the return-to-bottom timer after manual scrolling
	------------------------------------------------]]--
	local function low_down_handler(chat_frame)
		if timers[chat_frame] then
			module:CancelTimer(timers[chat_frame])
		end

		timers[chat_frame] = module:ScheduleTimer("bring_the_low_down", module.db.profile.low_down_delay, chat_frame)
	end

	--[[------------------------------------------------
		BR: Instala/remove hooks de rolagem para o TheLowDown
		EN: Installs/removes scrolling hooks for TheLowDown
	------------------------------------------------]]--
	function module:low_down(chat_frame, enabled)
		local funcs = { "ScrollUp", "ScrollDown", "ScrollToTop", "PageUp", "PageDown" }

		if enabled then
			for _, func in ipairs(funcs) do
				if not self:IsHooked(chat_frame, func) then
					self:SecureHook(chat_frame, func, low_down_handler)
				end
			end
		else
			for _, func in ipairs(funcs) do
				if self:IsHooked(chat_frame, func) then
					self:Unhook(chat_frame, func)
				end
			end
		end
	end

	--[[------------------------------------------------
		BR: Executa retorno automático ao fim do chat
		EN: Executes automatic return to chat bottom
	------------------------------------------------]]--
	function module:bring_the_low_down(frame)
		timers[frame] = nil
		self:reset_frame(frame)
	end

	--[[------------------------------------------------
		BR: Move a janela para o fim se ela não estiver no final
		EN: Moves the frame to bottom if it is not already there
	------------------------------------------------]]--
	function module:reset_frame(chat_frame)
		if not chat_frame:AtBottom() then
			chat_frame:ScrollToBottom()
		end
	end

	--[[------------------------------------------------
		BR: Mantém configuração legada de direção de inserção do texto
		EN: Keeps legacy text insertion direction setting
	------------------------------------------------]]--
	function module:set_scroll_direction(direction)
		-- Blizz bug DISABLED 10172010

		-- for _, frame in pairs(Prat.HookedFrames) do
		--     self:scroll_direction(frame, direction)
		-- end

		self.db.profile.scroll_direction = direction
	end

	--[[------------------------------------------------
		BR: Aplica direção de inserção do texto quando permitido
		EN: Applies text insertion direction when allowed
	------------------------------------------------]]--
	function module:scroll_direction(chat_frame, direction)
		if chat_frame:GetInsertMode() ~= direction then
			chat_frame:SetMaxLines(chat_frame:GetMaxLines())
			chat_frame:SetInsertMode(direction)
		end
	end

	--[[------------------------------------------------
		BR: Aliases legados para reduzir risco com chamadas antigas
		EN: Legacy aliases to reduce risk from older calls
	------------------------------------------------]]--
	module.ConfigureAllFrames = module.configure_all_frames
	module.MouseWheel = module.mouse_wheel
	module.LowDown = module.low_down
	module.BringTheLowDown = module.bring_the_low_down
	module.ResetFrame = module.reset_frame
	module.SetScrollDirection = module.set_scroll_direction
	module.ScrollDirection = module.scroll_direction

	return
end) -- Prat:AddModuleToLoad
