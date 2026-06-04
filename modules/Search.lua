--[[
    @File:      Search.lua
    @Project:   Prat-3.0

    BR: Sistema de busca no histórico do chat.
        - Caixa de pesquisa por janela
        - Comando /find
        - Busca em histórico via historyBuffer
        - Destaque do termo encontrado
        - Fade visual da caixa de pesquisa

    EN: Chat history search system.
        - Per-window search box
        - /find command
        - Search through historyBuffer
        - Search term highlight
        - Search box fade effect

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

Prat:AddModuleToLoad(function()
    --[[------------------------------------------------
        BR: Registro do módulo de busca
        EN: Search module registration
    ------------------------------------------------]]--
    local module = Prat:NewModule("Search")

    --[[------------------------------------------------
        BR: Referência local às strings centralizadas
        EN: Local reference to centralized strings
    ------------------------------------------------]]--
    local PL = module.PL

    --[[------------------------------------------------
        BR: Valores padrão do módulo
        EN: Module default values
    ------------------------------------------------]]--
    Prat:SetModuleDefaults(module.name, {
        profile = {
            on = true,
            search_active_alpha = 1.0,
            search_inactive_alpha = 0.1,
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

        if profile.searchactivealpha ~= nil and profile.search_active_alpha == nil then
            profile.search_active_alpha = profile.searchactivealpha
        end
        profile.searchactivealpha = nil

        if profile.searchinactivealpha ~= nil and profile.search_inactive_alpha == nil then
            profile.search_inactive_alpha = profile.searchinactivealpha
        end
        profile.searchinactivealpha = nil

        if profile.search_active_alpha == nil then
            profile.search_active_alpha = 1.0
        end

        if profile.search_inactive_alpha == nil then
            profile.search_inactive_alpha = 0.1
        end
    end

    --[[------------------------------------------------
        BR: Construção da interface de configuração
        EN: Configuration interface construction
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

            appearance = {
                type = "group",
                name = PL["appearance_tab_name"],
                desc = PL["appearance_tab_desc"],
                order = 100,
                args = {
                    appearance_help = {
                        type = "description",
                        name = PL["appearance_help"],
                        order = 10,
                        width = "full",
                    },

                    search_inactive_alpha = {
                        name = PL["search_inactive_alpha_name"],
                        desc = PL["search_inactive_alpha_desc"],
                        type = "range",
                        order = 20,
                        width = 1.25,
                        min = 0,
                        max = 1.0,
                        step = 0.1,
                    },

                    alpha_spacer = {
                        type = "description",
                        name = " ",
                        order = 25,
                        width = 0.15,
                    },

                    search_active_alpha = {
                        name = PL["search_active_alpha_name"],
                        desc = PL["search_active_alpha_desc"],
                        type = "range",
                        order = 30,
                        width = 1.25,
                        min = 0,
                        max = 1.0,
                        step = 0.1,
                    },
                },
            },
        }
    })

    --[[------------------------------------------------
        BR: Recolhe visualmente a caixa de busca
        EN: Visually collapses the search box
    ------------------------------------------------]]--
    function module:collapse_search_box(frame)
        frame:SetAlpha(self.db.profile.search_inactive_alpha)
        frame:SetWidth(30)
    end

    --[[------------------------------------------------
        BR: Expande visualmente a caixa de busca
        EN: Expands the search box visually
    ------------------------------------------------]]--
    function module:expand_search_box(frame)
        frame:SetAlpha(self.db.profile.search_active_alpha)
        frame:SetWidth(130)
    end

    --[[------------------------------------------------
        BR: Cria SearchBox para um chat frame
        EN: Creates a SearchBox for a chat frame
    ------------------------------------------------]]--
    function module:create_search_box(chat_frame)
        local name = chat_frame:GetName()
        local search_box = CreateFrame(
            "EditBox",
            name .. "ChatSearchEditBox",
            chat_frame,
            "SearchBoxTemplate"
        )

        search_box:SetWidth(130)
        search_box:SetHeight(16)
        search_box:SetFrameStrata("HIGH")
        search_box:SetPoint("TOPRIGHT", chat_frame, "TOPRIGHT")

        search_box:SetScript("OnEnter", function()
            local hover_alpha =
                self.db.profile.search_inactive_alpha +
                (self.db.profile.search_active_alpha -
                self.db.profile.search_inactive_alpha) / 2

            if search_box:HasFocus() then
                self:expand_search_box(search_box)
            else
                search_box:SetAlpha(hover_alpha)
            end
        end)

        search_box:SetScript("OnLeave", function()
            if search_box:HasFocus() then
                self:expand_search_box(search_box)
            else
                self:collapse_search_box(search_box)
            end
        end)

        search_box:SetScript("OnEditFocusLost", function()
            self:collapse_search_box(search_box)
        end)

        search_box:SetScript("OnEditFocusGained", function()
            self:expand_search_box(search_box)
        end)

        search_box:SetScript("OnEscapePressed", function()
            search_box:ClearFocus()
        end)

        search_box:SetScript("OnEnterPressed", function(frame)
            local query = search_box:GetText()

            if query and query:len() > 0 then
                module:find(query, true, frame:GetParent())
            end
        end)

        --[[------------------------------------------------
            BR: Sistema de fade da caixa de pesquisa
            EN: Search box fade animation system
        ------------------------------------------------]]--
        search_box.anim = search_box:CreateAnimationGroup()

        search_box.anim.fade_in = search_box.anim:CreateAnimation("Alpha")
        search_box.anim.fade_in:SetFromAlpha(self.db.profile.search_active_alpha)
        search_box.anim.fade_in:SetDuration(3)
        search_box.anim.fade_in:SetToAlpha(self.db.profile.search_inactive_alpha)
        search_box.anim.fade_in:SetSmoothing("IN")

        -- BR: Compatibilidade runtime com nome antigo.
        -- EN: Runtime compatibility with old name.
        search_box.anim.fade1 = search_box.anim.fade_in

        search_box.anim:SetScript("OnFinished", function()
            if search_box:HasFocus() then
                self:expand_search_box(search_box)
            else
                self:collapse_search_box(search_box)
            end
        end)

        search_box.anim:Play()

        return search_box
    end

    --[[------------------------------------------------
        BR: Inicialização das search boxes
        EN: Search box initialization
    ------------------------------------------------]]--
    Prat:SetModuleInit(module, function(self)
        migrate_profile(self.db.profile)

        self.search_boxes = {}
        self.searchBoxes = self.search_boxes -- Legacy runtime compatibility.
    end)

    --[[------------------------------------------------
        BR: Atualiza novos chat frames
        EN: Updates newly created chat frames
    ------------------------------------------------]]--
    function module:Prat_FramesUpdated(_, name, chat_frame)
        if not self.search_boxes[name] then
            self.search_boxes[name] = self:create_search_box(chat_frame)
        end
    end

    --[[------------------------------------------------
        BR: Ativação do módulo
        EN: Module activation
    ------------------------------------------------]]--
    function module:OnModuleEnable()
        migrate_profile(self.db.profile)

        Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)

        for name, frame in pairs(Prat.HookedFrames) do
            if not self.search_boxes[name] then
                self.search_boxes[name] = self:create_search_box(frame)
            end
        end

        for _, search_box in pairs(self.search_boxes) do
            search_box:Show()
        end
    end

    --[[------------------------------------------------
        BR: Desativação do módulo
        EN: Module deactivation
    ------------------------------------------------]]--
    function module:OnModuleDisable()
        for _, search_box in pairs(self.search_boxes) do
            search_box:Hide()
        end
    end

    --[[------------------------------------------------
        BR: Registro do comando /find
        EN: /find slash command registration
    ------------------------------------------------]]--
    SLASH_FIND1 = "/find"

    SlashCmdList["FIND"] = function(msg)
        module:find(msg, true)
    end

    local found_messages = {}
    local scraped_messages = {}

    -- BR: Compatibilidade documental com nomes antigos locais.
    -- EN: Documentary compatibility with old local names.
    local foundMessages = found_messages
    local scrapedMessages = scraped_messages

    local CLR = Prat.CLR

    --[[------------------------------------------------
        BR: Imprime mensagens da busca diretamente na janela, sem prefixo do módulo
        EN: Prints search messages directly to the frame, without the module prefix
    ------------------------------------------------]]--
    local function print_search_message(frame, text)
        frame:AddMessage(text, 0.80, 0.80, 0.80)
    end

    --[[------------------------------------------------
        BR: Coloriza termo buscado
        EN: Colorizes search term
    ------------------------------------------------]]--
    local function highlight_search_term(term)
        return CLR:Colorize("ffff40", term)
    end

    --[[------------------------------------------------
        BR: Busca mensagens no histórico do chat
        EN: Searches messages in chat history
    ------------------------------------------------]]--
    function module:find(word, all, frame)
        if not self.db.profile.on then
            return
        end

        if frame == nil then
            frame = SELECTED_CHAT_FRAME
        end

        if not word then
            return
        end

        if #word <= 1 then
            frame:ScrollToBottom()
            print_search_message(frame, PL["err_too_short"])
            return
        end

        if frame:GetNumMessages() == 0 then
            frame:ScrollToBottom()
            print_search_message(frame, PL["err_not_found"])
            return
        end

        self.last_search = word
        self.lastsearch = self.last_search -- Legacy runtime compatibility.

        self:scrape_frame(frame, nil, true)

        for _, message_data in ipairs(scraped_messages) do
            if message_data.message and message_data.message:find(
                Prat:CaseInsensitveWordPattern(word)
            ) then
                if all then
                    table.insert(found_messages, message_data)
                else
                    return
                end
            end
        end

        self.last_search = nil
        self.lastsearch = nil

        frame:ScrollToBottom()

        if all and #found_messages > 0 then
            print_search_message(frame, "-------------------------------------------------------------")
            print_search_message(frame, PL["find_results"] .. ": " .. highlight_search_term(word))

            -- BR: Evita timestamp duplicado.
            -- EN: Prevents duplicated timestamp.
            Prat.loading = true

            for _, message_data in ipairs(found_messages) do
                frame:AddMessage(
                    message_data.message:gsub("|K.-|k", PL["bnet_removed"]),
                    message_data.r,
                    message_data.g,
                    message_data.b
                )
            end

            Prat.loading = nil

            local result_count = #found_messages
            local summary_key = result_count == 1 and "result_summary_single" or "result_summary_plural"

            print_search_message(frame, (PL[summary_key]):format(result_count, word))
            print_search_message(frame, PL["end_search_marker"])
        else
            print_search_message(frame, PL["err_not_found"])
        end

        wipe(found_messages)
        wipe(scraped_messages)
    end

    --[[------------------------------------------------
        BR: Extrai mensagens do historyBuffer
        EN: Extracts messages from historyBuffer
    ------------------------------------------------]]--
    function module:scrape_frame(frame)
        wipe(scraped_messages)

        for i = frame:GetNumMessages(), 1, -1 do
            local msg = frame.historyBuffer:GetEntryAtIndex(i)

            if msg and msg.message then
                table.insert(scraped_messages, msg)
            end
        end
    end

    --[[------------------------------------------------
        BR: Aliases legados para reduzir risco com chamadas antigas
        EN: Legacy aliases to reduce risk from older calls
    ------------------------------------------------]]--
    module.StashSearch = module.collapse_search_box
    module.UnstashSearch = module.expand_search_box
    module.CollapseSearchBox = module.collapse_search_box
    module.ExpandSearchBox = module.expand_search_box
    module.CreateSearchBox = module.create_search_box
    module.Find = module.find
    module.ScrapeFrame = module.scrape_frame

    return
end) -- Prat:AddModuleToLoad
