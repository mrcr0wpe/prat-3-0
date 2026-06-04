--[[
    @File:      Highlight.lua
    @Project:   Prat-3.0

    BR: Destaque visual para o próprio nome e possíveis nomes de guilda.
        - Destaca o nome do jogador no chat
        - Destaca textos entre < > como possíveis nomes de guilda
        - Usa o sistema de patterns do Prat
        - Mantém prioridades originais dos padrões

    EN: Visual highlight for the player's name and possible guild names.
        - Highlights the player's name in chat
        - Highlights text between < > as possible guild names
        - Uses Prat's pattern system
        - Preserves original pattern priorities

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
        BR: Criação do módulo de destaque visual
        EN: Creation of the visual highlight module
    ------------------------------------------------]]--
    local module = Prat:NewModule("Highlight")

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
            player = true,
            guild = true,
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

            highlights = {
                type = "group",
                name = PL["highlights_tab_name"],
                desc = PL["highlights_tab_desc"],
                order = 100,
                args = {
                    highlights_help = {
                        type = "description",
                        name = PL["highlights_help"],
                        order = 10,
                        width = "full",
                    },

                    player = {
                        type = "toggle",
                        name = PL["player_name"],
                        desc = PL["player_desc"],
                        order = 20,
                        width = 1.30,
                    },

                    highlight_spacer = {
                        type = "description",
                        name = " ",
                        order = 25,
                        width = 0.15,
                    },

                    guild = {
                        type = "toggle",
                        name = PL["guild_name"],
                        desc = PL["guild_desc"],
                        order = 30,
                        width = 1.30,
                    },
                },
            },
        },
    })

    --[[------------------------------------------------
        BR: Retorna descrição localizada do módulo
        EN: Returns localized module description
    ------------------------------------------------]]--
    function module:GetDescription()
        return PL["module_desc"]
    end

    --[[------------------------------------------------
        BR: Utilitário de cores do Prat
        EN: Prat color utility
    ------------------------------------------------]]--
    local CLR = Prat.CLR

    --[[------------------------------------------------
        BR: Coloriza os sinais < > usados no destaque de guilda
        EN: Colorizes the < > brackets used in guild highlighting
    ------------------------------------------------]]--
    local function colorize_guild_bracket(text)
        return CLR:Colorize("ffffff", text)
    end

    --[[------------------------------------------------
        BR: Coloriza o texto interno do possível nome de guilda
        EN: Colorizes the inner text of the possible guild name
    ------------------------------------------------]]--
    local function colorize_guild_text(text)
        return CLR:Colorize("00ff00", text)
    end

    --[[------------------------------------------------
        BR: Destaca o nome do jogador quando a opção estiver ativa
        EN: Highlights the player's name when the option is enabled
    ------------------------------------------------]]--
    local function highlight_player_name(text)
        if module.db.profile.player then
            return Prat:RegisterMatch(CLR:Colorize("00ff00", text))
        end
    end

    --[[------------------------------------------------
        BR: Destaca texto entre < > como possível nome de guilda
        EN: Highlights text between < > as a possible guild name
    ------------------------------------------------]]--
    local function highlight_guild_name(text)
        if module.db.profile.guild then
            return Prat:RegisterMatch(colorize_guild_bracket("<") .. colorize_guild_text(text) .. colorize_guild_bracket(">"))
        end
    end

    --[[------------------------------------------------
        BR: Registra os padrões de destaque do nome do jogador e guilda
        EN: Registers player name and guild highlight patterns
    ------------------------------------------------]]--
    Prat:SetModulePatterns(module, {
        { pattern = Prat.GetNamePattern(UnitName("player")), matchfunc = highlight_player_name, priority = 47 },
        { pattern = "<(..-)>", matchfunc = highlight_guild_name, priority = 49 },
    })
end)
