--[[
    @File:      ChannelNames.lua
    @Project:   Prat-3.0

    BR: Abreviação e substituição dos nomes de canais/tipos de conversa.
        - Substituição de prefixos de canais e tipos de mensagem
        - Abreviações padrão vindas do locale
        - Apelidos personalizados para canais
        - Controle de espaço e dois-pontos após abreviações
        - Criação dinâmica de opções por tipo/canal
        - Processamento direto das mensagens do Prat

    EN: Abbreviation and replacement of channel/chat type names.
        - Replacement of channel and message type prefixes
        - Default abbreviations loaded from locale
        - Custom nicknames for channels
        - Space and colon control after abbreviations
        - Dynamic per-type/channel option creation
        - Direct processing of Prat messages

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
        BR: Criação do módulo de abreviação dos nomes de canais
        EN: Creation of the channel name abbreviation module
    ------------------------------------------------]]--
    local module = Prat:NewModule("ChannelNames", "AceEvent-3.0", "AceTimer-3.0", "AceHook-3.0")

    --[[------------------------------------------------
        BR: Referência local às strings centralizadas de localização
        EN: Local reference to centralized localization strings
    ------------------------------------------------]]--
    local PL = module.PL

    --[[------------------------------------------------
        BR: Ordem visual dos tipos fixos de conversa na interface
        EN: Visual order of fixed conversation types in the interface
    ------------------------------------------------]]--
    local chat_type_order = {
        "say",
        "whisper",
        "whisperincome",
        "yell",
        "party",
        "partyleader",
        "guild",
        "officer",
        "raid",
        "raidleader",
        "raidwarning",
        "instance",
        "instanceleader",
        "bnwhisper",
        "bnwhisperincome",
        "bnconversation",
    }

    local chat_type_order_index = {}
    for order, profile_key in ipairs(chat_type_order) do
        chat_type_order_index[profile_key] = order
    end

    --[[------------------------------------------------
        BR: Compatibilidade com constantes ausentes em alguns clientes
        EN: Compatibility with constants missing in some clients
    ------------------------------------------------]]--
    if not CHAT_MSG_BN_WHISPER_INFORM then
        CHAT_MSG_BN_WHISPER_INFORM = "Outgoing Real ID Whisper"
    end

    if not CHAT_MSG_INSTANCE_CHAT then
        CHAT_MSG_INSTANCE_CHAT = INSTANCE_CHAT_MESSAGE
    end

    if not CHAT_MSG_INSTANCE_CHAT_LEADER then
        CHAT_MSG_INSTANCE_CHAT_LEADER = INSTANCE_CHAT_LEADER
    end

    --[[------------------------------------------------
        BR: Mapa entre eventos Blizzard e chaves internas de perfil
        EN: Map between Blizzard events and internal profile keys
    ------------------------------------------------]]--
    local event_to_profile_key = {
        CHAT_MSG_CHANNEL1 = "channel1",
        CHAT_MSG_CHANNEL2 = "channel2",
        CHAT_MSG_CHANNEL3 = "channel3",
        CHAT_MSG_CHANNEL4 = "channel4",
        CHAT_MSG_CHANNEL5 = "channel5",
        CHAT_MSG_CHANNEL6 = "channel6",
        CHAT_MSG_CHANNEL7 = "channel7",
        CHAT_MSG_CHANNEL8 = "channel8",
        CHAT_MSG_CHANNEL9 = "channel9",
        CHAT_MSG_SAY = "say",
        CHAT_MSG_GUILD = "guild",
        CHAT_MSG_WHISPER = "whisperincome",
        CHAT_MSG_WHISPER_INFORM = "whisper",
        CHAT_MSG_BN_WHISPER = "bnwhisperincome",
        CHAT_MSG_BN_WHISPER_INFORM = "bnwhisper",
        CHAT_MSG_YELL = "yell",
        CHAT_MSG_PARTY = "party",
        CHAT_MSG_PARTY_LEADER = "partyleader",
        CHAT_MSG_OFFICER = "officer",
        CHAT_MSG_RAID = "raid",
        CHAT_MSG_RAID_LEADER = "raidleader",
        CHAT_MSG_RAID_WARNING = "raidwarning",
        CHAT_MSG_INSTANCE_CHAT = "instance",
        CHAT_MSG_INSTANCE_CHAT_LEADER = "instanceleader",
        CHAT_MSG_BN_CONVERSATION = "bnconversation",
    }

    --[[------------------------------------------------
        BR: Utilitário de cor para destacar opções conforme o tipo de conversa
        EN: Color utility for displaying options according to chat type color
    ------------------------------------------------]]--
    local CLR = Prat.CLR

    --[[------------------------------------------------
        BR: Configuração dos valores padrão do módulo
        EN: Module default values configuration
    ------------------------------------------------]]--
    Prat:SetModuleDefaults(module.name, {
        profile = {
            on = true,
            space = true,
            colon = true,
            -- channel_link legacy option removed: channel links are not used by the current implementation.
            replace = {
                say = true,
                whisper = true,
                whisperincome = true,
                bnwhisper = true,
                bnwhisperincome = true,
                yell = true,
                party = true,
                partyleader = true,
                guild = true,
                officer = true,
                raid = true,
                raidleader = true,
                raidwarning = true,
                instance = true,
                instanceleader = true,
                channel1 = true,
                channel2 = true,
                channel3 = true,
                channel4 = true,
                channel5 = true,
                channel6 = true,
                channel7 = true,
                channel8 = true,
                channel9 = true,
                channel10 = true,
            },
            channel_save = {},
            short_names = {
                say = PL["short_say"],
                whisper = PL["short_whisper"],
                whisperincome = PL["short_whisper_incoming"],
                bnwhisper = PL["short_bn_whisper"],
                bnwhisperincome = PL["short_bn_whisper_incoming"],
                yell = PL["short_yell"],
                party = PL["short_party"],
                partyleader = PL["short_party_leader"],
                guild = PL["short_guild"],
                officer = PL["short_officer"],
                raid = PL["short_raid"],
                raidleader = PL["short_raid_leader"],
                raidwarning = PL["short_raid_warning"],
                instance = PL["short_instance"],
                instanceleader = PL["short_instance_leader"],
                channel1 = PL["short_channel_1"],
                channel2 = PL["short_channel_2"],
                channel3 = PL["short_channel_3"],
                channel4 = PL["short_channel_4"],
                channel5 = PL["short_channel_5"],
                channel6 = PL["short_channel_6"],
                channel7 = PL["short_channel_7"],
                channel8 = PL["short_channel_8"],
                channel9 = PL["short_channel_9"],
                channel10 = PL["short_channel_10"],
            },
            nicknames = {}
        }
    })

    --[[------------------------------------------------
        BR: Contêineres dinâmicos para tipos, canais numerados e apelidos
        EN: Dynamic containers for chat types, numbered channels and nicknames
    ------------------------------------------------]]--
    local chat_type_options = {}
    local numbered_channel_options = {}
    local nickname_options = {}

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
            channel_types = {
                name = PL["channel_types_tab_name"],
                desc = PL["channel_types_tab_desc"],
                type = "group",
                childGroups = "tab",
                order = 1,
                args = {
                    chat_types = {
                        type = "group",
                        name = PL["chat_types_group_name"],
                        desc = PL["chat_types_group_desc"],
                        childGroups = "select",
                        order = 10,
                        args = chat_type_options,
                    },

                    numbered_channels = {
                        type = "group",
                        name = PL["numbered_channels_group_name"],
                        desc = PL["numbered_channels_group_desc"],
                        childGroups = "select",
                        order = 20,
                        args = numbered_channel_options,
                    },
                }
            },

            channel_nicknames = {
                name = PL["channel_nicknames_tab_name"],
                desc = PL["channel_nicknames_tab_desc"],
                order = 2,
                type = "group",
                childGroups = "select",
                args = {
                    custom_nicknames = {
                        type = "group",
                        name = PL["custom_nicknames_group_name"],
                        desc = PL["custom_nicknames_group_desc"],
                        childGroups = "select",
                        order = 10,
                        args = nickname_options,
                    },
                }
            },

            format_options = {
                name = PL["format_options_tab_name"],
                desc = PL["format_options_tab_desc"],
                order = 3,
                type = "group",
                args = {
                    format_group = {
                        type = "group",
                        name = PL["format_group_name"],
                        desc = PL["format_group_desc"],
                        inline = true,
                        order = 10,
                        args = {
                            space = {
                                name = PL["space_name"],
                                desc = PL["space_desc"],
                                type = "toggle",
                                order = 10,
                                width = 1.10,
                            },

                            format_spacer = {
                                type = "description",
                                name = " ",
                                order = 15,
                                width = 0.15,
                            },

                            colon = {
                                name = PL["colon_name"],
                                desc = PL["colon_desc"],
                                type = "toggle",
                                order = 20,
                                width = 1.10,
                            },
                        }
                    }
                }
            },
        }
    })


    --[[------------------------------------------------
        BR: Migra nomes antigos de perfil para o padrão atual
        EN: Migrates old profile names to the current standard
    ------------------------------------------------]]--
    function module:migrate_profile()
        local profile = self.db and self.db.profile
        if not profile then
            return
        end

        if profile.short_names == nil and profile.shortnames ~= nil then
            profile.short_names = profile.shortnames
        end

        if profile.nicknames == nil and profile.nickname ~= nil then
            profile.nicknames = profile.nickname
        end

        if profile.channel_save == nil and profile.chanSave ~= nil then
            profile.channel_save = profile.chanSave
        end
    end

    --[[------------------------------------------------
        BR: Ativa eventos e processamento das mensagens de canal
        EN: Enables events and channel message processing
    ------------------------------------------------]]--
    function module:OnModuleEnable()
        self:migrate_profile()
        self:build_channel_options()
        self:RegisterEvent("UPDATE_CHAT_COLOR", "refresh_options")
        self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")

        Prat.RegisterChatEvent(self, "Prat_FrameMessage")

        Prat.EnableProcessingForEvent("CHAT_MSG_CHANNEL_NOTICE")
        Prat.EnableProcessingForEvent("CHAT_MSG_CHANNEL_NOTICE_USER")
        Prat.EnableProcessingForEvent("CHAT_MSG_CHANNEL_LEAVE")
        Prat.EnableProcessingForEvent("CHAT_MSG_CHANNEL_JOIN")
    end

    --[[------------------------------------------------
        BR: Remove eventos e processamento do módulo
        EN: Removes module events and processing
    ------------------------------------------------]]--
    function module:OnModuleDisable()
        self:UnregisterAllEvents()
        Prat.UnregisterAllChatEvents(self)
    end

    --[[------------------------------------------------
        BR: Retorna descrição localizada do módulo
        EN: Returns localized module description
    ------------------------------------------------]]--
    function module:GetDescription()
        return PL["module_desc"]
    end

    --[[------------------------------------------------
        BR: Recria opções quando canais entram/saem/alteram estado
        EN: Rebuilds options when channels join/leave/change state
    ------------------------------------------------]]--
    function module:CHAT_MSG_CHANNEL_NOTICE()
        self:build_channel_options()
        self:refresh_options()
    end

    --[[------------------------------------------------
        BR: Notifica AceConfig para atualizar a interface do Prat
        EN: Notifies AceConfig to refresh the Prat interface
    ------------------------------------------------]]--
    function module:refresh_options()
        LibStub("AceConfigRegistry-3.0"):NotifyChange("Prat")
    end

    --[[------------------------------------------------
        BR: Define apelido personalizado para o canal selecionado
        EN: Defines a custom nickname for the selected channel
    ------------------------------------------------]]--
    function module:add_nickname(info, nickname)
        self.db.profile.nicknames[info[#info - 1]] = nickname
    end

    --[[------------------------------------------------
        BR: Remove apelido personalizado do canal selecionado
        EN: Removes the custom nickname from the selected channel
    ------------------------------------------------]]--
    function module:remove_nickname(info)
        if self.db.profile.nicknames[info[#info - 1]] then
            self.db.profile.nicknames[info[#info - 1]] = nil
        end
    end

    --[[------------------------------------------------
        BR: Lê apelido personalizado do canal selecionado
        EN: Reads the custom nickname from the selected channel
    ------------------------------------------------]]--
    function module:get_nickname(info)
        return self.db.profile.nicknames[info[#info - 1]]
    end

    --[[------------------------------------------------
        BR: Informa se o canal ainda não possui apelido personalizado
        EN: Reports whether the channel has no custom nickname yet
    ------------------------------------------------]]--
    function module:has_no_nickname(info)
        return self:get_nickname(info) == nil
    end

    module.not_get_nickname = module.has_no_nickname
    module.NotGetNickname = module.has_no_nickname -- Legacy alias.
    module.GetNickname = module.get_nickname -- Legacy alias.
    module.HasNoNickname = module.has_no_nickname -- Legacy alias.

    --[[------------------------------------------------
        BR: Lê valor interno das opções de abreviação/substituição
        EN: Reads internal abbreviation/replacement option values
    ------------------------------------------------]]--
    function module:get_channel_option_value(info)
        return self.db.profile[info[#info]][info[#info - 1]]
    end

    --[[------------------------------------------------
        BR: Salva valor interno das opções de abreviação/substituição
        EN: Saves internal abbreviation/replacement option values
    ------------------------------------------------]]--
    function module:set_channel_option_value(info, value)
        self.db.profile[info[#info]][info[#info - 1]] = value
    end

    module.GetChanOptValue = module.get_channel_option_value -- Legacy alias.
    module.SetChanOptValue = module.set_channel_option_value -- Legacy alias.
    module.GetChannelOptionValue = module.get_channel_option_value -- Legacy alias.
    module.SetChannelOptionValue = module.set_channel_option_value -- Legacy alias.

    --[[------------------------------------------------
        BR: Recupera o evento Blizzard a partir da chave interna do perfil
        EN: Retrieves the Blizzard event from the internal profile key
    ------------------------------------------------]]--
    local function get_event_from_profile_key(profile_key)
        for event_name, key in pairs(event_to_profile_key) do
            if profile_key == key then
                return event_name
            end
        end
    end

    --[[------------------------------------------------
        BR: Obtém cor hexadecimal do tipo de conversa
        EN: Gets the hexadecimal color of the chat type
    ------------------------------------------------]]--
    local function get_chat_color(event_name)
        if event_name == nil then
            return CLR.COLOR_NONE
        end

        local chat_type = strsub(event_name, 10)
        local info = ChatTypeInfo[chat_type]
        if not info then
            return CLR.COLOR_NONE
        end

        return CLR:GetHexColor(info)
    end

    --[[------------------------------------------------
        BR: Aplica cor ao rótulo exibido nas opções
        EN: Applies color to the label shown in options
    ------------------------------------------------]]--
    local function colorize_chat_label(text, event_name)
        return CLR:Colorize(get_chat_color(event_name), text)
    end

    --[[------------------------------------------------
        BR: Retorna rótulo localizado de um tipo fixo de conversa
        EN: Returns the localized label for a fixed chat type
    ------------------------------------------------]]--
    local function get_chat_type_label(profile_key)
        local event_name = get_event_from_profile_key(profile_key)

        if profile_key == "bnwhisper" then
            return PL["bn_whisper_label"], event_name
        elseif profile_key == "bnwhisperincome" then
            return PL["bn_whisper_incoming_label"], event_name
        elseif profile_key == "bnconversation" then
            return PL["bn_conversation_label"], event_name
        end

        return _G[event_name] or profile_key, event_name
    end

    --[[------------------------------------------------
        BR: Retorna rótulo localizado de um canal numerado
        EN: Returns the localized label for a numbered channel
    ------------------------------------------------]]--
    local function get_numbered_channel_label(profile_key)
        local number = profile_key:match("%d+$") or ""
        local event_name = get_event_from_profile_key(profile_key)
        return (PL["channel_number_name"]):format(number), event_name
    end

    --[[------------------------------------------------
        BR: Cria os controles comuns de abreviação e substituição
        EN: Creates common abbreviation and replacement controls
    ------------------------------------------------]]--
    local function create_replacement_controls(label_provider)
        return {
            selected_type_help = {
                type = "description",
                name = PL["selected_type_help"],
                order = 5,
                width = "full",
            },

            short_names = {
                name = PL["replacement_text_name"],
                desc = function(info)
                    local label, event_name = label_provider(info[#info - 1])
                    return (PL["short_name_desc"]):format(colorize_chat_label(label, event_name))
                end,
                order = 10,
                type = "input",
                usage = "<string>",
                width = 1.35,
            },

            replacement_spacer = {
                type = "description",
                name = " ",
                order = 15,
                width = 0.20,
            },

            replace = {
                name = PL["replace_name"],
                desc = PL["replace_desc"],
                type = "toggle",
                order = 20,
                width = 1.15,
            },
        }
    end

    --[[------------------------------------------------
        BR: Cria opção dinâmica para um tipo fixo de conversa
        EN: Creates a dynamic option for a fixed chat type
    ------------------------------------------------]]--
    function module:create_type_option(args, profile_key)
        if args[profile_key] then
            return
        end

        args[profile_key] = {
            type = "group",
            name = function(info)
                local label, event_name = get_chat_type_label(info[#info])
                return colorize_chat_label(label, event_name)
            end,
            desc = function(info)
                local label = get_chat_type_label(info[#info])
                return (PL["chat_type_settings_desc"]):format(label)
            end,
            order = chat_type_order_index[profile_key] or 100,
            get = "get_channel_option_value",
            set = "set_channel_option_value",
            args = create_replacement_controls(get_chat_type_label),
        }
    end

    --[[------------------------------------------------
        BR: Cria opção dinâmica para um canal numerado
        EN: Creates a dynamic option for a numbered channel
    ------------------------------------------------]]--
    function module:create_channel_option(args, profile_key)
        if args[profile_key] then
            return
        end

        args[profile_key] = {
            type = "group",
            name = function(info)
                local label, event_name = get_numbered_channel_label(info[#info])
                return colorize_chat_label(label, event_name)
            end,
            desc = function(info)
                local label, event_name = get_numbered_channel_label(info[#info])
                return (PL["chat_type_settings_desc"]):format(colorize_chat_label(label, event_name))
            end,
            order = function(info)
                return 200 + tonumber(info[#info]:match("%d+$") or 0)
            end,
            get = "get_channel_option_value",
            set = "set_channel_option_value",
            args = create_replacement_controls(get_numbered_channel_label),
        }
    end

    --[[------------------------------------------------
        BR: Cria grupo de opção para apelido de um canal específico
        EN: Creates an option group for a specific channel nickname
    ------------------------------------------------]]--
    function module:create_channel_nickname_option(args, channel_name)
        args[channel_name] = args[channel_name] or {
            name = channel_name,
            desc = string.format(PL["channel_nickname_settings_desc"], channel_name),
            type = "group",
            order = 228,
            args = {
                add_nick = {
                    name = PL["add_nick_name"],
                    desc = PL["add_nick_desc"],
                    type = "input",
                    order = 10,
                    usage = "<string>",
                    width = 1.35,
                    get = "get_nickname",
                    set = "add_nickname",
                },

                nickname_spacer = {
                    type = "description",
                    name = " ",
                    order = 15,
                    width = 0.15,
                },

                remove_nick = {
                    name = PL["remove_nick_name"],
                    desc = PL["remove_nick_desc"],
                    type = "execute",
                    order = 20,
                    width = 1.10,
                    func = "remove_nickname",
                    disabled = "has_no_nickname",
                },
            }
        }
    end

    module.CreateChanNickOption = module.create_channel_nickname_option -- Legacy alias.
    module.CreateChannelNicknameOption = module.create_channel_nickname_option -- Legacy alias.

    --[[------------------------------------------------
        BR: Constrói opções dinâmicas para tipos, canais e apelidos
        EN: Builds dynamic options for types, channels and nicknames
    ------------------------------------------------]]--
    function module:build_channel_options()
        for _, profile_key in ipairs(chat_type_order) do
            self:create_type_option(chat_type_options, profile_key)
        end

        for i = 1, 9 do
            self:create_channel_option(numbered_channel_options, "channel" .. i)
        end

        local channels = Prat.GetChannelTable()
        for _, channel_name in pairs(channels) do
            if type(channel_name) == "string" then
                self:create_channel_nickname_option(nickname_options, channel_name)
            end
        end
    end

    --[[------------------------------------------------
        BR: Resolve a chave de perfil a partir do evento recebido
        EN: Resolves the profile key from the received event
    ------------------------------------------------]]--
    local function get_profile_key_from_message_event(event_name, channel_number)
        if event_name == "CHAT_MSG_BN_CONVERSATION" then
            return event_to_profile_key[event_name]
        end

        return event_to_profile_key[event_name .. (channel_number or "")]
    end

    --[[------------------------------------------------
        BR: Aplica apelido personalizado ao canal da mensagem
        EN: Applies a custom nickname to the message channel
    ------------------------------------------------]]--
    local function apply_channel_nickname(module_instance, message)
        if issecretvalue and issecretvalue(message.CHANNEL) then
            return false
        end

        local nickname = module_instance.db.profile.nicknames[message.CHANNEL]
        if not nickname then
            return false
        end

        message.CHANNEL = nickname

        if message.CHANNEL:sub(1, 1) == "#" then
            message.CHANNEL = message.CHANNEL:sub(2)
        else
            message.CHANNELNUM, message.CC = "", ""
        end

        return true
    end

    --[[------------------------------------------------
        BR: Aplica abreviação configurada ao prefixo da mensagem
        EN: Applies configured abbreviation to the message prefix
    ------------------------------------------------]]--
    local function apply_channel_replacement(module_instance, message, profile_key)
        if not profile_key or not module_instance.db.profile.replace[profile_key] then
            return
        end

        message.cC, message.CHANNELNUM, message.CC, message.CHANNEL, message.Cc, message.CHANLINK = "", "", "", "", "", ""

        local short_name = module_instance.db.profile.short_names[profile_key] or ""
        local add_space = module_instance.db.profile.space and short_name ~= "" and " " or ""
        local add_colon = ""

        if module_instance.db.profile.colon then
            if message.PLAYER then
                add_colon = ":"
            elseif message.PLAYERLINK:len() > 0 and message.MESSAGE:len() > 0 then
                add_colon = ":"
            end
        end

        message.TYPEPREFIX = short_name

        if message.TYPEPREFIX:len() == 0 then
            message.nN, message.NN, message.Nn, message.CHANLINK = "", "", "", ""
        end

        message.TYPEPREFIX = message.TYPEPREFIX .. add_space

        if message.PLAYER or message.PLAYERLINK:len() > 0 then
            message.TYPEPOSTFIX = add_colon ~= "" and ": " or " "
        else
            message.TYPEPOSTFIX = ""
        end
    end

    --[[------------------------------------------------
        BR: Processa a mensagem e substitui prefixos/canais conforme configuração
        EN: Processes the message and replaces prefixes/channels as configured
    ------------------------------------------------]]--
    function module:Prat_FrameMessage(_, message, _, event_name)
        if event_name == "CHAT_MSG_CHANNEL_JOIN" or event_name == "CHAT_MSG_CHANNEL_LEAVE" then
            message.MESSAGE = message.ORG.TYPEPOSTFIX:trim()
            message.ORG.TYPEPOSTFIX = " "
        end

        if event_name == "CHAT_MSG_CHANNEL_NOTICE"
            or event_name == "CHAT_MSG_CHANNEL_NOTICE_USER"
            or event_name == "CHAT_MSG_CHANNEL_JOIN"
            or event_name == "CHAT_MSG_CHANNEL_LEAVE" then
            event_name = "CHAT_MSG_CHANNEL"
        end

        local profile_key = get_profile_key_from_message_event(event_name, message.CHANNELNUM)

        if not apply_channel_nickname(self, message) then
            apply_channel_replacement(self, message, profile_key)
        end
    end

    return
end)
