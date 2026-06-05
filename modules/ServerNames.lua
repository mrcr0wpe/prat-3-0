--[[
    @File:      ServerNames.lua
    @Project:   Prat-3.0

    BR: Controle de exibição dos nomes de reinos/servidores no bate-papo.
        - Ocultação do nome do reino
        - Abreviação automática do nome do reino
        - Cores aleatórias por reino
        - Substituições e configurações por reino detectado
        - Processamento antes da mensagem ser adicionada ao bate-papo

    EN: Chat realm/server name display control.
        - Realm name hiding
        - Automatic realm name abbreviation
        - Random color per realm
        - Per-realm replacements and settings
        - Processing before the message is added to chat

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

Prat:AddModuleToLoad(function()
    local module = Prat:NewModule("ServerNames")
    local PL = module.PL

    Prat:SetModuleDefaults(module.name, {
        profile = {
            on = true,
            space = true,
            colon = true,
            auto_abbreviate = true,
            hide = false,
            server_options = {
                ["*"] = {
                    replace = false,
                    custom_color = false,
                    short_name = "",
                    color = { r = 0.65, g = 0.65, b = 0.65, a = 1 },
                },
            },
            random_color = true,
        }
    })

    local detected_server_options = {}
    local CLR = Prat.CLR
    local key_to_full_name_map = {}
    local full_name_to_key_map = {}

    --[[------------------------------------------------
        BR: Migra nomes antigos de profile para o padrão snake_case
        EN: Migrates old profile names to the snake_case standard
    ------------------------------------------------]]--
    local function migrate_profile(profile)
        if not profile then
            return
        end

        if profile.auto_abbreviate == nil and profile.autoabbreviate ~= nil then
            profile.auto_abbreviate = profile.autoabbreviate
        end

        if profile.random_color == nil and profile.randomclr ~= nil then
            profile.random_color = profile.randomclr
        end

        if profile.server_options == nil and profile.serveropts ~= nil then
            profile.server_options = profile.serveropts
        end

        profile.server_options = profile.server_options or {}

        for server_key, options in pairs(profile.server_options) do
            if type(options) == "table" then
                if options.custom_color == nil and options.customcolor ~= nil then
                    options.custom_color = options.customcolor
                end

                if options.short_name == nil and options.shortname ~= nil then
                    options.short_name = options.shortname
                end

                options.color = options.color or { r = 0.65, g = 0.65, b = 0.65, a = 1 }
            end
        end
    end

    --[[------------------------------------------------
        BR: Cria uma cor formatada para um nome de reino
        EN: Creates a formatted colorized realm name
    ------------------------------------------------]]--
    local function format_server_color(server_key, text)
        return CLR:Colorize(module:GetServerCLR(server_key), text or server_key)
    end

    --[[------------------------------------------------
        BR: Registra um reino detectado e cria suas opções dinâmicas
        EN: Registers a detected realm and creates its dynamic options
    ------------------------------------------------]]--
    function module:add_server(server)
        if server and strlen(server) > 0 then
            local key = server:gsub(" ", ""):lower()

            full_name_to_key_map[server] = key
            key_to_full_name_map[key] = key_to_full_name_map[key] or server

            self:create_server_option(key, key_to_full_name_map[key])
        end
    end

    --[[------------------------------------------------
        BR: Obtém a chave normalizada de um reino
        EN: Gets the normalized key for a realm
    ------------------------------------------------]]--
    function module:get_server_key(server)
        local key = full_name_to_key_map[server]

        if key == nil then
            self:add_server(server)
            key = full_name_to_key_map[server]
        end

        return key
    end

    --[[------------------------------------------------
        BR: Obtém/cria as configurações persistidas de um reino
        EN: Gets/creates persisted settings for a realm
    ------------------------------------------------]]--
    function module:get_server_settings(server_key)
        local profile = self.db.profile
        profile.server_options = profile.server_options or {}

        local options = profile.server_options[server_key]

        if not options then
            profile.server_options[server_key] = {
                replace = false,
                custom_color = false,
                short_name = "",
                color = { r = 0.65, g = 0.65, b = 0.65, a = 1 },
            }

            options = profile.server_options[server_key]
        end

        if options.custom_color == nil and options.customcolor ~= nil then
            options.custom_color = options.customcolor
        end

        if options.short_name == nil and options.shortname ~= nil then
            options.short_name = options.shortname
        end

        options.color = options.color or { r = 0.65, g = 0.65, b = 0.65, a = 1 }

        return options
    end

    --[[------------------------------------------------
        BR: Obtém uma opção dinâmica de reino para AceConfig
        EN: Gets a dynamic realm option for AceConfig
    ------------------------------------------------]]--
    function module:get_server_option(info)
        local server_key = info[#info - 1]
        local option_key = info[#info]
        local options = self:get_server_settings(server_key)

        return options[option_key]
    end

    --[[------------------------------------------------
        BR: Define uma opção dinâmica de reino para AceConfig
        EN: Sets a dynamic realm option for AceConfig
    ------------------------------------------------]]--
    function module:set_server_option(info, value)
        local server_key = info[#info - 1]
        local option_key = info[#info]
        local options = self:get_server_settings(server_key)

        options[option_key] = value
    end

    --[[------------------------------------------------
        BR: Obtém a cor configurada de um reino
        EN: Gets the configured color for a realm
    ------------------------------------------------]]--
    function module:get_server_color(info)
        local server_key = info[#info - 1]
        local options = self:get_server_settings(server_key)
        local color = options.color

        return color.r, color.g, color.b, color.a
    end

    --[[------------------------------------------------
        BR: Define a cor configurada de um reino
        EN: Sets the configured color for a realm
    ------------------------------------------------]]--
    function module:set_server_color(info, r, g, b, a)
        local server_key = info[#info - 1]
        local options = self:get_server_settings(server_key)

        options.color = options.color or {}
        options.color.r, options.color.g, options.color.b, options.color.a = r, g, b, a
    end

    --[[------------------------------------------------
        BR: Cria as opções dinâmicas para um reino detectado
        EN: Creates dynamic options for a detected realm
    ------------------------------------------------]]--
    function module:create_server_option(server_key, server_name)
        if not server_key or detected_server_options[server_key] then
            return
        end

        detected_server_options[server_key] = {
            type = "group",
            name = server_name or server_key,
            desc = (PL["server_settings_desc"]):format(server_name or server_key),
            order = function(info)
                return tostring(server_name or server_key)
            end,
            get = "get_server_option",
            set = "set_server_option",
            args = {
                info = {
                    type = "description",
                    name = (PL["server_selected_help"]):format(server_name or server_key),
                    order = 5,
                    width = "full",
                },

                replace = {
                    type = "toggle",
                    name = PL["replace_name"],
                    desc = PL["replace_desc"],
                    order = 10,
                    width = 1.20,
                },

                server_spacer_a = {
                    type = "description",
                    name = " ",
                    order = 15,
                    width = 0.15,
                },

                short_name = {
                    type = "input",
                    name = PL["short_name_name"],
                    desc = PL["short_name_desc"],
                    order = 20,
                    width = 1.30,
                    usage = "<string>",
                    disabled = function(info)
                        local server_settings = module:get_server_settings(info[#info - 1])
                        return not server_settings.replace
                    end,
                },

                custom_color = {
                    type = "toggle",
                    name = PL["custom_color_name"],
                    desc = PL["custom_color_desc"],
                    order = 30,
                    width = 1.20,
                },

                server_spacer_b = {
                    type = "description",
                    name = " ",
                    order = 35,
                    width = 0.15,
                },

                color = {
                    type = "color",
                    name = PL["color_name"],
                    desc = PL["color_desc"],
                    order = 40,
                    width = 1.30,
                    get = "get_server_color",
                    set = "set_server_color",
                    disabled = function(info)
                        local server_settings = module:get_server_settings(info[#info - 1])
                        return not server_settings.custom_color
                    end,
                },
            }
        }

        LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")
    end

    Prat:SetModuleOptions(module.name, {
        name = PL["module_name"],
        desc = PL["module_desc"],
        type = "group",
        childGroups = "tab",
        args = {
            behavior = {
                type = "group",
                name = PL["behavior_tab_name"],
                desc = PL["behavior_tab_desc"],
                order = 100,
                args = {
                    behavior_group = {
                        type = "group",
                        name = PL["behavior_group_name"],
                        desc = PL["behavior_group_desc"],
                        inline = true,
                        order = 10,
                        args = {
                            hide = {
                                type = "toggle",
                                name = PL["hide_name"],
                                desc = PL["hide_desc"],
                                order = 10,
                                width = 1.15,
                            },

                            behavior_spacer_a = {
                                type = "description",
                                name = " ",
                                order = 15,
                                width = 0.15,
                            },

                            auto_abbreviate = {
                                type = "toggle",
                                name = PL["auto_abbreviate_name"],
                                desc = PL["auto_abbreviate_desc"],
                                order = 20,
                                width = 1.25,
                                disabled = function(info)
                                    return info.handler.db.profile.hide
                                end,
                            },

                            random_color = {
                                type = "toggle",
                                name = PL["random_color_name"],
                                desc = PL["random_color_desc"],
                                order = 30,
                                width = 1.15,
                                disabled = function(info)
                                    return info.handler.db.profile.hide
                                end,
                            },
                        }
                    },

                    behavior_help = {
                        type = "description",
                        name = PL["behavior_help"],
                        order = 20,
                        width = "full",
                    },
                }
            },

            detected_servers = {
                type = "group",
                name = PL["detected_servers_tab_name"],
                desc = PL["detected_servers_tab_desc"],
                order = 200,
                childGroups = "select",
                args = detected_server_options,
            },
        }
    })

    function module:OnModuleEnable()
        migrate_profile(self.db and self.db.profile)
        Prat.RegisterChatEvent(self, "Prat_PreAddMessage")
    end

    function module:OnModuleDisable()
        Prat.UnregisterAllChatEvents(self)
    end

    function module:GetDescription()
        return PL["module_desc"]
    end

    function module:Prat_PreAddMessage(_, message)
        local server_key = self:get_server_key(message.SERVER)
        local options = server_key and self:get_server_settings(server_key)

        if options and options.replace then
            message.SERVER = options.short_name
        end

        if self.db.profile.hide then
            message.SERVER = ""
        end

        if message.SERVER and strlen(message.SERVER) > 0 then
            message.SERVER = self:format_server(message.SERVER, server_key)
        end

        if not (message.SERVER and strlen(message.SERVER) > 0) then
            local split_message = Prat.SplitMessage
            split_message.SERVER, split_message.sS, split_message.Ss = "", "", ""
        end
    end

    --[[------------------------------------------------
        BR: Formata o nome de reino para exibição no chat
        EN: Formats the realm name for chat display
    ------------------------------------------------]]--
    function module:format_server(server, server_key)
        if server == nil then
            server = key_to_full_name_map[server_key]
        elseif server_key == nil then
            server_key = self:get_server_key(server)
        end

        if server == nil or server_key == nil then
            return
        end

        if self.db.profile.auto_abbreviate then
            server = server:match("^([%a\192-\255]?[\128-\191]*[%a\192-\255]?[\128-\191]*[%a\192-\255]?[\128-\191]*)")
        end

        return format_server_color(server_key, server)
    end

    local server_hashes = setmetatable({}, {
        __mode = "kv",
        __index = function(t, k)
            t[k] = CLR:GetHashColor(k)
            return t[k]
        end
    })

    local server_colors = setmetatable({}, {
        __mode = "kv",
        __index = function(t, k)
            t[k] = CLR:GetHexColor(k)
            return t[k]
        end
    })

    --[[------------------------------------------------
        BR: Retorna a cor final de um reino
        EN: Returns the final color for a realm
    ------------------------------------------------]]--
    function module:get_server_clr(server)
        local server_key = self:get_server_key(server)

        if server_key then
            local options = self:get_server_settings(server_key)

            if options and options.custom_color then
                return server_colors[options.color]
            elseif self.db.profile.random_color then
                return server_hashes[server_key]
            end
        end

        return CLR.COLOR_NONE
    end

    --[[------------------------------------------------
        BR: Aliases legados preservados por compatibilidade entre módulos
        EN: Legacy aliases preserved for cross-module compatibility
    ------------------------------------------------]]--
    module.AddServer = module.add_server
    module.GetServerKey = module.get_server_key
    module.GetServerSettings = module.get_server_settings
    module.GetServerOption = module.get_server_option
    module.SetServerOption = module.set_server_option
    module.GetServerColor = module.get_server_color
    module.SetServerColor = module.set_server_color
    module.CreateServerOption = module.create_server_option
    module.FormatServer = module.format_server
    module.GetServerCLR = module.get_server_clr

    return
end) -- Prat:AddModuleToLoad
