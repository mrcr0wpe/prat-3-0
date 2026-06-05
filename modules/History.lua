--[[
    @File:      History.lua
    @Project:   Prat-3.0

    BR: Controle do histórico de chat e comandos.
        - Histórico persistente do editbox
        - Quantidade máxima de linhas por janela
        - Histórico de comandos entre sessões
        - Integração com Scrollback
        - Configuração independente por frame
        - Gerenciamento de histórico seguro via hooks

    EN: Chat and command history control.
        - Persistent editbox history
        - Maximum line count per frame
        - Command history between sessions
        - Scrollback integration
        - Per-frame independent configuration
        - Safe history management through hooks

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade com constantes antigas e modernas de janelas de chat
    EN: Compatibility with old and modern chat window constants
------------------------------------------------]]--
local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS or Constants.ChatFrameConstants.MaxChatWindows

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo responsável pelo histórico do chat
		EN: Creation of the module responsible for chat history
	------------------------------------------------]]--
	local module = Prat:NewModule("History", "AceHook-3.0")

	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			chat_lines_frames = {},
			chat_lines = 384,
			max_lines = 50,
			save_history = false,

			-- BR: Chaves mantidas no padrão legado até a auditoria do Scrollback.lua.
			-- EN: Keys kept in legacy format until Scrollback.lua is audited.
			scrollback = true,
			scrollbackduration = 24,
			removespam = true,
			colorgmotd = true,
			delaygmotd = true,
		}
	})

	--[[------------------------------------------------
		BR: Plugins dinâmicos usados por extensões como Scrollback
		EN: Dynamic plugins used by extensions such as Scrollback
	------------------------------------------------]]--
	module.pluginopts = {}

	--[[------------------------------------------------
		BR: Migra chaves antigas de profile para o padrão snake_case
		EN: Migrates old profile keys to the snake_case standard
	------------------------------------------------]]--
	local function migrate_profile(profile)
		if not profile then
			return
		end

		if profile.chatlinesframes ~= nil and profile.chat_lines_frames == nil then
			profile.chat_lines_frames = profile.chatlinesframes
		end
		profile.chatlinesframes = nil

		if profile.chatlines ~= nil and profile.chat_lines == nil then
			profile.chat_lines = profile.chatlines
		end
		profile.chatlines = nil

		if profile.maxlines ~= nil and profile.max_lines == nil then
			profile.max_lines = profile.maxlines
		end
		profile.maxlines = nil

		if profile.savehistory ~= nil and profile.save_history == nil then
			profile.save_history = profile.savehistory
		end
		profile.savehistory = nil

		profile.chat_lines_frames = profile.chat_lines_frames or {}
		if profile.chat_lines == nil then
			profile.chat_lines = 384
		end
		if profile.max_lines == nil then
			profile.max_lines = 50
		end
		if profile.save_history == nil then
			profile.save_history = false
		end

		-- BR: Compatibilidade ativa com Scrollback.lua ainda não auditado.
		-- EN: Active compatibility with Scrollback.lua, which has not been audited yet.
		if profile.scrollback == nil then
			profile.scrollback = true
		end
		if profile.scrollbackduration == nil then
			profile.scrollbackduration = 24
		end
		if profile.removespam == nil then
			profile.removespam = true
		end
		if profile.colorgmotd == nil then
			profile.colorgmotd = true
		end
		if profile.delaygmotd == nil then
			profile.delaygmotd = true
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
		plugins = module.pluginopts,
		args = {
			overview = {
				type = "group",
				name = PL["overview_tab_name"],
				desc = PL["overview_tab_desc"],
				order = 10,
				args = {
					description = {
						name = PL["full_description"],
						type = "description",
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

			chat_lines_group = {
				type = "group",
				name = PL["chat_lines_group_name"],
				desc = PL["chat_lines_group_desc"],
				order = 20,
				args = {
					chat_lines_help = {
						name = PL["chat_lines_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					chat_lines_frames = {
						name = PL["chat_lines_frames_name"],
						desc = PL["chat_lines_frames_desc"],
						type = "multiselect",
						width = "full",
						order = 20,
						values = Prat.HookedFrameList,
						get = "GetSubValue",
						set = "SetSubValue",
					},

					spacer_after_frames = {
						type = "description",
						name = "\n",
						order = 25,
						width = "full",
					},

					chat_lines = {
						name = PL["chat_lines_name"],
						desc = PL["chat_lines_desc"],
						type = "range",
						order = 30,
						width = 1.35,
						min = 300,
						max = 5000,
						step = 10,
						bigStep = 50,
					},
				}
			},

			command_history_group = {
				type = "group",
				name = PL["command_history_group_name"],
				desc = PL["command_history_group_desc"],
				order = 30,
				args = {
					command_history_help = {
						name = PL["command_history_help"],
						type = "description",
						order = 10,
						width = "full",
					},

					save_history = {
						name = PL["save_history_name"],
						desc = PL["save_history_desc"],
						type = "toggle",
						order = 20,
						width = "full",
					},

					max_lines = {
						name = PL["max_lines_name"],
						desc = PL["max_lines_desc"],
						type = "range",
						order = 30,
						width = 1.35,
						min = 0,
						max = 500,
						step = 10,
						bigStep = 50,
						disabled = function()
							return not module.db.profile.save_history
						end,
					},
				}
			},
		}
	})

	--[[------------------------------------------------
		BR: Executa uma função em todos os editboxes de chat
		EN: Executes a function on all chat editboxes
	------------------------------------------------]]--
	local function apply_edit_box(func)
		for i = 1, NUM_CHAT_WINDOWS do
			local edit_box = _G["ChatFrame" .. i .. "EditBox"]
			if edit_box then
				func(edit_box)
			end
		end
	end

	--[[------------------------------------------------
		BR: Inicializa histórico persistente e instala hooks nos editboxes
		EN: Initializes persistent history and installs editbox hooks
	------------------------------------------------]]--
	function module:OnModuleEnable()
		migrate_profile(self.db.profile)

		Prat3CharDB = Prat3CharDB or {}
		Prat3CharDB.history = Prat3CharDB.history or {}
		Prat3CharDB.history.cmdhistory = Prat3CharDB.history.cmdhistory or {}

		for i, value in ipairs(Prat3CharDB.history.cmdhistory) do
			if type(value) == "string" and value:sub(1, 9) ~= "ChatFrame" then
				Prat3CharDB.history.cmdhistory[i] = nil
			end
		end

		apply_edit_box(function(edit_box)
			local name = edit_box:GetName()
			Prat3CharDB.history.cmdhistory[name] = Prat3CharDB.history.cmdhistory[name] or {}
		end)

		self:configure_all_chat_frames()

		for key in pairs(Prat3CharDB.history.cmdhistory) do
			local edit_box = _G[key]
			if edit_box then
				if not self:IsHooked(edit_box, "AddHistoryLine") then
					self:SecureHook(edit_box, "AddHistoryLine")
				end

				if self.db.profile.save_history then
					self:add_saved_history(edit_box)
				end

				if not self:IsHooked(edit_box, "ClearHistory") then
					self:SecureHook(edit_box, "ClearHistory")
				end
			end
		end

		-- BR: Remove dados antigos que pertenciam ao profile do módulo.
		-- EN: Removes old data that used to belong to the module profile.
		if self.db.profile.cmdhistory then
			self.db.profile.cmdhistory = nil
		end
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Restaura quantidade padrão de linhas do chat
		EN: Restores default chat line count
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:configure_all_chat_frames(384)
	end

	--[[------------------------------------------------
		BR: Aplica limites de histórico e configura histórico de comandos
		EN: Applies history limits and configures command history
	------------------------------------------------]]--
	function module:configure_all_chat_frames(lines)
		migrate_profile(self.db.profile)

		local profile = self.db.profile
		lines = lines or profile.chat_lines

		for frame_name in pairs(profile.chat_lines_frames) do
			self:set_history(_G[frame_name], lines)
		end

		if not (Prat3CharDB and Prat3CharDB.history and Prat3CharDB.history.cmdhistory) then
			return
		end

		for key in pairs(Prat3CharDB.history.cmdhistory) do
			local edit_box = _G[key]
			if edit_box then
				if profile.save_history then
					edit_box:SetHistoryLines(profile.max_lines)
					edit_box.history_lines = Prat3CharDB.history.cmdhistory[key]
				else
					edit_box.history_lines = {}
				end
				edit_box.history_index = 0
			end
		end
	end

	--[[------------------------------------------------
		BR: Reaplica configurações por janela após alteração individual
		EN: Reapplies per-frame settings after individual changes
	------------------------------------------------]]--
	function module:OnSubValueChanged()
		self:configure_all_chat_frames()
	end

	module.OnSubvalueChanged = module.OnSubValueChanged

	--[[------------------------------------------------
		BR: Reaplica configurações globais após alteração do usuário
		EN: Reapplies global settings after user changes
	------------------------------------------------]]--
	function module:OnValueChanged()
		self:configure_all_chat_frames()
	end

	--[[------------------------------------------------
		BR: Define quantidade máxima de linhas armazenadas pelo frame
		EN: Sets the maximum number of lines stored by the frame
	------------------------------------------------]]--
	function module:set_history(frame, lines)
		if frame == nil then
			return
		end

		frame:SetMaxLines(lines)
	end

	--[[------------------------------------------------
		BR: Restaura histórico salvo no editbox atual
		EN: Restores saved history into the current editbox
	------------------------------------------------]]--
	function module:add_saved_history(edit_box)
		edit_box = edit_box or ChatFrame1EditBox
		local command_history = Prat3CharDB.history.cmdhistory[edit_box:GetName()] or {}
		local command_index = #command_history

		-- where there's a while, there's a way
		while command_index > 0 do
			edit_box:AddHistoryLine(command_history[command_index])
			command_index = command_index - 1
			-- way
		end
	end

	--[[------------------------------------------------
		BR: Salva comando digitado respeitando limite máximo configurado
		EN: Saves typed commands respecting configured maximum limit
	------------------------------------------------]]--
	function module:save_line(text, edit_box)
		if not text or text == "" then
			return false
		end

		local max_lines = self.db.profile.max_lines
		local command_history = edit_box.history_lines or {}

		if command_history[1] == text then
			return
		end

		table.insert(command_history, 1, text)

		local command_count = #command_history - max_lines
		while command_count > 0 do
			table.remove(command_history)
			command_count = command_count - 1
		end
	end

	--[[------------------------------------------------
		BR: Limpa histórico persistente do editbox
		EN: Clears persistent editbox history
	------------------------------------------------]]--
	function module:clear_history(edit_box)
		edit_box = edit_box or ChatFrame1EditBox

		local command_history = edit_box.history_lines or {}
		local command_count = #command_history
		while command_count > 0 do
			table.remove(command_history)
			command_count = command_count - 1
		end
	end

	--[[------------------------------------------------
		BR: Reconstrói e registra comandos digitados no histórico
		EN: Rebuilds and records typed commands into history
	------------------------------------------------]]--
	function module:add_history_line(edit_box)
		edit_box = edit_box or ChatFrame1EditBox

		-- BR: Código baseado no comportamento original da Blizzard.
		-- EN: Code based on Blizzard's original behavior.
		local text = ""
		local chat_type = edit_box:GetAttribute("chatType")
		local header = _G["SLASH_" .. chat_type .. "1"]

		if header then
			text = header
		end

		if chat_type == "WHISPER" and edit_box:GetAttribute("tellTarget") ~= nil then
			text = text .. " " .. edit_box:GetAttribute("tellTarget")
		elseif chat_type == "CHANNEL" and edit_box:GetAttribute("channelTarget") ~= nil then
			text = "/" .. edit_box:GetAttribute("channelTarget")
		end

		local edit_box_text = edit_box:GetText()
		if strlen(edit_box_text) > 0 and not IsSecureCmd(edit_box_text:match("^/[%a%d_]+") or "") then
			text = (header and (text .. " ") or "") .. edit_box_text
			self:save_line(text, edit_box)
		end
	end

	--[[------------------------------------------------
		BR: Aliases legados para hooks e chamadas externas
		EN: Legacy aliases for hooks and external calls
	------------------------------------------------]]--
	module.ConfigureAllChatFrames = module.configure_all_chat_frames
	module.SetHistory = module.set_history
	module.AddSavedHistory = module.add_saved_history
	module.addSavedHistory = module.add_saved_history
	module.SaveLine = module.save_line
	module.saveLine = module.save_line
	module.ClearHistory = module.clear_history
	module.AddHistoryLine = module.add_history_line

	return
end) -- Prat:AddModuleToLoad
