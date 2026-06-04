--[[
    @File:      Fading.lua
    @Project:   Prat-3.0

    BR: Controle do esmaecimento gradual do texto do bate-papo.
        - Ativação/desativação do esmaecimento por janela
        - Configuração do tempo de visibilidade das mensagens
        - Integração automática com novas janelas de bate-papo
        - Compatibilidade com o sistema padrão da Blizzard

    EN: Chat text fading control.
        - Enable/disable fading per chat frame
        - Text visibility duration configuration
        - Automatic integration with new chat windows
        - Compatibility with Blizzard's default fading system

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
        BR: Criação do módulo de esmaecimento das mensagens
        EN: Creation of the message fading module
    ------------------------------------------------]]--
    local module = Prat:NewModule("Fading")

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
            on = true,
            text_fade = { ["*"] = true },
            duration = 120,
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

        if profile.textfade ~= nil and profile.text_fade == nil then
            profile.text_fade = profile.textfade
        end
        profile.textfade = nil

        if profile.text_fade == nil then
            profile.text_fade = { ["*"] = true }
        end

        if profile.duration == nil then
            profile.duration = 120
        end
    end

    --[[------------------------------------------------
        BR: Configuração da interface do módulo
        EN: Module interface options configuration
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

            windows = {
                type = "group",
                name = PL["windows_tab_name"],
                desc = PL["windows_tab_desc"],
                order = 100,
                args = {
                    windows_help = {
                        type = "description",
                        name = PL["windows_help"],
                        order = 10,
                        width = "full",
                    },

                    text_fade = {
                        name = PL["text_fade_name"],
                        desc = PL["text_fade_desc"],
                        type = "multiselect",
                        order = 20,
                        width = "full",
                        values = Prat.HookedFrameList,
                        get = "GetSubValue",
                        set = "SetSubValue",
                    },
                }
            },

            timing = {
                type = "group",
                name = PL["timing_tab_name"],
                desc = PL["timing_tab_desc"],
                order = 200,
                args = {
                    timing_help = {
                        type = "description",
                        name = PL["timing_help"],
                        order = 10,
                        width = "full",
                    },

                    duration = {
                        name = PL["duration_name"],
                        desc = PL["duration_desc"],
                        type = "range",
                        order = 20,
                        width = 1.2,
                        min = 1,
                        max = 240,
                        step = 1,
                    },
                }
            },
        }
    })

    --[[------------------------------------------------
        BR: Ativação do módulo e integração com atualização de frames
        EN: Module activation and frame update integration
    ------------------------------------------------]]--
    function module:OnModuleEnable()
        migrate_profile(self.db.profile)

        self:OnValueChanged()
        Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
    end

    --[[------------------------------------------------
        BR: Restaura fading padrão da Blizzard ao desabilitar o módulo
        EN: Restores Blizzard default fading when disabling the module
    ------------------------------------------------]]--
    function module:OnModuleDisable()
        for _, frame in pairs(Prat.HookedFrames) do
            self:fade(frame, true)
        end
    end

    --[[------------------------------------------------
        BR: Aplica configuração em novas janelas registradas pelo Prat
        EN: Applies configuration to newly registered Prat chat frames
    ------------------------------------------------]]--
    function module:Prat_FramesUpdated(_, name, chat_frame)
        migrate_profile(self.db.profile)

        self:fade(chat_frame, self.db.profile.text_fade[name])
    end

    --[[------------------------------------------------
        BR: Reaplica configuração em todas as janelas após alterações
        EN: Reapplies configuration to all windows after changes
    ------------------------------------------------]]--
    function module:OnValueChanged()
        migrate_profile(self.db.profile)

        for name, frame in pairs(Prat.HookedFrames) do
            self:fade(frame, self.db.profile.text_fade[name])
        end
    end

    --[[------------------------------------------------
        BR: Callback de alteração de subvalor usado pelo AceConfig
        EN: Sub-value change callback used by AceConfig
    ------------------------------------------------]]--
    module.OnSubValueChanged = module.OnValueChanged

    --[[------------------------------------------------
        BR: Aplica ou remove esmaecimento em uma janela de chat
        EN: Applies or removes fading on one chat frame
    ------------------------------------------------]]--
    function module:fade(chat_frame, text_fade)
        if text_fade then
            chat_frame:SetFading(true)
            chat_frame:SetTimeVisible(module.db.profile.duration)
        else
            chat_frame:SetFading(false)
        end
    end

    --[[------------------------------------------------
        BR: Alias legado para reduzir risco com chamadas antigas
        EN: Legacy alias to reduce risk from older calls
    ------------------------------------------------]]--
    module.Fade = module.fade

    return
end) -- Prat:AddModuleToLoad
