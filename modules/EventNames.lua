--[[
    @File:      EventNames.lua
    @Project:   Prat-3.0

    BR: Exibição dos nomes técnicos dos eventos de chat.
        - Adiciona o nome do evento ao final da mensagem
        - Configuração por janela de chat
        - Opção para forçar processamento completo de eventos
        - Colorização baseada na cor original da mensagem
        - Alteração temporária do filtro global de eventos do Prat

    EN: Display of technical chat event names.
        - Adds the event name at the end of the message
        - Per-chat-window configuration
        - Option to force full event processing
        - Coloring based on the original message color
        - Temporary override of Prat's global event processing filter

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
		BR: Criação do módulo de exibição de nomes de eventos
		EN: Creation of the event name display module
	------------------------------------------------]]--
	local module = Prat:NewModule("EventNames")

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
			show = {},
			all_events = false,
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

		if profile.allevents ~= nil and profile.all_events == nil then
			profile.all_events = profile.allevents
		end
		profile.allevents = nil

		profile.show = profile.show or {}

		if profile.all_events == nil then
			profile.all_events = false
		end
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

			windows = {
				type = "group",
				name = PL["windows_tab_name"],
				desc = PL["windows_tab_desc"],
				order = 100,
				args = {
					windows_help = {
						type = "description",
						name = PL["windows_help"],
						order = 10,
						width = "full",
					},

					show = {
						name = PL["show_name"],
						desc = PL["show_desc"],
						type = "multiselect",
						values = Prat.HookedFrameList,
						order = 20,
						width = "full",
						get = "GetSubValue",
						set = "SetSubValue",
					},
				},
			},

			processing = {
				type = "group",
				name = PL["processing_tab_name"],
				desc = PL["processing_tab_desc"],
				order = 200,
				args = {
					processing_help = {
						type = "description",
						name = PL["processing_help"],
						order = 10,
						width = "full",
					},

					all_events = {
						name = PL["all_events_name"],
						desc = PL["all_events_desc"],
						type = "toggle",
						order = 20,
						width = 1.60,
					},
				},
			},
		}
	})

	--[[------------------------------------------------
		BR: Registra processamento antes da mensagem e aplica modo todos-eventos
		EN: Registers pre-message processing and applies all-events mode
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db.profile)

		Prat.RegisterChatEvent(self, "Prat_PreAddMessage", "Prat_PreAddMessage")
		self:set_all_events(self.db.profile.all_events)
	end

	--[[------------------------------------------------
		BR: Restaura filtro global de eventos e remove eventos registrados
		EN: Restores global event filter and removes registered events
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:set_all_events(false)
		Prat.UnregisterAllChatEvents(self)
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Reaplica processamento global quando opções mudam
		EN: Reapplies global processing when options change
	------------------------------------------------]]--
	function module:OnValueChanged()
		migrate_profile(self.db.profile)
		self:set_all_events(self.db.profile.all_events)
	end

	--[[------------------------------------------------
		BR: Callback que força o Prat a processar todos os eventos
		EN: Callback that forces Prat to process all events
	------------------------------------------------]]--
	local function force_full_event_processing()
		return Prat.EventProcessingType.Full
	end

	--[[------------------------------------------------
		BR: Substitui/restaura temporariamente o filtro global de eventos
		EN: Temporarily overrides/restores the global event filter
	------------------------------------------------]]--
	function module:set_all_events(all_events)
		if not all_events then
			Prat.EventIsProcessed = self.orig_event_is_processed or Prat.EventIsProcessed
			self.orig_event_is_processed = nil
			self.origEventIsProcessed = nil -- Legacy runtime compatibility.
		elseif not self.orig_event_is_processed then
			self.orig_event_is_processed = Prat.EventIsProcessed
			self.origEventIsProcessed = self.orig_event_is_processed -- Legacy runtime compatibility.
			Prat.EventIsProcessed = force_full_event_processing
		end
	end

	--[[------------------------------------------------
		BR: Colorização e montagem do sufixo com o nome do evento
		EN: Coloring and construction of the event-name suffix
	------------------------------------------------]]--
	do
		local CLR = Prat.CLR

		local function colorize_event_brackets(text)
			return CLR:Colorize("ffffff", text)
		end

		local function colorize_event_name(text, color)
			return CLR:Colorize(color, text)
		end

		local desaturated = 192 * 0.7 + 63

		--[[------------------------------------------------
			BR: Adiciona o nome do evento no pós-texto da mensagem
			EN: Adds the event name to the message post-text
		------------------------------------------------]]--
		function module:Prat_PreAddMessage(_, message, frame, event, _, r, g, b)
			if frame and self.db.profile.show[frame:GetName()] then
				local color = ("%02x%02x%02x"):format(
					(r or 1.0) * desaturated,
					(g or 1.0) * desaturated,
					(b or 1.0) * desaturated
				)

				message.POST = "  "
					.. colorize_event_brackets("(")
					.. colorize_event_name(tostring(event), color)
					.. colorize_event_brackets(")")
			end
		end
	end

	--[[------------------------------------------------
		BR: Aliases legados para reduzir risco com chamadas antigas
		EN: Legacy aliases to reduce risk from older calls
	------------------------------------------------]]--
	module.SetAllEvents = module.set_all_events

	return
end) -- Prat:AddModuleToLoad
