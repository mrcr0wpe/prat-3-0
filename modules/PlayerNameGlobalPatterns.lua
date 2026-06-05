--[[
    @File:      PlayerNameGlobalPatterns.lua
    @Project:   Prat-3.0

    BR: Extensão do módulo PlayerNames para colorir nomes de jogadores em padrões globais do chat.
        - Integra-se ao módulo PlayerNames sem criar um módulo independente
        - Registra padrões globais para links, hyperlinks e nomes de jogadores
        - Preserva links existentes antes de aplicar coloração de nomes
        - Adiciona a opção Colorir em todos os lugares
        - Usa dados conhecidos de jogador/classe para aplicar cor quando disponível
        - Mantém compatibilidade com a chave legada coloreverywhere

    EN: PlayerNames extension for coloring player names in global chat patterns.
        - Integrates with PlayerNames without creating a standalone module
        - Registers global patterns for links, hyperlinks and player names
        - Preserves existing links before applying name coloring
        - Adds the Color Everywhere option
        - Uses known player/class data to apply color when available
        - Keeps compatibility with the legacy coloreverywhere key

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Registro tardio da extensão para carregamento controlado pelo Prat
    EN: Deferred extension registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleExtension(function()
	--[[------------------------------------------------
	    BR: Usa o módulo PlayerNames já existente como base da extensão
	    EN: Uses the existing PlayerNames module as the extension base
	------------------------------------------------]]--
	local module = Prat:GetModule("PlayerNames")
	if not module then
		return
	end

	--[[------------------------------------------------
	    BR: Incorpora AceTimer ao PlayerNames para compatibilidade com rotinas temporizadas
	    EN: Embeds AceTimer into PlayerNames for timed routine compatibility
	------------------------------------------------]]--
	LibStub("AceTimer-3.0"):Embed(module)

	--[[------------------------------------------------
	    BR: Referência local às strings de localização herdadas de PlayerNames
	    EN: Local reference to localization strings inherited from PlayerNames
	------------------------------------------------]]--
	local PL = module.PL

	--[[------------------------------------------------
	    BR: Adiciona a opção de colorir nomes em padrões globais do bate-papo
	    EN: Adds the option to color names in global chat patterns
	------------------------------------------------]]--
	module.pluginopts["GlobalPatterns"] = {
		color_everywhere = {
			type = "toggle",
			name = PL["color_everywhere_name"],
			desc = PL["color_everywhere_desc"],
			order = 220,
		}
	}

	--[[------------------------------------------------
	    BR: Preserva links coloridos completos antes de aplicar padrões de nomes
	    EN: Preserves fully colored links before applying name patterns
	------------------------------------------------]]--
	Prat:RegisterPattern({
		pattern = "|c.-|H.-:.-|h.-|h|r",
		matchfunc = function(link)
			return Prat:RegisterMatch(link)
		end,
		type = "FRAME",
		priority = 44,
	}, module.name)

	--[[------------------------------------------------
	    BR: Preserva hyperlinks não coloridos para evitar interferência na leitura do chat
	    EN: Preserves uncolored hyperlinks to avoid interfering with chat parsing
	------------------------------------------------]]--
	Prat:RegisterPattern({
		pattern = "|H.-:.-|h.-|h",
		matchfunc = function(link)
			return Prat:RegisterMatch(link)
		end,
		type = "FRAME",
		priority = 45,
	}, module.name)

	--[[------------------------------------------------
	    BR: Preserva links protegidos/ocultos usados internamente pelo cliente
	    EN: Preserves protected/hidden links used internally by the client
	------------------------------------------------]]--
	Prat:RegisterPattern({
		pattern = "|K.-|k",
		matchfunc = function(link)
			return Prat:RegisterMatch(link)
		end,
		type = "FRAME",
		priority = 45,
	}, module.name)

	--[[------------------------------------------------
	    BR: Cria função reutilizável para colorir nomes com base nos dados de classe conhecidos
	    EN: Creates a reusable function to color names using known class data
	------------------------------------------------]]--
	local color_player
	do
		local function player(name, class)
			return Prat.CLR:Player(name, name, class)
		end

		color_player = function(name)
			return Prat:RegisterMatch(player(name, module:GetData(name)))
		end
	end

	--[[------------------------------------------------
	    BR: Constrói um padrão de nome usando o gerador central do Prat
	    EN: Builds a name pattern using Prat's central pattern generator
	------------------------------------------------]]--
	local function new_pattern(name)
		return { pattern = Prat.GetNamePattern(name), matchfunc = color_player, priority = 48 }
	end

	do
		--[[------------------------------------------------
		    BR: Armazena os padrões dinâmicos registrados para permitir remoção posterior
		    EN: Stores dynamically registered patterns so they can be removed later
		------------------------------------------------]]--
		local name_patterns = {}

		--[[------------------------------------------------
		    BR: Lê a opção atual e mantém compatibilidade com a chave legada
		    EN: Reads the current option and keeps compatibility with the legacy key
		------------------------------------------------]]--
		local function is_color_everywhere_enabled(profile)
			if not profile then
				return false
			end

			if profile.color_everywhere ~= nil then
				return profile.color_everywhere
			end

			return profile.coloreverywhere
		end

		--[[------------------------------------------------
		    BR: Registra ou remove padrões globais quando dados de jogador são atualizados
		    EN: Registers or removes global patterns when player data is updated
		------------------------------------------------]]--
		function module:on_player_data_changed_throttled(name)
			self.timer_player_data = nil
			self.timerPlayerData = nil -- Legacy compatibility for older saved/runtime references.

			if is_color_everywhere_enabled(self.db and self.db.profile) and name then
				name = name:match("(.-)%-.+") or name
				name = name:lower()
				if not name_patterns[name] and not Prat.PlayerNameBlackList[name] and name:len() > 1 then
					name_patterns[name] = Prat:RegisterPattern(new_pattern(name), self.name)
				end
			else
				for key, pattern_handle in pairs(name_patterns) do
					Prat:UnregisterPattern(pattern_handle)
					name_patterns[key] = nil
				end
			end
		end

		--[[------------------------------------------------
		    BR: Ponto de entrada chamado pelo PlayerNames quando dados de jogador mudam
		    EN: Entry point called by PlayerNames when player data changes
		------------------------------------------------]]--
		function module:OnPlayerDataChanged(name)
			if not is_color_everywhere_enabled(self.db and self.db.profile) then
				return
			end

			self:on_player_data_changed_throttled(name)
		end
	end

	return
end) -- Prat:AddModuleExtension
