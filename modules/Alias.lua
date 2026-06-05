--[[
    @File:      Alias.lua
    @Project:   Prat-3.0

    BR: Sistema de criação e expansão de abreviações para comandos de barra ( / ).
        - Criação, remoção, listagem e busca de abreviações
        - Expansão automática de comandos digitados
        - Proteção contra sobrescrita e loops infinitos
        - Registro dinâmico de comandos de barra ( / ) no Retail
        - Compatibilidade com o processamento clássico do chat

    EN: Slash command alias creation and expansion system.
        - Alias creation, removal, listing and search
        - Automatic expansion of typed commands
        - Protection against overwrites and infinite loops
        - Dynamic slash command registration on Retail
        - Compatibility with classic chat processing

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade entre clientes antigos e modernos do chat
    EN: Compatibility between old and modern chat clients
------------------------------------------------]]--
local ChatEdit_ChooseBoxForSend = _G.ChatEdit_ChooseBoxForSend or (_G.ChatFrameUtil and _G.ChatFrameUtil.ChooseBoxForSend)
local ChatEdit_ParseText = _G.ChatEdit_ParseText or (_G.ChatFrameEditBoxMixin and _G.ChatFrameEditBoxMixin.ParseText)

--[[------------------------------------------------
    BR: Verifica o bloqueio de mensagens do chat apenas quando a API existir.
        Em alguns clientes modernos, C_ChatInfo.InChatMessagingLockdown pode não estar disponível.
    EN: Checks chat messaging lockdown only when the API exists.
        In some modern clients, C_ChatInfo.InChatMessagingLockdown may not be available.
------------------------------------------------]]--
local function is_chat_messaging_locked_down()
	local chatInfo = _G.C_ChatInfo
	if chatInfo and chatInfo.InChatMessagingLockdown then
		return chatInfo.InChatMessagingLockdown()
	end

	return false
end

--[[------------------------------------------------
    BR: Envia mensagem de bate-papo usando a API disponível no cliente atual.
        Alguns clientes expõem C_ChatInfo.SendChatMessage; outros mantêm SendChatMessage global.
    EN: Sends a chat message using the API available in the current client.
        Some clients expose C_ChatInfo.SendChatMessage; others keep global SendChatMessage.
------------------------------------------------]]--
local function send_chat_message_compat(text, chatType, languageID, target)
	local chatInfo = _G.C_ChatInfo
	if chatInfo and chatInfo.SendChatMessage then
		chatInfo.SendChatMessage(text, chatType, languageID, target)
		return true
	end

	if _G.SendChatMessage then
		_G.SendChatMessage(text, chatType, languageID, target)
		return true
	end

	return false
