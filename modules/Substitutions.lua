--[[
    @File:      Substitutions.lua
    @Project:   Prat-3.0

    BR: Sistema de substituições dinâmicas no chat.
        - Expansão de tokens digitados pelo usuário
        - Substituições padrão baseadas em jogador, alvo, mapa e status
        - Substituições definidas pelo usuário
        - Expansão em tempo real na editbox do chat

    EN: Dynamic chat substitution system.
        - Expansion of tokens typed by the user
        - Default substitutions based on player, target, map and status
        - User-defined substitutions
        - Real-time expansion in the chat editbox

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[ 
	BR: Este módulo foi desativado por baixa utilidade prática. Ele ainda existe no código para referência e possível reativação futura, mas não é carregado por padrão.

	EN: This module has been disabled due to low practical utility. It still exists in the code for reference and possible future reactivation, but it is not loaded by default.

	local ChatEdit_GetActiveWindow = _G.ChatEdit_GetActiveWindow or _G.ChatFrameUtil.GetActiveWindow
	local ChatFrame_OpenChat = _G.ChatFrame_OpenChat or _G.ChatFrameUtil.OpenChat

	Prat:AddModuleToLoad(function()
		local module = Prat:NewModule("Substitutions")
		local PL = module.PL

		Prat:SetModuleDefaults(module.name, {
			profile = {
				on = false,
			}
		})

		local patternPlugins = { patterns = {} }

		Prat:SetModuleOptions(module.name, {
			name = PL["Substitutions"],
			desc = PL["A module to provide basic chat substitutions."],
			type = 'group',
			plugins = patternPlugins,
			args = {}
		})

		-- ============================================================================
		-- BR: Converte qualquer valor para string antes de registrar no sistema do Prat.
		-- EN: Converts any value to string before registering in Prat's system.
		-- ============================================================================
		local function prat_match(text)
			text = tostring(text or "")   -- força string, evita erros de tipo
			if module.buildingMenu then
				return text
			end
			return Prat:RegisterMatch(text, "OUTBOUND")
		end

		-- ============================================================================
		-- BR: Retorna a subzona atual (ex: nome do local no minimapa).
		-- EN: Returns the current subzone (e.g., name shown on the minimap).
		-- ============================================================================
		local function Loc()
			return prat_match(GetMinimapZoneText())
		end

		-- ============================================================================
		-- BR: Retorna a zona atual (ex: continente/região).
		-- EN: Returns the current zone (e.g., continent/region).
		-- ============================================================================
		local function Zone()
			return prat_match(GetRealZoneText())
		end

		-- ============================================================================
		-- BR: Retorna as coordenadas X e Y atuais do jogador como "(X,Y)".
		-- EN: Returns the player's current X and Y coordinates as "(X,Y)".
		-- ============================================================================
		local function Pos()
			local x, y = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()
			local str = "(" .. math.floor((x * 100) + 0.5) .. "," .. math.floor((y * 100) + 0.5) .. ")"
			return prat_match(str)
		end

		-- ============================================================================
		-- BR: Retorna a coordenada Y atual do jogador.
		-- EN: Returns the player's current Y coordinate.
		-- ============================================================================
		local function Ypos()
			local _, y = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()
			y = tostring(math.floor((y * 100) + 0.5))
			return prat_match(y)
		end

		-- ============================================================================
		-- BR: Retorna a coordenada X atual do jogador.
		-- EN: Returns the player's current X coordinate.
		-- ============================================================================
		local function Xpos()
			local x = C_Map.GetPlayerMapPosition(C_Map.GetBestMapForUnit("player"), "player"):GetXY()
			x = tostring(math.floor((x * 100) + 0.5))
			return prat_match(x)
		end

		-- ============================================================================
		-- BR: Retorna a vida atual do jogador como string.
		-- EN: Returns the player's current health as a string.
		-- ============================================================================
		local function PlayerHP()
			return prat_match(tostring(UnitHealth("player")))
		end

		-- ============================================================================
		-- BR: Retorna a vida máxima do jogador como string.
		-- EN: Returns the player's maximum health as a string.
		-- ============================================================================
		local function PlayerMaxHP()
			return prat_match(tostring(UnitHealthMax("player")))
		end

		-- ============================================================================
		-- BR: Retorna o percentual de vida do jogador (0-100) como string.
		-- EN: Returns the player's health percentage (0-100) as a string.
		-- ============================================================================
		local function PlayerPercentHP()
			local health = UnitHealth("player")
			local maxHealth = UnitHealthMax("player")
			local percent = math.floor(100 * health / maxHealth)
			return prat_match(tostring(percent))
		end

		-- ============================================================================
		-- BR: Retorna o déficit de vida do jogador (vida máxima - vida atual) como string.
		-- EN: Returns the player's health deficit (max health - current health) as a string.
		-- ============================================================================
		local function PlayerHealthDeficit()
			return prat_match(tostring(UnitHealthMax("player") - UnitHealth("player")))
		end

		-- ============================================================================
		-- BR: Retorna a mana atual do jogador como string.
		-- EN: Returns the player's current mana as a string.
		-- ============================================================================
		local function PlayerCurrentMana()
			return prat_match(tostring(UnitPower("player")))
		end

		-- ============================================================================
		-- BR: Retorna a mana máxima do jogador como string.
		-- EN: Returns the player's maximum mana as a string.
		-- ============================================================================
		local function PlayerMaxMana()
			return prat_match(tostring(UnitPowerMax("player")))
		end

		-- ============================================================================
		-- BR: Retorna o percentual de mana do jogador (0-100) como string.
		-- EN: Returns the player's mana percentage (0-100) as a string.
		-- ============================================================================
		local function PlayerPercentMana()
			local mana = UnitPower("player")
			local maxMana = UnitPowerMax("player")
			local percent = math.floor(100 * mana / maxMana)
			return prat_match(tostring(percent))
		end

		-- ============================================================================
		-- BR: Retorna o déficit de mana do jogador (mana máxima - mana atual) como string.
		-- EN: Returns the player's mana deficit (max mana - current mana) as a string.
		-- ============================================================================
		local function PlayerManaDeficit()
			return prat_match(tostring(UnitPowerMax("player") - UnitPower("player")))
		end

		-- ============================================================================
		-- BR: Retorna o nome do jogador.
		-- EN: Returns the player's name.
		-- ============================================================================
		local function PlayerName()
			local p = GetUnitName("player") or ""
			return prat_match(p)
		end

		-- ============================================================================
		-- BR: Retorna o nível médio de item do jogador como string.
		-- EN: Returns the player's average item level as a string.
		-- ============================================================================
		local function PlayerAverageItemLevel()
			local avgItemLevel = GetAverageItemLevel()
			avgItemLevel = math.floor(avgItemLevel)
			return prat_match(tostring(avgItemLevel))
		end

		-- ============================================================================
		-- BR: Retorna o nome do alvo atual (ou "<semalvo>").
		-- EN: Returns the current target's name (or "<notarget>").
		-- ============================================================================
		local function TargetName()
			local t = PL['<notarget>']
			if UnitExists("target") then
				t = UnitName("target")
			end
			return prat_match(t)
		end

		-- ============================================================================
		-- BR: Retorna o nome do alvo do alvo (ou "<semalvo>").
		-- EN: Returns the target's target name (or "<notarget>").
		-- ============================================================================
		local function TargetTargetName()
			local t = PL['<notarget>']
			if UnitExists("targettarget") then
				t = UnitName("targettarget")
			end
			return prat_match(t)
		end

		-- ============================================================================
		-- BR: Retorna o nome do alvo sob o mouse (ou "<semalvo>").
		-- EN: Returns the name of the mouseover target (or "<notarget>").
		-- ============================================================================
		local function MouseoverName()
			local t = PL['<notarget>']
			if UnitExists("mouseover") then
				t = UnitName("mouseover")
			end
			return prat_match(t)
		end

		-- ============================================================================
		-- BR: Retorna a classe do alvo (ou "<semalvo>").
		-- EN: Returns the target's class (or "<notarget>").
		-- ============================================================================
		local function TargetClass()
			local class = PL["<notarget>"]
			if UnitExists("target") then
				class = UnitClass("target")
			end
			return prat_match(class)
		end

		-- ============================================================================
		-- BR: Retorna a raça do alvo (ou "<semalvo>").
		-- EN: Returns the target's race (or "<notarget>").
		-- ============================================================================
		local function TargetRace()
			local race = PL["<notarget>"]
			if UnitExists("target") then
				if UnitIsPlayer("target") then
					race = UnitRace("target")
				else
					race = UnitCreatureFamily("target")
					if not race then
						race = UnitCreatureType("target")
					end
				end
			end
			return prat_match(race)
		end

		-- ============================================================================
		-- BR: Retorna o sexo do alvo (masculino/feminino/desconhecido) ou "<semalvo>".
		-- EN: Returns the target's gender (male/female/unknown) or "<notarget>".
		-- ============================================================================
		local function TargetGender()
			local sex = PL["<notarget>"]
			if UnitExists("target") then
				local s = UnitSex("target")
				if (s == 2) then
					sex = PL["male"]
				elseif (s == 3) then
					sex = PL["female"]
				else
					sex = PL["unknown sex"]
				end
			end
			return prat_match(sex)
		end

		-- ============================================================================
		-- BR: Retorna o nível do alvo como string (ou "<semalvo>").
		-- EN: Returns the target's level as a string (or "<notarget>").
		-- ============================================================================
		local function TargetLevel()
			local level = PL["<notarget>"]
			if UnitExists("target") then
				level = tostring(UnitLevel("target"))
			end
			return prat_match(level)
		end

		-- ============================================================================
		-- BR: Retorna a vida atual do alvo como string (ou "<semalvo>").
		-- EN: Returns the target's current health as a string (or "<notarget>").
		-- ============================================================================
		local function TargetHealth()
			local str = PL["<notarget>"]
			if UnitExists("target") then
				str = tostring(UnitHealth("target"))
			end
			return prat_match(str)
		end

		-- ============================================================================
		-- BR: Retorna o déficit de vida do alvo como string (ou "<semalvo>").
		-- EN: Returns the target's health deficit as a string (or "<notarget>").
		-- ============================================================================
		local function TargetHealthDeficit()
			local str = PL["<notarget>"]
			if UnitExists("target") then
				str = tostring(UnitHealthMax("target") - UnitHealth("target"))
			end
			return prat_match(str)
		end

		-- ============================================================================
		-- BR: Retorna o déficit de mana do alvo como string (ou "<semalvo>").
		-- EN: Returns the target's mana deficit as a string (or "<notarget>").
		-- ============================================================================
		local function TargetManaDeficit()
			local str = PL["<notarget>"]
			if UnitExists("target") then
				str = tostring(UnitPowerMax("target") - UnitPower("target"))
			end
			return prat_match(str)
		end

		-- ============================================================================
		-- BR: Retorna o percentual de vida do alvo como string (ou "<semalvo>").
		-- EN: Returns the target's health percentage as a string (or "<notarget>").
		-- ============================================================================
		local function TargetPercentHP()
			local str = PL["<notarget>"]
			if UnitExists("target") then
				local percent = math.floor(100 * (UnitHealth("target") / UnitHealthMax("target")))
				str = tostring(percent) .. "%%"
			end
			return prat_match(str)
		end

		-- ============================================================================
		-- BR: Retorna a guilda do alvo (ou "<noguild>" ou "<semalvo>").
		-- EN: Returns the target's guild (or "<noguild>" or "<notarget>").
		-- ============================================================================
		local function TargetGuild()
			local guild = PL["<notarget>"]
			if UnitExists("target") then
				guild = PL["<noguild>"]
				if IsInGuild("target") then
					guild = GetGuildInfo("target") or ""
				end
			end
			return prat_match(guild)
		end

		-- ============================================================================
		-- BR: Retorna o ícone de raid do alvo (ex: {star}) ou vazio.
		-- EN: Returns the target's raid icon (e.g., {star}) or empty.
		-- ============================================================================
		local function TargetIcon()
			local icon = ""
			if not Prat.IsRetail and UnitExists("target") then
				local iconnum = GetRaidTargetIndex("target")
				if iconnum then
					local prefix = ICON_TAG_RAID_TARGET_STAR1:sub(1, -2) or "rt"
					icon = ("{%s%d}"):format(prefix, iconnum)
				end
			end
			return prat_match(icon)
		end

		-- ============================================================================
		-- BR: Retorna o possessivo do alvo (dele/dela/dele ou dela).
		-- EN: Returns the target's possessive (his/hers/its).
		-- ============================================================================
		local function TargetPossesive()
			local p = PL["<notarget>"]
			if UnitExists("target") then
				local s = UnitSex("target")
				if (s == 2) then
					p = PL["his"]
				elseif (s == 3) then
					p = PL["hers"]
				else
					p = PL["its"]
				end
			end
			return prat_match(p)
		end

		
		-- BR: Retorna o pronome do alvo (ele/ela/ele ou ela).
		-- EN: Returns the target's pronoun (him/her/it).
		local function TargetPronoun()
			local p = PL["<notarget>"]
			if UnitExists("target") then
				local s = UnitSex("target")
				if (s == 2) then
					p = PL["him"]
				elseif (s == 3) then
					p = PL["her"]
				else
					p = PL["it"]
				end
			end
			return prat_match(p)
		end

		
		-- BR: Retorna um número aleatório entre 1 e 100 como string.
		-- EN: Returns a random number between 1 and 100 as a string.
		local function Rand()
			local num = math.random(1, 100)
			return prat_match(num .. "")   -- concatena com string vazia
		end

		
		-- BR: Gera a descrição do padrão de substituição para o tooltip.
		-- EN: Generates the description of the substitution pattern for the tooltip.
		local function subDesc(info)
			return info.handler:GetSubstDescription(info)
		end


		-- BR: Registra os patterns de substituição no sistema do Prat.
		-- EN: Registers the substitution patterns in Prat's system.
		function module:OnModuleEnable()
			self:BuildModuleOptions(patternPlugins.patterns)
		end

		function module:BuildModuleOptions(args)
			local modulePatterns = Prat:GetModulePatterns(self)
			self.buildingMenu = true
			for _, v in pairs(modulePatterns) do
				if v then
					local name = v.optname
					local pat = v.pattern:gsub("%%%%", "%%")
					args[name] = args[name] or {}
					local d = args[name]
					d.name = name .. " " .. pat
					d.desc = subDesc
					d.type = "execute"
					d.func = "DoPat"
				end
			end
			self.buildingMenu = false
		end

		function module:GetDescription()
			return PL["A module to provide basic chat substitutions."]
		end

		function module:GetSubstDescription(info)
			local val = self:InfoToPattern(info)
			self.buildingMenu = true
			val = val and val.matchfunc and val.matchfunc() or PL["NO MATCHFUNC FOUND"]
			val = PL["current-prompt"]:format("|cff80ff80" .. tostring(val) .. "|r"):gsub("%%%%", "%%")
			self.buildingMenu = false
			return val
		end

		function module:InfoToPattern(info)
			local modulePatterns = Prat:GetModulePatterns(self)
			local name = info[#info] or ""
			if modulePatterns then
				for _, v in pairs(modulePatterns) do
					if v and v.optname == name then
						return v
					end
				end
			end
		end


		-- BR: Executado ao clicar no botão: cola o token na editbox do chat.
		-- EN: Called when the button is clicked: pastes the token into the chat editbox.
		function module:DoPat(info)
			local pat = self:InfoToPattern(info)
			if not pat then return end

			local token = pat.pattern:match("^%((%%w+)%)$")
			if not token then return end

			-- Cria um editbox temporário invisível
			local hiddenEdit = CreateFrame("EditBox", nil, UIParent)
				hiddenEdit:SetSize(1, 1)
				hiddenEdit:SetPoint("CENTER", UIParent, "CENTER")
				hiddenEdit:SetAutoFocus(false)
				hiddenEdit:SetText(token)
				hiddenEdit:HighlightText()
				hiddenEdit:Copy()  -- copia para a área de transferência
				hiddenEdit:SetText("")
				hiddenEdit:ClearFocus()
				hiddenEdit:Hide()
				hiddenEdit:SetScript("OnUpdate", nil)
			-- Destrói o frame após um curto período
			C_Timer.After(0.1, function() hiddenEdit:Destroy() end)

			-- Mensagem de confirmação
			local msg = ("|cff00ff00Token %s copiado! Cole no chat (Ctrl+V).|r"):format(token)
			DEFAULT_CHAT_FRAME:AddMessage(msg)
		end

		-- ============================================================================
		-- BR: Registra todos os patterns de substituição (tokens) no Prat.
		-- EN: Registers all substitution patterns (tokens) in Prat.
		-- ============================================================================
		Prat:SetModulePatterns(module, {
			{ pattern = "(%%thd)", matchfunc = TargetHealthDeficit, optname = PL["TargetHealthDeficit"], type = "OUTBOUND" },
			{ pattern = "(%%thp)", matchfunc = TargetPercentHP, priority = 51, optname = PL["TargetPercentHP"], type = "OUTBOUND" },
			{ pattern = "(%%tpn)", matchfunc = TargetPronoun, optname = PL["TargetPronoun"], type = "OUTBOUND" },

			{ pattern = "(%%hc)", matchfunc = PlayerHP, optname = PL["PlayerHP"], type = "OUTBOUND" },
			{ pattern = "(%%pn)", matchfunc = PlayerName, optname = PL["PlayerName"], type = "OUTBOUND" },
			{ pattern = "(%%hm)", matchfunc = PlayerMaxHP, optname = PL["PlayerMaxHP"], type = "OUTBOUND" },
			{ pattern = "(%%hd)", matchfunc = PlayerHealthDeficit, optname = PL["PlayerHealthDeficit"], type = "OUTBOUND" },
			{ pattern = "(%%hp)", matchfunc = PlayerPercentHP, optname = PL["PlayerPercentHP"], type = "OUTBOUND" },
			{ pattern = "(%%mc)", matchfunc = PlayerCurrentMana, optname = PL["PlayerCurrentMana"], type = "OUTBOUND" },
			{ pattern = "(%%mm)", matchfunc = PlayerMaxMana, optname = PL["PlayerMaxMana"], type = "OUTBOUND" },
			{ pattern = "(%%mp)", matchfunc = PlayerPercentMana, optname = PL["PlayerPercentMana"], type = "OUTBOUND" },
			{ pattern = "(%%pmd)", matchfunc = PlayerManaDeficit, optname = PL["PlayerManaDeficit"], type = "OUTBOUND" },

			GetAverageItemLevel and {
				pattern = "(%%ail)", matchfunc = PlayerAverageItemLevel, optname = PL["PlayerAverageItemLevel"], type = "OUTBOUND"
			} or nil,

			{ pattern = "(%%tn)", matchfunc = TargetName, optname = PL["TargetName"], type = "OUTBOUND" },
			{ pattern = "(%%tt)", matchfunc = TargetTargetName, optname = PL["TargetTargetName"], type = "OUTBOUND" },
			{ pattern = "(%%tc)", matchfunc = TargetClass, optname = PL["TargetClass"], type = "OUTBOUND" },
			{ pattern = "(%%th)", matchfunc = TargetHealth, optname = PL["TargetHealth"], type = "OUTBOUND" },
			{ pattern = "(%%tr)", matchfunc = TargetRace, optname = PL["TargetRace"], type = "OUTBOUND" },
			{ pattern = "(%%ts)", matchfunc = TargetGender, optname = PL["TargetGender"], type = "OUTBOUND" },
			{ pattern = "(%%ti)", matchfunc = TargetIcon, optname = PL["TargetIcon"], type = "OUTBOUND" },
			{ pattern = "(%%tl)", matchfunc = TargetLevel, optname = PL["TargetLevel"], type = "OUTBOUND" },
			{ pattern = "(%%tps)", matchfunc = TargetPossesive, optname = PL["TargetPossesive"], type = "OUTBOUND" },
			{ pattern = "(%%tmd)", matchfunc = TargetManaDeficit, optname = PL["TargetManaDeficit"], type = "OUTBOUND" },
			{ pattern = "(%%tg)", matchfunc = TargetGuild, optname = PL["TargetGuild"], type = "OUTBOUND" },

			{ pattern = "(%%mn)", matchfunc = MouseoverName, optname = PL["MouseoverTargetName"], type = "OUTBOUND" },

			{ pattern = "(%%zon)", matchfunc = Zone, optname = PL["MapZone"], type = "OUTBOUND" },
			{ pattern = "(%%loc)", matchfunc = Loc, optname = PL["MapLoc"], type = "OUTBOUND" },
			{ pattern = "(%%pos)", matchfunc = Pos, optname = PL["MapPos"], type = "OUTBOUND" },
			{ pattern = "(%%ypos)", matchfunc = Ypos, optname = PL["MapYPos"], type = "OUTBOUND" },
			{ pattern = "(%%xpos)", matchfunc = Xpos, optname = PL["MapXPos"], type = "OUTBOUND" },
			{ pattern = "(%%rnd)", matchfunc = Rand, optname = PL["RandNum"], type = "OUTBOUND" },
		})

		return
	end)
--]]--
