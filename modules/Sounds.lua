--[[
    @File:      Sounds.lua
    @Project:   Prat-3.0

    BR: Reprodução de sons para mensagens específicas do chat.
        - Sons separados para mensagens recebidas e enviadas
        - Suporte a grupo, raide, guilda, oficiais e sussurros
        - Suporte a sussurros Battle.net
        - Sons para líderes/guias de grupo, raide e instância
        - Canais personalizados por nome
        - Integração com LibSharedMedia

    EN: Sound playback for specific chat messages.
        - Separate sounds for incoming and outgoing messages
        - Party, raid, guild, officer and whisper support
        - Battle.net whisper support
        - Sounds for party/raid/instance leaders and guides
        - Custom channels by name
        - LibSharedMedia integration

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
        BR: Criação do módulo de sons com suporte a eventos
        EN: Creation of the sound module with event support
    ------------------------------------------------]]--
    local module = Prat:NewModule("Sounds", "AceEvent-3.0")

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

            incoming = {
                GUILD = "Kachink",
                OFFICER = "popup",
                PARTY = "Text1",
                RAID = "Text1",
                WHISPER = "Heart",
                BN_WHISPER = "Heart",
                GROUP_LEAD = "Text2",
            },

            outgoing = {
                GUILD = "None",
                OFFICER = "None",
                PARTY = "None",
                RAID = "None",
                WHISPER = "None",
                BN_WHISPER = "None",
                GROUP_LEAD = "None",
            },

            custom_list = GetLocale() == "zhTW" and {} or { ["*"] = "None" },
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

        if profile.customlist ~= nil and profile.custom_list == nil then
            profile.custom_list = profile.customlist
        end
        profile.customlist = nil

        profile.incoming = profile.incoming or {}
        profile.outgoing = profile.outgoing or {}
        profile.custom_list = profile.custom_list or (GetLocale() == "zhTW" and {} or { ["*"] = "None" })

        -- BR: Remove dados antigos inválidos herdados de versões anteriores.
        -- EN: Removes invalid old data inherited from previous versions.
        for channel_name, _ in pairs(profile.custom_list) do
            if type(channel_name) == "number" then
                profile.custom_list[channel_name] = nil
            end
        end
    end

    --[[------------------------------------------------
        BR: Referências ao LibSharedMedia e ao tipo de mídia de som
        EN: References to LibSharedMedia and the sound media type
    ------------------------------------------------]]--
    local media
    local sound_media_type

    --[[------------------------------------------------
        BR: Lista dinâmica de sons disponíveis via LibSharedMedia
        EN: Dynamic list of sounds available through LibSharedMedia
    ------------------------------------------------]]--
    local sound_list = {}

    --[[------------------------------------------------
        BR: Ativa callbacks, eventos e processamento de mensagens
        EN: Enables callbacks, events and message processing
    ------------------------------------------------]]--
    function module:OnModuleEnable()
        migrate_profile(self.db.profile)

        media = Prat.Media
        sound_media_type = media.MediaType.SOUND

        self:build_sound_list()
        self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE", "refresh_options")
        self:refresh_options()

        Prat.RegisterChatEvent(self, Prat.Events.POST_ADDMESSAGE)

        media.RegisterCallback(self, "LibSharedMedia_Registered", "shared_media_registered")
        media.RegisterCallback(self, "LibSharedMedia_SetGlobal", "shared_media_registered")

        _G.MuteSoundFile(567421)
    end

    --[[------------------------------------------------
        BR: Remove eventos/callbacks e restaura som silenciado
        EN: Removes events/callbacks and restores muted sound
    ------------------------------------------------]]--
    function module:OnModuleDisable()
        self:UnregisterAllEvents()
        Prat.UnregisterAllChatEvents(self)

        if media then
            media.UnregisterAllCallbacks(self)
        end

        _G.UnmuteSoundFile(567421)
    end

    --[[------------------------------------------------
        BR: Retorna descrição localizada do módulo
        EN: Returns localized module description
    ------------------------------------------------]]--
    function module:GetDescription()
        return PL["module_desc"]
    end

    --[[------------------------------------------------
        BR: Reconstrói a lista de sons registrados
        EN: Rebuilds the registered sound list
    ------------------------------------------------]]--
    function module:build_sound_list()
        if not media or not sound_media_type then
            return
        end

        for key, _ in pairs(sound_list) do
            sound_list[key] = nil
        end

        for key, _ in pairs(media.MediaTable[sound_media_type]) do
            sound_list[key] = key
        end
    end

    --[[------------------------------------------------
        BR: Atualiza sons quando novas mídias são registradas
        EN: Updates sounds when new media is registered
    ------------------------------------------------]]--
    function module:shared_media_registered(media_type)
        if media_type == sound_media_type then
            self:build_sound_list()
        end
    end

    do
        --[[------------------------------------------------
            BR: Modelo reutilizável para opções de seleção de som
            EN: Reusable template for sound selection options
        ------------------------------------------------]]--
        local sound_option_template = {
            __index = {
                type = "select",
                get = "get_channel_option_value",
                set = "set_channel_option_value",
                dialogControl = "LSM30_Sound",
                values = AceGUIWidgetLSMlists.sound,
                width = 1.35,
            }
        }

        --[[------------------------------------------------
            BR: Cria opção de som para tipo de mensagem recebida/enviada
            EN: Creates a sound option for incoming/outgoing message type
        ------------------------------------------------]]--
        local function new_sound_option(locale_key, incoming)
            local option = setmetatable({}, sound_option_template)

            option.name = PL[locale_key .. "_name"]
            option.desc = (PL[locale_key .. "_desc"]):format(incoming and PL["incoming"] or PL["outgoing"])

            return option
        end

        --[[------------------------------------------------
            BR: Modelo usado apenas por canais personalizados
            EN: Template used only by custom channels
        ------------------------------------------------]]--
        local custom_channel_option_template = {
            __index = {
                type = "select",
                get = "get_custom_channel_option_value",
                set = "set_custom_channel_option_value",
                dialogControl = "LSM30_Sound",
                values = AceGUIWidgetLSMlists.sound,
                width = 1.35,
            }
        }

        --[[------------------------------------------------
            BR: Opções dinâmicas para canais personalizados encontrados
            EN: Dynamic options for detected custom channels
        ------------------------------------------------]]--
        local custom_channels = {}

        --[[------------------------------------------------
            BR: Atualiza lista de canais personalizados encontrados
            EN: Updates the list of detected custom channels
        ------------------------------------------------]]--
        function module:refresh_options()
            local channels = Prat.GetChannelTable()

            for _, channel_name in pairs(channels) do
                if type(channel_name) == "string" and channel_name ~= "" then
                    if not custom_channels[channel_name] then
                        custom_channels[channel_name] = setmetatable({
                            name = channel_name,
                            desc = PL["custom_channel_desc"]:format(channel_name),
                        }, custom_channel_option_template)
                    end
                end
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
                    type = "group",
                    name = PL["overview_tab_name"],
                    desc = PL["overview_tab_desc"],
                    order = 10,
                    args = {
                        full_description = {
                            type = "description",
                            name = PL["full_description"],
                            order = 10,
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

                incoming = {
                    type = "group",
                    name = PL["incoming_tab_name"],
                    desc = PL["incoming_tab_desc"],
                    order = 100,
                    args = {
                        incoming_help = {
                            type = "description",
                            name = PL["incoming_help"],
                            order = 10,
                            width = "full",
                        },

                        party = new_sound_option("party", true),
                        raid = new_sound_option("raid", true),
                        guild = new_sound_option("guild", true),
                        officer = new_sound_option("officer", true),
                        whisper = new_sound_option("whisper", true),
                        bn_whisper = new_sound_option("bn_whisper", true),
                        group_lead = new_sound_option("group_lead", true),
                    },
                },

                outgoing = {
                    type = "group",
                    name = PL["outgoing_tab_name"],
                    desc = PL["outgoing_tab_desc"],
                    order = 200,
                    args = {
                        outgoing_help = {
                            type = "description",
                            name = PL["outgoing_help"],
                            order = 10,
                            width = "full",
                        },

                        party = new_sound_option("party", false),
                        raid = new_sound_option("raid", false),
                        guild = new_sound_option("guild", false),
                        officer = new_sound_option("officer", false),
                        whisper = new_sound_option("whisper", false),
                        bn_whisper = new_sound_option("bn_whisper", false),
                        group_lead = new_sound_option("group_lead", false),
                    },
                },

                custom_channels = {
                    type = "group",
                    name = PL["custom_channels_tab_name"],
                    desc = PL["custom_channels_tab_desc"],
                    order = 300,
                    args = {
                        custom_channels_help = {
                            type = "description",
                            name = PL["custom_channels_help"],
                            order = 10,
                            width = "full",
                        },

                        channels = {
                            type = "group",
                            name = PL["custom_channels_group_name"],
                            desc = PL["custom_channels_group_desc"],
                            inline = true,
                            order = 20,
                            args = custom_channels,
                        },
                    },
                },
            },
        })
    end

    --[[------------------------------------------------
        BR: Lê som configurado para tipo de mensagem padrão
        EN: Reads configured sound for a standard message type
    ------------------------------------------------]]--
    function module:get_channel_option_value(info)
        local group = info[#info - 1]
        local key = info[#info]:upper()

        return self.db.profile[group] and self.db.profile[group][key]
    end

    --[[------------------------------------------------
        BR: Salva e testa som para tipo de mensagem padrão
        EN: Saves and previews sound for a standard message type
    ------------------------------------------------]]--
    function module:set_channel_option_value(info, value)
        local group = info[#info - 1]
        local key = info[#info]:upper()

        Prat:PlaySound(value)

        if self.db.profile[group] then
            self.db.profile[group][key] = value
        end
    end

    --[[------------------------------------------------
        BR: Lê som configurado para canal customizado
        EN: Reads configured sound for a custom channel
    ------------------------------------------------]]--
    function module:get_custom_channel_option_value(info)
        return self.db.profile.custom_list[info[#info]]
    end

    --[[------------------------------------------------
        BR: Salva som configurado para canal customizado
        EN: Saves configured sound for a custom channel
    ------------------------------------------------]]--
    function module:set_custom_channel_option_value(info, value)
        Prat:PlaySound(value)
        self.db.profile.custom_list[info[#info]] = value
    end

    --[[------------------------------------------------
        BR: Detecta tipo de mensagem e escolhe o perfil de som correto
        EN: Detects message type and selects the correct sound profile
    ------------------------------------------------]]--
    function module:Prat_PostAddMessage(_, message, _, event)
        if message.LINE_ID and message.LINE_ID == self.last_event and self.last_event_type == event then
            return
        end

        local message_type = string.sub(event, 10)
        local player_link = message.PLAYERLINK or ""
        local player = player_link:match("([^%-]+)%-?.*")
        local outgoing = (player == UnitName("player")) and true or false
        local sound_profile = outgoing and self.db.profile.outgoing or self.db.profile.incoming

        if message_type == "CHANNEL" or message_type == "COMMUNITIES_CHANNEL" then
            local channel_name = message.ORG and message.ORG.CHANNEL and string.lower(message.ORG.CHANNEL)

            if channel_name then
                for custom_channel_name, value in pairs(self.db.profile.custom_list) do
                    if strlen(custom_channel_name) > 0 and channel_name == custom_channel_name:lower() then
                        self:play_sound(value, event, message.LINE_ID)
                    end
                end
            end
        else
            if message_type == "WHISPER_INFORM" then
                message_type = "WHISPER"
                sound_profile = self.db.profile.outgoing
            elseif message_type == "WHISPER" then
                sound_profile = self.db.profile.incoming
            end

            if message_type == "BN_WHISPER_INFORM" then
                message_type = "BN_WHISPER"
                sound_profile = self.db.profile.outgoing
            elseif message_type == "BN_WHISPER" then
                sound_profile = self.db.profile.incoming
            end

            if message_type == "PARTY_LEADER" or message_type == "RAID_LEADER" or
                message_type == "PARTY_GUIDE" or message_type == "INSTANCE_CHAT_LEADER" then
                message_type = "GROUP_LEAD"
            end

            if message_type == "INSTANCE_CHAT" then
                message_type = IsInRaid() and "RAID" or "PARTY"
            end

            if message_type == "RAID_WARNING" then
                message_type = "GROUP_LEAD"
            end

            if message_type == "GUILD_ACHIEVEMENT" or message_type == "GUILD_ITEM_LOOTED" then
                message_type = "GUILD"
            end

            self:play_sound(sound_profile[message_type], event, message.LINE_ID)
        end
    end

    --[[------------------------------------------------
        BR: Executa o som e registra último evento para evitar duplicação
        EN: Plays the sound and records the last event to avoid duplication
    ------------------------------------------------]]--
    function module:play_sound(sound, event, event_id)
        self.last_event_type = event
        self.last_event = event_id

        -- BR: Compatibilidade runtime com nomes antigos.
        -- EN: Runtime compatibility with old names.
        self.lasteventtype = self.last_event_type
        self.lastevent = self.last_event

        Prat:PlaySound(sound)
    end

    --[[------------------------------------------------
        BR: Aliases legados para reduzir risco com chamadas antigas
        EN: Legacy aliases to reduce risk from older calls
    ------------------------------------------------]]--
    module.BuildSoundList = module.build_sound_list
    module.SharedMedia_Registered = module.shared_media_registered
    module.RefreshOptions = module.refresh_options
    module.GetChanOptValue = module.get_channel_option_value
    module.SetChanOptValue = module.set_channel_option_value
    module.GetCChanOptValue = module.get_custom_channel_option_value
    module.SetCChanOptValue = module.set_custom_channel_option_value
    module.PlaySound = module.play_sound

    return
end) -- Prat:AddModuleToLoad
