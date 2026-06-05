--[[
    @File:      channelapi.lua
    @Project:   Prat-3.0

    BR: Serviço de gerenciamento e cache de canais do chat.
        - Reconstrução dinâmica de canais
        - Resolução de nomes de comunidade
        - Lookup bidirecional nome/id
        - Hooks automáticos de atualização

    EN: Chat channel management and cache service.
        - Dynamic channel rebuilding
        - Community name resolution
        - Bidirectional name/id lookup
        - Automatic update hooks

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local _, private = ...

local chanTable = {}

--[[------------------------------------------------
    BR: Reconstrói a tabela interna de canais.
    EN: Rebuilds the internal channel table.
------------------------------------------------]]--
function private.RebuildChannelTable()
	table.wipe(chanTable)

	local channels = { GetChannelList() }

	if #channels > 0 then
		for i = 1, #channels, 3 do
			local num, name = channels[i], channels[i + 1]

			name = private.ResolveChannelName(name)

			if not issecretvalue or not issecretvalue(name) then
				chanTable[num] = name
				chanTable[name] = num
			end
		end
	end

	--[[--------------------------------------------
	    BR: Fallback manual para LookingForGroup.
	    EN: Manual fallback for LookingForGroup.
	--------------------------------------------]]--
	if not chanTable["LookingForGroup"] then
		local lfgnum = GetChannelName("LookingForGroup")

		if lfgnum and lfgnum > 0 then
			chanTable["LookingForGroup"] = lfgnum
			chanTable[lfgnum] = "LookingForGroup"
		end
	end

	--[[--------------------------------------------
	    BR: Cria lookup case-insensitive.
	    EN: Creates case-insensitive lookup.
	--------------------------------------------]]--
	for k, v in pairs(chanTable) do
		if type(k) == "string" then
			chanTable[k:lower()] = v
		end
	end
end

--[[------------------------------------------------
    BR: Retorna a tabela de canais reconstruindo quando necessário.
    EN: Returns the channel table rebuilding it when necessary.
------------------------------------------------]]--
function private.GetChannelTable()
	if #chanTable == 0 then
		private.RebuildChannelTable()
	end

	return chanTable
end

--[[------------------------------------------------
    BR: Hooks automáticos para atualização de canais.
    EN: Automatic hooks for channel updates.
------------------------------------------------]]--
if ChatFrame_AddCommunitiesChannel then
	hooksecurefunc("ChatFrame_AddCommunitiesChannel", function()
		private.RebuildChannelTable()
	end)

	hooksecurefunc("ChatFrame_RemoveCommunitiesChannel", function()
		private.RebuildChannelTable()
	end)

elseif ChatFrameUtil and ChatFrameUtil.AddCommunitiesChannel then
	hooksecurefunc(ChatFrameUtil, "AddCommunitiesChannel", function()
		private.RebuildChannelTable()
	end)

	hooksecurefunc(ChatFrameUtil, "RemoveCommunitiesChannel", function()
		private.RebuildChannelTable()
	end)
end

hooksecurefunc(C_ChatInfo, "SwapChatChannelsByChannelIndex", function()
	private.RebuildChannelTable()
end)
