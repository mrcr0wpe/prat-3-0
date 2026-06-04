--[[
    @File:      Timestamps.lua
    @Project:   Prat-3.0

    BR: Controle e inserção de timestamps nas janelas de chat.
        - Formatos de hora e data configuráveis
        - Horário local ou horário do servidor
        - Cor personalizada do timestamp
        - Timestamp antes ou depois do texto conforme alinhamento
        - Desativação do timestamp nativo da Blizzard
        - Hook seguro no AddMessage das janelas de chat

    EN: Timestamp control and insertion for chat windows.
        - Configurable time and date formats
        - Local time or server time
        - Custom timestamp color
        - Timestamp before or after text depending on alignment
        - Blizzard native timestamp disabling
        - Safe AddMessage hook on chat windows

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
		BR: Criação do módulo de timestamps com suporte a hooks
		EN: Creation of the timestamp module with hook support
	------------------------------------------------]]--
	local module = Prat:NewModule("Timestamps", "AceHook-3.0")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	module.pluginopts = {}

	--[[------------------------------------------------
		BR: Formatos de hora herdados do Chatter/Antiarc
		EN: Time formats inherited from Chatter/Antiarc
	------------------------------------------------]]--
	-- Chatter (Antiarc)
	local time_formats = {
		["%I:%M:%S %p"] = PL["time_format_12_hour_seconds_ampm"],
		["%I:%M:%S"] = PL["time_format_12_hour_seconds"],
		["%X"] = PL["time_format_24_hour_seconds"],
		["%I:%M %p"] = PL["time_format_12_hour_minutes_ampm"],
		["%I:%M"] = PL["time_format_12_hour_minutes"],
		["%H:%M"] = PL["time_format_24_hour_minutes"],
		["%M:%S"] = PL["time_format_minutes_seconds"],
	}
	--[[------------------------------------------------
		BR: Formatos opcionais de data
		EN: Optional date formats
	------------------------------------------------]]--
	local date_formats = {
		[""] = PL["date_format_none"],
		["%d/%m/%y"] = PL["date_format_day_month_year"],
		["%m/%d/%y"] = PL["date_format_month_day_year"],
		["%d/%m"] = PL["date_format_day_month"],
		["%m/%d"] = PL["date_format_month_day"],
	}

	local migrate_profile

	--[[------------------------------------------------
		BR: Monta uma pré-visualização dinâmica da marca de tempo
		EN: Builds a dynamic preview of the timestamp
	------------------------------------------------]]--
	local function build_timestamp_preview()
		local db = module.db.profile
		if migrate_profile then
			migrate_profile(db)
		end
		local code = db.time_format

		if db.date_format ~= "" then
			code = db.date_format .. " " .. code
		end

		local timestamp = db.format_prefix .. module:GetTime(code) .. db.format_suffix
		local space = db.space and " " or ""
		local preview = timestamp .. space .. PL["example_message"]

		if db.color_timestamp then
			preview = Prat.CLR:Colorize(db.timestamp_color, preview)
		else
			preview = "|cff66ccff" .. preview .. "|r"
		end

		return preview
	end

	--[[------------------------------------------------
		BR: Configuração dos valores padrão do módulo
		EN: Module default values configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			show = { ["*"] = true },
			time_format = "%X",
			date_format = "",
			format_prefix = "[",
			format_suffix = "]",
			["timestamp_color"] = {
				["b"] = 0.592156862745098,
				["g"] = 0.592156862745098,
				["r"] = 0.592156862745098,
				a = 1
			},
			color_timestamp = true,
			space = true,
			local_time = true,
		}
	})


	--[[------------------------------------------------
		BR: Migração leve de configurações antigas para snake_case
		EN: Light migration from old settings to snake_case
	------------------------------------------------]]--
	migrate_profile = function(db)
		if not db then
			return
		end

		local rename_map = {
			formatcode = "time_format",
			formatdate = "date_format",
			formatpre = "format_prefix",
			formatpost = "format_suffix",
			timestampcolor = "timestamp_color",
			colortimestamp = "color_timestamp",
			localtime = "local_time",
		}

		for old_key, new_key in pairs(rename_map) do
			if db[new_key] == nil and db[old_key] ~= nil then
				db[new_key] = db[old_key]
			end
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
		plugins = module.pluginopts,
		args = {
			overview = {
				type = "group",
				name = PL["overview_tab_name"],
				desc = PL["overview_tab_desc"],
				order = 10,
				args = {
					description = {
						type = "description",
						name = PL["full_description"],
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

			display_group = {
				type = "group",
				name = PL["display_tab_name"],
				desc = PL["display_tab_desc"],
				order = 20,
				args = {
					display_help = {
						type = "description",
						name = PL["display_help"],
						order = 10,
						width = "full",
					},

					spacer_after_display_help = {
						type = "description",
						name = "\n",
						order = 15,
						width = "full",
					},

					show = {
						name = PL["show_name"],
						desc = PL["show_desc"],
						type = "multiselect",
						order = 20,
						width = "full",
						values = Prat.HookedFrameList,
						get = "GetSubValue",
						set = "SetSubValue"
					},

					spacer_after_show = {
						type = "description",
						name = "\n",
						order = 25,
						width = "full",
					},

					local_time = {
						name = PL["local_time_name"],
						desc = PL["local_time_desc"],
						type = "toggle",
						order = 30,
						width = "full",
					},
				},
			},

			format_group = {
				type = "group",
				name = PL["format_tab_name"],
				desc = PL["format_tab_desc"],
				order = 30,
				args = {
					format_help = {
						type = "description",
						name = PL["format_help"],
						order = 10,
						width = "full",
					},

					spacer_after_format_help = {
						type = "description",
						name = "\n",
						order = 15,
						width = "full",
					},

					format_prefix = {
						name = PL["format_prefix_name"],
						desc = PL["format_prefix_desc"],
						type = "input",
						order = 20,
						width = 0.75,
						usage = "<string>",
					},

					format_suffix = {
						name = PL["format_suffix_name"],
						desc = PL["format_suffix_desc"],
						type = "input",
						order = 30,
						width = 0.75,
						usage = "<string>",
					},

					spacer_after_delimiters = {
						type = "description",
						name = "\n",
						order = 35,
						width = "full",
					},

					time_format = {
						name = PL["time_format_name"],
						desc = PL["time_format_desc"],
						type = "select",
						order = 40,
						width = 1.20,
						values = time_formats,
					},

					date_format = {
						name = PL["date_format_name"],
						desc = PL["date_format_desc"],
						type = "select",
						order = 50,
						width = 1.20,
						values = date_formats,
					},

					spacer_after_formats = {
						type = "description",
						name = "\n",
						order = 55,
						width = "full",
					},

					space = {
						name = PL["space_name"],
						desc = PL["space_desc"],
						type = "toggle",
						order = 60,
						width = "full",
					},

					spacer_before_example = {
						type = "description",
						name = "\n",
						order = 65,
						width = "full",
					},

					example_header = {
						type = "header",
						name = PL["example_header"],
						order = 70,
					},

					example_text = {
						type = "description",
						name = build_timestamp_preview,
						order = 80,
						width = "full",
					},
				},
			},

			appearance_group = {
				type = "group",
				name = PL["appearance_tab_name"],
				desc = PL["appearance_tab_desc"],
				order = 40,
				args = {
					appearance_help = {
						type = "description",
						name = PL["appearance_help"],
						order = 10,
						width = "full",
					},

					spacer_after_appearance_help = {
						type = "description",
						name = "\n",
						order = 15,
						width = "full",
					},

					color_timestamp = {
						name = PL["color_timestamp_name"],
						desc = PL["color_timestamp_desc"],
						type = "toggle",
						order = 20,
						width = "full",
						get = function(info)
							return info.handler:GetValue(info)
						end,
					},

					timestamp_color = {
						name = PL["timestamp_color_name"],
						desc = PL["timestamp_color_desc"],
						type = "color",
						order = 30,
						width = "full",
						get = "GetColorValue",
						set = "SetColorValue",
						disabled = "is_timestamp_plain",
					},
				},
			},
		},
	})

	--[[------------------------------------------------
		BR: Inicialização crítica: desativa timestamps nativos da Blizzard
		EN: Critical initialization: disables Blizzard native timestamps
	------------------------------------------------]]--
	Prat:SetModuleInit(module, function(self)
		-- Disable blizz timestamps if possible
		local proxy = {}
		if Prat.IsClassic then
			proxy.CHAT_TIMESTAMP_FORMAT = false -- nil would defer to __index
		else
			proxy.GetChatTimestampFormat = function()
			end
		end
		local CF_MEH_env = setmetatable(proxy, { __index = _G, __newindex = _G })
		if _G.ChatFrameMixin and _G.ChatFrameMixin.MessageEventHandler then
			setfenv(_G.ChatFrameMixin.MessageEventHandler, CF_MEH_env)
		elseif _G["ChatFrame_MessageEventHandler"] and issecurevariable("ChatFrame_MessageEventHandler") then
			setfenv(_G.ChatFrame_MessageEventHandler, CF_MEH_env)
		else
			self:Output("Could not install hook")
		end

		for _, v in pairs(Prat.HookedFrames) do
			self:SecureHook(v, "AddMessage")
		end
	end)

	--[[------------------------------------------------
		BR: Instala hooks AddMessage e registra atualização/remoção de frames
		EN: Installs AddMessage hooks and registers frame update/removal events
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db and self.db.profile)

		for _, v in pairs(Prat.HookedFrames) do
			if not self:IsHooked(v, "AddMessage") then
				self:SecureHook(v, "AddMessage")
			end
		end
		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_REMOVED)
	end

	--[[------------------------------------------------
		BR: Remove hooks AddMessage das janelas de chat
		EN: Removes AddMessage hooks from chat windows
	------------------------------------------------]]--
	function module:OnModuleDisable()
		for _, v in pairs(Prat.HookedFrames) do
			if self:IsHooked(v, "AddMessage") then
				self:Unhook(v, "AddMessage")
			end
		end
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Aplica hook em novos frames de chat
		EN: Applies hook to newly added chat frames
	------------------------------------------------]]--
	function module:Prat_FramesUpdated(_, _, chatFrame)
		if not self:IsHooked(chatFrame, "AddMessage") then
			self:SecureHook(chatFrame, "AddMessage")
		end
	end

	--[[------------------------------------------------
		BR: Remove hook de frames excluídos/removidos
		EN: Removes hook from deleted/removed frames
	------------------------------------------------]]--
	function module:Prat_FramesRemoved(_, _, chatFrame)
		if self:IsHooked(chatFrame, "AddMessage") then
			self:Unhook(chatFrame, "AddMessage")
		end
	end

	--[[------------------------------------------------
		BR: Funções centrais de inserção, cor e geração do timestamp
		EN: Core timestamp insertion, coloring and generation functions
	------------------------------------------------]]--
	--[[------------------------------------------------
		BR: Proteção contra duplicação/reprocessamento da mesma mensagem
		EN: Protection against duplicating/reprocessing the same message
	------------------------------------------------]]--
	local last_parsed
	--[[------------------------------------------------
		BR: Hook chamado após AddMessage para inserir timestamp no buffer
		EN: Hook called after AddMessage to insert timestamp into the buffer
	------------------------------------------------]]--
	function module:AddMessage(frame)
		if self.db.profile.on and self.db.profile.show and self.db.profile.show[frame:GetName()] and not Prat.loading then
			local entry = frame.historyBuffer:GetEntryAtIndex(1)
			if last_parsed == entry then
				return
			end
			entry.message = self:insert_timestamp(entry.message, frame)
			last_parsed = entry
		end
	end

	--[[------------------------------------------------
		BR: Verifica se o timestamp deve ser colorido
		EN: Checks whether the timestamp should be colored
	------------------------------------------------]]--
	function module:is_timestamp_plain()
		migrate_profile(self.db and self.db.profile)
		return not self.db.profile.color_timestamp
	end

	--[[------------------------------------------------
		BR: Aplica cor configurada ao timestamp quando permitido
		EN: Applies configured color to the timestamp when allowed
	------------------------------------------------]]--
	local function timestamp(text)
		if not module:is_timestamp_plain() then
			return Prat.CLR:Colorize(module.db.profile.timestamp_color, text)
		end
		return text
	end

	--[[------------------------------------------------
		BR: Mantém compatibilidade com opção antiga de timestamp simples
		EN: Keeps compatibility with the old plain timestamp option
	------------------------------------------------]]--
	function module:plain_timestamp_not_allowed()
		return false
	end

	--[[------------------------------------------------
		BR: Monta e injeta o timestamp antes/depois da mensagem
		EN: Builds and injects the timestamp before/after the message
	------------------------------------------------]]--
	function module:insert_timestamp(text, cf)
		if type(text) == "string" then
			local db = self.db.profile
			migrate_profile(db)
			local space = db.space
			local code = db.time_format
			if db.date_format ~= "" then
				code = db.date_format .. " " .. code
			end
			local fmt = db.format_prefix .. code .. db.format_suffix

			if cf and cf:GetJustifyH() == "RIGHT" then
				return text .. (space and " " or "") .. timestamp(self:GetTime(fmt))
			end
			return timestamp(self:GetTime(fmt)) .. (space and " " or "") .. text
		end

		return text
	end

	--[[------------------------------------------------
		BR: Retorna hora local ou do servidor conforme configuração
		EN: Returns local or server time according to configuration
	------------------------------------------------]]--
	function module:GetTime(format)
		migrate_profile(self.db and self.db.profile)
		if self.db.profile.local_time then
			return date(format)
		end
		return date(format, GetServerTime())
	end


	--[[------------------------------------------------
		BR: Aliases legados para compatibilidade com chamadas antigas
		EN: Legacy aliases for compatibility with older calls
	------------------------------------------------]]--
	module.IsTimestampPlain = module.is_timestamp_plain
	module.PlainTimestampNotAllowed = module.plain_timestamp_not_allowed
	module.InsertTimestamp = module.insert_timestamp

	return
end) -- Prat:AddModuleToLoad
