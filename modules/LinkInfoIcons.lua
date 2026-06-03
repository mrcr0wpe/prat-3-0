--[[
    @File:      LinkInfoIcons.lua
    @Project:   Prat-3.0

    BR: Adiciona ícones e informações extras a hyperlinks no chat.
        - Ícones, nível e tipo em links de item
        - Ícones em links de spell e achievement
        - Ícone/classe/raça em links de jogadores
        - Integração com PLAYERINFO no pipeline do Prat
        - Uso de APIs modernas C_Item, C_Spell e C_PlayerInfo

    EN: Adds icons and extra information to chat hyperlinks.
        - Icons, level and type on item links
        - Icons on spell and achievement links
        - Class/race/icon information on player links
        - PLAYERINFO integration in Prat's pipeline
        - Uses modern C_Item, C_Spell and C_PlayerInfo APIs

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
		BR: Criação do módulo de ícones e informações em links
		EN: Creation of the link icons and information module
	------------------------------------------------]]--
	local module = Prat:NewModule("LinkInfoIcons")

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
			item = {
				icon = true,
				item_level = true,
				item_type = true,
			},
			spell = {
				icon = true,
			},
			achievement = {
				icon = true,
			},
			player = {
				race_label = false,
				class_icon = true,
				class_label = false,
			},
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

		profile.item = profile.item or {}
		profile.spell = profile.spell or {}
		profile.achievement = profile.achievement or {}
		profile.player = profile.player or {}

		if profile.item.itemLevel ~= nil and profile.item.item_level == nil then
			profile.item.item_level = profile.item.itemLevel
		end
		profile.item.itemLevel = nil

		if profile.item.itemType ~= nil and profile.item.item_type == nil then
			profile.item.item_type = profile.item.itemType
		end
		profile.item.itemType = nil

		if profile.player.raceLabel ~= nil and profile.player.race_label == nil then
			profile.player.race_label = profile.player.raceLabel
		end
		profile.player.raceLabel = nil

		if profile.player.classIcon ~= nil and profile.player.class_icon == nil then
			profile.player.class_icon = profile.player.classIcon
		end
		profile.player.classIcon = nil

		if profile.player.classLabel ~= nil and profile.player.class_label == nil then
			profile.player.class_label = profile.player.classLabel
		end
		profile.player.classLabel = nil

		if profile.item.icon == nil then
			profile.item.icon = true
		end
		if profile.item.item_level == nil then
			profile.item.item_level = true
		end
		if profile.item.item_type == nil then
			profile.item.item_type = true
		end
		if profile.spell.icon == nil then
			profile.spell.icon = true
		end
		if profile.achievement.icon == nil then
			profile.achievement.icon = true
		end
		if profile.player.race_label == nil then
			profile.player.race_label = false
		end
		if profile.player.class_icon == nil then
			profile.player.class_icon = true
		end
		if profile.player.class_label == nil then
			profile.player.class_label = false
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
		get = function(info)
			migrate_profile(module.db.profile)
			return module.db.profile[info[#info - 1]][info[#info]]
		end,
		set = function(info, value)
			migrate_profile(module.db.profile)
			module.db.profile[info[#info - 1]][info[#info]] = value
			if module.updateAll then
				module:updateAll()
			end
		end,
		args = {
			overview = {
				name = PL["overview_tab_name"],
				desc = PL["overview_tab_desc"],
				type = "group",
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

			item = {
				name = PL["item_group_name"],
				desc = PL["item_group_desc"],
				type = "group",
				order = 100,
				args = {
					item_help = {
						name = PL["item_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					icon = {
						name = PL["icon_name"],
						desc = PL["item_icon_desc"],
						type = "toggle",
						order = 20,
						width = 1.25,
					},

					item_type = {
						name = PL["item_type_name"],
						desc = PL["item_type_desc"],
						type = "toggle",
						order = 30,
						width = 1.25,
					},

					item_level = {
						name = PL["item_level_name"],
						desc = PL["item_level_desc"],
						type = "toggle",
						order = 40,
						width = 1.25,
					},
				},
			},

			spell = {
				name = PL["spell_group_name"],
				desc = PL["spell_group_desc"],
				type = "group",
				order = 200,
				args = {
					spell_help = {
						name = PL["spell_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					icon = {
						name = PL["icon_name"],
						desc = PL["spell_icon_desc"],
						type = "toggle",
						order = 20,
						width = 1.25,
					},
				},
			},

			achievement = {
				name = PL["achievement_group_name"],
				desc = PL["achievement_group_desc"],
				type = "group",
				order = 300,
				args = {
					achievement_help = {
						name = PL["achievement_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					icon = {
						name = PL["icon_name"],
						desc = PL["achievement_icon_desc"],
						type = "toggle",
						order = 20,
						width = 1.25,
					},
				},
			},

			player = {
				name = PL["player_group_name"],
				desc = PL["player_group_desc"],
				type = "group",
				order = 400,
				args = {
					player_help = {
						name = PL["player_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					class_icon = {
						name = PL["class_icon_name"],
						desc = PL["class_icon_desc"],
						type = "toggle",
						order = 20,
						width = 1.25,
					},

					class_label = {
						name = PL["class_label_name"],
						desc = PL["class_label_desc"],
						type = "toggle",
						order = 30,
						width = 1.25,
					},

					race_label = {
						name = PL["race_label_name"],
						desc = PL["race_label_desc"],
						type = "toggle",
						order = 40,
						width = 1.25,
					},
				},
			},
		},
	})

	--[[------------------------------------------------
		BR: Registra item PLAYERINFO antes do nome do jogador
		EN: Registers PLAYERINFO before the player name
	------------------------------------------------]]--
	Prat:SetModuleInit(module, function(self)
		migrate_profile(self.db.profile)
		Prat.RegisterMessageItem("PLAYERINFO", "PLAYER", "before")
	end)

	--[[------------------------------------------------
		BR: Registra processamento das mensagens do chat
		EN: Registers chat message processing
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db.profile)
		Prat.RegisterChatEvent(self, "Prat_FrameMessage")
	end

	--[[------------------------------------------------
		BR: Remove eventos registrados pelo módulo
		EN: Removes events registered by the module
	------------------------------------------------]]--
	function module:OnModuleDisable()
		Prat.UnregisterAllChatEvents(self)
	end

	--[[------------------------------------------------
		BR: Retorna atlas/ícone da classe do jogador
		EN: Returns the player's class atlas/icon
	------------------------------------------------]]--
	local function get_class_texture(class_filename)
		return CreateAtlasMarkup(GetClassAtlas(class_filename), 12, 12, 0, -2)
	end

	--[[------------------------------------------------
		BR: Adiciona classe/raça/ícone ao bloco PLAYERINFO
		EN: Adds class/race/icon information to PLAYERINFO
	------------------------------------------------]]--
	function module:Prat_FrameMessage(_, message)
		if message.GUID == nil or (_G.issecretvalue and _G.issecretvalue(message.GUID)) then
			return
		end

		local player_location = PlayerLocation:CreateFromGUID(message.GUID)

		if not player_location:IsValid() then
			return
		end

		local class_name, class_filename = C_PlayerInfo.GetClass(player_location)
		local race = C_PlayerInfo.GetRace(player_location)
		local race_info = race and C_CreatureInfo.GetRaceInfo(race)

		if self.db.profile.player.class_label and class_name ~= nil then
			message.PLAYERINFO = class_name .. " " .. message.PLAYERINFO
		end

		if self.db.profile.player.class_icon and class_filename ~= nil then
			message.PLAYERINFO = get_class_texture(class_filename) .. message.PLAYERINFO
		end

		if self.db.profile.player.race_label and race_info ~= nil then
			message.PLAYERINFO = race_info.raceName .. " " .. message.PLAYERINFO
		end
	end

	--[[------------------------------------------------
		BR: Atualiza mensagens após o Prat estar pronto
		EN: Updates messages after Prat is ready
	------------------------------------------------]]--
	function module:Prat_Ready()
		migrate_profile(self.db.profile)
		self:updateAll()
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Gera markup de textura para exibição no chat
		EN: Generates texture markup for chat display
	------------------------------------------------]]--
	local function get_texture(file)
		return CreateTextureMarkup(file, 64, 64, 12, 12, 0, 1, 0, 1, 0, -2)
	end

	--[[------------------------------------------------
		BR: Monta pattern genérico para hyperlinks do WoW
		EN: Builds generic pattern for WoW hyperlinks
	------------------------------------------------]]--
	local function get_pattern(link_type)
		return "|c.-|H" .. link_type .. ":.-|h.-|h|r"
	end

	--[[------------------------------------------------
		BR: Verifica se item pertence a categorias de equipamento
		EN: Checks whether item belongs to gear categories
	------------------------------------------------]]--
	local function is_gear(class_id)
		return class_id == Enum.ItemClass.Armor or class_id == Enum.ItemClass.Weapon or class_id == Enum.ItemClass.Profession
	end

	--[[------------------------------------------------
		BR: Insere ícone, nível e tipo em links de item
		EN: Inserts icon, level and type into item links
	------------------------------------------------]]--
	local function sub_in_item_info(link)
		local result = link

		local _, _, sub_type, equip_location, icon, class_id = C_Item.GetItemInfoInstant(link)

		local details = {}

		if module.db.profile.item.item_type and sub_type then
			table.insert(details, sub_type)
		end

		if module.db.profile.item.item_type and is_gear(class_id) and class_id ~= Enum.ItemClass.Weapon and equip_location and equip_location ~= "" then
			table.insert(details, _G[equip_location])
		end

		local level = C_Item.GetDetailedItemLevelInfo(link)
		if module.db.profile.item.item_level and is_gear(class_id) and level then
			table.insert(details, level)
		end

		if #details > 0 then
			result = link:gsub("|h%[(.-)%]|h", "|h%[%1 %(" .. table.concat(details, " ") .. "%)%]|h")
		end

		if module.db.profile.item.icon and icon then
			result = get_texture(icon) .. result
		end

		return result
	end

	--[[------------------------------------------------
		BR: Insere ícone em links de spell
		EN: Inserts icon into spell links
	------------------------------------------------]]--
	local function sub_in_spell_info(link)
		local spell_id = tonumber(link:match("Hspell:(%d+)"))
		local icon

		if C_Spell and C_Spell.GetSpellInfo then
			local info = C_Spell.GetSpellInfo(spell_id)
			icon = info and info.iconID
		else
			icon = select(3, GetSpellInfo(spell_id))
		end

		local result = link
		if module.db.profile.spell.icon and icon then
			result = get_texture(icon) .. result
		end

		return result
	end

	--[[------------------------------------------------
		BR: Insere ícone em links de achievement
		EN: Inserts icon into achievement links
	------------------------------------------------]]--
	local function sub_in_achievement_info(link)
		local achievement_id = tonumber(link:match("Hachievement:(%d+)"))
		local icon = select(10, GetAchievementInfo(achievement_id))

		local result = link
		if module.db.profile.achievement.icon and icon then
			result = get_texture(icon) .. result
		end

		return result
	end

	--[[------------------------------------------------
		BR: Registra pattern para enriquecer links de item
		EN: Registers pattern to enrich item links
	------------------------------------------------]]--
	Prat:RegisterPattern({
		pattern = get_pattern("item"),
		matchfunc = function(link)
			if module.db.profile.on then
				return Prat:RegisterMatch(sub_in_item_info(link))
			end
		end,
		type = "FRAME",
		priority = 43
	}, module.name)

	--[[------------------------------------------------
		BR: Registra pattern para enriquecer links de feitiço
		EN: Registers pattern to enrich spell links
	------------------------------------------------]]--
	Prat:RegisterPattern({
		pattern = get_pattern("spell"),
		matchfunc = function(link)
			if module.db.profile.on then
				return Prat:RegisterMatch(sub_in_spell_info(link))
			end
		end,
		type = "FRAME",
		priority = 43
	}, module.name)

	--[[------------------------------------------------
		BR: Registra pattern para enriquecer links de conquista
		EN: Registers pattern to enrich achievement links
	------------------------------------------------]]--
	Prat:RegisterPattern({
		pattern = get_pattern("achievement"),
		matchfunc = function(link)
			if module.db.profile.on then
				return sub_in_achievement_info(link)
			end
		end,
		type = "FRAME",
		priority = 41
	}, module.name)

	return
end) -- Prat:AddModuleToLoad
