--[[
    @File:      PlayerNames.lua
    @Project:   Prat-3.0

    BR: Formatação, cache, coloração e autocomplete de nomes de jogadores.
        - Colore nomes por classe, aleatório ou sem cor adicional
        - Exibe nível, grupo, ícone de alvo e ícone de cliente BNet
        - Mantém cache de classes, níveis e subgrupos
        - Integra dados de amigos, guilda, grupo, raid, target, mouseover e WHO
        - Suporte a RealID/Battle.net
        - TabComplete de nomes conhecidos
        - Integração profunda com o pipeline visual do chat do Prat

    EN: Formatting, caching, coloring and autocomplete for player names.
        - Colors names by class, random or no extra color
        - Shows level, group, target icon and BNet client icon
        - Maintains cache for classes, levels and subgroups
        - Integrates friends, guild, group, raid, target, mouseover and WHO data
        - RealID/Battle.net support
        - Known player name TabComplete
        - Deep integration with Prat's visual chat pipeline

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
		BR: Criação do módulo com suporte a hooks, eventos e timers
		EN: Creation of the module with hook, event and timer support
	------------------------------------------------]]--
	local module = Prat:NewModule("PlayerNames", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
	local PL = module.PL

	module.Classes = {}
	module.Levels = {}
	module.Subgroups = {}

	local NOP = function()
		return
	end

	module.OnPlayerDataChanged = NOP

	--[[------------------------------------------------
		BR: Configuração dos valores padrão e armazenamento persistente
		EN: Default values and persistent storage configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		realm = {
			classes = {},
			levels = {}
		},
		profile = {
			on = true,
			brackets = "Square",
			tab_complete = true,
			tab_complete_limit = 20,
			tabcompletelimit = 20, -- Legacy compatibility for Mentions.
			level = true,
			level_color = "DIFFICULTY",
			subgroup = true,
			show_target_icon = false,
			keep = false,
			keep_lots = false,
			color_mode = "CLASS",
			real_id_color = "CLASS",
			real_id_name = false,
			color_everywhere = true,
			coloreverywhere = true, -- Legacy compatibility for PlayerNameGlobalPatterns.
			use_common_color = true,
			brackets_common_color = true,
			linkifycommon = true,
			bnet_client_icon = true,
			brackets_color = {
				r = 0.85,
				g = 0.85,
				b = 0.85,
				a = 1.0
			},
			use_who = false,
			color = {
				r = 0.65,
				g = 0.65,
				b = 0.65,
				a = 1.0
			},
		}
	})

	module.pluginopts = {}

	--[[------------------------------------------------
		BR: Sincroniza aliases legados usados por extensões antigas do PlayerNames.
		EN: Synchronizes legacy aliases used by older PlayerNames extensions.
	------------------------------------------------]]--
	local function sync_legacy_profile_aliases(profile)
		if not profile then
			return
		end

		profile.coloreverywhere = profile.color_everywhere
		profile.tabcompletelimit = profile.tab_complete_limit
	end

	--[[------------------------------------------------
		BR: Interface de configuração do módulo
		EN: Module configuration interface
	------------------------------------------------]]--
	Prat:SetModuleOptions(module, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		childGroups = "tab",
		args = {
			appearance = {
				type = "group",
				name = PL["appearance_tab_name"],
				desc = PL["appearance_tab_desc"],
				order = 100,
				args = {
					bracket_group = {
						type = "group",
						name = PL["bracket_group_name"],
						desc = PL["bracket_group_desc"],
						inline = true,
						order = 10,
						args = {
							brackets = {
								name = PL["brackets_name"],
								desc = PL["brackets_desc"],
								type = "select",
								order = 10,
								width = 1.25,
								values = {
									["Square"] = PL["brackets_square"],
									["Angled"] = PL["brackets_angled"],
									["None"] = PL["brackets_none"],
								},
							},

							bracket_spacer = {
								type = "description",
								name = " ",
								order = 15,
								width = 0.15,
							},

							brackets_common_color = {
								name = PL["brackets_common_color_name"],
								desc = PL["brackets_common_color_desc"],
								type = "toggle",
								order = 20,
								width = 1.20,
							},

							brackets_color = {
								name = PL["brackets_color_name"],
								desc = PL["brackets_color_desc"],
								type = "color",
								order = 30,
								width = 1.20,
								get = "GetColorValue",
								set = "SetColorValue",
								disabled = function(info)
									return not info.handler.db.profile.brackets_common_color
								end,
							},
						}
					},

					color_group = {
						type = "group",
						name = PL["color_group_name"],
						desc = PL["color_group_desc"],
						inline = true,
						order = 20,
						args = {
							color_mode = {
								name = PL["color_mode_name"],
								desc = PL["color_mode_desc"],
								type = "select",
								order = 10,
								width = 1.25,
								values = {
									["RANDOM"] = PL["color_random"],
									["CLASS"] = PL["color_class"],
									["NONE"] = PL["color_none"],
								},
							},

							color_spacer_a = {
								type = "description",
								name = " ",
								order = 15,
								width = 0.15,
							},

							level_color = {
								name = PL["level_color_name"],
								desc = PL["level_color_desc"],
								type = "select",
								order = 20,
								width = 1.25,
								values = {
									["PLAYER"] = PL["level_color_player"],
									["CHANNEL"] = PL["level_color_channel"],
									["DIFFICULTY"] = PL["level_color_difficulty"],
									["NONE"] = PL["level_color_none"],
								},
							},

							use_common_color = {
								name = PL["use_common_color_name"],
								desc = PL["use_common_color_desc"],
								type = "toggle",
								order = 30,
								width = "full",
							},

							color = {
								name = PL["unknown_color_name"],
								desc = PL["unknown_color_desc"],
								type = "color",
								order = 40,
								width = "full",
								get = "GetColorValue",
								set = "SetColorValue",
								disabled = function(info)
									return not info.handler.db.profile.use_common_color
								end,
							},

							color_everywhere_spacer = {
								type = "description",
								name = " ",
								order = 45,
								width = "full",
							},

							color_everywhere = {
								name = PL["color_everywhere_name"],
								desc = PL["color_everywhere_desc"],
								type = "toggle",
								order = 50,
								width = "full",
							},
						}
					},
				}
			},

			information = {
				type = "group",
				name = PL["information_tab_name"],
				desc = PL["information_tab_desc"],
				order = 200,
				args = {
					extra_info_group = {
						type = "group",
						name = PL["extra_info_group_name"],
						desc = PL["extra_info_group_desc"],
						inline = true,
						order = 10,
						args = {
							level = {
								name = PL["level_name"],
								desc = PL["level_desc"],
								type = "toggle",
								order = 10,
								width = "full",
							},

							info_spacer_a = {
								type = "description",
								name = " ",
								order = 15,
								width = 0.15,
							},

							subgroup = {
								name = PL["subgroup_name"],
								desc = PL["subgroup_desc"],
								type = "toggle",
								order = 20,
								width = "full",
							},

							show_target_icon = {
								name = PL["show_target_icon_name"],
								desc = PL["show_target_icon_desc"],
								type = "toggle",
								order = 30,
								width = "full",
								hidden = Prat.IsRetail,
							},

							info_spacer_b = {
								type = "description",
								name = " ",
								order = 35,
								width = 0.15,
							},

							bnet_client_icon = {
								name = PL["bnet_client_icon_name"],
								desc = PL["bnet_client_icon_desc"],
								type = "toggle",
								order = 40,
								width = "full",
							},
						}
					},
				}
			},

			battle_net = {
				type = "group",
				name = PL["battle_net_tab_name"],
				desc = PL["battle_net_tab_desc"],
				order = 300,
				args = {
					battle_net_group = {
						type = "group",
						name = PL["battle_net_group_name"],
						desc = PL["battle_net_group_desc"],
						inline = true,
						order = 10,
						args = {
							real_id_color = {
								name = PL["real_id_color_name"],
								desc = PL["real_id_color_desc"],
								type = "select",
								order = 10,
								width = 1.25,
								values = {
									["RANDOM"] = PL["color_random"],
									["CLASS"] = PL["color_class"],
									["NONE"] = PL["color_none"],
								},
							},

							battle_net_spacer = {
								type = "description",
								name = " ",
								order = 15,
								width = 0.15,
							},

							real_id_name = {
								name = PL["real_id_name_name"],
								desc = PL["real_id_name_desc"],
								type = "toggle",
								order = 20,
								width = 1.25,
							},
						}
					},
				}
			},

			autocomplete = {
				type = "group",
				name = PL["autocomplete_tab_name"],
				desc = PL["autocomplete_tab_desc"],
				order = 400,
				args = {
					autocomplete_group = {
						type = "group",
						name = PL["autocomplete_group_name"],
						desc = PL["autocomplete_group_desc"],
						inline = true,
						order = 10,
						args = {
							tab_complete = {
								name = PL["tab_complete_name"],
								desc = PL["tab_complete_desc"],
								type = "toggle",
								order = 10,
								width = 1.25,
								get = function(info)
									return info.handler.db.profile.tab_complete
								end,
								set = function(info, v)
									info.handler.db.profile.tab_complete = v
									info.handler:TabComplete(v)
								end
							},

							autocomplete_spacer = {
								type = "description",
								name = " ",
								order = 15,
								width = 0.15,
							},

							tab_complete_limit = {
								name = PL["tab_complete_limit_name"],
								desc = PL["tab_complete_limit_desc"],
								type = "range",
								order = 20,
								width = 1.25,
								min = 1,
								max = 100,
								step = 1,
							},
						}
					},
				}
			},

			cache = {
				type = "group",
				name = PL["cache_tab_name"],
				desc = PL["cache_tab_desc"],
				order = 500,
				args = {
					cache_group = {
						type = "group",
						name = PL["cache_group_name"],
						desc = PL["cache_group_desc"],
						inline = true,
						order = 10,
						args = {
							keep = {
								name = PL["keep_name"],
								desc = PL["keep_desc"],
								type = "toggle",
								order = 10,
								width = "full",
							},

							cache_spacer_a = {
								type = "description",
								name = " ",
								order = 15,
								width = 0.15,
							},

							keep_lots = {
								name = PL["keep_lots_name"],
								desc = PL["keep_lots_desc"],
								type = "toggle",
								order = 20,
								width = "full",
								disabled = function(info)
									return not info.handler.db.profile.keep
								end,
							},

							use_who = {
								name = PL["use_who_name"],
								desc = PL["use_who_desc"],
								type = "toggle",
								order = 30,
								width = "full",
								hidden = function()
									if LibStub:GetLibrary("LibWho-2.0", true) then
										return false
									end

									if C_AddOns.GetAddOnInfo("LibWho-2.0") then
										return false
									end

									return true
								end
							},

							cache_spacer_b = {
								type = "description",
								name = " ",
								order = 35,
								width = 0.15,
							},

							reset = {
								name = PL["reset_name"],
								desc = PL["reset_desc"],
								type = "execute",
								order = 40,
								width = 1.25,
								func = "reset_stored_data"
							},
						}
					},
				}
			},
		}
	})

	--[[------------------------------------------------
		BR: Reage a alterações de opções sensíveis em runtime
		EN: Reacts to sensitive option changes at runtime
	------------------------------------------------]]--
	function module:OnValueChanged(info, b)
		sync_legacy_profile_aliases(self.db and self.db.profile)

		local field = info[#info]
		if field == "use_who" then
			if b and not LibStub:GetLibrary("LibWho-2.0", true) then
				C_AddOns.LoadAddOn("LibWho-2.0")
			end
			self.wholib = b and LibStub:GetLibrary("LibWho-2.0", true)
			self:UpdateAll()
		elseif field == "color_everywhere" then
			self:OnPlayerDataChanged(b and UnitName("player") or nil)
		end
	end

	--[[------------------------------------------------
		BR: Registra eventos, itens visuais e inicializa caches
		EN: Registers events, visual items and initializes caches
	------------------------------------------------]]--
	function module:OnModuleEnable()
		sync_legacy_profile_aliases(self.db and self.db.profile)

		Prat.RegisterChatEvent(self, "Prat_FrameMessage")
		Prat.RegisterChatEvent(self, "Prat_Ready")

		Prat.RegisterMessageItem("PREPLAYERDELIM", "PLAYER", "before")
		Prat.RegisterMessageItem("POSTPLAYERDELIM", "Ss", "after")
		Prat.RegisterMessageItem("PLAYERTARGETICON", "Ss", "after")
		Prat.RegisterMessageItem("PLAYERLEVEL", "PREPLAYERDELIM", "before")
		Prat.RegisterMessageItem("PLAYERGROUP", "POSTPLAYERDELIM", "after")
		Prat.RegisterMessageItem("PLAYERCLIENTICON", "PLAYERLEVEL", "before")

		Prat.EnableProcessingForEvent("CHAT_MSG_GUILD_ACHIEVEMENT")
		Prat.EnableProcessingForEvent("CHAT_MSG_ACHIEVEMENT")

		self:RegisterEvent("FRIENDLIST_UPDATE", "UpdateFriends")
		self:RegisterEvent("GUILD_ROSTER_UPDATE")
		self:RegisterEvent("GROUP_ROSTER_UPDATE", "UpdateGroup")
		self:RegisterEvent("PLAYER_LEVEL_UP")
		self:RegisterEvent("PLAYER_TARGET_CHANGED", "UpdateTarget")
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "UpdateMouseOver")
		self:RegisterEvent("WHO_LIST_UPDATE", "UpdateWho")
		self:RegisterEvent("CHAT_MSG_SYSTEM", "UpdateWho")
		self:RegisterEvent("PLAYER_LEAVING_WORLD", "EmptyDataCache")

		if self.db.profile.use_who then
			if not LibStub:GetLibrary("LibWho-2.0", true) then
				C_AddOns.LoadAddOn("LibWho-2.0")
			end
			self.wholib = LibStub:GetLibrary("LibWho-2.0", true)
		end

		self:UpdatePlayer()
		self.NEEDS_INIT = true

		if IsInGuild() then
			C_GuildInfo.GuildRoster()
		end

		self:TabComplete(self.db.profile.tab_complete)

		self:CacheAppIcons()
	end

	--[[------------------------------------------------
		BR: Desativa autocomplete e remove eventos registrados
		EN: Disables autocomplete and removes registered events
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:TabComplete(false)
		self:UnregisterAllEvents()
		Prat.UnregisterAllChatEvents(self)
	end

	--[[------------------------------------------------
		BR: Atualiza todos os dados quando o Prat termina de inicializar
		EN: Updates all data when Prat finishes initializing
	------------------------------------------------]]--
	function module:Prat_Ready()
		self:UpdateAll()
	end

	local cache = {
		module.Levels,
		module.Classes,
		module.Subgroups
	}

	--[[------------------------------------------------
		BR: Limpa caches voláteis ao sair do mundo
		EN: Clears volatile caches when leaving the world
	------------------------------------------------]]--
	function module:EmptyDataCache()
		for _, v in pairs(cache) do
			wipe(v)
		end

		self:UpdatePlayer()
		self.NEEDS_INIT = true
		self:OnPlayerDataChanged()
	end

	--[[------------------------------------------------
	  Fill Functions
	------------------------------------------------]] --
	--[[------------------------------------------------
		BR: Funções auxiliares para dados Battle.net/RealID
		EN: Helper functions for Battle.net/RealID data
	------------------------------------------------]]--
	local function get_toon_info_by_bnet_id(bnetAccountID)
		if not bnetAccountID then
			return
		end

		local accountInfo = C_BattleNet.GetAccountInfoByID(bnetAccountID)
		if not accountInfo then
			return
		end

		return accountInfo.gameAccountInfo.characterName,
			accountInfo.gameAccountInfo.characterLevel,
			accountInfo.gameAccountInfo.className
	end

	local function get_bnet_client_by_id(bnetAccountID)
		if not bnetAccountID then
			return
		end

		local accountInfo = C_BattleNet.GetAccountInfoByID(bnetAccountID)
		if not accountInfo then
			return
		end

		return accountInfo.gameAccountInfo.clientProgram
	end

	--[[------------------------------------------------
		BR: Carrega ícones de clientes Battle.net conhecidos
		EN: Loads icons for known Battle.net clients
	------------------------------------------------]]--
	function module:CacheAppIcons()
		self.appIcons = {}

		-- List derived from old atlas containing client icons
		for _, client in ipairs({
			"App", -- B.net
			"WoW",
			"Hero", -- Heroes of the Storm
			"LAZR", -- Modern Warfare 2
			"OSI", -- Diablo Something
			"Pro", -- Overwatch
			"Overwatch-zhCN", -- Overwatch zhCN
			"RTRO",
			"ODIN", -- Modern Warfare
			"S1", -- Starcraft 1
			"WTCG", -- Hearthstone
			"ZEUS", -- Black Ops
			"FEN", -- Diablo 4
			"D3", -- Diablo 3
			"ANBS", -- Diablo Something
			"VIPR",
			"W3", -- Warcraft 3
			"WLBY",
			"GRY",
		}) do
			C_Texture.GetTitleIconTexture(client, 0, function(success, texture)
				if success then
					self.appIcons[client] = texture
				end
			end)
		end
	end

	--[[------------------------------------------------
	  Core Functions
	------------------------------------------------]] --
	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Atualiza todas as fontes conhecidas de dados de jogadores
		EN: Updates all known player data sources
	------------------------------------------------]]--
	function module:UpdateAll()
		self.NEEDS_INIT = nil
		self:UpdatePlayer()
		self:UpdateFriends()
		self:UpdateWho()
		if IsInGuild() then
			C_GuildInfo.GuildRoster()
		end
		if GetNumBattlefieldScores() > 0 then
			self:UpdateBG()
		else
			self:UpdateGroup()
		end
	end

	function module:UpdateGF()
		self:UpdateFriends()
		self:UpdateWho()
		if IsInGuild() then
			C_GuildInfo.GuildRoster()
		end
		if GetNumBattlefieldScores() > 0 then
			self:UpdateBG()
		else
			self:UpdateGroup()
		end
	end

	--[[------------------------------------------------
		BR: Atualiza dados do próprio jogador
		EN: Updates current player data
	------------------------------------------------]]--
	function module:UpdatePlayer()
		local PlayerClass = select(2, UnitClass("player"))
		local Name, Server = UnitName("player")
		self:addName(Name, Server, PlayerClass, UnitLevel("player"), nil, "PLAYER")
	end

	function module:PLAYER_LEVEL_UP(_, level)
		local PlayerClass = select(2, UnitClass("player"))
		local Name, Server = UnitName("player")
		self:addName(Name, Server, PlayerClass, level, nil, "PLAYER")
	end

	--[[------------------------------------------------
		BR: Atualiza cache usando lista de amigos
		EN: Updates cache using the friends list
	------------------------------------------------]]--
	function module:UpdateFriends()
		for i = 1, C_FriendList.GetNumFriends() do
			local info = C_FriendList.GetFriendInfoByIndex(i)
			self:addName(info.name, nil, info.className, info.level, nil, "FRIEND")
		end
	end

	--[[------------------------------------------------
		BR: Atualiza cache usando roster da guilda
		EN: Updates cache using the guild roster
	------------------------------------------------]]--
	function module:GUILD_ROSTER_UPDATE()
		for i = 1, GetNumGuildMembers() do
			local Name, _, _, Level, _, _, _, _, _, _, Class = GetGuildRosterInfo(i)
			if Name then
				local plr, svr = Name:match("([^%-]+)%-?(.*)")
				self:addName(plr, nil, Class, Level, nil, "GUILD")
				self:addName(plr, svr, Class, Level, nil, "GUILD")
			end
		end
	end

	function module:UpdateRaid()
		for k, _ in pairs(self.Subgroups) do
			self.Subgroups[k] = nil
		end

		for i = 1, GetNumGroupMembers() do
			local _, _, SubGroup, Level, _, Class = GetRaidRosterInfo(i)
			local Name, Server = UnitName("raid" .. i)
			self:addName(Name, Server, Class, Level, SubGroup, "RAID")
		end
	end

	function module:UpdateParty()
		for i = 1, GetNumSubgroupMembers() do
			local Unit = "party" .. i
			local _, Class = UnitClass(Unit)
			local Name, Server = UnitName(Unit)
			self:addName(Name, Server, Class, UnitLevel(Unit), nil, "PARTY")
		end
	end

	--[[------------------------------------------------
		BR: Atualiza cache de party ou raid
		EN: Updates party or raid cache
	------------------------------------------------]]--
	function module:UpdateGroup()
		if IsInRaid() then
			self:UpdateRaid()
		elseif IsInGroup() then
			self:UpdateParty()
		end
	end

	function module:UpdateTarget()
		if not UnitIsPlayer("target") or not UnitIsFriend("player", "target") then
			return
		end
		local Class = select(2, UnitClass("target"))
		local Name, Server = UnitName("target")
		self:addName(Name, Server, Class, UnitLevel("target"), nil, "TARGET")
	end

	function module:UpdateMouseOver()
		if not UnitIsPlayer("mouseover") or not UnitIsFriend("player", "mouseover") then
			return
		end
		local Class = select(2, UnitClass("mouseover"))
		local Name, Server = UnitName("mouseover")
		self:addName(Name, Server, Class, UnitLevel("mouseover"), nil, "MOUSE")
	end

	--[[------------------------------------------------
		BR: Atualiza cache usando resultados de /who quando disponível
		EN: Updates cache using /who results when available
	------------------------------------------------]]--
	function module:UpdateWho()
		if self.wholib then
			return
		end

		for i = 1, C_FriendList.GetNumWhoResults() do
			local info = C_FriendList.GetWhoInfo(i)
			self:addName(info.fullName, nil, info.classStr, info.level, nil, "WHO")
		end
	end

	function module:UpdateBG()
		if C_PvP and C_PvP.GetScoreInfo then
			for i = 1, GetNumBattlefieldScores() do
				local score = C_PvP.GetScoreInfo(i);

				if (not issecretvalue or not issecretvalue(score.name)) and score.name then
					local plr, svr = score.name:match("([^%-]+)%-?(.*)")
					self:addName(plr, nil, score.className, nil, nil, "BATTLEFIELD")
					self:addName(plr, svr, score.className, nil, nil, "BATTLEFIELD")
				end
			end
		else
			for i = 1, GetNumBattlefieldScores() do
				local name, _, _, _, _, _, _, _, class = GetBattlefieldScore(i);

				if (not issecretvalue or not issecretvalue(name)) and name then
					local plr, svr = name:match("([^%-]+)%-?(.*)")
					self:addName(plr, nil, class, nil, nil, "BATTLEFIELD")
					self:addName(plr, svr, class, nil, nil, "BATTLEFIELD")
				end
			end
		end
		self:UpdateGroup()
	end

	function module:reset_stored_data()
		self.db.realm.classes = {}
		self.db.realm.levels = {}

		self:EmptyDataCache(true)

		self:Output(PL["msg_stored_data_cleared"])
	end

	--
	-- Coloring Functions
	--
	local CLR = Prat.CLR
	function CLR:Bracket(text)
		return self:Colorize(module:GetBracketCLR(), text)
	end

	function CLR:Random(text, seed)
		return self:Colorize(module:GetRandomCLR(seed), text)
	end

	local colorFunc = GetQuestDifficultyColor or GetDifficultyColor
	function CLR:Level(text, level, name, class, mode)
		mode = mode or module.db.profile.level_color
		if mode and type(level) == "number" and level > 0 then
			if mode == "DIFFICULTY" then
				local diff = colorFunc(level)
				return self:Colorize(CLR:GetHexColor(CLR:Desaturate(diff)), text)
			elseif mode == "PLAYER" then
				return self:Player(text, name, class)
			end
		end

		return text
	end

	function CLR:Player(text, name, class)
		local mode = module.db.profile.color_mode

		if name then
			if class and mode == "CLASS" then
				local classColor = Prat.GetClassColor(class, true)
				if classColor then
					return classColor:WrapTextInColorCode(text)
				end
				return text
			elseif mode == "RANDOM" then
				return self:Colorize(module:GetRandomCLR(name), text)
			else
				return self:Colorize(module:GetCommonCLR(), text)
			end
		end
	end

	local servernames
	function module:addName(Name, Server, Class, Level, SubGroup, Source)
		if not Name then
			return
		end

		if issecretvalue and (issecretvalue(Name) or issecretvalue(Server)) then
			return
		end

		local nosave
		Source = Source or "UNKNOWN"

		-- Messy negations, but this says dont save data from
		-- sources other than guild or friends unless you enable
		-- the keep_lots option
		if Source ~= "GUILD" and Source ~= "FRIEND" and Source ~= "PLAYER" then
			nosave = not self.db.profile.keep_lots
		end

		if Server and Server:len() > 0 then
			nosave = true
			servernames = servernames or Prat:GetModule("ServerNames")

			if servernames then
				servernames:GetServerKey(Server)
			end
		end

		Name = Name .. (Server and Server:len() > 0 and ("-" .. Server) or "")

		local changed
		if Level and Level > 0 then
			self.Levels[Name:lower()] = Level
			if ((not nosave) and self.db.profile.keep) then
				self.db.realm.levels[Name:lower()] = Level
			else
				-- Update it if it exists
				if self.db.realm.levels[Name:lower()] then
					self.db.realm.levels[Name:lower()] = Level
				end
			end

			changed = true
		end
		if Class and Class ~= UNKNOWN then
			self.Classes[Name:lower()] = Class
			if ((not nosave) and self.db.profile.keep) then
				self.db.realm.classes[Name:lower()] = Class
			end

			changed = true
		end
		if SubGroup then
			module.Subgroups[Name:lower()] = SubGroup

			changed = true
		end

		if changed then
			self:OnPlayerDataChanged(Name)
		end
	end

	function module:getClass(player)
		return self.Classes[player:lower()] or self.db.realm.classes[player:lower()] or self.db.realm.classes[player]
	end

	function module:getLevel(player)
		return self.Levels[player:lower()] or self.db.realm.levels[player:lower()] or self.db.realm.levels[player]
	end

	function module:getSubgroup(player)
		return self.Subgroups[player:lower()]
	end

	function module:GetData(player)
		local class = self:getClass(player)
		local level = self:getLevel(player)

		if level == 0 then
			level = nil
		end
		if class == UNKNOWN then
			class = nil
		end

		if self.wholib and not (class and level) then
			local user = self.wholib:UserInfo(player, { timeout = 20 })

			if user then
				level = user.Level or level
				class = user.NoLocaleClass or user.Class or class
			end
		end
		return class, level, self:getSubgroup(player)
	end

	function module:FormatPlayer(message, Name, frame, class)
		if not Name or Name:len() == 0 then
			return
		end

		local storedclass, level, subgroup = self:GetData(Name, frame)
		if class == nil then
			class = storedclass
		end

		-- Add level information if needed
		if level and self.db.profile.level then
			message.PLAYERLEVEL = CLR:Level(tostring(level), level, Name, class)
			message.PREPLAYERDELIM = ":"
		end

		-- Add raid subgroup information if needed
		if subgroup and self.db.profile.subgroup and (GetNumGroupMembers() > 0) then
			message.POSTPLAYERDELIM = ":"
			message.PLAYERGROUP = subgroup
		end

		-- Add raid target icon
		if not Prat.IsRetail and self.db.profile.show_target_icon then
			local icon = UnitExists(Name) and GetRaidTargetIndex(Name)
			if icon then
				icon = ICON_LIST[icon]

				if icon and icon:len() > 0 then
					-- since you cant have icons in links end the link before the icon
					message.PLAYERTARGETICON = "|h" .. icon .. "0|t"
					message.Ll = ""
				end
			end
		end

		if message.PLAYERLINKDATA and (message.PLAYERLINKDATA:find("BN_") and message.PLAYER ~= UnitName("player")) then
			if self.db.profile.real_id_color == "CLASS" then
				local toonName, toonLevel, toonClass = get_toon_info_by_bnet_id(message.PRESENCE_ID)
				if toonName and self.db.profile.real_id_name then
					message.PLAYER = toonName
					if level and self.db.profile.level then
						message.PLAYERLEVEL = CLR:Level(tostring(toonLevel), tonumber(toonLevel), nil, nil, "DIFFICULTY")
						message.PREPLAYERDELIM = ":"
					end
				end

				local classColor = Prat.GetClassColor(toonClass, true)
				if classColor then
					message.PLAYER = classColor:WrapTextInColorCode(message.PLAYER)
				end
			elseif self.db.profile.real_id_color == "RANDOM" then
				message.PLAYER = CLR:Random(message.PLAYER, message.PLAYER:lower())
			end

			if self.db.profile.bnet_client_icon then
				local client = get_bnet_client_by_id(message.PRESENCE_ID)
				if client and self.appIcons[client] then
					message.PLAYERCLIENTICON = CreateTextureMarkup(self.appIcons[client], 12, 12, 12, 12, 0, 1, 0, 1) .. " "
				elseif client then
					C_Texture.GetTitleIconTexture(client, 0, function(success, texture)
						if success then
							self.appIcons[client] = texture
						end
					end)
				end
			end
		else
			-- Add the player name in the proper color
			message.PLAYER = CLR:Player(message.PLAYER, Name, class)
		end

		-- Add the correct bracket style and color
		if message.pP then
			local prof_brackets = self.db.profile.brackets
			if prof_brackets == "Angled" then
				message.pP = CLR:Bracket("<") .. message.pP
				message.Pp = message.Pp .. CLR:Bracket(">")
			elseif prof_brackets ~= "None" then
				message.pP = CLR:Bracket("[") .. message.pP
				message.Pp = message.Pp .. CLR:Bracket("]")
			end
		end
	end

	--
	-- Prat Event Implementation
	--
	local EVENTS_FOR_RECHECK = {
		["CHAT_MSG_GUILD"] = module.UpdateGF,
		["CHAT_MSG_INSTANCE_CHAT"] = module.UpdateBG,
		["CHAT_MSG_INSTANCE_CHAT_LEADER"] = module.UpdateBG,
		["CHAT_MSG_SYSTEM"] = module.UpdateGF,
	}

	local EVENTS_FOR_CACHE_GUID_DATA = {
		CHAT_MSG_PARTY = true,
		CHAT_MSG_PARTY_LEADER = true,
		CHAT_MSG_RAID = true,
		CHAT_MSG_RAID_WARNING = true,
		CHAT_MSG_RAID_LEADER = true,
		CHAT_MSG_INSTANCE_CHAT = true,
		CHAT_MSG_INSTANCE_CHAT_LEADER = true,
	}

	function module:Prat_FrameMessage(_, message, frame, event)
		if self.NEEDS_INIT then
			self:UpdateAll()
		end

		-- This name is used to lookup playerdata, not for display
		local Name = message.PLAYERLINK or ""
		message.Pp = ""
		message.pP = ""

		-- If there is no playerlink, then we have nothing to do
		if Name:len() == 0 then
			return
		end

		Name = Ambiguate(Name, "all")

		local _
		local class, level, subgroup = self:GetData(Name)

		if (class == nil) and message and message.ORG and message.ORG.GUID and message.ORG.GUID:len() > 0 and message.ORG.GUID ~= "0000000000000000" then
			_, class = GetPlayerInfoByGUID(message.ORG.GUID)

			if class ~= nil and EVENTS_FOR_CACHE_GUID_DATA[event] then
				self:addName(Name, message.SERVER, class, level, subgroup, "GUID")
			end
		end

		local fx = EVENTS_FOR_RECHECK[event]
		if fx ~= nil and (level == nil or level == 0) then
			fx(self)
		end

		self:FormatPlayer(message, Name, frame, class)
	end

	function module:GetBracketCLR()
		if not self.db.profile.brackets_common_color then
			return CLR.COLOR_NONE
		end

		return CLR:GetHexColor(self.db.profile.brackets_color)
	end

	function module:GetCommonCLR()
		if not self.db.profile.use_common_color then
			return CLR.COLOR_NONE
		end

		return CLR:GetHexColor(self.db.profile.color)
	end

	function module:GetRandomCLR(Name)
		local hash = 17
		for i = 1, string.len(Name) do
			hash = hash * 37 * string.byte(Name, i);
		end

		local r = math.floor(math.fmod(hash / 97, 255));
		local g = math.floor(math.fmod(hash / 17, 255));
		local b = math.floor(math.fmod(hash / 227, 255));

		if ((r * 299 + g * 587 + b * 114) / 1000) < 105 then
			r = math.abs(r - 255);
			g = math.abs(g - 255);
			b = math.abs(b - 255);
		end

		return string.format("%02x%02x%02x", r, g, b)
	end

	local AceTab = LibStub("AceTab-3.0", true)
	function module:TabComplete(enabled)
		if not enabled then
			if AceTab:IsTabCompletionRegistered(PL["tab_complete_name"]) then
				AceTab:UnregisterTabCompletion(PL["tab_complete_name"])
			end
			return
		end

		servernames = servernames or Prat:GetModule("ServerNames")

		if not AceTab:IsTabCompletionRegistered(PL["tab_complete_name"]) then
			AceTab:RegisterTabCompletion(
				PL["tab_complete_name"],
				nil,
				function(t)
					for name in pairs(self.Classes) do
						table.insert(t, name)
					end
				end,
				function(_, cands)
					local candcount = #cands
					if candcount <= self.db.profile.tab_complete_limit then
						local text
						for key, cand in pairs(cands) do
							if servernames then
								local plr, svr = key:match("([^%-]+)%-?(.*)")

								cand = CLR:Player(cand, plr, self:getClass(key))

								if svr then
									svr = servernames:FormatServer(nil, servernames:GetServerKey(svr))
									cand = cand .. (svr and ("-" .. svr) or "")
								end
							else
								cand = CLR:Player(cand, cand, self:getClass(cand))
							end

							text = text and (text .. ", " .. cand) or cand
						end
						return "   " .. text
					else
						return "   " .. PL["too_many_matches"]:format(candcount)
					end
				end,
				nil,
				function(name)
					return name:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1):match("^[^%-]+")
				end
			)
		end
	end

	return
end)