end

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo Alias com suporte a hooks
		EN: Creation of the Alias module with hook support
	------------------------------------------------]]--
	local module = Prat:NewModule("Alias", "AceHook-3.0")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = false,
			aliases = {},
			inline = false,
			no_clobber = false,
			protect_commands = true,

			-- BR: Comandos protegidos que não devem virar abreviações.
			-- EN: Protected commands that should not become aliases.
			wont_alias = {
				unalias = 1,
				alias = 1,
				prat = 1,
				script = 1,
				run = 1,
				ace = 1,
				ace2 = 1,
				listaliases = 1,
				quit = 1,
				reload = 1,
				rl = 1,
			},
		}
	})

	--[[------------------------------------------------
		BR: Configuração das opções da interface do módulo
		EN: Module interface options configuration
	------------------------------------------------]]--
	--[[------------------------------------------------
		BR: Interface organizada em abas para comandos abreviados.
		EN: Tabbed interface for command aliases.
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

				management = {
					type = "group",
					name = PL["management_tab_name"],
					desc = PL["management_tab_desc"],
					order = 20,
					args = {
						management_help = {
							type = "description",
							name = PL["management_help"],
							order = 10,
							width = "full",
						},

						examples_header = {
							type = "header",
							name = PL["examples_header"],
							order = 15,
						},

						examples_text = {
							type = "description",
							name = PL["examples_text"],
							order = 16,
							width = "full",
						},

						input_usage = {
							type = "description",
							name = PL["input_usage"],
							order = 17,
							width = "full",
						},

						builder_header = {
							type = "header",
							name = PL["builder_header"],
							order = 20,
						},

						builder_help = {
							type = "description",
							name = PL["builder_help"],
							order = 30,
							width = "full",
						},

						builder_alias = {
							type = "input",
							name = PL["builder_alias_name"],
							desc = PL["builder_alias_desc"],
							get = function(info)
								return info.handler:get_alias_builder_value("name")
							end,
							set = function(info, value)
								info.handler:set_alias_builder_value("name", value)
							end,
							order = 40,
							width = 1.15,
						},

						builder_command = {
							type = "select",
							name = PL["builder_command_name"],
							desc = PL["builder_command_desc"],
							values = function(info)
								return info.handler:get_builder_command_values()
							end,
							get = function(info)
								return info.handler:get_alias_builder_value("command")
							end,
							set = function(info, value)
								info.handler:set_alias_builder_value("command", value)
							end,
							order = 50,
							width = 1.15,
						},

						builder_message = {
							type = "input",
							name = PL["builder_message_name"],
							desc = PL["builder_message_desc"],
							get = function(info)
								return info.handler:get_alias_builder_value("message")
							end,
							set = function(info, value)
								info.handler:set_alias_builder_value("message", value)
							end,
							order = 60,
							width = "full",
						},

						builder_preview = {
							type = "description",
							name = function(info)
								return info.handler:get_alias_builder_preview()
							end,
							order = 65,
							width = "full",
						},

						builder_create = {
							type = "execute",
							name = PL["builder_create_name"],
							desc = PL["builder_create_desc"],
							func = function(info)
								info.handler:create_alias_from_builder()
							end,
							order = 70,
							width = "full",
						},

						advanced_header = {
							type = "header",
							name = PL["advanced_header"],
							order = 80,
						},

						advanced_help = {
							type = "description",
							name = PL["advanced_help"],
							order = 90,
							width = "full",
						},

						add = {
							type = "input",
							name = PL["add_name"],
							desc = PL["add_desc"],
							get = false,
							set = function(info, argstr)
								return info.handler:set_alias(argstr)
							end,
							order = 100,
							width = "full",
						},

						manage_existing_header = {
							type = "header",
							name = PL["manage_existing_header"],
							order = 110,
						},

						del = {
							name = PL["del_name"],
							desc = PL["del_desc"],
							type = "select",
							values = function(info)
								return info.handler:get_alias_select_values()
							end,
							set = function(info, aliastoremove)
								return info.handler:delete_alias(aliastoremove)
							end,
							order = 120,
							width = "full",
							disabled = function(info)
								return info.handler:num_aliases() == 0
							end,
						},

						find = {
							name = PL["find_name"],
							desc = PL["find_desc"],
							type = "input",
							set = function(info, q)
								return info.handler:list_aliases(q)
							end,
							get = false,
							order = 130,
							width = 1.5,
						},

						list = {
							name = PL["list_name"],
							desc = PL["list_desc"],
							type = "execute",
							func = function(info)
								info.handler:list_aliases()
							end,
							order = 140,
							width = 1.5,
						},
					},
				},
			behavior = {
				type = "group",
				name = PL["behavior_tab_name"],
				desc = PL["behavior_tab_desc"],
				order = 30,
				args = {
					behavior_help = {
						type = "description",
						name = PL["behavior_help"],
						order = 10,
						width = "full",
					},

					inline = {
						name = PL["inline_name"],
						desc = PL["inline_desc"],
						type = "toggle",
						order = 20,
						width = "full",
					},

					no_clobber = {
						name = PL["no_clobber_name"],
						desc = PL["no_clobber_desc"],
						type = "toggle",
						order = 30,
						width = "full",
					},
				},
			},

			protection = {
				type = "group",
				name = PL["protection_tab_name"],
				desc = PL["protection_tab_desc"],
				order = 40,
				args = {
					protection_help = {
						type = "description",
						name = PL["protection_help"],
						order = 10,
						width = "full",
					},

					protect_commands = {
						name = PL["protect_commands_name"],
						desc = PL["protect_commands_desc"],
						type = "toggle",
						order = 20,
						width = "full",
					},

					protected_commands_header = {
						type = "header",
						name = PL["protected_commands_header"],
						order = 30,
					},

					protected_commands_text = {
						type = "description",
						name = PL["protected_commands_text"],
						order = 40,
						width = "full",
					},
				},
			},
		}
	})


	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo.
		EN: Returns the localized module description.
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Armazena temporariamente os campos do criador assistido de abreviações.
		EN: Temporarily stores fields used by the assisted alias builder.
	------------------------------------------------]]--
	function module:get_alias_builder()
		self.alias_builder = self.alias_builder or {
			name = "",
			command = "say",
			message = "",
		}

		return self.alias_builder
	end

	function module:get_alias_builder_value(field)
		local builder = self:get_alias_builder()
		return builder[field] or ""
	end

	function module:set_alias_builder_value(field, value)
		local builder = self:get_alias_builder()
		value = tostring(value or "")

		if field == "name" then
			value = self:normalize_alias_name(value)
		elseif field == "command" then
			value = string.lower(value)
		end

		builder[field] = value
	end

	--[[------------------------------------------------
		BR: Lista de destinos de bate-papo do criador assistido.
		EN: Chat destination list used by the assisted builder.
	------------------------------------------------]]--
	function module:get_builder_command_values()
		return {
			say = PL["builder_command_say"],
			yell = PL["builder_command_yell"],
			party = PL["builder_command_party"],
			raid = PL["builder_command_raid"],
			rw = PL["builder_command_raid_warning"],
			guild = PL["builder_command_guild"],
			officer = PL["builder_command_officer"],
			instance = PL["builder_command_instance"],
			emote = PL["builder_command_emote"],
		}
	end

	function module:get_alias_builder_preview()
		local builder = self:get_alias_builder()
		local name = self:normalize_alias_name(builder.name)
		local command = tostring(builder.command or "say")
		local message = tostring(builder.message or "")

		if name == "" then
			return PL["builder_preview_empty"]
		end

		local expansion = command .. (message ~= "" and (" " .. message) or "")
		return string.format(PL["builder_preview_format"], name, expansion)
	end

	--[[------------------------------------------------
		BR: Cria uma abreviação a partir dos campos separados da interface.
		EN: Creates an alias from the separated interface fields.
	------------------------------------------------]]--
	function module:create_alias_from_builder()
		local builder = self:get_alias_builder()
		local name = self:normalize_alias_name(builder.name)
		local command = tostring(builder.command or "")
		local message = tostring(builder.message or "")

		message = message:gsub("^%s+", ""):gsub("%s+$", "")

		if name == "" then
			self:warn_user(PL["builder_missing_alias_warning"])
			return false
		end

		if command == "" then
			self:warn_user(PL["builder_missing_command_warning"])
			return false
		end

		if message == "" then
			self:warn_user(PL["builder_missing_message_warning"])
			return false
		end

		return self:set_alias(name .. " " .. command .. " " .. message)
	end

	--[[------------------------------------------------
		BR: Utilitário de cores para mensagens informativas do módulo
		EN: Color utility for module informational messages
	------------------------------------------------]]--
	local CLR = Prat.CLR

	local function color_alias(text)
		return CLR:Colorize("64ff64", text:lower())
	end

	local function color_expansion(text)
		return CLR:Colorize("64ffff", text:lower())
	end

	local function color_module_name(text)
		return CLR:Colorize("ff8080", text)
	end

	--[[------------------------------------------------
		BR: Ativação do módulo, restauração das abreviações e registro de comandos
		EN: Module activation, alias restoration and command registration
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self.Aliases = {}

		table.sort(self.db.profile.aliases)

		for k, v in pairs(self.db.profile.aliases) do
			self.Aliases[k] = v
		end

		self.wont_alias = self.db.profile.wont_alias
		for naughtyalias, _ in pairs(self.wont_alias) do
			self.wont_alias[string.lower(naughtyalias)] = 1
		end

		if Prat.IsRetail then
			self.registered_alias_commands = {}
			self:register_all_alias_commands()
		else
			self:RawHook('ChatEdit_HandleChatType', true)
		end

		Prat.RegisterChatCommand("alias", function(argstr)
			return self:set_alias(argstr)
		end)
		Prat.RegisterChatCommand("unalias", function(argstr)
			return self:delete_alias(argstr)
		end)
		Prat.RegisterChatCommand("listaliases", function(argstr)
			return self:list_aliases(argstr)
		end)
	end

	--[[------------------------------------------------
		BR: Desativação do módulo e remoção dos hooks ativos
		EN: Module deactivation and active hook removal
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:UnhookAll()
		self.Aliases = nil
	end

	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --
	--[[------------------------------------------------
		BR: Gera a chave interna usada pelo sistema de comandos de barra ( / )
		EN: Generates the internal key used by the slash command system
	------------------------------------------------]]--
	function module:get_alias_command_key(alias)
		return "PRATALIAS_" .. string.upper(alias)
	end

	--[[------------------------------------------------
		BR: Normaliza nomes de abreviações para comparar comandos de barra ( / ).
		EN: Normalizes alias names for slash command comparison.
	------------------------------------------------]]--
	function module:normalize_alias_name(alias)
		alias = tostring(alias or "")
		alias = alias:gsub("^%s+", ""):gsub("%s+$", "")
		alias = alias:gsub("^/*", "")
		return string.lower(alias)
	end

	--[[------------------------------------------------
		BR: Procura comandos de barra ( / ) já registrados pelo jogo, pelo Prat ou por outros addons.
		    Quando ignorePratAliasCommands estiver ativo, os comandos criados por este próprio módulo são ignorados.
		EN: Searches for slash commands already registered by the game, Prat, or other addons.
		    When ignorePratAliasCommands is enabled, commands created by this module are ignored.
	------------------------------------------------]]--
	function module:find_registered_slash_command(alias, ignorePratAliasCommands)
		alias = self:normalize_alias_name(alias)
		if alias == "" then
			return nil
		end

		local slashCommand = "/" .. alias

		for globalName, value in pairs(_G) do
			if type(globalName) == "string" and type(value) == "string" then
				if globalName:match("^SLASH_.+%d+$") and string.lower(value) == slashCommand then
					if not (ignorePratAliasCommands and globalName:match("^SLASH_PRATALIAS_")) then
						return globalName
					end
				end
			end
		end

		if _G.hash_ChatTypeInfoList and _G.hash_ChatTypeInfoList[slashCommand] then
			return "hash_ChatTypeInfoList"
		end

		if _G.hash_EmoteTokenList and _G.hash_EmoteTokenList[slashCommand] then
			return "hash_EmoteTokenList"
		end

		return nil
	end

	--[[------------------------------------------------
		BR: Registra dinamicamente um comando de barra ( / ) para a abreviação informada
		EN: Dynamically registers a slash command for the given alias
	------------------------------------------------]]--
	function module:register_alias_command(alias)
		alias = self:normalize_alias_name(alias)

		if alias == "" or self.registered_alias_commands[alias] then
			return false
		end

		if self.db.profile.protect_commands then
			local conflict = self:find_registered_slash_command(alias, true)
			if conflict then
				self:warn_user(string.format(PL["saved_alias_conflict_warning"], color_alias(alias)))
				return false
			end
		end

		local key = self:get_alias_command_key(alias)

		_G["SLASH_" .. key .. "1"] = "/" .. alias
		SlashCmdList[key] = function(msg)
			module:execute_alias(alias, msg or "")
		end

		self.registered_alias_commands[alias] = true
		return true
	end

	--[[------------------------------------------------
		BR: Remove o comando de barra ( / ) criado por este módulo para uma abreviação.
		EN: Removes the slash command created by this module for an alias.
	------------------------------------------------]]--
	function module:unregister_alias_command(alias)
		alias = self:normalize_alias_name(alias)
		if alias == "" then
			return
		end

		local key = self:get_alias_command_key(alias)
		_G["SLASH_" .. key .. "1"] = nil
		SlashCmdList[key] = nil

		if self.registered_alias_commands then
			self.registered_alias_commands[alias] = nil
		end
	end

	function module:register_all_alias_commands()
		if not self.registered_alias_commands then
			self.registered_alias_commands = {}
		end

		for alias in pairs(self.Aliases) do
			self:register_alias_command(alias)
		end
	end

	--[[------------------------------------------------
		BR: Divide a entrada do usuário entre nome da abreviação e expansão
		EN: Splits user input into alias name and expansion value
	------------------------------------------------]]--
	function module:split_alias_args(str)
		local args = {
			name = "",
			value = "",
		}

		for alias, command in str:gmatch("/?(%w+)%s*[%s=]%s*/?(.-)$") do
			args['name'] = self:normalize_alias_name(alias)
			args['value'] = command or ""
		end
		return args
	end

	--[[------------------------------------------------
		BR: Valida argumentos antes de operações críticas de abreviação
		EN: Validates arguments before critical alias operations
	------------------------------------------------]]--
	function module:check_arg_str(funcname, argstr)
		if argstr == nil then
			self:warn_user(string.format(PL["nil_argument_error"], funcname))
			return false
		end

		if argstr == "" then
			self:warn_user(string.format(PL["blank_argument_error"], funcname))
			return false
		end

		return true
	end

	--[[------------------------------------------------
		BR: Cria, atualiza ou consulta uma abreviação existente
		EN: Creates, updates or queries an existing alias
	------------------------------------------------]]--
	function module:set_alias(argstr)
		if not self:check_arg_str('set_alias', argstr) then
			return false
		end

		--[[------------------------------------------------
			BR: Aceita também o comando completo no campo da interface.
			    Isso evita que o usuário cole "/alias oi say Olá" e acabe tentando criar uma abreviação chamada "alias".
			EN: Also accepts the full command inside the options field.
			    This prevents users from pasting "/alias hi say Hello" and accidentally trying to create an alias named "alias".
		------------------------------------------------]]--
		argstr = argstr:gsub("^%s+", ""):gsub("%s+$", "")
		argstr = argstr:gsub("^/?alias%s+", "", 1)

		if not self:check_arg_str('set_alias', argstr) then
			return false
		end

		local alias = self:split_alias_args(argstr)

		-- Check to see if the user is defining an alias or not
		if not alias['value'] or (alias['value'] == "") then
			local name = argstr:gsub('^/*', ''):lower()

			-- Called as: /alias <command> - check for alias called <command> to display
			if self.Aliases[name] then
				-- Alias found; show it :)
				self:show_alias(name)
				return true
			else
				-- No alias found called <command>; tell user
				self:report_undefined_alias(name)
			end
		elseif self.wont_alias[string.lower(alias['name'])] then
			-- User is defining an alias called <command>, but it's potentially bad
			self:warn_user(string.format(PL["protected_alias_warning"], color_alias(alias['name'])))
			return false
		elseif self.db.profile.protect_commands and self:find_registered_slash_command(alias['name'], true) then
			-- BR: Evita criar abreviações que conflitem com comandos do jogo ou de outros addons.
			-- EN: Prevents aliases from conflicting with game or other addon commands.
			self:warn_user(string.format(PL["existing_command_conflict_warning"], color_alias(alias['name'])))
			return false
		elseif self.db.profile.no_clobber and self.Aliases[string.lower(alias['name'])] then
			self:warn_user(string.format(PL["no_clobber_warning"], color_alias(alias['name']), color_expansion(alias['value'])))
			return false
		else
			-- It's not listed as bad, so create or update the aliases tables
			-- called as /alias <command> <value> - define alias <command> as <value>
			if self.Aliases[alias['name']] then
				-- Specified alias already exists, warn user and print old setting
				self:warn_user(string.format(PL["overwrite_alias_warning"], color_alias(alias['name']), color_expansion(self.Aliases[alias['name']])))
			end

			-- Now (re?)define the alias <command> to <value>
			self.Aliases[alias['name']] = alias['value']
			self.db.profile.aliases[alias['name']] = alias['value']

			table.sort(self.db.profile.aliases)
			table.sort(self.Aliases)

			LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")

			self:warn_user(string.format(PL["alias_created_message"], color_alias(alias['name']), color_expansion(alias['value'])))
		end
		if Prat.IsRetail then
			self:register_alias_command(alias['name'])
		end
	end

	function module:delete_alias(aliasname)
		if not self:check_arg_str('delete_alias', aliasname) then
			return false
		end

		-- Remove unecessary /s at the beginning of the alias name
		aliasname = self:normalize_alias_name(aliasname)

		if not self.Aliases[aliasname] then
			self:warn_user(string.format(PL["alias_missing_message"], color_alias(aliasname)))
			return false
		end

		local oldalias = self.Aliases[aliasname]

		self:warn_user(string.format(PL["alias_deleted_message"], color_alias(aliasname), color_expansion(oldalias)))

		self.Aliases[aliasname] = nil
		self.db.profile.aliases[aliasname] = nil

		if Prat.IsRetail then
			self:unregister_alias_command(aliasname)
		end

		LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")

		return oldalias
	end

	function module:show_alias(aliasname)
		if not self:check_arg_str('show_alias', aliasname) then
			return false
		end

		-- Check for undefined alias called aliasname
		if not self.Aliases[aliasname] then
			self:warn_user(string.format(PL["alias_internal_missing_warning"], color_alias(aliasname)))
			return false
		end

		-- Everything OK; display value of alias "aliasname"
		self:warn_user(string.format(PL["alias_value_message"], color_alias(aliasname), color_expansion(self.Aliases[aliasname])))

		return true
	end

	--[[------------------------------------------------
		BR: Lista aliases existentes ou filtra por termo de busca
		EN: Lists existing aliases or filters them by search term
	------------------------------------------------]]--
	function module:list_aliases(q)
		if self:num_aliases() == 0 then
			self:warn_user(PL["no_aliases_message"])
			return false
		end

		table.sort(self.Aliases)

		local count = 0
		for name, _ in pairs(self.Aliases) do
			if not q or (name:match(q)) then
				self:show_alias(name)
				count = count + 1
			end
		end

		self:tell_user(string.format(q and PL["matching_aliases_message"] or PL["total_aliases_message"], count))
	end

	function module:report_undefined_alias(name)
		return self:warn_user(string.format(PL["undefined_alias_message"], color_alias(name)))
	end

	function module:tell_user(str)
		return module:warn_user(str)
	end

	function module:num_aliases()
		if not self.Aliases then
			return 0
		end

		local n = 0
		for _, _ in pairs(self.Aliases) do
			n = n + 1
		end
		return n
	end

	--[[------------------------------------------------
		BR: Monta a lista exibida no seletor de remoção de abreviações.
		EN: Builds the list shown in the alias removal selector.
	------------------------------------------------]]--
	function module:get_alias_select_values()
		local values = {}

		if not self.Aliases then
			return values
		end

		for name, expansion in pairs(self.Aliases) do
			values[name] = string.format(PL["alias_select_format"], name, tostring(expansion or ""))
		end

		return values
	end

	function module:warn_user(str)
		if str == nil then
			str = PL["warn_nil_argument_error"]
		elseif str == "" then
			str = PL["warn_empty_string_error"]
		end

		Prat:Print(string.format("%s: %s", color_module_name(self.moduleName), str))
	end

	--[[------------------------------------------------
		BR: Comandos de bate-papo mais comuns que podem ser executados diretamente.
		    Isso evita depender de tabelas internas da Blizzard que podem mudar entre clientes.
		EN: Most common chat commands that can be executed directly.
		    This avoids relying on Blizzard internal tables that may change between clients.
	------------------------------------------------]]--
	local chat_command_types = {
		s = "SAY",
		say = "SAY",
		dizer = "SAY",
		falar = "SAY",

		y = "YELL",
		yell = "YELL",
		gritar = "YELL",

		p = "PARTY",
		party = "PARTY",
		grupo = "PARTY",

		ra = "RAID",
		raid = "RAID",
		raide = "RAID",

		rw = "RAID_WARNING",
		avisoraide = "RAID_WARNING",
		avisoderaide = "RAID_WARNING",
		["aviso_de_raide"] = "RAID_WARNING",

		g = "GUILD",
		guild = "GUILD",
		guilda = "GUILD",

		o = "OFFICER",
		officer = "OFFICER",
		oficial = "OFFICER",

		i = "INSTANCE_CHAT",
		instance = "INSTANCE_CHAT",
		instancia = "INSTANCE_CHAT",
		["instância"] = "INSTANCE_CHAT",
		bg = "INSTANCE_CHAT",

		e = "EMOTE",
		em = "EMOTE",
		emote = "EMOTE",
		me = "EMOTE",
		eu = "EMOTE",
	}

	--[[------------------------------------------------
		BR: Normaliza comandos de barra ( / ) para comparação interna.
		EN: Normalizes slash ( / ) commands for internal comparison.
	------------------------------------------------]]--
	local function normalize_slash_command_name(command)
		command = tostring(command or "")
		command = command:gsub("^/+", "")
		command = command:gsub("^%s+", ""):gsub("%s+$", "")
		return string.lower(command)
	end

	--[[------------------------------------------------
		BR: Adiciona à tabela de comandos os aliases reais registrados pelo cliente.
			Isso permite reconhecer comandos localizados como /dizer quando o cliente os expõe.
		EN: Adds the real command aliases registered by the client to the command table.
			This allows recognizing localized commands such as /dizer when exposed by the client.
	------------------------------------------------]]--
	local function add_registered_chat_slash_commands(chatType, ...)
		for argIndex = 1, select("#", ...) do
			local prefix = select(argIndex, ...)
			for i = 1, 20 do
				local command = _G[prefix .. i]
				if not command then
					break
				end

				local normalized = normalize_slash_command_name(command)
				if normalized ~= "" then
					chat_command_types[normalized] = chatType
				end
			end
		end
	end

	add_registered_chat_slash_commands("SAY", "SLASH_SAY")
	add_registered_chat_slash_commands("YELL", "SLASH_YELL")
	add_registered_chat_slash_commands("PARTY", "SLASH_PARTY")
	add_registered_chat_slash_commands("RAID", "SLASH_RAID")
	add_registered_chat_slash_commands("RAID_WARNING", "SLASH_RAID_WARNING", "SLASH_RAIDWARN")
	add_registered_chat_slash_commands("GUILD", "SLASH_GUILD")
	add_registered_chat_slash_commands("OFFICER", "SLASH_OFFICER")
	add_registered_chat_slash_commands("INSTANCE_CHAT", "SLASH_INSTANCE_CHAT", "SLASH_INSTANCE")
	add_registered_chat_slash_commands("EMOTE", "SLASH_EMOTE", "SLASH_TEXT_EMOTE", "SLASH_ME")

	-- Retail logic
	--[[------------------------------------------------
		BR: Executa uma abreviação registrada como comando de barra ( / ) no Retail.
		    A checagem de lockdown é protegida porque a API pode não existir em todos os clientes.
		EN: Executes an alias registered as a slash command on Retail.
		    The lockdown check is guarded because the API may not exist in every client.
	------------------------------------------------]]--
	function module:execute_alias(aliasName, msg)
		if is_chat_messaging_locked_down() then
			return
		end

		local alias = self.Aliases[string.lower(aliasName)]
		if not alias or alias == "" then
			self:report_undefined_alias(aliasName)
			return
		end

		alias = Prat:ReplaceMatches(alias, 'OUTBOUND')
		msg = msg or ""

		-- Extract target command
		local newcmd = strmatch(alias, "^/*([^%s]+)") or ""
		local premsg = strsub(alias, strlen(newcmd) + 2) or ""

		if premsg ~= "" then
			msg = premsg .. (msg ~= "" and (" " .. msg) or "")
		end

		if msg and msg ~= "" then
			local fake = {}
			fake.MESSAGE = msg

			Prat.Addon:ProcessUserEnteredChat(fake)

			msg = fake.MESSAGE
		end

		local cmd = newcmd:upper()
		local lowercmd = normalize_slash_command_name(newcmd)

		--[[------------------------------------------------
			BR: Envia diretamente comandos comuns de bate-papo, como /say, /guild e /party.
			    Exemplo: uma abreviação "oi say Olá" executa /say Olá.
			EN: Directly sends common chat commands, such as /say, /guild and /party.
			    Example: an alias "hi say Hello" executes /say Hello.
		------------------------------------------------]]--
		local chatType = chat_command_types[lowercmd]
		if chatType and msg ~= "" then
			if send_chat_message_compat(msg, chatType) then
				return true
			end

			self:warn_user(PL["chat_send_unavailable_warning"])
			return false
		end

		-- Slash command
		local slashCmd = SlashCmdList[cmd]
		if slashCmd then
			slashCmd(msg)
			return
		end
		-- Chat Type
		local chatCmd = hash_ChatTypeInfoList and (hash_ChatTypeInfoList['/' .. newcmd] or hash_ChatTypeInfoList['/' .. lowercmd] or hash_ChatTypeInfoList['/' .. cmd])
		if chatCmd and ChatEdit_ChooseBoxForSend then
			local editBox = ChatEdit_ChooseBoxForSend()
			if editBox and editBox.ProcessChatType and editBox:ProcessChatType(msg, chatCmd, 1) then
				local type = editBox:GetChatType();
				local text = editBox:GetText();
				if strfind(text, "%s*[^%s]+") then
					text = ChatFrameUtil.SubstituteChatMessageBeforeSend(text)
					if type == "WHISPER" then
						local target = editBox:GetTellTarget()
						ChatFrameUtil.SetLastToldTarget(target, type)
						send_chat_message_compat(text, type, editBox.languageID, target)
					elseif type == "BN_WHISPER" then
						local target = editBox:GetTellTarget();
						local bnetIDAccount = BNet_GetBNetIDAccount(target)
						if bnetIDAccount then
							ChatFrameUtil.SetLastToldTarget(target, type)
							C_BattleNet.SendWhisper(bnetIDAccount, text)
						else
							ChatFrameUtil.DisplaySystemMessageInPrimary(format(BN_UNABLE_TO_RESOLVE_NAME, target))
						end
					elseif type == "CHANNEL" then
						send_chat_message_compat(text, type, editBox.languageID, editBox:GetChannelTarget())
					else
						send_chat_message_compat(text, type, editBox.languageID)
					end
				end
				return
			end
		end
		-- Emote
		local emoteCmd = hash_EmoteTokenList and (hash_EmoteTokenList['/' .. newcmd] or hash_EmoteTokenList['/' .. lowercmd] or hash_EmoteTokenList['/' .. cmd])
		if emoteCmd and _G.C_ChatInfo and _G.C_ChatInfo.PerformEmote then
			_G.C_ChatInfo.PerformEmote(emoteCmd, msg)
			return true
		end

		self:warn_user(string.format(PL["unknown_command_warning"], color_expansion(newcmd)))
		return false
	end

	-- Classic logic
	--[[------------------------------------------------
		BR: Intercepta comandos no fluxo clássico do chat
		EN: Intercepts commands in the classic chat flow
	------------------------------------------------]]--
	function module:ChatEdit_HandleChatType(editBox, msg, command, send)
		command = command or ""
		msg = msg or ""
		local alias = self.Aliases[string.lower(strsub(command, 2))]

		if not alias or alias == "" then
			return self.hooks["ChatEdit_HandleChatType"](editBox, msg, command, send)
		end

		alias = Prat:ReplaceMatches(alias, 'OUTBOUND')

		local newcmd = strmatch(alias, "^/*([^%s]+)") or ""
		local premsg = strsub(alias, strlen(newcmd) + 2) or ""

		if premsg ~= "" then
			msg = premsg .. ' ' .. msg
		end

		command = '/' .. string.upper(newcmd) -- this needs to be upper
		local text = string.lower(command) -- this needs to be lower

		if msg and msg ~= "" then
			local fake = {}
			fake.MESSAGE = msg

			Prat.Addon:ProcessUserEnteredChat(fake)

			msg = fake.MESSAGE
			text = text .. ' ' .. msg
		end

		if (send == 1) then
			editBox:SetText(text)
			ChatEdit_ParseText(editBox, send)
		elseif (self.db.profile.inline) then
			editBox:SetText(text .. ' ')
		end
		return true
	end

	--[[------------------------------------------------
		BR: Aliases legados preservados para compatibilidade interna/externa.
		EN: Legacy aliases preserved for internal/external compatibility.
	------------------------------------------------]]--
	module.GetAliasBuilder = module.get_alias_builder
	module.GetAliasBuilderValue = module.get_alias_builder_value
	module.SetAliasBuilderValue = module.set_alias_builder_value
	module.GetBuilderCommandValues = module.get_builder_command_values
	module.GetAliasBuilderPreview = module.get_alias_builder_preview
	module.CreateAliasFromBuilder = module.create_alias_from_builder
	module.GetAliasCommandKey = module.get_alias_command_key
	module.NormalizeAliasName = module.normalize_alias_name
	module.FindRegisteredSlashCommand = module.find_registered_slash_command
	module.RegisterAliasCommand = module.register_alias_command
	module.UnregisterAliasCommand = module.unregister_alias_command
	module.RegisterAllAliasCommands = module.register_all_alias_commands
	module.splitAliasArgs = module.split_alias_args
	module.checkArgStr = module.check_arg_str
	module.setAlias = module.set_alias
	module.delAlias = module.delete_alias
	module.showAlias = module.show_alias
	module.listAliases = module.list_aliases
	module.reportUndefinedAlias = module.report_undefined_alias
	module.tellUser = module.tell_user
	module.NumAliases = module.num_aliases
	module.GetAliasSelectValues = module.get_alias_select_values
	module.warnUser = module.warn_user
	module.ExecuteAlias = module.execute_alias

end)
