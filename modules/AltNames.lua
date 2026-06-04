--[[
    @File:      AltNames.lua
    @Project:   Prat-3.0

    BR: Sistema de associação entre personagens principais e alternativos.
        - Vinculação manual entre mains e alts
        - Importação via guilda, notas e addons externos
        - Exibição de mains/alts em tooltips e chat
        - Compatibilidade com PlayerNames e LibAlts
        - Processamento de padrões UTF-8 e nomes internacionais

    EN: Main and alternate character association system.
        - Manual linking between mains and alts
        - Importing from guild rosters, notes and external addons
        - Display of mains/alts in tooltips and chat
        - Compatibility with PlayerNames and LibAlts
        - UTF-8 pattern and international name processing

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local Prat = Prat

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo AltNames com suporte a hooks e eventos
		EN: Creation of the AltNames module with hook and event support
	------------------------------------------------]]--
	local module = Prat:NewModule("AltNames", "AceHook-3.0", "AceEvent-3.0")

	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL
	local alt_registry

	module.Alts = {}

	--[[------------------------------------------------
		BR: Configuração dos valores padrão do módulo
		EN: Module default values configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = false,
			quiet = false,
			class_color_source = 'no',
			alt_index = {},
			main_position = 'RIGHT',
			custom_color = { r = 0, g = 0, b = 0 },
			main_color = '97ff4c', -- fairly light bright green
			alt_color = 'ff6df2', -- fairly bright light purpley pinkish
			no_clobber = false,
			tooltip_show_main = false,
			tooltip_show_alts = false,
			use_alt_lib = true,
			auto_guild_alts = false,
		},
		realm = {
			alts = {},
		}
	})

	Prat:SetModuleInit(module,
		function(self)
			alt_registry = LibStub("LibAlts-1.0")

			if self.db.profile.alts then
				local alts = self.db.profile.alts
				self.db.profile.alts = nil
				for k, v in pairs(alts) do
					self.db.realm.alts[k] = self.db.realm.alts[k] or v
				end
			end

			-- Load shared Alts data
			for alt, main in pairs(self.db.realm.alts) do

				alt_registry:SetAlt(main, alt, "Prat")
			end

			-- define a popup to get the main name
			StaticPopupDialogs['MENUITEM_LINKALT'] = {
				-- text		= "Who would you like to set as the main character of %s?",
				text = 'Mainname',
				button1 = ACCEPT,
				button2 = CANCEL,
				hasEditBox = 1,
				maxLetters = 24,
				exclusive = 0,
				preferredIndex = 3,
				OnAccept = function(this, alt_name)
					local main_name = this.editBox:GetText()

					alt_name = alt_name or 'xxx'

					module:add_alt(string.format('%s %s', alt_name, main_name))
				end,
				OnShow = function(this)
					this.editBox:SetFocus();
				end,
				OnHide = function(this)
					if (this.editBox:IsShown()) then
						this.editBox:SetFocus();
					end
					_G[this:GetName() .. "EditBox"]:SetText("");
				end,
				EditBoxOnEnterPressed = function(this, alt_name)
					local parent = this:GetParent()
					local editBox = parent.editBox
					local main_name = editBox:GetText()

					alt_name = alt_name or 'xxx'

					module:add_alt(string.format('%s %s', alt_name, main_name))

					parent:Hide()
				end,
				EditBoxOnEscapePressed = function(this)

					this:GetParent():Hide();
				end,
				timeout = 0,
				whileDead = 1,
				hideOnEscape = 1
			}
			return
		end)

	Prat:SetModuleOptions(module, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		childGroups = "tab",
		args = {
			links = {
				name = PL["links_tab_name"],
				desc = PL["links_tab_desc"],
				type = "group",
				order = 100,
				args = {
					help = { type = "description", name = PL["links_help"], order = 10, width = "full" },
					manual_links = {
						name = PL["manual_links_group_name"],
						desc = PL["manual_links_group_desc"],
						type = "group",
						inline = true,
						order = 20,
						args = {
							link = {
								name = PL["link_name"],
								desc = PL["link_desc"],
								type = "input",
								usage = PL["link_usage"],
								order = 10,
								width = 1.70,
								set = function(info, arg_string) info.handler:add_alt(arg_string) end,
								get = false,
							},
							del = {
								name = PL["delete_name"],
								desc = PL["delete_desc"],
								type = "input",
								usage = PL["delete_usage"],
								order = 20,
								width = 1.70,
								set = function(info, alt_name) info.handler:delete_alt(alt_name) end,
								get = false,
								confirm = true,
							},
						},
					},
					behavior = {
						name = PL["link_options_group_name"],
						desc = PL["link_options_group_desc"],
						type = "group",
						inline = true,
						order = 30,
						args = {
							no_clobber = { name = PL["no_clobber_name"], desc = PL["no_clobber_desc"], type = "toggle", order = 10, width = 1.70 },
							quiet = { name = PL["quiet_name"], desc = PL["quiet_desc"], type = "toggle", order = 20, width = 1.30 },
						},
					},
				},
			},

			lookup = {
				name = PL["lookup_tab_name"],
				desc = PL["lookup_tab_desc"],
				type = "group",
				order = 200,
				args = {
					help = { type = "description", name = PL["lookup_help"], order = 10, width = "full" },
					tools = {
						name = PL["lookup_group_name"],
						desc = PL["lookup_group_desc"],
						type = "group",
						inline = true,
						order = 20,
						args = {
							find = {
								name = PL["find_name"], desc = PL["find_desc"], type = "input",
								usage = PL["find_usage"], order = 10, width = 1.70,
								set = function(info, q) info.handler:find_chars(q) end, get = false,
							},
							list_alts = {
								name = PL["list_alts_name"], desc = PL["list_alts_desc"], type = "input",
								usage = PL["list_alts_usage"], order = 20, width = 1.70,
								set = function(info, main_name) info.handler:list_alts(main_name) end, get = false,
							},
							list_all = { name = PL["list_all_name"], desc = PL["list_all_desc"], type = "execute", func = "list_all", order = 30, width = 1.30 },
						},
					},
				},
			},

			display = {
				name = PL["display_tab_name"],
				desc = PL["display_tab_desc"],
				type = "group",
				order = 300,
				args = {
					help = { type = "description", name = PL["display_help"], order = 10, width = "full" },
					chat = {
						name = PL["chat_display_group_name"],
						desc = PL["chat_display_group_desc"],
						type = "group",
						inline = true,
						order = 20,
						args = {
							main_position = {
								name = PL["main_position_name"], desc = PL["main_position_desc"], type = "select",
								order = 10, width = 1.35,
								get = function(info) return info.handler.db.profile.main_position end,
								set = function(info, value) info.handler:set_main_position(value) end,
								values = { LEFT = PL["position_left"], RIGHT = PL["position_right"], START = PL["position_start"] },
							},
							class_color_source = {
								name = PL["class_color_source_name"], desc = PL["class_color_source_desc"], type = "select",
								order = 20, width = 1.35,
								get = function(info) return info.handler.db.profile.class_color_source end,
								set = function(info, value) info.handler.db.profile.class_color_source = value end,
								values = { main = PL["class_color_source_main"], alt = PL["class_color_source_alt"], no = PL["class_color_source_no"] },
							},
							custom_color = {
								name = PL["custom_color_name"], desc = PL["custom_color_desc"], type = "color",
								order = 30, width = 1.25,
								get = function(info) return info.handler:get_color() end,
								set = function(info, nr, ng, nb, na) info.handler.db.profile.custom_color = { r = nr, g = ng, b = nb, a = na } end,
								disabled = function(info) return info.handler.db.profile.class_color_source ~= "no" end,
							},
						},
					},
					tooltips = {
						name = PL["tooltip_group_name"],
						desc = PL["tooltip_group_desc"],
						type = "group",
						inline = true,
						order = 30,
						args = {
							tooltip_show_main = {
								name = PL["tooltip_show_main_name"], desc = PL["tooltip_show_main_desc"], type = "toggle",
								order = 10, width = 1.60,
								get = function(info) return info.handler.db.profile.tooltip_show_main end,
								set = function(info)
									info.handler.db.profile.tooltip_show_main = not info.handler.db.profile.tooltip_show_main
									info.handler.alter_tooltip = info.handler.db.profile.tooltip_show_alts or info.handler.db.profile.tooltip_show_main
									info.handler:hook_tooltip()
								end,
							},
							tooltip_show_alts = {
								name = PL["tooltip_show_alts_name"], desc = PL["tooltip_show_alts_desc"], type = "toggle",
								order = 20, width = 1.70,
								get = function(info) return info.handler.db.profile.tooltip_show_alts end,
								set = function(info)
									info.handler.db.profile.tooltip_show_alts = not info.handler.db.profile.tooltip_show_alts
									info.handler.alter_tooltip = info.handler.db.profile.tooltip_show_alts or info.handler.db.profile.tooltip_show_main
									info.handler:hook_tooltip()
								end,
							},
						},
					},
				},
			},

			import = {
				name = PL["import_tab_name"],
				desc = PL["import_tab_desc"],
				type = "group",
				order = 400,
				args = {
					help = { type = "description", name = PL["import_help"], order = 10, width = "full" },
					options = {
						name = PL["import_options_group_name"],
						desc = PL["import_options_group_desc"],
						type = "group",
						inline = true,
						order = 20,
						args = {
							use_alt_lib = { name = PL["use_alt_lib_name"], desc = PL["use_alt_lib_desc"], type = "toggle", order = 10, width = 1.55 },
							auto_guild_alts = { name = PL["auto_guild_alts_name"], desc = PL["auto_guild_alts_desc"], type = "toggle", order = 20, width = 1.75 },
							no_clobber = { name = PL["no_clobber_name"], desc = PL["no_clobber_desc"], type = "toggle", order = 30, width = 1.75 },
						},
					},
					sources = {
						name = PL["import_buttons_group_name"],
						desc = PL["import_buttons_group_desc"],
						type = "group",
						inline = true,
						order = 30,
						args = {
							guild_import = { name = PL["guild_import_name"], desc = PL["guild_import_desc"], type = "execute", func = "import_guild_alts", confirm = true, order = 10, width = 1.35 },
							guild_greet_import = { name = PL["guild_greet_import_name"], desc = PL["guild_greet_import_desc"], type = "execute", func = "import_guild_greet_alts", confirm = true, order = 20, width = 1.35 },
							import_from_lok = { name = PL["import_from_lok_name"], desc = PL["import_from_lok_desc"], type = "execute", func = "import_from_lok", confirm = true, order = 30, width = 1.35 },
						},
					},
				},
			},

			maintenance = {
				name = PL["maintenance_tab_name"],
				desc = PL["maintenance_tab_desc"],
				type = "group",
				order = 500,
				args = {
					help = { type = "description", name = PL["maintenance_help"], order = 10, width = "full" },
					tools = {
						name = PL["maintenance_group_name"],
						desc = PL["maintenance_group_desc"],
						type = "group",
						inline = true,
						order = 20,
						args = {
							fix_alts = { name = PL["fix_alts_name"], desc = PL["fix_alts_desc"], type = "execute", func = "fix_alts", order = 10, width = 1.30 },
							clear_all = { name = PL["clear_all_name"], desc = PL["clear_all_desc"], type = "execute", func = "clear_all_alts", confirm = true, order = 20, width = 1.45 },
						},
					},
				},
			},
		}
	})

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		Module Event Functions
	------------------------------------------------]] --

	--[[------------------------------------------------
		BR: Ativação do módulo e registro dos eventos necessários
		EN: Module activation and required event registration
	------------------------------------------------]]--
	function module:OnModuleEnable()
		-- much code ripped off from the PlayerMenu code - thanks, and sorry!

		-- things to do when the module is enabled
		for alt_name, main_name in pairs(self.db.realm.alts) do
			self.Alts[alt_name] = main_name
		end

		-- PlayerNames class color source
		self.db.profile.class_color_source = self.db.profile.class_color_source or 'no'

		-- for caching a main's list of alts
		self.alt_lists = {}

		-- just register one area which can be used for anything
		-- (and only actually has one use at the moment)
		self.ALTNAMES = ""

		-- set position that main names are displayed in chat messages
		self:set_main_position(self.db.profile.main_position)

		-- register events
		Prat.RegisterChatEvent(self, "Prat_PreAddMessage")

		-- hook functions
		self.alter_tooltip = self.db.profile.tooltip_show_main or self.db.profile.tooltip_show_alts

		self:hook_tooltip()

		if not self.menus_added then
			self.menus_added = true
		end

		if self.db.profile.auto_guild_alts then
			self:auto_import_guild_alts(true)
		end

		alt_registry.RegisterCallback(self, "LibAlts_SetAlt", function(_, main, alt)
			self:add_alt(alt .. " " .. main, true)
		end)
		alt_registry.RegisterCallback(self, "LibAlts_RemoveAlt", function(_, _, alt)
			self:delete_alt(alt, true)
		end)
	end

	function module:auto_import_guild_alts(b)
		if b then
			self:RegisterEvent("GUILD_ROSTER_UPDATE", function()
				module:import_guild_alts(nil, true)
			end)
			C_GuildInfo.GuildRoster()
		else
			self:UnregisterEvent("GUILD_ROSTER_UPDATE")
		end
	end

	function module:OnValueChanged(info, b)
		local field = info[#info]
		if field == "auto_guild_alts" then
			self:auto_import_guild_alts(b)
		end
	end

	local function NOP()
		return
	end

	function module:hook_tooltip()
		if self.alter_tooltip then

			if Prat.IsClassic then
				self:SecureHookScript(GameTooltip, 'OnTooltipSetUnit', function()
					if self.alter_tooltip and not self.showing_tooltip then
						-- check who / what the tooltip's being displayed for
						local _, unitid = GameTooltip:GetUnit()
						self:modify_unit_tooltip(unitid)
					end
				end)
				self:SecureHookScript(GameTooltip, 'OnTooltipCleared', function()
					-- got to reset the flag so we know when to readd the lines
					self.showing_tooltip = false
				end)
			else
				TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip, data)
					if tooltip == GameTooltip and self.alter_tooltip then
						local unitid = UnitTokenFromGUID(data.guid)
						if (not issecretvalue or not issecretvalue(unitid)) and UnitIsPlayer(unitid) then
							self:modify_unit_tooltip(unitid)
						end
					end
				end)
			end

			module.hook_tooltip = NOP
		end
	end

	-- things to do when the module is disabled
	--[[------------------------------------------------
		BR: Desativação do módulo e limpeza de eventos/hooks
		EN: Module deactivation and event/hook cleanup
	------------------------------------------------]]--
	function module:OnModuleDisable()
		-- unregister events
		Prat.UnregisterAllChatEvents(self)

		alt_registry.UnregisterAllCallbacks(self)
	end

	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --

	function module:print(msg, print_anyway)
		-- make sure we've got a message
		if msg == nil then
			print_anyway = true
			msg = PL['error_blank_message']
		end

		local verbose = (not self.db.profile.quiet)

		if (not self.silent) and (verbose or print_anyway) then
			self:Output(msg)
		end
	end

	--[[ colo*u*ring and formatting ]] --

	local color_name = function(name, custom_color)
		return '|cff' .. (custom_color or 'ffffff') .. (name or "") .. '|r'
	end

	local color_main = function(main_name, main_color)
		main_name = main_name or ""
		main_color = main_color or module.db.profile.main_color or '8080ff'

		-- 1, 0.9, 0, 0.5, 0.5, 1

		return color_name(main_name, main_color)
	end

	local color_alt = function(alt_name, alt_color)
		alt_name = alt_name or ""
		alt_color = alt_color or module.db.profile.alt_color or 'ff8080'

		-- 1, 0.7, 0, 1, 0.5, 0.5

		return color_name(alt_name, alt_color)
	end

	function module:format_char_name(name)
		-- format character names as having uppercase first letter followed by all lowercase

		if name == nil then
			return ""
		end

		name = name:gsub('[%%%[%]":|%s]', '')
		name = name:gsub("'", '')

		name = name:lower()
		name = name:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1)

		return name
	end

	--[[ alt <-> main link management ]] --

	--[[------------------------------------------------
		BR: Cria ou atualiza o vínculo entre alt e personagem principal
		EN: Creates or updates the link between alt and main character
	------------------------------------------------]]--
	function module:add_alt(arg_string, event_generated)
		local main_name

		local alt_name = ""

		-- check we've been passed somethin
		if (arg_string == nil) or (arg_string == "") then
			self:print(PL['error_no_add_alt_argument'])
			return false
		end

		-- extract the alt's name and the main name to link to
		for k, v in arg_string:gmatch('(%S+)%s+(%S+)') do
			alt_name, main_name = k, v
		end

		-- check we've got a main name to link to
		if alt_name and not main_name then
			alt_name = arg_string
			self:print(string.format(PL["error_no_main_name_for_link"], color_alt(alt_name)), true)
			return false
		end

		-- clean up character names
		main_name = self:format_char_name(main_name)
		alt_name = self:format_char_name(alt_name)

		if self.Alts[alt_name] then
			local oldmain = self.Alts[alt_name]

			if oldmain == main_name then
				self:print(string.format(PL['warning_alt_already_linked'], color_alt(alt_name), color_main(main_name)))
				return false
			end

			if self.db.profile.no_clobber then
				self:print(string.format(PL['warning_existing_link_not_overwritten'],
					color_alt(alt_name), color_main(oldmain)))
				return false
			end

			self:print(string.format(PL['warning_alt_already_linked'], color_alt(alt_name), color_main(oldmain)))
		end

		-- add alt to list of alts -> mains
		self.Alts[alt_name] = main_name
		self.db.realm.alts[alt_name] = main_name

		-- make sure this character's list of alts is rebuilt next time it's needed
		if self.alt_lists[main_name] then
			self.alt_lists[main_name] = nil
		end

		-- publish this info globablly
		if not event_generated then
			alt_registry:SetAlt(main_name, alt_name, "Prat")
		end

		self:print(string.format(PL["msg_alt_linked"], color_alt(alt_name), color_main(main_name)))
	end

	--[[------------------------------------------------
		BR: Remove vínculos existentes de personagens alternativos
		EN: Removes existing alternate-character links
	------------------------------------------------]]--
	function module:delete_alt(alt_name, event_generated)
		local supplied_alt_name = alt_name

		alt_name = self:format_char_name(alt_name)

		if self.Alts[alt_name] then
			local main_name = self.Alts[alt_name]
			self.Alts[alt_name] = nil
			self.db.realm.alts[alt_name] = nil

			self:print(string.format(PL["msg_character_removed"], color_alt(supplied_alt_name)))

			-- make sure this character's list of alts is rebuilt next time it's needed
			if self.alt_lists[main_name] then
				self.alt_lists[main_name] = nil
			end

			if not event_generated then
				alt_registry:DeleteAlt(main_name, alt_name, "Prat")
			end

			return true
		end

		self:print(string.format(PL['msg_no_character_deleted'], color_alt(supplied_alt_name)))
	end

	function module:list_all()
		if not self.db.realm.alts and self.Alts then
			self:print(PL["msg_no_links_yet"], true)
			return false
		end

		local altcount = 0

		for alt_name, main_name in pairs(self.Alts) do
			altcount = altcount + 1
			self:print(string.format("alt: %s => main: %s", color_alt(alt_name), color_main(main_name)))
		end

		self:print(string.format(PL['msg_total_links'], altcount))
	end

	function module:find_chars(q)

		if not self.Alts then
			self:print(PL["msg_no_links_yet"], true)
			return false
		else
			local matches = {}
			local num_found = 0

			for alt_name, main_name in pairs(self.Alts) do
				local a = string.lower(alt_name)
				local m = string.lower(main_name)
				local pat = string.lower(q)

				-- self:print(string.format("matching against: alt_name:'%s', main_name:'%s', pat:'%s'", a, m, pat))

				if (a == pat) or (m == pat) or (a:find(pat)) or (m:find(pat)) then
					matches[alt_name] = main_name
					num_found = num_found + 1
				end
			end

			if num_found == 0 then
				self:print(string.format(PL['msg_no_matches_found'], '|cffffb200' .. q .. '|r'), true)
			else
				for alt_name, main_name in pairs(matches) do
					self:print(string.format(PL["msg_found_alt_main"], color_alt(alt_name), color_main(main_name)))
				end

				self:print(string.format(PL["msg_search_summary"], q, num_found))
			end

			return num_found
		end
	end

	function module:fix_alts()
		local fixedalts = {}

		for alt_name, main_name in pairs(self.db.realm.alts) do
			alt_name = self:format_char_name(alt_name)
			main_name = self:format_char_name(main_name)

			fixedalts[alt_name] = main_name
		end

		self.Alts = fixedalts
		self.db.realm.alts = fixedalts
	end

	function module:clear_all_alts()
		self.Alts = {}
		self.db.realm.alts = {}
		self.alt_lists = {}
	end

	local CLR = Prat.CLR

	function module:set_main_position(pos)
		-- which item to go after, depending on our position
		local msgitems = {
			RIGHT = 'Pp',
			LEFT = 'Ff',
			START = nil,
		}

		pos = pos or 'RIGHT'

		Prat.RegisterMessageItem('ALTNAMES', msgitems[pos])

		if pos == 'RIGHT' then
			self.pad_format = ' ' .. CLR:Colorize("ffffff", "(") .. "%s" .. CLR:Colorize("ffffff", ")")
		else
			self.pad_format = CLR:Colorize("ffffff", "(") .. "%s" .. CLR:Colorize("ffffff", ")") .. ' '
		end

		self.db.profile.main_position = pos
	end

	local function is_alt(name)
		local alt = module.Alts[name]
		if alt then
			return alt
		end

		if alt_registry and alt_registry:IsAlt(name) then
			return alt_registry:GetMain(name)
		end

		return
	end

	local player_names
	function module:Prat_PreAddMessage(_, message)
		local hex_color = CLR.NONE

		local main_name = message.PLAYERLINK

		local alt_name = is_alt(main_name) or is_alt(Ambiguate(main_name, "all"))

		if self.db.profile.on and alt_name then
			local pad_format = self.pad_format or ' (%s)'

			if self.db.profile.custom_color then
				if self.db.profile.class_color_source ~= 'no' then
					local char_name
					local color_type = self.db.profile.class_color_source

					if color_type == "alt" then
						char_name = main_name
					elseif color_type == "main" then
						char_name = alt_name
					else
						char_name = nil
						self.db.profile.class_color_source = 'no'
					end

					player_names = player_names or Prat:GetModule("PlayerNames")
					if char_name and player_names then
						local class = player_names:GetData(char_name)
						if class then
							local classColor = Prat.GetClassColor(class, true)
							if classColor then
								self.ALTNAMES = string.format(pad_format, classColor:WrapTextInColorCode(alt_name:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1)))
								message.ALTNAMES = self.ALTNAMES
								return
							end
						end
					end
				else
					hex_color = CLR:GetHexColor(self.db.profile.custom_color)
				end

				hex_color = hex_color or CLR:GetHexColor(self.db.profile.custom_color)
			end

			self.ALTNAMES = string.format(pad_format, CLR:Colorize(hex_color, alt_name:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1)))

			message.ALTNAMES = self.ALTNAMES
		end
	end

	function module:get_color()
		local col = self.db.profile.custom_color
		-- We check every component as old profiles from before 10.0 with a default
		-- custom_color had them all nil. In 10.0 SetVertexColor requires non-nil custom_color
		-- components, so we return a black.
		if not col or col.r == nil or col.g == nil or col.b == nil then
			return 0, 0, 0
		end
		return col.r, col.g, col.b, nil
	end

	function module:import_from_lok()
		if not LOKWhoIsWho_Config then
			self:print(PL['msg_lok_file_not_found'])
			return false
		end

		local server = GetRealmName()
		local lokalts = LOKWhoIsWho_Config[server]['players']

		if lokalts == nil then
			self:print(PL["msg_lok_data_not_found"])
			return false
		end

		local num_imported = 0

		for alt_name, main_name in pairs(lokalts) do
			self:add_alt(string.format("%s %s", alt_name, main_name))
			num_imported = num_imported + 1
		end

		self:print(string.format(PL["msg_lok_alts_imported"], num_imported))
	end

	function module:import_guild_greet_alts()
		--[[
		 imports guilds from a Guild Greet database, if present
	   ]]
		if not GLDG_Data then
			self:print(PL['msg_no_guild_greet_database'])
			return
		end

		local server_name = GetRealmName()
		local main_name, alt_name

		for k, v in pairs(GLDG_Data) do
			if string.match(k, server_name .. ' - %S+') then
				for name, player in pairs(v) do
					-- not sure whether this would be useful:
					-- if player['alt'] and player['alt'] ~= "" and not player['own'] then
					if player['alt'] and player['alt'] ~= "" then
						main_name = player['alt']
						alt_name = name

						self:add_alt(string.format('%s %s', alt_name, main_name))
					end
				end
			end
		end
	end

	function module:import_guild_alts(alt_rank, silently)
		if alt_rank == "" then
			alt_rank = nil
		end

		local total_members
		self.silent = silently

		total_members = GetNumGuildMembers(true)

		if total_members == 0 then
			self:print(PL['msg_not_in_guild'])
			return
		end

		-- build a list of guild members to check guild notes against later
		local guild_members = {}

		for x = 1, total_members do
			local name = GetGuildRosterInfo(x)
			if name then
				--since GetGuildRosterInfo returns Playername-Realm we need to trim Realmname
				--later we can compare Playername with officer_note/public_note
				--nobody is typing Playername with realm into the notes
				local shortname, _ = strsplit("-", name, 2)
				guild_members[string.lower(shortname)] = shortname
			end
		end

		-- loop through members and check stuff for later
		local num_found = 0

		for x = 1, total_members do
			local main_name

			local name, rank, _, _, _, _, public_note, officer_note = GetGuildRosterInfo(x)

			-- yeah I know the vars should be pre-lc'ed and it's not as efficient as it could be below
			-- ... feel free to clean it up

			-- untested (is there a more convenient trim function available?):
			--[[
		   officer_note = gsub("^%s*", "", officer_note)
		   public_note = gsub("^%s*", "", public_note)
		   ]]

			officer_note = officer_note or ""
			public_note = public_note or ""
			rank = rank or ""
			officer_note = (officer_note):match(PL["pattern_possessive_alt_cleanup"]) or officer_note or ""
			public_note = (public_note):match(PL["pattern_possessive_alt_cleanup"]) or public_note or ""

			local clean_public_note = public_note:match(Prat.AnyNamePattern)
			local clean_officer_note = officer_note:match(Prat.AnyNamePattern)

			-- check for guild members with rank "alt" or "alts" or "officer alt" or "twink"
			if (rank:match(PL["pattern_rank_alts"]) or rank:match(PL["pattern_rank_twink"]) or (alt_rank and rank == alt_rank)) and (clean_public_note and
				guild_members[clean_public_note:lower()]) then
				-- self:print(string.format('found main_name name for member %s', name))
				main_name = clean_public_note
				-- check whether guild note is an exact match of a member's name
			elseif clean_public_note and guild_members[clean_public_note:lower()] then
				main_name = clean_public_note
			elseif clean_officer_note and guild_members[clean_officer_note:lower()] then
				main_name = clean_officer_note
			elseif officer_note:find(PL["pattern_note_possessive_alt"]) or public_note:find(PL["pattern_note_possessive_alt"]) then
				local temp_name = officer_note:match(PL["pattern_note_possessive_alt"]) or public_note:match(PL["pattern_note_possessive_alt"])
				if temp_name and guild_members[string.lower(temp_name)] then
					main_name = temp_name
				end
			elseif officer_note:find(PL["pattern_note_alt_of"]) or public_note:find(PL["pattern_note_alt_of"]) then
				local temp_name = officer_note:match(PL["pattern_note_alt_of"]) or public_note:match(PL["pattern_note_alt_of"])
				if temp_name and guild_members[string.lower(temp_name)] then
					main_name = temp_name
				end
			end

			-- set alt name if we've found their main name
			if main_name and main_name ~= "" then

				if main_name:lower() ~= name:lower() then
					num_found = num_found + 1
					self:add_alt(string.format('%s %s', name, main_name))
				end
			end
		end

		self:print(string.format(PL["msg_guild_alts_imported"], num_found))
		self.silent = nil
	end

	-- function for showing a list of alt names in the tooltip
	function module:get_alts(main_name)
		if self.db.profile.use_alt_lib then
			local alts = { alt_registry:GetAlts(main_name) }
			if #alts > 0 then
				return alts
			end

			return false
		end

		-- self.Alts = self.db.profile.alt_names

		-- check valid main_name is being passed and that we actually have a list of alts
		if not (main_name and self.Alts) then
			return false
		end

		-- format the character name
		main_name = self:format_char_name(main_name)

		-- check main_name wasn't just made of invalid characters
		if main_name == "" then
			return false
		end

		-- check we've not already built the list of alts for this character
		if self.alt_lists[main_name] then
			return self.alt_lists[main_name]
		end

		local alts = {}
		local allalts = self.Alts

		-- loop through list of alts and build alts table for given main_name
		for alt, tmpmain_name in pairs(allalts) do
			if main_name == tmpmain_name then
				table.insert(alts, alt)
			end
		end

		-- check there we've actually found some alts
		if #alts == 0 then
			return false
		end

		-- cache this list of alts
		self.alt_lists[main_name] = alts

		return alts
	end

	-- function for showing main names in the tooltip
	function module:get_main(alt_name)
		if self.db.profile.use_alt_lib then
			local main = alt_registry:GetMain(alt_name)
			if main then
				return self:format_char_name(main)
			end

			return false
		end

		-- self.Alts = self.db.profile.alt_names

		-- check for valid alt name being passed and that we actually have a list of alts
		if not alt_name and self.Alts then
			return false
		end

		-- format the character name
		alt_name = self:format_char_name(alt_name)

		-- check the alt name wasn't just made of invalid character
		if alt_name == "" then
			return false
		end

		-- check a main exists for the given alt name
		if not self.Alts[alt_name] then
			return false
		end

		return self.Alts[alt_name]
	end

	function module:nice_join(t, glue, glue_before_last)
		-- check we've got a table
		if type(t) ~= 'table' then
			return false
		end

		local list = {}
		local index = 1

		-- create a copy of the table with a numerical and no nested tables
		for _, v in pairs(t) do
			local vtype = type(v)
			local item = self:format_char_name(v)

			if vtype ~= 'string' then
				item = vtype
			end

			list[index] = item or vtype
			index = index + 1
		end

		-- make sure we have some items to join
		if #list == 0 then
			return ""
		end

		-- trying to join one item = that item
		if #list == 1 then
			return list[1]
		end

		-- defaults with which we will want wo woin no that's not going to work
		-- defaults
		glue = glue or ', '
		glue_before_last = glue_before_last or ', and '

		-- pop the last value off
		local last = table.remove(list) or "" -- shouldn't need the ' or ""'?

		-- standard way of joining a list of items together
		local str = table.concat(list, glue)

		-- return the previous list, but add the last value nicely
		return str .. glue_before_last .. last
	end

	-- displays all alts for a given character as a list rather than seperate matches
	function module:list_alts(main_name)
		if not main_name then
			return false
		end

		main_name = self:format_char_name(main_name)

		if main_name == "" then
			return false
		end

		local alts

		alts = self:get_alts(main_name)

		if not alts or (#alts == 0) then
			self:print(PL['msg_no_alts_for_character'] .. main_name)
			return
		else
			self:print(string.format(PL['msg_alts_found_for_character'], #alts, color_main(main_name), color_alt(self:nice_join(alts))))
			return #alts
		end
	end

	-- hooked function to show mains and alts if set in preferences
	function module:modify_unit_tooltip(unitid)
		-- check to see if it's a character
		if UnitIsPlayer(unitid) then
			-- create lines table for extra information that might be added
			local char_name = UnitName(unitid)

			local tooltip_altered

			-- check if the user wants the mainame name shown on alts' tooltips
			local main_name
			if self.db.profile.tooltip_show_main then
				main_name = self:get_main(char_name)

				if main_name then
					-- add the character's main name to the tooltip
					GameTooltip:AddDoubleLine(PL['label_main'] .. ' ', color_main(main_name), 1, 0.9, 0, 0.5, 0.5, 1)
					tooltip_altered = true
				end
			end

			-- check if the user wants a list of alts shown on mains' tooltips
			if self.db.profile.tooltip_show_alts then
				local alts = self:get_alts(char_name)
				if not alts and main_name then
					alts = self:get_alts(main_name)
				end

				if alts then
					-- build the string listing alts
					--					local altstr = self:nice_join(alts)

					-- add the list of alts to the tooltip
					GameTooltip:AddLine("|cffffc080" .. PL['label_alts'] .. "|r " .. color_alt(self:nice_join(alts)), 1, 0.5, 0.5, 1)
					tooltip_altered = true
				end
			end

			if tooltip_altered then
				GameTooltip:Show()
			end

			self.showing_tooltip = true
		end
	end


	--[[------------------------------------------------
		BR: Aliases legados preservados para compatibilidade interna/externa.
		EN: Legacy aliases preserved for internal/external compatibility.
	------------------------------------------------]]--
	module.AutoImportGuildAlts = module.auto_import_guild_alts
	module.HookTooltip = module.hook_tooltip
	module.formatCharName = module.format_char_name
	module.addAlt = module.add_alt
	module.delAlt = module.delete_alt
	module.listAll = module.list_all
	module.findChars = module.find_chars
	module.fixAlts = module.fix_alts
	module.clearAllAlts = module.clear_all_alts
	module.setMainPos = module.set_main_position
	module.getColour = module.get_color
	module.importFromLOK = module.import_from_lok
	module.importGGAlts = module.import_guild_greet_alts
	module.importGuildAlts = module.import_guild_alts
	module.getAlts = module.get_alts
	module.getMain = module.get_main
	module.nicejoin = module.nice_join
	module.listAlts = module.list_alts
	module.ModifyUnitTooltip = module.modify_unit_tooltip

	return
end) -- Prat:AddModuleToLoad
