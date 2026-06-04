	--[[
    @File:      CustomFilters.lua
    @Project:   Prat-3.0

    BR: Sistema avançado de filtros personalizados para chat.
        - Filtros inbound e outbound
        - Patterns configuráveis pelo usuário
        - Substituição, bloqueio, destaque e sons por filtro
        - Saída secundária via LibSink
        - Encaminhamento para canais/janelas
        - Suporte opcional a replacement como código Lua
        - Integração direta com o motor global de patterns do Prat

    EN: Advanced custom chat filter system.
        - Inbound and outbound filters
        - User-configurable patterns
        - Replacement, blocking, highlighting and sounds per filter
        - Secondary output through LibSink
        - Forwarding to channels/windows
        - Optional replacement as Lua code
        - Direct integration with Prat's global pattern engine

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
		BR: Criação do módulo de filtros customizados com saída via LibSink
		EN: Creation of the custom filter module with LibSink output
	------------------------------------------------]]--
	local module = Prat:NewModule("CustomFilters", "LibSink-2.0")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	local event_map = {
		CHAT_MSG_CHANNEL_LIST = true,
		CHAT_MSG_SAY = true,
		CHAT_MSG_GUILD = true,
		CHAT_MSG_WHISPER_INFORM = true,
		CHAT_MSG_WHISPER = true,
		CHAT_MSG_YELL = true,
		CHAT_MSG_PARTY = true,
		CHAT_MSG_PARTY_LEADER = true,
		CHAT_MSG_OFFICER = true,
		CHAT_MSG_RAID = true,
		CHAT_MSG_RAID_LEADER = true,
		CHAT_MSG_INSTANCE_CHAT = true,
		CHAT_MSG_INSTANCE_CHAT_LEADER = true,
	}

	--[[------------------------------------------------
		BR: Mapa dinâmico de tipos de chat usados nas opções de canal
		EN: Dynamic chat type map used by channel options
	------------------------------------------------]]--
	local event_types = {}
	local function get_types()
		for k, _ in pairs(ChatTypeGroup) do
			event_types[k] = _G["CHAT_MSG_" .. k]
		end
		for _, v in ipairs(Prat.GetChannelTable()) do
			event_types[v] = "Channel: " .. v
		end
		event_types.WHISPER_INFORM = CHAT_MSG_WHISPER_INFORM
		event_types.CHANNEL = CHANNEL
		return event_types
	end

	local function get_types_config()
		local types = get_types()

		local keys = {}
		for k in pairs(types) do
			table.insert(keys, k)
		end
		table.sort(keys, function(a, b)
			return strcmputf8i(types[a], types[b]) < 0
		end)

		local result = {}

		for index, k in ipairs(keys) do
			result[k] = {
				type = "toggle",
				name = types[k],
				desc = PL["channel_scope_desc"]:format(types[k], k),
				order = index,
			}
		end

		return result
	end

	local new_map = {}
	for event_name in pairs(event_map) do
		new_map[_G[event_name] or event_name] = _G[event_name] or event_name
	end
	event_map = new_map

	--[[------------------------------------------------
		BR: Configurações padrão aplicadas a novos filtros/patterns
		EN: Default settings applied to new filters/patterns
	------------------------------------------------]]--
	local pattern_defaults = {
		["*"] = {
			enabled = true,
			sink20OutputSink = "None",
			replacement_is_code = false,
			output_message_only = true,
			in_channels = {
				SYSTEM = true,
				SAY = true,
				EMOTE = true,
				YELL = true,
				WHISPER = true,
				WHISPER_INFORM = true,
				PARTY = true,
				RAID = true,
				RAID_LEADER = true,
				RAID_WARNING = true,
				INSTANCE_CHAT = true,
				INSTANCE_CHAT_LEADER = true,
				GUILD = true,
				GUILD_OFFICER = true,
				MONSTER_SAY = true,
				MONSTER_YELL = true,
				MONSTER_EMOTE = true,
				MONSTER_WHISPER = true,
				MONSTER_BOSS_EMOTE = true,
				MONSTER_BOSS_WHISPER = true,
				ERRORS = true,
				AFK = true,
				DND = true,
				IGNORED = true,
				BG_HORDE = true,
				BG_ALLIANCE = true,
				BG_NEUTRAL = true,
				COMBAT_XP_GAIN = true,
				COMBAT_HONOR_GAIN = true,
				COMBAT_FACTION_CHANGE = true,
				SKILL = true,
				MONEY = true,
				OPENING = true,
				TRADESKILLS = true,
				PET_INFO = true,
				COMBAT_MISC_INFO = true,
				ACHIEVEMENT = true,
				GUILD_ACHIEVEMENT = true,
				CHANNEL = true,
			}
		}
	}
	--[[------------------------------------------------
		BR: Configuração dos valores padrão do módulo
		EN: Module default values configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module, {
		profile = {
			on = false,
			inbound = pattern_defaults,
			outbound = pattern_defaults,
			output_channel = CHAT_MSG_SAY,
			output_channel_data = "",
			sink_options = {}
		}
	})


	--[[------------------------------------------------
		BR: Migra chaves antigas de profile/filtros para snake_case
		EN: Migrates old profile/filter keys to snake_case
	------------------------------------------------]]--
	local function migrate_filter_settings(settings)
		if not settings or type(settings) ~= "table" then
			return
		end

		if settings.outputmessageonly ~= nil and settings.output_message_only == nil then
			settings.output_message_only = settings.outputmessageonly
		end
		settings.outputmessageonly = nil

		if settings.inchannels ~= nil and settings.in_channels == nil then
			settings.in_channels = settings.inchannels
		end
		settings.inchannels = nil

		if settings.searchfor ~= nil and settings.search_for == nil then
			settings.search_for = settings.searchfor
		end
		settings.searchfor = nil

		if settings.replacewith ~= nil and settings.replace_with == nil then
			settings.replace_with = settings.replacewith
		end
		settings.replacewith = nil

		if settings.tosink ~= nil and settings.to_sink == nil then
			settings.to_sink = settings.tosink
		end
		settings.tosink = nil

		if settings.hilight ~= nil and settings.highlight == nil then
			settings.highlight = settings.hilight
		end
		settings.hilight = nil

		if settings.hilight_color ~= nil and settings.highlight_color == nil then
			settings.highlight_color = settings.hilight_color
		end
		settings.hilight_color = nil

		settings.in_channels = settings.in_channels or {}
		if settings.output_message_only == nil then
			settings.output_message_only = true
		end
	end

	local function migrate_profile(profile)
		if not profile then
			return
		end

		if profile.outputchannel ~= nil and profile.output_channel == nil then
			profile.output_channel = profile.outputchannel
		end
		profile.outputchannel = nil

		if profile.outputchanneldata ~= nil and profile.output_channel_data == nil then
			profile.output_channel_data = profile.outputchanneldata
		end
		profile.outputchanneldata = nil

		if profile.sinkoptions ~= nil and profile.sink_options == nil then
			profile.sink_options = profile.sinkoptions
		end
		profile.sinkoptions = nil

		profile.inbound = profile.inbound or {}
		profile.outbound = profile.outbound or {}
		profile.sink_options = profile.sink_options or {}

		for _, mode in ipairs({ "inbound", "outbound" }) do
			for _, settings in pairs(profile[mode]) do
				migrate_filter_settings(settings)
			end
		end
	end

	--[[------------------------------------------------
		BR: Estrutura dinâmica das abas de entrada/saída
		EN: Dynamic structure for inbound/outbound tabs
	------------------------------------------------]]--
	local mode_options = {
		mode = {
			inbound = {
				type = "group",
				name = PL["inbound_name"],
				desc = PL["inbound_desc"],
				args = {
					help = {
						type = "description",
						name = PL["inbound_help"],
						order = 1,
						width = "full",
					},
				}
			},
			outbound = {
				type = "group",
				name = PL["outbound_name"],
				desc = PL["outbound_desc"],
				args = {
					help = {
						type = "description",
						name = PL["outbound_help"],
						order = 1,
						width = "full",
					},
				}
			},
		}
	}

	--[[------------------------------------------------
		BR: Interface principal de configuração do módulo
		EN: Main module configuration interface
	------------------------------------------------]]--
	Prat:SetModuleOptions(module, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		plugins = mode_options,
		args = {
			description = {
				type = "description",
				name = PL["full_description"],
				order = 10,
				width = "full",
			},

			global_help = {
				type = "description",
				name = PL["global_help"],
				order = 100,
				width = "full",
			},
		}
	})

	--[[------------------------------------------------
		BR: Constrói opções dinâmicas de filtros por modo
		EN: Builds dynamic filter options per mode
	------------------------------------------------]]--
	function module:build_mode_options(mode, opts)
		migrate_profile(self.db.profile)

		local po = opts[mode].args
		local help = po.help
		wipe(po)
		po.help = help

		self[mode] = {}
		self[mode].validate = {}

		--    po.pathdr = {
		--        type = "header",
		--        name = PL["Pattern Options"],
		--        order = 80,
		--    }

		for k, v in pairs(self.db.profile[mode]) do
			self:add_pattern_options(po, v.name or k, mode, k)
			self[mode].validate[k] = v.name or k
		end

		--    po.opspc = {
		--        type = "header",
		--        order = 94,
		--    }

		po.management_header = {
			type = "header",
			name = PL["filter_management_header"],
			order = 10,
		}

		po.addpattern = {
			name = PL["add_pattern_name"],
			desc = PL["add_pattern_desc"],
			type = "input",
			usage = PL["string_usage"],
			order = 20,
			width = "full",
			get = false,
			set = "add_pattern"
		}

		po.removepattern = {
			name = PL["remove_pattern_name"],
			desc = PL["remove_pattern_desc"],
			type = "select",
			order = 30,
			width = "full",
			get = function()
				return ""
			end,
			set = "remove_pattern",
			values = self[mode].validate,
			disabled = function(info)
				return next(info.handler.db.profile[info[#info - 1]]) == nil
			end,
		}

		po.management_help = {
			type = "description",
			name = PL["filter_management_help"],
			order = 40,
			width = "full",
		}
	end

	--[[------------------------------------------------
		BR: Localiza modo e chave do filtro dentro do caminho AceConfig
		EN: Finds filter mode and key inside the AceConfig path
	------------------------------------------------]]--
	local function get_filter_path(info)
		local mode, key

		for i = 1, #info do
			if info[i] == "inbound" or info[i] == "outbound" then
				mode = info[i]
				key = info[i + 1]
				break
			end
		end

		return mode, key
	end

	--[[------------------------------------------------
		BR: Desativa opções de saída quando secondary output está desligado
		EN: Disables output options when secondary output is off
	------------------------------------------------]]--
	function module:disable_output_option(info)
		local mode, key = get_filter_path(info)

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return true
		end

		return not self.db.profile[mode][key].to_sink
	end

	--[[------------------------------------------------
		BR: Cria painel de opções para um filtro/pattern específico
		EN: Creates option panel for a specific filter/pattern
	------------------------------------------------]]--
	function module:add_pattern_options(o, pattern, mode, key)
		migrate_profile(self.db.profile)

		key = key or pattern
		o[key] = o[key] or {}
		local po = o[key]
		local settings = self.db.profile[mode][key]
		po.type = "group"
		po.name = pattern
		po.desc = pattern
		po.order = 90

		po.childGroups = "tab"

		po.args = {
			overview = {
				name = PL["overview_tab_name"],
				desc = PL["overview_tab_desc"],
				type = "group",
				order = 10,
				args = {
					help = {
						type = "description",
						name = PL["single_filter_help"],
						order = 1,
						width = "full",
					},

					identity_header = {
						type = "header",
						name = PL["identity_header"],
						order = 10,
					},

					name = {
						order = 20,
						type = "input",
						name = PL["filter_name_name"],
						desc = PL["filter_name_desc"],
						get = "get_pattern_value",
						set = "update_pattern_value",
					},

					enabled = {
						order = 30,
						type = "toggle",
						name = PL["enabled_name"],
						desc = PL["enabled_desc"],
						get = "get_pattern_value",
						set = "update_pattern_value",
					},

					quick_summary = {
						type = "description",
						name = PL["overview_help"],
						order = 40,
						width = "full",
					},
				},
			},

			pattern_group = {
				name = PL["pattern_tab_name"],
				desc = PL["pattern_group_desc"],
				type = "group",
				order = 20,
				args = {
					pattern_help = {
						type = "description",
						name = PL["pattern_help"],
						order = 1,
						width = "full",
					},

					search_for = {
						order = 10,
						type = "input",
						name = PL["search_pattern_name"],
						desc = PL["search_pattern_desc"],
						usage = PL["string_usage"],
						width = "full",
						get = "get_pattern_value",
						set = "update_pattern_value"
					},

					replace_with = {
						order = 20,
						type = "input",
						name = PL["replacement_text_name"],
						desc = PL["replacement_text_desc"],
						usage = PL["string_usage"],
						width = "full",
						get = "get_pattern_value",
						set = "update_pattern_value",
						disabled = "get_disable_replace",
					},

					replacement_is_code = {
						order = 30,
						type = "toggle",
						get = "get_pattern_value",
						set = "set_pattern_value",
						name = PL["replacement_is_code_name"],
						desc = PL["replacement_is_code_desc"],
					},

					replacement_help = {
						order = 40,
						type = "description",
						name = PL["replacement_help"],
						width = "full",
					},
				},
			},

			actions_group = {
				name = PL["actions_tab_name"],
				desc = PL["actions_group_desc"],
				type = "group",
				order = 30,
				args = {
					actions_help = {
						type = "description",
						name = PL["actions_help"],
						order = 1,
						width = "full",
					},

					block = {
						order = 10,
						type = "toggle",
						name = PL["block_message_name"],
						desc = PL["block_message_desc"],
						width = "full",
						get = "get_pattern_value",
						set = "set_pattern_value"
					},

					highlight = {
						order = 20,
						type = "toggle",
						name = PL["highlight_match_name"],
						desc = PL["highlight_match_desc"],
						width = "full",
						get = "get_pattern_value",
						set = "update_pattern_value",
						disabled = "get_block_message",
					},

					highlight_color = {
						order = 30,
						type = "color",
						name = PL["highlight_color_name"],
						desc = PL["highlight_color_desc"],
						get = "get_pattern_color_value",
						set = "set_pattern_color_value",
						disabled = "get_block_message",
						hidden = function(info)
							local mode, key = get_filter_path(info)

							if not mode or not key or not info.handler.db.profile[mode] or not info.handler.db.profile[mode][key] then
								return true
							end

							return not info.handler.db.profile[mode][key].highlight
						end,
					},

					sound = {
						order = 40,
						type = "select",
						name = PL["play_sound_name"],
						desc = PL["play_sound_desc"],
						dialogControl = 'LSM30_Sound',
						width = 1.20,
						get = "get_pattern_value",
						set = "set_pattern_value",
						values = AceGUIWidgetLSMlists.sound,
					},

					to_sink = {
						order = 50,
						type = "toggle",
						name = PL["secondary_output_name"],
						desc = PL["secondary_output_desc"],
						width = "full",
						get = "get_pattern_value",
						set = "set_pattern_value"
					},
				},
			},

			in_channels = {
				name = PL["channels_tab_name"],
				desc = PL["in_channels_desc"],
				type = "group",
				order = 40,
				args = {
					help = {
						type = "description",
						name = PL["channels_help"],
						order = 1,
						width = "full",
					},
					channels = {
						name = PL["channels_group_name"],
						desc = PL["in_channels_desc"],
						type = "group",
						inline = true,
						order = 10,
						args = get_types_config(),
						get = "get_channel_pattern_sub_value",
						set = "set_channel_pattern_sub_value",
					},
				},
			},
		}

		self.SetSinkStorage(settings, settings)

		po.args.secondary_output_group = {
			name = PL["secondary_output_tab_name"],
			desc = PL["secondary_output_group_desc"],
			type = "group",
			order = 50,
			hidden = function(info)
				local mode, key = get_filter_path(info)

				if not mode or not key or not info.handler.db.profile[mode] or not info.handler.db.profile[mode][key] then
					return true
				end

				return not info.handler.db.profile[mode][key].to_sink
			end,
			args = {
				output_help = {
					type = "description",
					name = PL["secondary_output_help"],
					order = 10,
					width = "full",
				},

				output_message_only = {
					type = "toggle",
					name = PL["output_message_only_name"],
					desc = PL["output_message_only_desc"],
					order = 20,
					width = "full",
					get = "get_pattern_value",
					set = "update_pattern_value",
				},
			},
		}

		po.args.output = self.GetSinkAce3OptionsDataTable(settings)
		po.args.output.name = PL["secondary_output_config_header"]
		po.args.output.inline = true
		po.args.output.order = 60
		po.args.output.hidden = function(info)
			local mode, key = get_filter_path(info)

			if not mode or not key or not info.handler.db.profile[mode] or not info.handler.db.profile[mode][key] then
				return true
			end

			return not info.handler.db.profile[mode][key].to_sink
		end
		po.args.output.disabled = "disable_output_option"
	end

	--[[------------------------------------------------
		BR: Utilitário de cor usado para destaque de mensagens
		EN: Color utility used for message highlighting
	------------------------------------------------]]--
	local CLR = Prat.CLR

	--[[------------------------------------------------
		BR: Núcleo do filtro: substitui, destaca, envia ao sink, toca som ou bloqueia
		EN: Filter core: replaces, highlights, sinks, plays sound or blocks
	------------------------------------------------]]--
	local function match(text, matchopts, mode)
		if (not matchopts) or (not matchopts.enabled) then
			return
		end

		local match_type
		if mode == "inbound" then
			match_type = "FRAME"
		else
			match_type = "OUTBOUND"
		end

		local text_out = text

		if mode == "inbound" then
			local chat_type = Prat.SplitMessage.CHATTYPE
			local type_option = matchopts.in_channels[chat_type]

			if Prat.SplitMessage.CHATTYPE == "CHANNEL" then
				local channel_option = matchopts.in_channels[Prat.SplitMessage.ORG.CHANNEL]

				if channel_option == false then
					return
				end
				if channel_option == nil and not type_option then
					return
				end
			else
				if not type_option then
					return
				end
			end
		end

		if matchopts.replace_with and matchopts.replace_with ~= matchopts.search_for then
			if matchopts.replacement_is_code then
				text_out = loadstring(matchopts.replace_with)(text)
			else
				text_out = text_out:gsub(matchopts.search_for, matchopts.replace_with)
			end
		end

		if matchopts.highlight then
			local hex_color = CLR:GetHexColor(matchopts.highlight_color)
			text_out = CLR:Colorize(hex_color, text_out)
		end

		if matchopts.sink20OutputSink then
			if mode == "inbound" then
				Prat.SplitMessage.CF_SINK_OUT = matchopts
			else
				Prat.SplitMessageOut.CF_SINK_OUT = matchopts
			end
		end

		if matchopts.to_sink then
			if mode == "inbound" then
				Prat.SplitMessage.CF_SINK = true
			else
				Prat.SplitMessageOut.CF_SINK = true
			end
		end

		if matchopts.sound then
			if mode == "inbound" then
				Prat.SplitMessage.CF_SOUND = matchopts.sound
			else
				Prat.SplitMessageOut.CF_SOUND = matchopts.sound
			end
		end

		if matchopts.block then
			if mode == "inbound" then
				Prat.SplitMessage.DONOTPROCESS = true
			else
				Prat.SplitMessageOut.DONOTPROCESS = true
			end
		end

		text_out = Prat:RegisterMatch(text_out, match_type)
		--  end

		return text_out
	end

	--[[------------------------------------------------
		BR: Registra pattern no motor global do Prat
		EN: Registers pattern in Prat's global engine
	------------------------------------------------]]--
	function module:register_pattern(matchopts, mode)
		migrate_filter_settings(matchopts)

		local match_type
		if mode == "inbound" then
			match_type = "FRAME"
		else
			match_type = "OUTBOUND"
		end
		local pattern_info = {
			pattern = matchopts.search_for,
			matchopts = matchopts,
			matchfunc = function(text)
				return match(text, matchopts, mode)
			end,
			type = match_type,
			deformat = matchopts.deformat,
			priority = 46
		}

		Prat:RegisterPattern(pattern_info, self.name)

		table.insert(self.module_patterns, pattern_info)
	end

	--[[------------------------------------------------
		BR: Remove pattern previamente registrado
		EN: Removes previously registered pattern
	------------------------------------------------]]--
	function module:unregister_pattern(matchopts)
		migrate_filter_settings(matchopts)

		local pattern_info
		for _, v in pairs(self.module_patterns) do
			if v.matchopts == matchopts then
				pattern_info = v
			end
		end

		if pattern_info == nil then
			return
		end

		if pattern_info.idx then
			Prat:UnregisterPattern(pattern_info.idx)
		end

		local idx
		for k, v in pairs(self.module_patterns) do
			if v == pattern_info then
				idx = k
			end
		end

		table.remove(self.module_patterns, idx)
	end

	--[[------------------------------------------------
		BR: Atualiza pattern registrado após mudança de configuração
		EN: Updates registered pattern after configuration changes
	------------------------------------------------]]--
	function module:update_pattern(matchopts)
		migrate_filter_settings(matchopts)

		local pattern_info
		for _, v in pairs(self.module_patterns) do
			if v.matchopts == matchopts then
				pattern_info = v
			end
		end

		if pattern_info == nil then
			return
		end

		local mode
		if pattern_info.type == "FRAME" then
			mode = "inbound"
		else
			mode = "outbound"
		end

		pattern_info.pattern = matchopts.search_for
		pattern_info.deformat = matchopts.deformat
		pattern_info.matchfunc = function(text)
			return match(text, matchopts, mode)
		end
	end

	--[[------------------------------------------------
		BR: Inicialização e ciclo de vida do módulo
		EN: Module initialization and lifecycle
	------------------------------------------------]]--

	--[[------------------------------------------------
		BR: Registra sink customizado e constrói opções dinâmicas iniciais
		EN: Registers custom sink and builds initial dynamic options
	------------------------------------------------]]--
	Prat:SetModuleInit(module,
		function(self)
			migrate_profile(self.db.profile)

			self:RegisterSink(PL.chatframesink_name,
				PL.chatframesink_name,
				PL.chatframesink_desc,
				"chatframe_sink",
				function()
					local keys = {}
					for k, v in pairs(Prat.HookedFrames) do
						if not v.isTemporary and (v:IsShown() or v.isDocked) then
							keys[#keys + 1] = v.name or k
						end
					end

					return keys
				end)

			local mode_options_table = mode_options.mode
			for k, _ in pairs(mode_options_table) do
				self:build_mode_options(k, mode_options_table)
			end

			self:SetSinkStorage(self.db.profile.sink_options)
			mode_options_table.output = self:GetSinkAce3OptionsDataTable()
			mode_options_table.output.inline = true
		end)

	--[[------------------------------------------------
		BR: Registra filtros ativos e eventos de pós-processamento
		EN: Registers active filters and post-processing events
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db.profile)

		self.module_patterns = {}
		self.modulePatterns = self.module_patterns -- Legacy runtime compatibility.
		local mode_options_table = mode_options.mode
		for mode, _ in pairs(mode_options_table) do
			if type(self.db.profile[mode]) == "table" then
				for _, patopts in pairs(self.db.profile[mode]) do
					if patopts.enabled then
						self:register_pattern(patopts, mode)
					end
				end
			end
		end

		Prat.RegisterChatEvent(self, Prat.Events.POST_ADDMESSAGE)
		Prat.RegisterChatEvent(self, Prat.Events.POST_ADDMESSAGE_BLOCKED, "Prat_PostAddMessage")
	end

	--[[------------------------------------------------
		BR: Remove eventos registrados e limpa patterns rastreados
		EN: Removes registered events and clears tracked patterns
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self.module_patterns = nil
		self.modulePatterns = nil
		Prat.UnregisterAllChatEvents(self)
	end

	--[[------------------------------------------------
		BR: Processa saída secundária e som após a mensagem entrar no chat
		EN: Processes secondary output and sound after message enters chat
	------------------------------------------------]]--
	function module:Prat_PostAddMessage(_, message, _, event, text, r, g, b)
		local uid = message.LINE_ID
		if uid and
			uid == self.last_event and
			self.last_event_type == event then
			return
		end

		self.last_event_type = event
		self.last_event = uid

		if message.CF_SINK or message.CF_SINK_OUT then
			local sink_output = message.CF_SINK_OUT or self
			if sink_output.output_message_only or sink_output.outputmessageonly then
				self.Pour(sink_output, message.MESSAGE, r, g, b)
			else
				self.Pour(sink_output, text, r, g, b)
			end
		end

		if message.CF_SOUND then
			Prat:PlaySound(message.CF_SOUND)
		end
	end

	--[[------------------------------------------------
		BR: Funções centrais de leitura, escrita e gerenciamento de filtros
		EN: Core filter reading, writing and management functions
	------------------------------------------------]]--

	--[[------------------------------------------------
		BR: Lê valor simples de configuração de pattern
		EN: Reads simple pattern configuration value
	------------------------------------------------]]--
	function module:get_pattern_value(info)
		local mode, key = get_filter_path(info)
		local field = info[#info]

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return nil
		end

		return self.db.profile[mode][key][field]
	end

	function module:update_pattern_value(info, v)
		local mode, key = get_filter_path(info)
		local field = info[#info]

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return
		end

		self.db.profile[mode][key][field] = v
		self:update_pattern(self.db.profile[mode][key])
	end

	function module:set_pattern_value(info, v)
		local mode, key = get_filter_path(info)
		local field = info[#info]

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return
		end

		self.db.profile[mode][key][field] = v
	end

	function module:get_pattern_sub_value(info, val)
		local mode, key = get_filter_path(info)
		local group = info[#info]

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return nil
		end

		return self.db.profile[mode][key][group] and self.db.profile[mode][key][group][val]
	end

	function module:set_pattern_sub_value(info, val, v)
		local mode, key = get_filter_path(info)
		local group = info[#info]

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return
		end

		self.db.profile[mode][key][group] = self.db.profile[mode][key][group] or {}
		self.db.profile[mode][key][group][val] = v
	end

	function module:get_channel_pattern_sub_value(info)
		local mode, key = get_filter_path(info)
		local channel = info[#info]

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return nil
		end

		local channels = self.db.profile[mode][key].in_channels

		if not channels then
			return nil
		end

		local v = channels[channel]

		if ChatTypeGroup[channel] or v ~= nil then
			return v
		end

		return channels["CHANNEL"]
	end

	function module:set_channel_pattern_sub_value(info, v)
		local mode, key = get_filter_path(info)
		local channel = info[#info]

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return
		end

		self.db.profile[mode][key].in_channels = self.db.profile[mode][key].in_channels or {}
		self.db.profile[mode][key].in_channels[channel] = v
	end

	function module:set_pattern_name(info, v)
		local mode, key = get_filter_path(info)
		local field = info[#info]

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return
		end

		self.db.profile[mode][key][field] = v
	end

	function module:get_pattern_color_value(info)
		local mode, key = get_filter_path(info)
		local field = info[#info]

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return 1, 1, 1, 1
		end

		local c = self.db.profile[mode][key][field]
		if c == nil then
			self.db.profile[mode][key][field] = { r = 1, g = 1, b = 1, a = 1 }
			c = self.db.profile[mode][key][field]
		end
		return c.r, c.g, c.b, c.a
	end

	function module:set_pattern_color_value(info, r, g, b, a)
		local mode, key = get_filter_path(info)
		local field = info[#info]

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return
		end

		self.db.profile[mode][key][field] = { r = r, g = g, b = b, a = a }
	end

	function module:get_pattern_search(info)
		return self:get_pattern_value(info)
	end

	function module:set_pattern_search(info, v)
		self:update_pattern_value(info, v)
	end

	function module:get_pattern_replace(info)
		return self:get_pattern_value(info)
	end

	function module:set_pattern_replace(info, v)
		self:update_pattern_value(info, v)
	end

	function module:get_pattern_highlight(p)
		return p.highlight
	end

	function module:set_pattern_highlight(p, v)
		p.highlight = v

		self:update_pattern(p)
	end

	function module:get_disable_replace(info)
		local mode, key = get_filter_path(info)

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return true
		end

		local p = self.db.profile[mode][key]
		return p.block or p.to_sink
	end

	function module:get_block_message(info)
		local mode, key = get_filter_path(info)

		if not mode or not key or not self.db.profile[mode] or not self.db.profile[mode][key] then
			return true
		end

		return self.db.profile[mode][key].block
	end

	function module:set_block_message(p, v)
		p.block = v
	end

	function module:get_sink_message(p)
		return p.to_sink
	end

	function module:set_sink_message(p, v)
		p.to_sink = v
	end

	function module:get_sound_message(p)
		return p.sound
	end

	function module:set_sound_message(p, v)
		p.sound = v

		Prat:PlaySound(v)
	end

	local white_color = { r = 1.0, b = 1.0, g = 1.0 }
	function module:get_pattern_highlight_color(p)
		local h = p.highlight_color or white_color
		return h.r or 1.0, h.g or 1.0, h.b or 1.0
	end

	function module:set_pattern_highlight_color(p, r, g, b)
		p.highlight_color = p.highlight_color or {}
		local h = p.highlight_color
		h.r, h.g, h.b = r, g, b

		self:update_pattern(p)
	end

	--[[------------------------------------------------
		BR: Adiciona novo filtro/pattern configurável
		EN: Adds a new configurable filter/pattern
	------------------------------------------------]]--
	function module:add_pattern(info, pattern)
		local mode = info[#info - 1]
		local p = self.db.profile[mode]

		for _, v in pairs(p) do
			if v.name == pattern then
				return
			end
		end

		self[mode].validate = self[mode].validate or {}
		local v = self[mode].validate

		local num = 0
		while rawget(p, "pat" .. num) ~= nil do
			num = num + 1
		end

		local key = "pat" .. num

		p[key] = p[key] or {}
		p[key].name = pattern
		p[key].search_for = pattern
		p[key].replace_with = "%1"

		v[key] = pattern

		local o = mode_options.mode[mode].args
		self:add_pattern_options(o, pattern, mode, key)

		self:register_pattern(p[key], mode)

		self:refresh_options()
	end

	--[[------------------------------------------------
		BR: Remove filtro/pattern configurável existente
		EN: Removes an existing configurable filter/pattern
	------------------------------------------------]]--
	function module:remove_pattern(info, pattern)
		local mode = info[#info - 1]
		local p = self.db.profile[mode]
		local key, name

		if type(pattern) == "number" then
			name = self[mode].validate[pattern]
		else
			name = pattern
		end

		for k, v in pairs(p) do
			if k == name then
				key = k
				break
			end

			if v.name == name then
				key = k
				break
			end
		end

		if key == nil then
			return
		end

		self:unregister_pattern(p[key])

		p[key] = nil

		mode_options.mode[mode].args = {}

		self:build_mode_options(mode, mode_options.mode)

		self:refresh_options()
	end

	--[[------------------------------------------------
		BR: Notifica AceConfig para atualizar a interface do Prat
		EN: Notifies AceConfig to refresh Prat's interface
	------------------------------------------------]]--
	function module:refresh_options()
		LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")
	end

	--[[------------------------------------------------
		BR: Saída secundária diretamente para uma janela de chat específica
		EN: Secondary output directly to a specific chat window
	------------------------------------------------]]--
	function module:chatframe_sink(source, text, r, g, b)
		local sink = LibStub("LibSink-2.0")
		local s = sink.storageForAddon[source]
		local name = s and s.sink20ScrollArea or ""

		for k, v in pairs(Prat.HookedFrames) do
			if k == name or v.name == name then
				v:AddMessage(text, r, g, b)
				return
			end
		end
	end


	--[[------------------------------------------------
		BR: Aliases legados para reduzir risco com chamadas antigas ou strings AceConfig antigas
		EN: Legacy aliases to reduce risk from older calls or old AceConfig strings
	------------------------------------------------]]--
	module.BuildModeOptions = module.build_mode_options
	module.AddPatternOptions = module.add_pattern_options
	module.DisableOutputOption = module.disable_output_option
	module.RegisterPattern = module.register_pattern
	module.UnregisterPattern = module.unregister_pattern
	module.UpdatePattern = module.update_pattern
	module.GetPatternValue = module.get_pattern_value
	module.UpdatePatternValue = module.update_pattern_value
	module.SetPatternValue = module.set_pattern_value
	module.GetPatternSubValue = module.get_pattern_sub_value
	module.SetPatternSubValue = module.set_pattern_sub_value
	module.GetChannelPatternSubValue = module.get_channel_pattern_sub_value
	module.SetChannelPatternSubValue = module.set_channel_pattern_sub_value
	module.SetPatternName = module.set_pattern_name
	module.GetPatternColorValue = module.get_pattern_color_value
	module.SetPatternColorValue = module.set_pattern_color_value
	module.GetPatternSearch = module.get_pattern_search
	module.SetPatternSearch = module.set_pattern_search
	module.GetPatternReplace = module.get_pattern_replace
	module.SetPatternReplace = module.set_pattern_replace
	module.GetPatternHilight = module.get_pattern_highlight
	module.SetPatternHilight = module.set_pattern_highlight
	module.GetPatternHilightClr = module.get_pattern_highlight_color
	module.SetPatternHilightClr = module.set_pattern_highlight_color
	module.GetDisableReplace = module.get_disable_replace
	module.GetBlockMessage = module.get_block_message
	module.SetBlockMessage = module.set_block_message
	module.GetSinkMessage = module.get_sink_message
	module.SetSinkMessage = module.set_sink_message
	module.GetSoundMessage = module.get_sound_message
	module.SetSoundMessage = module.set_sound_message
	module.AddPattern = module.add_pattern
	module.RemovePattern = module.remove_pattern
	module.RefreshOptions = module.refresh_options
	module.ChatframeSink = module.chatframe_sink

	return
end)
