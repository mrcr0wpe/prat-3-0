--[[
    @File:      Invites.lua
    @Project:   Prat-3.0

    BR: Facilita convites para grupo a partir do chat.
        - ALT+click em nomes de jogadores para convidar
        - Links clicáveis em palavras como invite/inv
        - Detecção de pedidos de convite em mensagens
        - Suporte a hyperlinks customizados invplr
        - Filtros por canal de detecção
        - Lista de bloqueio, trava em combate e cooldown anti-spam
        - Compatibilidade com APIs antigas e modernas de grupo/chat

    EN: Makes group invites easier from chat.
        - ALT-click player names to invite
        - Clickable links on words like invite/inv
        - Detects invite requests in messages
        - Custom invplr hyperlink support
        - Detection filters by chat channel
        - Blacklist, combat lock and anti-spam cooldown
        - Compatibility with old and modern group/chat APIs

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade com APIs antigas e modernas da editbox do chat
    EN: Compatibility with old and modern chat editbox APIs
------------------------------------------------]]--
local ChatEdit_GetActiveWindow = _G.ChatEdit_GetActiveWindow or _G.ChatFrameUtil.GetActiveWindow

--[[------------------------------------------------
    BR: Compatibilidade com APIs antigas e modernas de convite para grupo
    EN: Compatibility with old and modern group invite APIs
------------------------------------------------]]--
local CanInvite = _G.CanGroupInvite or _G.C_PartyInfo.CanInvite
local InviteUnit = _G.InviteUnit or _G.C_PartyInfo.InviteUnit

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo de convites com suporte a hooks
		EN: Creation of the invite module with hook support
	------------------------------------------------]]--
	local module = Prat:NewModule("Invites", "AceHook-3.0")
	local PL = module.PL

	--[[------------------------------------------------
		BR: Configuração das opções da interface do módulo
		EN: Module interface options configuration
	------------------------------------------------]]--
	Prat:SetModuleOptions(module, {
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

			invite_actions_group = {
				type = "group",
				name = PL["actions_tab_name"],
				desc = PL["actions_tab_desc"],
				order = 20,
				args = {
					actions_help = {
						type = "description",
						name = PL["actions_help"],
						order = 10,
						width = "full",
					},

					alt_invite = {
						name = PL["alt_invite_name"],
						desc = PL["alt_invite_desc"],
						type = "toggle",
						order = 20,
						width = "full",
					},

					link_invite = {
						name = PL["link_invite_name"],
						desc = PL["link_invite_desc"],
						type = "toggle",
						order = 30,
						width = "full",
					},
				},
			},

			detection_group = {
				type = "group",
				name = PL["detection_tab_name"],
				desc = PL["detection_tab_desc"],
				order = 30,
				args = {
					detection_help = {
						type = "description",
						name = PL["detection_help"],
						order = 10,
						width = "full",
					},

					detect_whisper = {
						name = PL["detect_whisper_name"],
						desc = PL["detect_whisper_desc"],
						type = "toggle",
						order = 20,
						width = 1.5,
						disabled = function()
							return not module.db.profile.link_invite
						end,
					},

					detect_guild = {
						name = PL["detect_guild_name"],
						desc = PL["detect_guild_desc"],
						type = "toggle",
						order = 30,
						width = 1.5,
						disabled = function()
							return not module.db.profile.link_invite
						end,
					},

					detect_group = {
						name = PL["detect_group_name"],
						desc = PL["detect_group_desc"],
						type = "toggle",
						order = 40,
						width = 1.5,
						disabled = function()
							return not module.db.profile.link_invite
						end,
					},

					detect_say_yell = {
						name = PL["detect_say_yell_name"],
						desc = PL["detect_say_yell_desc"],
						type = "toggle",
						order = 50,
						width = 1.5,
						disabled = function()
							return not module.db.profile.link_invite
						end,
					},

					detect_channel = {
						name = PL["detect_channel_name"],
						desc = PL["detect_channel_desc"],
						type = "toggle",
						order = 60,
						width = 1.5,
						disabled = function()
							return not module.db.profile.link_invite
						end,
					},
				},
			},

			safety_group = {
				type = "group",
				name = PL["safety_tab_name"],
				desc = PL["safety_tab_desc"],
				order = 40,
				args = {
					safety_help = {
						type = "description",
						name = PL["safety_help"],
						order = 10,
						width = "full",
					},

					block_combat = {
						name = PL["block_combat_name"],
						desc = PL["block_combat_desc"],
						type = "toggle",
						order = 20,
						width = "full",
					},

					invite_cooldown = {
						name = PL["invite_cooldown_name"],
						desc = PL["invite_cooldown_desc"],
						type = "range",
						order = 30,
						width = 1.5,
						min = 0,
						max = 60,
						step = 1,
					},

					blacklist_help = {
						type = "description",
						name = PL["blacklist_help"],
						order = 40,
						width = "full",
					},

					blacklist = {
						name = PL["blacklist_name"],
						desc = PL["blacklist_desc"],
						type = "input",
						order = 50,
						width = "full",
						multiline = 5,
					},
				},
			},
		}
	})

	--[[------------------------------------------------
		BR: Configuração dos valores padrão do módulo
		EN: Module default values configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			alt_invite = true,
			link_invite = true,
			detect_whisper = true,
			detect_guild = true,
			detect_group = true,
			detect_say_yell = true,
			detect_channel = true,
			block_combat = true,
			invite_cooldown = 5,
			blacklist = "",
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
		BR: Ativa hooks e registra tipos de links customizados
		EN: Enables hooks and registers custom link types
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:set_alt_invite()

		Prat.RegisterLinkType({ linkid = "invplr", linkfunc = self.invite_link, handler = self }, self.name)
		Prat.RegisterLinkType({ linkid = "player", linkfunc = self.player_link, handler = self }, self.name)
	end

	--[[------------------------------------------------
		BR: Reaplica hook de ALT-invite quando opções mudam
		EN: Reapplies ALT-invite hook when options change
	------------------------------------------------]]--
	function module:OnValueChanged(info)
		local field = info[#info]
		if field == "alt_invite" or field == "link_invite" then
			self:set_alt_invite()
		end
	end

	--[[------------------------------------------------
		BR: Instala/remove hook global de clique em links de jogador
		EN: Installs/removes global player link click hook
	------------------------------------------------]]--
	function module:set_alt_invite()
		if (self.db.profile.alt_invite) then
			self:SecureHook("SetItemRef")
		else
			self:Unhook("SetItemRef")
		end
	end

	--[[------------------------------------------------
		BR: Eventos de chat agrupados por opção de detecção.
		    Isso permite que o usuário escolha onde os links de convite serão criados.
		EN: Chat events grouped by detection option.
		    This lets the user choose where invite links should be created.
	------------------------------------------------]]--
	local event_option_for_invite = {
		["CHAT_MSG_GUILD"] = "detect_guild",
		["CHAT_MSG_OFFICER"] = "detect_guild",
		["CHAT_MSG_PARTY"] = "detect_group",
		["CHAT_MSG_RAID"] = "detect_group",
		["CHAT_MSG_RAID_LEADER"] = "detect_group",
		["CHAT_MSG_RAID_WARNING"] = "detect_group",
		["CHAT_MSG_SAY"] = "detect_say_yell",
		["CHAT_MSG_YELL"] = "detect_say_yell",
		["CHAT_MSG_WHISPER"] = "detect_whisper",
		["CHAT_MSG_CHANNEL"] = "detect_channel",
	}

	--[[------------------------------------------------
		BR: Remove espaços extras no começo e no fim de uma string.
		    Mantido local para não depender de funções externas de outras libs.
		EN: Removes extra spaces from the beginning and end of a string.
		    Kept local to avoid depending on external library helpers.
	------------------------------------------------]]--
	local function trim(value)
		return (tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""))
	end

	--[[------------------------------------------------
		BR: Normaliza nomes para comparação interna.
		    Também remove sufixos de links do chat, como dados depois de ':'.
		EN: Normalizes names for internal comparison.
		    Also removes chat-link suffixes, such as data after ':'.
	------------------------------------------------]]--
	local function normalize_player_name(name)
		name = trim(name)
		if name == "" then
			return nil
		end

		name = name:gsub("|c%x%x%x%x%x%x%x%x", ""):gsub("|r", "")
		name = name:match("^([^%s:]+)") or name

		return string.lower(name)
	end

	--[[------------------------------------------------
		BR: Retorna somente o nome base, sem o reino, quando houver Nome-Reino.
		EN: Returns only the base name, without realm, when Name-Realm is present.
	------------------------------------------------]]--
	local function get_base_player_name(name)
		name = normalize_player_name(name)
		if not name then
			return nil
		end

		return name:match("^([^-]+)") or name
	end

	--[[------------------------------------------------
		BR: Verifica se o nome está na lista de bloqueio configurada pelo usuário.
		    - Se o usuário informar Nome-Reino, exige correspondência completa.
		    - Se informar apenas Nome, compara pelo nome base.
		EN: Checks whether the name is in the user-configured blacklist.
		    - If the user enters Name-Realm, full match is required.
		    - If only Name is entered, comparison uses the base name.
	------------------------------------------------]]--
	function module:is_player_blacklisted(name)
		local normalized_name = normalize_player_name(name)
		local base_name = get_base_player_name(name)
		local list = self.db.profile.blacklist or ""

		if not normalized_name or list == "" then
			return false
		end

		for token in string.gmatch(list, "[^,%s;]+") do
			local blocked_name = normalize_player_name(token)
			if blocked_name then
				if blocked_name:find("-", 1, true) then
					if normalized_name == blocked_name then
						return true
					end
				elseif base_name == blocked_name then
					return true
				end
			end
		end

		return false
	end

	--[[------------------------------------------------
		BR: Verifica se o evento atual do chat está liberado nas opções de detecção.
		EN: Checks whether the current chat event is allowed by detection options.
	------------------------------------------------]]--
	function module:is_invite_event_allowed(event)
		local option = event_option_for_invite[event]
		if option then
			return self.db.profile[option]
		end

		return false
	end

	--[[------------------------------------------------
		BR: Centraliza as travas de segurança antes de chamar InviteUnit.
		    Isso evita duplicar blacklist, combate e cooldown em vários pontos.
		EN: Centralizes safety checks before calling InviteUnit.
		    This avoids duplicating blacklist, combat and cooldown checks in many places.
	------------------------------------------------]]--
	function module:can_send_invite(name)
		local normalized_name = normalize_player_name(name)

		if not normalized_name then
			return false
		end

		if self:is_player_blacklisted(name) then
			return false
		end

		if self.db.profile.block_combat and UnitAffectingCombat and UnitAffectingCombat("player") then
			return false
		end

		if CanInvite and not CanInvite() then
			return false
		end

		local invite_cooldown = tonumber(self.db.profile.invite_cooldown) or 0
		if invite_cooldown > 0 then
			self.invite_cooldowns = self.invite_cooldowns or {}

			local now_time = GetTime and GetTime() or time()
			local last_invite = self.invite_cooldowns[normalized_name]

			if last_invite and ((now_time - last_invite) < invite_cooldown) then
				return false
			end

			self.invite_cooldowns[normalized_name] = now_time
		end

		return true
	end

	--[[------------------------------------------------
		BR: Executa o convite somente depois das validações de segurança.
		EN: Sends the invite only after safety checks pass.
	------------------------------------------------]]--
	function module:try_invite(name)
		if self:can_send_invite(name) then
			InviteUnit(name)
			return true
		end

		return false
	end

	--[[------------------------------------------------
		BR: Converte palavra de convite em link clicável para o jogador da mensagem.
		    A blacklist também é respeitada na criação do link, não apenas no clique.
		EN: Converts invite word into a clickable link for the message player.
		    The blacklist is respected when creating the link, not only when clicked.
	------------------------------------------------]]--
	local function create_invite_link_for_sender(text)
		if module.db.profile.link_invite then
			return module:scan_for_links(text, Prat.SplitMessage.PLAYERLINK)
		end
	end

	--[[------------------------------------------------
		BR: Palavras comuns que não devem ser tratadas como nomes de jogadores
		EN: Common words that should not be treated as player names
	------------------------------------------------]]--
	local invalid_names = {
		["meh"] = true,
		["now"] = true,
		["plz"] = true,
		["pls"] = true,
		["please"] = true,
		["when"] = true,
		["group"] = true,
		["raid"] = true,
		["grp"] = true,
	}

	--[[------------------------------------------------
		BR: Referências genéricas que não devem virar destino de convite
		EN: Generic references that should not become invite targets
	------------------------------------------------]]--
	local invalid_name_reference = {
		["him"] = true,
		["her"] = true,
		["them"] = true,
		["someone"] = true,
	}

	--[[------------------------------------------------
		BR: Detecta pedido de convite direcionado a um nome específico
		EN: Detects invite request directed at a specific name
	------------------------------------------------]]--
	local function invite_someone(text, name)
		if module.db.profile.link_invite and name then
			name = name:lower()
			if name:len() > 2 and not invalid_names[name] then
				if invalid_name_reference[name] then
					return Prat:RegisterMatch(text)
				else
					return module:scan_for_links(text, name)
				end
			end
		end
	end

	--[[------------------------------------------------
		BR: Registra patterns multilíngues de pedidos de convite
		EN: Registers multilingual invite request patterns
	------------------------------------------------]]--
	Prat:SetModulePatterns(module, {
		{ pattern = "(send%s+invite%s+to%s+" .. Prat.AnyNamePattern .. ")", matchfunc = invite_someone },
		{ pattern = "(invi?t?e?%s+" .. Prat.AnyNamePattern .. ")", matchfunc = invite_someone },
		{ pattern = "(" .. Prat.GetNamePattern("invites?%??") .. ")", matchfunc = create_invite_link_for_sender },
		{ pattern = "(" .. Prat.GetNamePattern("inv%??") .. ")", matchfunc = create_invite_link_for_sender },
		{ pattern = "(초대)", matchfunc = create_invite_link_for_sender },
		{ pattern = "(組%??)$", matchfunc = create_invite_link_for_sender },
		{ pattern = "(組我%??)$", matchfunc = create_invite_link_for_sender },
	})

	--[[------------------------------------------------
		BR: Handler do hyperlink customizado invplr
		EN: Handler for custom invplr hyperlink
	------------------------------------------------]]--
	function module:invite_link(link)
		if self.db.profile.link_invite then
			local name = strsub(link, 8)
			if (name and (strlen(name) > 0)) then
				local begin = string.find(name, "%s[^%s]+$")
				if (begin) then
					name = strsub(name, begin + 1)
				end

				self:try_invite(name)
			end
		end

		return false
	end

	--[[------------------------------------------------
		BR: Intercepta clique em link de jogador para ALT-invite
		EN: Intercepts player link click for ALT-invite
	------------------------------------------------]]--
	function module:SetItemRef(link)
		if (strsub(link, 1, 6) == "player") then
			self:player_link(link)
		end
	end

	--[[------------------------------------------------
		BR: Convida jogador ao ALT+clicar em seu link/nome
		EN: Invites player when ALT-clicking their link/name
	------------------------------------------------]]--
	function module:player_link(link)
		if self.db.profile.alt_invite then
			local name = strsub(link, 8)
			if (name and (strlen(name) > 0)) then
				local begin, nend = string.find(name, "%s*[^%s:]+")
				if (begin) then
					name = strsub(name, begin, nend)
				end
				if (IsAltKeyDown()) then
					self:try_invite(name)

					local active_window = ChatEdit_GetActiveWindow()
					if active_window then
						if _G.ChatEdit_OnEscapePressed then
							_G.ChatEdit_OnEscapePressed(active_window)
						else
							active_window:OnEscapePressed()
						end
					end
					return false
				end
			end
		end

		return true
	end

	--[[------------------------------------------------
		BR: Decide se a mensagem atual pode receber link de convite
		EN: Decides whether the current message can receive an invite link
	------------------------------------------------]]--
	function module:scan_for_links(text, name)
		if text == nil then
			return ""
		end

		local link_invite_enabled = self.db.profile.link_invite
		local player_can_invite = (not CanInvite) or CanInvite()

		if link_invite_enabled and player_can_invite and name and not self:is_player_blacklisted(name) then
			if Prat.CurrentMessage then
				if self:is_invite_event_allowed(Prat.CurrentMessage.EVENT) then
					return self:create_invite_link(text, name)
				end
			end
		end

		return text
	end

	--[[------------------------------------------------
		BR: Cria hyperlink visual de convite
		EN: Creates visual invite hyperlink
	------------------------------------------------]]--
	function module:create_invite_link(link, name)
		return Prat:RegisterMatch(("|cff%s|Hinvplr:%s|h[%s]|h|r"):format("ffff00", name, link))
	end
end)
