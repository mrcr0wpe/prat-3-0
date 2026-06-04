--[[
    @File:      Filtering.lua
    @Project:   Prat-3.0

    BR: Filtros básicos e avançados para mensagens de chat.
        - Filtro de avisos de canal
        - Controle de spam repetido por janela de tempo
        - Controle de mensagens AFK/DND repetidas
        - Filtro Bayes/AI para spam
        - Interface de treino com links clicáveis
        - Marcação de mensagens para não processamento

    EN: Basic and advanced filters for chat messages.
        - Channel notice filtering
        - Repeated spam throttling by time window
        - Repeated AFK/DND message throttling
        - Bayes/AI spam filter
        - Training interface with clickable links
        - Message marking to prevent processing

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Fallback para ambientes sem proteção de valores secretos da Blizzard
    EN: Fallback for environments without Blizzard secret value protection
------------------------------------------------]]--
local issecretvalue = issecretvalue or function() return false end

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo de filtros com suporte a eventos
		EN: Creation of the filtering module with event support
	------------------------------------------------]]--
	local module = Prat:NewModule("Filtering", "AceEvent-3.0")

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
			leave_join = true,
			notices = true,
			trade_spam = false,
			afk_dnd = false,
			training = false,
			use_ai = true,
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
			leavejoin = "leave_join",
			tradespam = "trade_spam",
			afkdnd = "afk_dnd",
			useai = "use_ai",
		}

		for old_key, new_key in pairs(migrations) do
			if profile[old_key] ~= nil and profile[new_key] == nil then
				profile[new_key] = profile[old_key]
			end
			profile[old_key] = nil
		end

		if profile.leave_join == nil then
			profile.leave_join = true
		end
		if profile.notices == nil then
			profile.notices = true
		end
		if profile.trade_spam == nil then
			profile.trade_spam = false
		end
		if profile.afk_dnd == nil then
			profile.afk_dnd = false
		end
		if profile.training == nil then
			profile.training = false
		end
		if profile.use_ai == nil then
			profile.use_ai = true
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

			basic = {
				name = PL["basic_tab_name"],
				desc = PL["basic_tab_desc"],
				type = "group",
				order = 100,
				args = {
					basic_help = {
						name = PL["basic_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					notices = {
						name = PL["notices_name"],
						desc = PL["notices_desc"],
						type = "toggle",
						order = 20,
					},

					trade_spam = {
						name = PL["trade_spam_name"],
						desc = PL["trade_spam_desc"],
						type = "toggle",
						order = 30,
					},

					afk_dnd = {
						name = PL["afk_dnd_name"],
						desc = PL["afk_dnd_desc"],
						type = "toggle",
						width = "full",
						order = 40,
					},
				},
			},

			ai = {
				name = PL["ai_tab_name"],
				desc = PL["ai_tab_desc"],
				type = "group",
				order = 200,
				args = {
					ai_help = {
						name = PL["ai_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					use_ai = {
						name = PL["use_ai_name"],
						desc = PL["use_ai_desc"],
						type = "toggle",
						order = 20,
					},

					training = {
						name = PL["training_name"],
						desc = PL["training_desc"],
						type = "toggle",
						order = 30,
					},

					training_help = {
						name = PL["training_help"],
						type = "description",
						order = 40,
						width = "full",
					},
				},
			},
		},
	})

	--[[------------------------------------------------
		BR: Janela de tempo usada para bloquear repetições
		EN: Time window used to block repeated messages
	------------------------------------------------]]--
	local throttle_time = 120

	--[[------------------------------------------------
		BR: Cache de mensagens normalizadas e seus horários
		EN: Cache of normalized messages and their timestamps
	------------------------------------------------]]--
	local message_time = {}

	--[[------------------------------------------------
		BR: Normaliza texto agressivamente para comparar spam repetido
		EN: Aggressively normalizes text to compare repeated spam
	------------------------------------------------]]--
	local function clean_text(msg, author)
		local clean_message = msg:gsub("...hic!", ""):gsub("%d", ""):gsub("%c", ""):gsub("%p", ""):gsub("%s", ""):upper():gsub("SH", "S")
		return (author and author:upper() or "") .. clean_message
	end

	--[[------------------------------------------------
		BR: Inicializa classificador, cache, timer e eventos de filtragem
		EN: Initializes classifier, cache, timer and filtering events
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db.profile)

		Prat.RegisterMessageItem("SPAMPROB", "PRE", "after")
		self.classifier = Prat.GetClassifier(self.db.global)
		self.throttle_frame = self.throttle_frame or CreateFrame("FRAME")
		self.line_table = {}
		self.train_table = {}
		self.throttle = throttle_time

		-- BR: Compatibilidade runtime com nomes antigos.
		-- EN: Runtime compatibility with old names.
		self.throttleFrame = self.throttle_frame
		self.lineTable = self.line_table
		self.trainTable = self.train_table

		self.throttle_frame:SetScript("OnUpdate",
			function(frame, elapsed)
				self.throttle = self.throttle - elapsed
				if frame:IsShown() and self.throttle < 0 then
					self.throttle = throttle_time
					self:prune_messages()
				end
			end)

		-- ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", tradeSpamFilter)
		-- ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", tradeSpamFilter)

		Prat.RegisterChatEvent(self, "Prat_FrameMessage")
		Prat.RegisterLinkType({ linkid = "pratfilter", linkfunc = module.prat_filter, handler = module }, module.name)
	end

	--[[------------------------------------------------
		BR: Limpa estado interno e remove eventos registrados
		EN: Clears internal state and removes registered events
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self.line_table = nil
		self.train_table = nil
		self.lineTable = nil
		self.trainTable = nil

		-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_CHANNEL", tradeSpamFilter)
		-- ChatFrame_RemoveMessageEventFilter("CHAT_MSG_YELL", tradeSpamFilter)

		Prat.UnregisterAllChatEvents(self)
	end

	--[[------------------------------------------------
		BR: Handler dos links clicáveis de treino do filtro Bayes
		EN: Handler for Bayes filter clickable training links
	------------------------------------------------]]--
	function module:prat_filter(data, frame)
		local _, id, found = strsplit(":", data)
		found = tonumber(found) == 1 and true or false
		self:toggle_learn(id, found, frame)
		return false
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Remove entradas antigas do cache de mensagens repetidas
		EN: Removes old entries from the repeated-message cache
	------------------------------------------------]]--
	function module:prune_messages()
		for key, value in pairs(message_time) do
			if difftime(time(), value) > throttle_time then
				message_time[key] = nil
			end
		end
	end

	--[[------------------------------------------------
		BR: Divide texto em tokens normalizados para o classificador
		EN: Splits text into normalized tokens for the classifier
	------------------------------------------------]]--
	local function string_split(text, sep, pattern)
		sep = sep or ""
		local fields = {}
		local patt = pattern or ("([^%s]+)"):format(sep)
		text:gsub(patt, function(c)
			fields[#fields + 1] = c:lower()
		end)
		return fields
	end

	--[[------------------------------------------------
		BR: Tokeniza mensagem removendo pontuação/obfuscações simples
		EN: Tokenizes message while removing punctuation/simple obfuscations
	------------------------------------------------]]--
	local function tokenize(msg)
		return string_split(msg, nil, "([^%s%p%c]+)") -- obfuscations removal
	end

	--[[------------------------------------------------
		BR: Utilitário de cores usado na interface de treino/probabilidade
		EN: Color utility used in training/probability UI
	------------------------------------------------]]--
	local CLR = Prat.CLR

	--[[------------------------------------------------
		BR: Atualiza visualmente a pontuação de spam em linhas visíveis
		EN: Visually updates spam score on visible lines
	------------------------------------------------]]--
	function module:adjust_score(id, frame)
		id = tonumber(id)

		local text = self.line_table and self.line_table[id]
		if not text then
			return
		end

		local probability = self.classifier.getprob(tokenize(text))

		for _, visible_line in ipairs(frame.visibleLines) do
			local message_info = visible_line.messageInfo
			local line_message = message_info.message

			if line_message:match(("pratfilter:%d"):format(id)) then
				message_info.message = line_message:gsub("|c%x-%d+%%%x-|r", CLR:Probability(FormatPercentage(probability), probability):gsub("%%", "%%%%"))
				break
			end
		end
	end

	--[[------------------------------------------------
		BR: Ensina o classificador marcando mensagem como spam ou não-spam
		EN: Trains the classifier by marking message as spam or not-spam
	------------------------------------------------]]--
	function module:learn(id, found, frame)
		id = tonumber(id)

		local text = self.line_table and self.line_table[id]
		if not text then
			return
		end

		local learned = self.train_table[id]
		if learned ~= nil then
			self.classifier.unlearn(tokenize(text), learned)
		end

		self:Output(frame, PL["learning_prefix"] .. text .. PL["learning_as"] .. CLR:Probability(found and PL["spam_label"] or PL["not_spam_label"], found and 1 or 0))
		self.train_table[id] = found or false
		self.classifier.learn(tokenize(text), found)
		self:adjust_score(id, frame)
	end

	--[[------------------------------------------------
		BR: Remove aprendizado anterior do classificador para uma mensagem
		EN: Removes previous classifier training for a message
	------------------------------------------------]]--
	function module:unlearn(id, found, frame)
		id = tonumber(id)

		local text = self.line_table and self.line_table[id]
		if not text then
			return
		end

		local learned = self.train_table[id]
		self.train_table[id] = nil

		if learned ~= nil then
			self.classifier.unlearn(tokenize(text), learned)
		end

		self:Output(frame, PL["unlearning_prefix"] .. text .. PL["learning_as"] .. CLR:Probability(found and PL["spam_label"] or PL["not_spam_label"], found and 1 or 0))
		self.classifier.unlearn(tokenize(text), found)
		self:adjust_score(id, frame)
	end

	--[[------------------------------------------------
		BR: Alterna treinamento/desfazer treinamento pelo link clicado
		EN: Toggles training/untraining from the clicked link
	------------------------------------------------]]--
	function module:toggle_learn(id, found, frame)
		id = tonumber(id)

		local learned = self.train_table and self.train_table[id]
		if learned ~= nil then
			self:unlearn(id, learned, frame)
			return
		end

		self:learn(id, found, frame)
	end

	--[[------------------------------------------------
		BR: Limiares de decisão para spam e mensagem legítima
		EN: Decision thresholds for spam and legitimate messages
	------------------------------------------------]]--
	local spam_cutoff = 0.90
	local ham_cutoff = 0.20

	--[[------------------------------------------------
		BR: Coloriza colchetes da interface de treino
		EN: Colors brackets in the training interface
	------------------------------------------------]]--
	function CLR:Bracket(text)
		return self:Colorize({
			r = 0.85,
			g = 0.85,
			b = 0.85,
			a = 1.0
		}, text)
	end

	--[[------------------------------------------------
		BR: Coloriza probabilidade conforme spam/ham/incerto
		EN: Colors probability according to spam/ham/uncertain state
	------------------------------------------------]]--
	function CLR:Probability(text, probability)
		local is_ham = probability <= ham_cutoff
		local is_spam = probability >= spam_cutoff

		local color = is_ham and "40ff40" or is_spam and "ff4040" or "a0a0a0"
		return self:Colorize(color, text)
	end

	--[[------------------------------------------------
		BR: Eventos submetidos ao filtro Bayes/AI
		EN: Events submitted to the Bayes/AI filter
	------------------------------------------------]]--
	local events_to_handle = {
		CHAT_MSG_CHANNEL = true
	}

	--[[------------------------------------------------
		BR: Pipeline principal: classifica, treina, limita spam e oculta notices
		EN: Main pipeline: classifies, trains, throttles spam and hides notices
	------------------------------------------------]]--
	function module:Prat_FrameMessage(_, message, _, event)
		if self.db.profile.use_ai and not issecretvalue(message.GUID) and events_to_handle[event] and message.GUID ~= UnitGUID("player") then
			local tokens = tokenize(message.ORG.MESSAGE)
			local probability = self.classifier.getprob(tokens)
			local is_spam = probability >= spam_cutoff

			if self.db.profile.training then
				self.line_table[message.LINE_ID] = message.ORG.MESSAGE
				self.lineTable = self.line_table

				message.SPAMPROB = ("|cff40ff40|Hpratfilter:%d:0|h[--]|h|r" .. CLR:Bracket("[") .. "%s" .. CLR:Bracket("]") .. "|cffff4040|Hpratfilter:%d:1|h[++]|h|r ")
					:format(message.LINE_ID, CLR:Probability(FormatPercentage(probability), probability), message.LINE_ID)
			elseif is_spam then
				message.DONOTPROCESS = true
			end
		end

		local new_event = true
		if message.LINE_ID and
			message.LINE_ID == self.last_event and
			self.last_event_type == event then
			new_event = false
		end

		if self.db.profile.trade_spam then
			if event == "CHAT_MSG_CHANNEL" or event == "CHAT_MSG_YELL" then
				local clean_message = clean_text(message.ORG.MESSAGE, message.ORG.PLAYER)

				if message.ORG.PLAYER ~= UnitName("player") then
					if new_event and message_time[clean_message] then
						if difftime(time(), message_time[clean_message]) <= throttle_time then
							message.DONOTPROCESS = true
						else
							message_time[clean_message] = nil
						end
					else
						self.last_event_type = event
						self.last_event = message.LINE_ID
						self.lasteventtype = self.last_event_type
						self.lastevent = self.last_event
						message_time[clean_message] = time()
					end
				end
			end
		end

		if self.db.profile.afk_dnd then
			if event == "CHAT_MSG_AFK" or event == "CHAT_MSG_DND" then
				local clean_message = clean_text(message.ORG.MESSAGE, message.ORG.PLAYER)

				if new_event and message_time[clean_message] then
					if difftime(time(), message_time[clean_message]) <= throttle_time then
						message.DONOTPROCESS = true
					else
						message_time[clean_message] = nil
					end
				else
					self.last_event_type = event
					self.last_event = message.LINE_ID
					self.lasteventtype = self.last_event_type
					self.lastevent = self.last_event
					message_time[clean_message] = time()
				end
			end
		end

		if self.db.profile.notices then
			if event == "CHAT_MSG_CHANNEL_NOTICE_USER" or event == "CHAT_MSG_CHANNEL_NOTICE" then
				message.DONOTPROCESS = true
			end
		end
	end

	--[[------------------------------------------------
		BR: Aliases legados para reduzir risco com chamadas antigas
		EN: Legacy aliases to reduce risk from older calls
	------------------------------------------------]]--
	module.PratFilter = module.prat_filter
	module.PruneMessages = module.prune_messages
	module.AdjustScore = module.adjust_score
	module.Learn = module.learn
	module.Unlearn = module.unlearn
	module.ToggleLearn = module.toggle_learn

	return
end) -- Prat:AddModuleToLoad
