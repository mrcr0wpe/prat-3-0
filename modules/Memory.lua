--[[
    @File:      Memory.lua
    @Project:   Prat-3.0

    BR: Salva e restaura configurações do chat da Blizzard.
        - Salva layout, canais, cores, dimensões e CVars do chat
        - Restaura janelas, grupos de mensagens e canais
        - Suporte a carregamento automático
        - Usa timers para restaurar canais de forma incremental
        - Módulo experimental e sensível a taint

    EN: Saves and restores Blizzard chat settings.
        - Saves chat layout, channels, colors, dimensions and CVars
        - Restores windows, message groups and channels
        - Automatic loading support
        - Uses timers to restore channels incrementally
        - Experimental module sensitive to taint

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

local Chat_GetChatFrame = _G.Chat_GetChatFrame or _G.ChatFrameUtil.GetChatFrame

local ChatEdit_DeactivateChat = _G.ChatEdit_DeactivateChat or _G.ChatFrameUtil.DeactivateChat

local ChatFrame_AddNewCommunitiesChannel = _G.ChatFrame_AddNewCommunitiesChannel or _G.ChatFrameUtil.AddNewCommunitiesChannel
local ChatFrame_RemoveAllMessageGroups = _G.ChatFrame_RemoveAllMessageGroups or _G.ChatFrameMixin.RemoveAllMessageGroups
local ChatFrame_AddMessageGroup = _G.ChatFrame_AddMessageGroup or _G.ChatFrameMixin.AddMessageGroup
local ChatFrame_RemoveAllChannels = _G.ChatFrame_RemoveAllChannels or _G.ChatFrameMixin.RemoveAllChannels
local ChatFrame_ReceiveAllPrivateMessages = _G.ChatFrame_ReceiveAllPrivateMessages or _G.ChatFrameMixin.ReceiveAllPrivateMessages

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo com suporte a hooks, eventos e timers
		EN: Creation of the module with hook, event and timer support
	------------------------------------------------]]--
	local module = Prat:NewModule("Memory", "AceHook-3.0", "AceEvent-3.0", "AceTimer-3.0")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	--[[------------------------------------------------
		BR: Configuração dos valores padrão e armazenamento persistente
		EN: Default values and persistent storage configuration
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			frames = { ["*"] = {} },
			types = {},
			cvars = {},
			auto_load = false
		}
	})

	Prat:SetModuleOptions(module.name, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		args = {
			warning_group = {
				type = "group",
				name = PL["warning_group_name"],
				desc = PL["warning_group_desc"],
				inline = true,
				order = 50,
				args = {
					warning = {
						type = "description",
						name = PL["warning_text"],
						order = 10,
						width = "full",
					},
				}
			},

			actions_group = {
				type = "group",
				name = PL["actions_group_name"],
				desc = PL["actions_group_desc"],
				inline = true,
				order = 100,
				args = {
					load = {
						name = PL["load_name"],
						desc = PL["load_desc"],
						type = "execute",
						order = 10,
						width = 1.25,
						func = "load_settings"
					},

					action_spacer = {
						type = "description",
						name = " ",
						order = 15,
						width = 0.15,
					},

					save = {
						name = PL["save_name"],
						desc = PL["save_desc"],
						type = "execute",
						order = 20,
						width = 1.25,
						func = "save_settings"
					},
				}
			},

			options_group = {
				type = "group",
				name = PL["options_group_name"],
				desc = PL["options_group_desc"],
				inline = true,
				order = 200,
				args = {
					auto_load = {
						name = PL["auto_load_name"],
						desc = PL["auto_load_desc"],
						type = "toggle",
						order = 10,
						width = 1.60,
					},

					auto_load_help = {
						type = "description",
						name = PL["auto_load_help"],
						order = 20,
						width = "full",
					},
				}
			},

			scope_group = {
				type = "group",
				name = PL["scope_group_name"],
				desc = PL["scope_group_desc"],
				inline = true,
				order = 300,
				args = {
					scope = {
						type = "description",
						name = PL["scope_text"],
						order = 10,
						width = "full",
					},
				}
			},
		}
	})

	--[[------------------------------------------------
		BR: CVars do chat salvos/restaurados pelo módulo
		EN: Chat CVars saved/restored by the module
	------------------------------------------------]]--
	local chat_cvars = {
		whisperMode = "CVar",
		chatStyle = "CVar",
		wholeChatWindowClickable = "CVarBool",
		blockChannelInvites = "CVarBool"
	}

	Prat:SetModuleInit(module.name,
		function(self)
			self:RegisterEvent("PLAYER_ENTERING_WORLD")
		end)

	function module:PLAYER_ENTERING_WORLD()
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.ready = true
		if self.needs_loading then
			self:ScheduleTimer("load_settings", 0)
		end
	end

	function module:OnModuleEnable()
		if not self.working and self.db.profile.auto_load and next(self.db.profile.frames) then
			if not self.ready then
				self.needs_loading = true
			else
				self:ScheduleTimer("load_settings", 0)
			end
		end

		Prat.RegisterChatEvent(self, Prat.Events.PRE_ADDMESSAGE)
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Salva configuração global do chat, canais, cores e CVars
		EN: Saves global chat configuration, channels, colors and CVars
	------------------------------------------------]]--
	function module:save_settings()
		local db = self.db.profile

		wipe(db.frames)

		for i = 1, NUM_CHAT_WINDOWS do
			self:save_settings_for_frame(i)
		end

		db.types = CopyTable(getmetatable(ChatTypeInfo).__index)
		db.channels = { GetChannelList() }

		for k, v in pairs(chat_cvars) do
			db.cvars[k] = _G["Get" .. v](k)
		end

		self:Output(PL["msg_settings_saved"])
	end

	function module:save_settings_for_frame(frame_id)
		local db = self.db.profile.frames[frame_id]

		local name, font_size, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(frame_id)
		db.name, db.font_size, db.r, db.g, db.b, db.alpha, db.shown, db.locked, db.docked, db.uninteractable = name, font_size, r, g, b, alpha, shown, locked, docked, uninteractable

		local f = Chat_GetChatFrame(frame_id)
		db.minimized = f.minimized
		if f.minFrame then
			db.min_frame = {}
			for i = 1, f.minFrame:GetNumPoints() do
				local point, relative_to, relative_point, xoff, yoff = f.minFrame:GetPoint(i)
				db.min_frame[#db.min_frame + 1] = { point, (type(relative_to) == "table") and relative_to:GetName() or relative_to, relative_point, xoff, yoff }
			end
		end
		db.messages = { GetChatWindowMessages(frame_id) }
		db.channels = { GetChatWindowChannels(frame_id) }

		local width, height = GetChatWindowSavedDimensions(frame_id);
		local point, x_offset, y_offset = GetChatWindowSavedPosition(frame_id)

		db.point, db.x_offset, db.y_offset, db.width, db.height = point, x_offset, y_offset, width, height
	end

	-- BR: Atenção: esta função pode causar taint no Edit Mode do Dragonflight/Retail.
	-- EN: Warning: this function may cause taint in Dragonflight/Retail Edit Mode.
	--[[------------------------------------------------
		BR: Restaura layout/aparência de uma janela de chat
		EN: Restores layout/appearance of a chat window
	------------------------------------------------]]--
	function module:load_frame_settings_for_frame(frame_id)
		local db = self.db.profile.frames[frame_id]
		local success = true
		local f = Chat_GetChatFrame(frame_id)

		if not db.shown and not db.docked then
			FCF_Close(f)
			return success
		end

		if f.minimized then
			FCF_MaximizeFrame(f)
		end

		-- Restore FloatingChatFrame
		SetChatWindowName(frame_id, db.name)
		SetChatWindowSize(frame_id, db.font_size)
		SetChatWindowColor(frame_id, db.r, db.g, db.b)
		SetChatWindowAlpha(frame_id, db.alpha)
		SetChatWindowDocked(frame_id, db.docked)
		SetChatWindowLocked(frame_id, db.locked)
		SetChatWindowUninteractable(frame_id, db.uninteractable)
		SetChatWindowSavedDimensions(frame_id, db.width, db.height)
		if db.point then
			SetChatWindowSavedPosition(frame_id, db.point, db.x_offset, db.y_offset)
		end
		SetChatWindowShown(frame_id, db.shown)
		FloatingChatFrame_Update(frame_id, 1)
		FCF_DockUpdate()
		ChatEdit_DeactivateChat(f.editBox)
		FCF_FadeInChatFrame(f)

		if db.minimized then
			FCF_MinimizeFrame(f, "LEFT")
			f.minFrame:ClearAllPoints()
			for _, v in ipairs(db.min_frame) do
				local point, relative_to, relative_point, xoff, yoff = unpack(v)
				f.minFrame:SetPoint(point, relative_to and _G[relative_to], relative_point, xoff, yoff)
			end

			f.minFrame:SetUserPlaced(true)
		end
		return success
	end

	--[[------------------------------------------------
		BR: Restaura grupos de mensagens, canais e whispers do chatframe
		EN: Restores message groups, channels and whispers for the chatframe
	------------------------------------------------]]--
	function module:load_chat_settings_for_frame(frame_id)
		local db = self.db.profile.frames[frame_id]
		local success = true
		local f = Chat_GetChatFrame(frame_id)

		-- Restore ChatFrame
		ChatFrame_RemoveAllMessageGroups(f)
		for _, v in ipairs(db.messages) do
			ChatFrame_AddMessageGroup(f, v);
		end

		ChatFrame_RemoveAllChannels(f)
		for i = 1, #db.channels, 2 do
			local chan
			if _G.ChatFrame_AddChannel then
				chan = _G.ChatFrame_AddChannel(f, db.channels[i])
			elseif _G.ChatFrameMixin.AddChannel then
				chan = f:AddChannel(db.channels[i])
			end
			if not chan then
				success = false
			end
		end

		ChatFrame_ReceiveAllPrivateMessages(f)
		return success
	end
	function module:leave_channels(...)
		local db = self.db.profile
		local map = self:get_channel_map(unpack(db.channels))
		for i = 1, select("#", ...), 3 do
			local snum, sname = select(i, ...);
			local num, name = map[sname], map[snum];
			if snum ~= num or sname ~= name then
				LeaveChannelByName(snum)
			end
		end
	end

	local channel_step_delay = 0.5
	local function get_delay()
		return channel_step_delay + module.error_count
	end

	function module:leave_placeholder_channels(...)
		for i = 1, select("#", ...), 3 do
			local num, name = select(i, ...);
			if name:match("^LeaveMe") then
				LeaveChannelByName(num)
			end
		end

		self:ScheduleTimer(function()
			module:check_channels(GetChannelList())
		end, get_delay())
	end

	function module:get_channel_map(...)
		local map = {}
		for i = 1, select("#", ...), 3 do
			local num, name = select(i, ...);
			map[name] = num
			map[num] = name
		end

		return map
	end

	--[[------------------------------------------------
		BR: Verifica ordem/quantidade dos canais antes de restaurar
		EN: Checks channel order/count before restoring
	------------------------------------------------]]--
	function module:check_channels(...)
		local db = self.db.profile
		local map = self:get_channel_map(unpack(db.channels))

		local correct = true
		if select("#", ...) ~= #db.channels then
			correct = "wrong"
		else
			for i = 1, select("#", ...), 3 do
				local snum, sname = select(i, ...);
				local num, name = db.channels[i], db.channels[i + 1];
				if snum ~= num or sname ~= name then
					correct = map[sname] and "order" or "wrong"
				end
			end
		end

		if type(correct) == "boolean" or self.error_count >= 3 then
			self:ScheduleTimer("load_settings", 0)
		else
			if correct == "wrong" then
				self:leave_channels(GetChannelList())
				self:ScheduleTimer("restore_channels", get_delay(), unpack(db.channels))
				self.error_count = self.error_count + 1
			elseif correct == "order" then
				for i = 1, select("#", ...), 3 do
					local snum, sname = select(i, GetChannelList());
					local cur_num = map[sname]
					-- we check if the channel is joined and was joined in the past before
					-- doing anything (avoids nil reference error on some new characters)
					if cur_num ~= nil and snum ~= nil and snum ~= cur_num then
						if Prat.IsClassic then
							SwapChatChannelByLocalID(snum, cur_num)
						else
							C_ChatInfo.SwapChatChannelsByChannelIndex(snum, cur_num)
						end
					end
				end

				self:ScheduleTimer(function()
					module:check_channels(GetChannelList())
				end, get_delay())
			end
		end
	end

	if Prat.IsClassic then
		function module:restore_channels(...)
			local index = 1
			for i = 1, select("#", ...), 3 do
				local num, name = select(i, ...);
				while index < num do
					if GetChannelName(index) == 0 then
						JoinTemporaryChannel("LeaveMe" .. index)
					end
					index = index + 1
				end
				if GetChannelName(index) == 0 then
					JoinChannelByName(name)
				end
				index = index + 1
			end

			self:ScheduleTimer(function()
				module:leave_placeholder_channels(GetChannelList())
			end, get_delay())
		end
	else
		function module:restore_channels(...)
			local index = 1
			for i = 1, select("#", ...), 3 do
				local num, name = select(i, ...);
				while index < num do
					if GetChannelName(index) == 0 then
						JoinTemporaryChannel("LeaveMe" .. index)
					end
					index = index + 1
				end
				if GetChannelName(index) == 0 then
					local club_id, stream_id = Prat.GetCommunityAndStreamFromChannel(name);
					if not club_id or not stream_id then
						JoinChannelByName(name)
					else
						ChatFrame_AddNewCommunitiesChannel(1, club_id, stream_id)
					end
				end
				index = index + 1
			end
			self:ScheduleTimer(function()
				module:leave_placeholder_channels(GetChannelList())
			end, get_delay())
		end
	end
	--[[------------------------------------------------
		BR: Máquina de estados para restauração incremental das configurações
		EN: State machine for incremental settings restoration
	------------------------------------------------]]--
	function module:load_settings()
		local db = self.db.profile
		local success = true

		if not next(db.frames) then
			self:Output(PL["msg_no_settings"])
			self.needs_loading = nil
			return
		end

		if not self.working then
			self.working = {}
		end

		-- restore CVars
		if not self.working.cvars then
			for k, _ in pairs(chat_cvars) do
				local val = db.cvars[k]
				if val ~= nil then
					SetCVar(k, val)
				end
			end
			self.working.cvars = true
		end

		-- Disabled for retail because it causes taint errors with edit mode
		if Prat.IsClassic then
			-- restore frame appearance and layout
			if not self.working.frames then
				for k, _ in pairs(db.frames) do
					if not self:load_frame_settings_for_frame(k) then
						success = false
					end
				end
				FCFDock_SelectWindow(GENERAL_CHAT_DOCK, ChatFrame1)
				self.working.frames = success
			end
		end

		-- restore chat channels
		if not self.working.channels and db.channels and #db.channels > 0 then
			self.error_count = 0
			self:ScheduleTimer("check_channels", get_delay(), GetChannelList())
			self.working.channels = true
			return
		end

		-- restore channels and messages to chat_frames
		if not self.working.chat_frames then
			for k, _ in pairs(db.frames) do
				if not self:load_chat_settings_for_frame(k) then
					success = false
				end
			end
			self.working.chat_frames = success
		end

		-- restore chat colors
		if not self.working.chat_colors then
			for k, v in pairs(db.types) do
				ChangeChatColor(k, v.r, v.g, v.b)
			end
			self.working.chat_colors = true
		end

		if success then
			self.needs_loading = nil
			self.working = nil
			self.error_count = 0
			self:Output(PL["msg_settings_loaded"])
		else
			self.error_count = self.error_count + 1

			if self.error_count > 10 then
				self.working = nil
				self.error_count = 0
				self:Output(PL["msg_load_failed"])
				return
			end
			self:ScheduleTimer("load_settings", get_delay())
		end
	end

	--[[------------------------------------------------
		BR: Oculta mensagens de saída/entrada de canais durante restauração
		EN: Hides channel leave/join messages during restoration
	------------------------------------------------]]--
	function module:Prat_PreAddMessage(_, message)
		if self.working and ("YOU_CHANGED" == message.NOTICE or "YOU_LEFT" == message.NOTICE) then
			message.DONOTPROCESS = true
		end
	end
end)

