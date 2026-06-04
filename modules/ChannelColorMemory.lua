--[[
    @File:      ChannelColorMemory.lua
    @Project:   Prat-3.0

    BR: Memória de cores dos canais de chat.
        - Salva cores associadas aos nomes dos canais
        - Restaura cores ao reencontrar/reentrar em canais
        - Sincroniza cores após mudanças manuais
        - Mantém canais por nome, independentemente do número atual

    EN: Chat channel color memory.
        - Saves colors associated with channel names
        - Restores colors when channels are found or rejoined
        - Synchronizes colors after manual changes
        - Tracks channels by name, regardless of their current number

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
		BR: Criação do módulo de memória de cores dos canais
		EN: Creation of the channel color memory module
	------------------------------------------------]]--
	local module = Prat:NewModule("ChannelColorMemory", "AceEvent-3.0")

	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			colors = {},
		}
	})

	--[[------------------------------------------------
		BR: Configuração das opções da interface do módulo
		EN: Module interface options configuration
	------------------------------------------------]]--
	Prat:SetModuleOptions(module.name, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		args = {
			info_group = {
				type = "group",
				name = PL["info_group_name"],
				desc = PL["info_group_desc"],
				inline = true,
				order = 100,
				args = {
					info = {
						type = "description",
						name = PL["info_text"],
						order = 10,
						width = "full",
					},

					info_spacer = {
						type = "description",
						name = " ",
						order = 20,
						width = "full",
					},

					note = {
						type = "description",
						name = PL["info_note"],
						order = 30,
						width = "full",
					},
				}
			}
		}
	})

	--[[------------------------------------------------
		BR: Ativação do módulo, eventos e restauração inicial das cores
		EN: Module activation, events and initial color restoration
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:RegisterEvent("UPDATE_CHAT_COLOR")
		self:RegisterEvent("CHAT_MSG_CHANNEL_NOTICE")
		self.zone_chan_idx = {}

		-- BR: Atualiza nomes antigos salvos para minúsculas.
		-- EN: Upgrades old saved channel names to lowercase.
		for channel_name, color in pairs(self.db.profile.colors) do
			local normalized_name = channel_name:lower()
			if channel_name ~= normalized_name then
				self.db.profile.colors[normalized_name] = color
			end
		end

		self:restore_all_chat_colors()
	end

	--[[------------------------------------------------
		BR: Retorna a descrição localizada do módulo
		EN: Returns the localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Indexa canais do servidor pelo número atual da janela de chat
		EN: Indexes server channels by the current chat window number
	------------------------------------------------]]--
	function module:index_server_channels()
		for _, frame in pairs(Prat.HookedFrames) do
			local channels = { GetChatWindowChannels(frame:GetID()) }
			for i = 1, #channels, 2 do
				local channel_name, channel_number = channels[i], channels[i + 1]
				if tonumber(channel_number) and tonumber(channel_number) > 0 then
					self.zone_chan_idx[tostring(channel_number)] = tostring(channel_name)
				end
			end
		end
	end

	--[[------------------------------------------------
		BR: Restaura cores salvas para todos os canais conhecidos
		EN: Restores saved colors for all known channels
	------------------------------------------------]]--
	function module:restore_all_chat_colors()
		for _, frame in pairs(Prat.HookedFrames) do
			local channels = { GetChatWindowChannels(frame:GetID()) }
			for i = 1, #channels, 2 do
				local channel_name, channel_number = channels[i], channels[i + 1]

				if tonumber(channel_number) and tonumber(channel_number) > 0 then
					self.zone_chan_idx[tostring(channel_number)] = tostring(channel_name)
				end

				if channel_name and channel_name:len() > 0 then
					local color = self.db.profile.colors[channel_name:lower()]
					if color then
						local active_channel_number = Prat.GetChannelName(channel_name)
						if active_channel_number then
							ChangeChatColor("CHANNEL" .. active_channel_number, color.r, color.g, color.b)
						end
					end
				end
			end
		end
	end

	--[[------------------------------------------------
		BR: Resolve o nome real do canal conforme a lista do servidor
		EN: Resolves the real channel name from the server channel list
	------------------------------------------------]]--
	local function get_server_channel_name(name)
		local channels = { EnumerateServerChannels() }
		for _, channel_name in pairs(channels) do
			if channel_name:lower() == name:lower() then
				return channel_name
			end
		end
	end

	--[[------------------------------------------------
		BR: Salva alterações manuais de cor feitas pelo usuário
		EN: Saves manual color changes made by the user
	------------------------------------------------]]--
	function module:UPDATE_CHAT_COLOR(_, chat_type, cr, cg, cb)
		if not chat_type then
			return
		end

		local channel_number = chat_type:match("CHANNEL(%d+)")
		if not channel_number then
			return
		end

		local _, channel_name = Prat.GetChannelName(channel_number)
		if not channel_name then
			return
		end

		local zone_suffix
		channel_name, zone_suffix = channel_name:match(PL["channel_name_pattern"])

		if zone_suffix and zone_suffix:len() > 0 then
			channel_name = get_server_channel_name(channel_name)
		end

		if not channel_name then
			return
		end

		local color = self.db.profile.colors[channel_name:lower()]
		if not color then
			self.db.profile.colors[channel_name:lower()] = { r = cr, g = cg, b = cb }
		else
			color.r = cr
			color.g = cg
			color.b = cb
		end
	end

	--[[------------------------------------------------
		BR: Restaura ou registra cores quando o jogador entra/sai de canais
		EN: Restores or records colors when the player joins/leaves channels
	------------------------------------------------]]--
	function module:CHAT_MSG_CHANNEL_NOTICE(_, notice_type, _, _, _, _, _, server_channel_id, number, channel_name)
		if issecretvalue and issecretvalue(notice_type) then
			return
		end

		if tonumber(server_channel_id) and tonumber(server_channel_id) > 0 then
			channel_name = self.zone_chan_idx[tostring(server_channel_id)]

			if not channel_name then
				self:index_server_channels()
				channel_name = self.zone_chan_idx[tostring(server_channel_id)]
			end
		end

		if number == nil or channel_name == nil then
			return
		elseif notice_type == "YOU_JOINED" then
			local color = self.db.profile.colors[channel_name:lower()]
			if color then
				ChangeChatColor("CHANNEL" .. number, color.r, color.g, color.b)
			end
		elseif notice_type == "YOU_LEFT" then
			local color = self.db.profile.colors[channel_name:lower()]
			if color then
				ChangeChatColor("CHANNEL" .. number, 1.0, 0.75, 0.75)
			else
				color = ChatTypeInfo["CHANNEL" .. number]
				-- BR: A cor pode não existir se o número for 0.
				-- EN: The color may not exist if the number is 0.
				if color then
					self.db.profile.colors[channel_name:lower()] = { r = color.r, g = color.g, b = color.b }
				end
			end
		end
	end

	return
end) -- Prat:AddModuleToLoad
