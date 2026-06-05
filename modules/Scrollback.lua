--[[
    @File:      Scrollback.lua
    @Project:   Prat-3.0

    BR: Extensão do módulo History para restaurar histórico entre sessões.
        - Armazena linhas do chat em SavedVariables por personagem
        - Restaura mensagens da última sessão
        - Filtra spam/opções de duração do histórico
        - Atualiza links Battle.net restaurados
        - Integra opções adicionais ao módulo History

    EN: History module extension for restoring chat history between sessions.
        - Stores chat lines in per-character SavedVariables
        - Restores messages from the previous session
        - Filters spam/history duration options
        - Updates restored Battle.net links
        - Injects additional options into the History module

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade com APIs antigas e modernas de decomposição de tempo
    EN: Compatibility with old and modern time breakdown APIs
------------------------------------------------]]--
local chat_frame_time_break_down = _G.ChatFrame_TimeBreakDown or _G.ChatFrameUtil.TimeBreakDown

--[[------------------------------------------------
    BR: Extensão carregada sobre o módulo History, não um módulo isolado
    EN: Extension loaded on top of History, not a standalone module
------------------------------------------------]]--
Prat:AddModuleExtension(function()
    --[[------------------------------------------------
        BR: Recupera o módulo History para anexar recursos de scrollback
        EN: Retrieves the History module to attach scrollback features
    ------------------------------------------------]]--
    local module = Prat:GetModule("History")
    if not module then
        return
    end

    --[[------------------------------------------------
        BR: Usa as strings localizadas do módulo History
        EN: Uses localized strings from the History module
    ------------------------------------------------]]--
    local PL = module.PL

    --[[------------------------------------------------
        BR: Migra e inicializa chaves de profile do Scrollback dentro do History
        EN: Migrates and initializes Scrollback profile keys inside History
    ------------------------------------------------]]--
    local function migrate_scrollback_profile(profile)
        if not profile then
            return
        end

        if profile.scrollbackduration ~= nil and profile.scrollback_duration == nil then
            profile.scrollback_duration = profile.scrollbackduration
        end
        profile.scrollbackduration = nil

        if profile.removespam ~= nil and profile.remove_spam == nil then
            profile.remove_spam = profile.removespam
        end
        profile.removespam = nil

        if profile.scrollback == nil then
            profile.scrollback = true
        end
        if profile.scrollback_duration == nil then
            profile.scrollback_duration = 24
        end
        if profile.remove_spam == nil then
            profile.remove_spam = true
        end
    end

    --[[------------------------------------------------
        BR: Injeta opções de scrollback no painel do módulo History
        EN: Injects scrollback options into the History module panel
    ------------------------------------------------]]--
    module.pluginopts["GlobalPatterns"] = {
        scrollback_group = {
            type = "group",
            name = PL["scrollback_group_name"],
            desc = PL["scrollback_group_desc"],
            inline = true,
            order = 300,
            args = {
                scrollback = {
                    type = "toggle",
                    name = PL["scrollback_name"],
                    desc = PL["scrollback_desc"],
                    order = 10,
                    width = 1.5,
                },

                scrollback_spacer = {
                    type = "description",
                    name = " ",
                    order = 15,
                    width = 0.15,
                },

                scrollback_duration = {
                    name = PL["scrollback_duration_name"],
                    desc = PL["scrollback_duration_desc"],
                    type = "range",
                    order = 20,
                    width = 1.35,
                    min = 0,
                    max = 168,
                    step = 1,
                    bigStep = 24,
                    disabled = function()
                        return not module.db.profile.scrollback
                    end
                },

                remove_spam = {
                    name = PL["remove_spam_name"],
                    desc = PL["remove_spam_desc"],
                    type = "toggle",
                    order = 30,
                    width = "full",
                    disabled = function()
                        return not module.db.profile.scrollback
                    end
                }
            }
        }
    }

    --[[------------------------------------------------
        BR: Preserva OnModuleEnable original antes de estender o comportamento
        EN: Preserves original OnModuleEnable before extending behavior
    ------------------------------------------------]]--
    local original_on_module_enable = module.OnModuleEnable

    --[[------------------------------------------------
        BR: Habilita restauração e armazenamento do histórico entre sessões
        EN: Enables restoration and storage of history between sessions
    ------------------------------------------------]]--
    function module:OnModuleEnable(...)
        original_on_module_enable(self, ...)
        migrate_scrollback_profile(self.db.profile)

        Prat3HighCPUPerCharDB = Prat3HighCPUPerCharDB
        Prat3HighCPUPerCharDB = Prat3HighCPUPerCharDB or {}

        Prat3HighCPUPerCharDB.scrollback = Prat3HighCPUPerCharDB.scrollback or {}

        self.scrollback = Prat3HighCPUPerCharDB.scrollback

        if self.db.profile.scrollback then
            self:restore_last_session()

            for name, frame in pairs(Prat.HookedFrames) do
                self.scrollback[name] = frame.historyBuffer
                if not self:IsHooked(frame, "AddMessage") then
                    self:SecureHook(frame, "AddMessage")
                end
            end
        end

        Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
        Prat.RegisterChatEvent(self, Prat.Events.FRAMES_REMOVED)
    end

    --[[------------------------------------------------
        BR: Preserva OnModuleDisable original antes de estender limpeza
        EN: Preserves original OnModuleDisable before extending cleanup
    ------------------------------------------------]]--
    local original_on_module_disable = module.OnModuleDisable

    --[[------------------------------------------------
        BR: Remove hooks de AddMessage e limpa referências de scrollback
        EN: Removes AddMessage hooks and clears scrollback references
    ------------------------------------------------]]--
    function module:OnModuleDisable(...)
        original_on_module_disable(self, ...)

        if self.scrollback then
            for name, frame in pairs(Prat.HookedFrames) do
                if self:IsHooked(frame, "AddMessage") then
                    self:Unhook(frame, "AddMessage")
                end
                self.scrollback[name] = nil
            end
        end
    end

    --[[------------------------------------------------
        BR: Atualiza quais frames terão histórico salvo conforme configuração
        EN: Updates which frames have saved history according to settings
    ------------------------------------------------]]--
    function module:OnValueChanged()
        migrate_scrollback_profile(self.db.profile)

        if not self.scrollback then
            return
        end

        for name, frame in pairs(Prat.HookedFrames) do
            if self.db.profile.scrollback then
                if not frame.isTemporary then
                    self.scrollback[name] = frame.historyBuffer
                else
                    self.scrollback[name] = nil
                end
            else
                self.scrollback[name] = nil
            end
        end
    end

    --[[------------------------------------------------
        BR: Registra novos frames no scrollback quando permitido
        EN: Registers new frames in scrollback when allowed
    ------------------------------------------------]]--
    function module:Prat_FramesUpdated(_, name, chat_frame)
        migrate_scrollback_profile(self.db.profile)

        if not self.scrollback then
            return
        end

        if self.db.profile.scrollback and not chat_frame.isTemporary then
            self.scrollback[name] = chat_frame.historyBuffer
        end

        if not self:IsHooked(chat_frame, "AddMessage") then
            self:SecureHook(chat_frame, "AddMessage")
        end
    end

    --[[------------------------------------------------
        BR: Remove frames excluídos do scrollback e seus hooks
        EN: Removes deleted frames from scrollback and their hooks
    ------------------------------------------------]]--
    function module:Prat_FramesRemoved(_, name, chat_frame)
        if self.scrollback then
            self.scrollback[name] = nil
        end

        if self:IsHooked(chat_frame, "AddMessage") then
            self:Unhook(chat_frame, "AddMessage")
        end
    end

    --[[------------------------------------------------
        BR: Marca horário do servidor na mensagem mais recente do buffer
        EN: Marks server time on the most recent buffer message
    ------------------------------------------------]]--
    function module:AddMessage(frame)
        if self.db.profile.on and self.scrollback and self.scrollback[frame:GetName()] then
            local entry = frame.historyBuffer:GetEntryAtIndex(1)
            if entry then
                entry.serverTime = GetServerTime()
            end
        end
    end

    --[[------------------------------------------------
        BR: Recupera item do buffer circular preservado pela Blizzard
        EN: Retrieves item from Blizzard's preserved circular buffer
    ------------------------------------------------]]--
    function module:get_entry_at_index(scrollback, index)
        if index > 0 and index <= #scrollback.elements then
            local head_index = type(scrollback.headIndex) == "table" and scrollback.headIndex.value or scrollback.headIndex
            local max_elements = type(scrollback.maxElements) == "table" and scrollback.maxElements.value or scrollback.maxElements

            local global_index = head_index - index + 1
            local element_index = (global_index - 1) % max_elements + 1

            return scrollback.elements[element_index]
        end
    end

    --[[------------------------------------------------
        BR: Detecta mensagens reais para reduzir spam restaurado
        EN: Detects real messages to reduce restored spam
    ------------------------------------------------]]--
    local function is_real_chat_message(message)
        return message.extraData and message.extraData.n >= #message.extraData
    end

    --[[------------------------------------------------
        BR: Monta tabela de consulta para links Battle.net restaurados
        EN: Builds lookup table for restored Battle.net links
    ------------------------------------------------]]--
    local function get_battle_tag_lookup_table()
        local lookup = {}
        local num_bnet = BNGetNumFriends()

        for i = 1, num_bnet do
            if C_BattleNet and C_BattleNet.GetFriendAccountInfo then
                local account_info = C_BattleNet.GetFriendAccountInfo(i)
                if account_info then
                    lookup[account_info.battleTag] = account_info
                end
            else
                local bnet_account_id, account_name, battle_tag = BNGetFriendInfo(i)
                local account_info = { bnetAccountID = bnet_account_id, accountName = account_name }
                if battle_tag then
                    lookup[battle_tag] = account_info
                end
            end
        end

        return lookup
    end

    --[[------------------------------------------------
        BR: Cache local da tabela de BattleTags
        EN: Local cache for the BattleTag table
    ------------------------------------------------]]--
    local battle_tag_lookup

    --[[------------------------------------------------
        BR: Reconstrói link clicável de jogador Battle.net
        EN: Rebuilds clickable Battle.net player link
    ------------------------------------------------]]--
    local function get_bn_player_link(name, link_display_text, bnet_id_account, line_id, chat_type, chat_target, battle_tag)
        return Prat.FormatLink("BNplayer", link_display_text, name, bnet_id_account, line_id or 0, chat_type, chat_target, battle_tag)
    end

    --[[------------------------------------------------
        BR: Corrige links Battle.net anonimizados no histórico restaurado
        EN: Fixes anonymized Battle.net links in restored history
    ------------------------------------------------]]--
    local function update_bnet(data, display)
        battle_tag_lookup = battle_tag_lookup or get_battle_tag_lookup_table()

        local name, bnet_id_account, _, chat_type, chat_target, battle_tag = strsplit(":", data)

        if battle_tag then
            local info = battle_tag_lookup[battle_tag]
            if info then
                name, bnet_id_account = info.accountName, info.bnetAccountID
                display = display:gsub("%?%?%?", name)
                chat_target = chat_target:gsub("%?%?%?", name)
            end
        end

        return get_bn_player_link(name, display, bnet_id_account, 0, chat_type, chat_target, battle_tag)
    end

    --[[------------------------------------------------
        BR: Restaura mensagens da sessão anterior respeitando duração e filtros
        EN: Restores previous session messages respecting duration and filters
    ------------------------------------------------]]--
    function module:restore_last_session()
        migrate_scrollback_profile(self.db.profile)

        local now = GetServerTime()
        local uptime = GetTime()
        local max_time = self.db.profile.scrollback_duration * 60 * 60

        for frame_name, scrollback in pairs(self.scrollback) do
            local frame = _G[frame_name]

            if scrollback.elements and scrollback.headIndex and scrollback.maxElements and frame_name ~= "ChatFrame2" then
                if frame and #scrollback.elements then
                    local time_shown = false

                    for i = 1, #scrollback.elements do
                        local line = self:get_entry_at_index(scrollback, i)

                        if line and type(line.message) == "string" and (not self.db.profile.remove_spam or is_real_chat_message(line)) then
                            line.serverTime = line.serverTime or now
                            line.timestamp = uptime

                            if max_time == 0 or (now - line.serverTime) <= max_time then
                                if not time_shown then
                                    frame:BackFillMessage(PL["divider"])
                                    frame:BackFillMessage(format(TIME_DAYHOURMINUTESECOND, chat_frame_time_break_down(now - line.serverTime)))
                                    time_shown = true
                                end

                                line.message = line.message:gsub("|K.-|k", "???")
                                line.message = line.message:gsub([[|HBNplayer:(.-)|h(.-)|h]], update_bnet)
                                frame.historyBuffer:PushBack(line)
                            end
                        end
                    end

                    frame:ResetAllFadeTimes()
                end
            end
        end
    end

    --[[------------------------------------------------
        BR: Aliases legados para reduzir risco com chamadas antigas
        EN: Legacy aliases to reduce risk from older calls
    ------------------------------------------------]]--
    module.GetEntryAtIndex = module.get_entry_at_index
    module.RestoreLastSession = module.restore_last_session

    return
end)
