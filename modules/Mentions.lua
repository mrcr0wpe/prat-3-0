--[[
    @File:      Mentions.lua
    @Project:   Prat-3.0

    BR: Suporte experimental a menções de jogadores no chat.
        - Detecta @nome em mensagens enviadas
        - Envia whisper automático ao jogador mencionado
        - Suporte a autocomplete com AceTab
        - Integração com PlayerNames e ServerNames

    EN: Experimental support for player mentions in chat.
        - Detects @name in outgoing messages
        - Automatically whispers the mentioned player
        - AceTab autocomplete support
        - PlayerNames and ServerNames integration

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade com APIs antigas e modernas de envio de mensagem
    EN: Compatibility with old and modern chat message sending APIs
------------------------------------------------]]--
local SendChatMessage = C_ChatInfo.SendChatMessage or SendChatMessage

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo de menções com suporte a hooks
		EN: Creation of the mentions module with hook support
	------------------------------------------------]]--
	local module = Prat:NewModule("Mentions", "AceHook-3.0")
	local PL = module.PL

	--[[------------------------------------------------
		BR: Configuração dos valores padrão do módulo
		EN: Module default values configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = false,
		}
	})

	--[[------------------------------------------------
		BR: Interface de configuração do módulo
		EN: Module configuration interface
	------------------------------------------------]]--
	Prat:SetModuleOptions(module.name, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		args = {
			description = {
				name = PL["full_description"],
				type = "description",
				order = 10,
				width = "full",
			},

			spacer_after_description = {
				type = "description",
				name = "\n",
				order = 15,
				width = "full",
			},

			how_it_works_header = {
				name = PL["how_it_works_header"],
				type = "header",
				order = 20,
			},

			how_it_works = {
				name = PL["how_it_works"],
				type = "description",
				order = 30,
				width = "full",
			},

			spacer_after_how_it_works = {
				type = "description",
				name = "\n",
				order = 35,
				width = "full",
			},

			features_header = {
				name = PL["features_header"],
				type = "header",
				order = 40,
			},

			features = {
				name = PL["features"],
				type = "description",
				order = 50,
				width = "full",
			},

			spacer_after_features = {
				type = "description",
				name = "\n",
				order = 55,
				width = "full",
			},

			example_header = {
				name = PL["example_header"],
				type = "header",
				order = 60,
			},

			example = {
				name = PL["example"],
				type = "description",
				order = 70,
				width = "full",
			},

			spacer_before_warning = {
				type = "description",
				name = "\n",
				order = 75,
				width = "full",
			},

			warning = {
				name = PL["warning"],
				type = "description",
				order = 80,
				width = "full",
			},
		}
	})

	--[[------------------------------------------------
		BR: Processa @nome em mensagens enviadas e dispara whisper
		EN: Processes @name in outgoing messages and sends whisper
	------------------------------------------------]]--
	local function handle_mention(match, message)
		if Prat.IsRetail and InCombatLockdown() then
			return
		end

		if not match or not message or not message.MESSAGE or not message.CTYPE then
			return
		end

		local name = match:sub(2)

		if name == "" then
			return
		end

		local event = "CHAT_MSG_" .. message.CTYPE
		local from = PL["mention_whisper_prefix"]:format(_G[event] or event)

		SendChatMessage(from .. message.MESSAGE, "WHISPER", GetDefaultLanguage("player"), name)
	end

	--[[------------------------------------------------
		BR: Registra pattern outbound para capturar menções
		EN: Registers outbound pattern to capture mentions
	------------------------------------------------]]--
	Prat:SetModulePatterns(module, {
		{ pattern = "@%S+", matchfunc = handle_mention, priority = 47, type = "OUTBOUND" }
	})

	--[[------------------------------------------------
		BR: Ativa autocomplete de menções
		EN: Enables mention autocomplete
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:register_tab_complete()
	end

	--[[------------------------------------------------
		BR: Registra autocomplete de @nomes usando AceTab
		EN: Registers @name autocomplete using AceTab
	------------------------------------------------]]--
	function module:register_tab_complete()
		local CLR = Prat.CLR
		local AceTab = LibStub("AceTab-3.0")
		local tab_complete_name = "mentions-tab-complete"
		local server_names = Prat:GetModule("ServerNames")
		local player_names = Prat:GetModule("PlayerNames")

		if not AceTab:IsTabCompletionRegistered(tab_complete_name) then
			AceTab:RegisterTabCompletion(tab_complete_name, "@",
				function(matches)
					for name in pairs(player_names.Classes) do
						table.insert(matches, name)
					end
				end,
				function(_, candidates)
					local candidate_count = #candidates
					local tab_complete_limit = player_names.db.profile.tab_complete_limit or player_names.db.profile.tabcompletelimit or 20

					if candidate_count <= tab_complete_limit then
						local text
						for key, candidate in pairs(candidates) do
							if server_names then
								local player, server = key:match("([^%-]+)%-?(.*)")

								candidate = CLR:Player(candidate, player, player_names:getClass(key))

								if server then
									server = server_names:FormatServer(nil, server_names:GetServerKey(server))
									candidate = candidate .. (server and ("-" .. server) or "")
								end
							else
								candidate = CLR:Player(candidate, candidate, player_names:getClass(candidate))
							end

							text = text and (text .. ", " .. candidate) or candidate
						end
						return "   " .. text
					else
						return "   " .. PL["too_many_matches"]:format(candidate_count)
					end
				end,
				nil,
				function(name)
					return name:gsub(Prat.MULTIBYTE_FIRST_CHAR, string.upper, 1):match("^[^%-]+")
				end)
		end
	end
end)
