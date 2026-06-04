--[[
    @File:      helpers.lua
    @Project:   Prat-3.0

    BR: Serviço auxiliar para resolução de canais, nomes de jogadores e links de chat.
        - Resolve nomes de comunidades e streams do sistema de clubes da Blizzard
        - Decora nomes de remetentes com classe, filtros e ícones contextuais
        - Monta hyperlinks internos de jogadores e comunidades usados pelo chat

    EN: Helper service for resolving channels, player names, and chat links.
        - Resolves community and stream names from Blizzard's club system
        - Decorates sender names with class colors, filters, and contextual icons
        - Builds internal player and community hyperlinks used by chat

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local _, private = ...

local issecretvalue = issecretvalue or function() return false end

--[[------------------------------------------------
    BR: Extrai os identificadores de comunidade e stream a partir do canal bruto.
        O pattern abaixo faz parte do parsing interno e deve ser preservado.
    EN: Extracts community and stream identifiers from the raw channel value.
        The pattern below is part of the internal parsing and must be preserved.
------------------------------------------------]]--
function private.GetCommunityAndStreamFromChannel(communityChannel)
	local clubId, streamId = communityChannel:match("(%d+)%:(%d+)")
	return tonumber(clubId), tonumber(streamId)
end

--[[------------------------------------------------
    BR: Resolve o nome exibível de uma comunidade/stream usando a API C_Club.
        Preserva o tratamento especial de Guild, Officer e General.
    EN: Resolves the display name for a community/stream using the C_Club API.
        Preserves the special handling for Guild, Officer, and General streams.
------------------------------------------------]]--
function private.GetCommunityAndStreamName(clubId, streamId)
	local streamInfo = C_Club.GetStreamInfo(clubId, streamId)

	if streamInfo and (streamInfo.streamType == Enum.ClubStreamType.Guild or streamInfo.streamType == Enum.ClubStreamType.Officer) then
		return streamInfo.name
	end

	local streamName = streamInfo and streamInfo.name or ""

	local clubInfo = C_Club.GetClubInfo(clubId)
	if streamInfo and streamInfo.streamType == Enum.ClubStreamType.General then
		if not clubInfo then
			return ""
		end
		local _name = clubInfo.shortName or clubInfo.name
		if not issecretvalue(_name) then
			_name = ChatFrameUtil.TruncateToMaxLength(_name, ChatFrameConstants.TruncatedCommunityNameWithoutChannelLength)
		end
		return _name
	else
		if not clubInfo then
			return ""
		end
		local _name = clubInfo.shortName or clubInfo.name
		if not issecretvalue(_name) then
			_name = ChatFrameUtil.TruncateToMaxLength(_name, ChatFrameConstants.TruncatedCommunityNameLength)
		end
		return _name .. " - " .. streamName
	end
end

--[[------------------------------------------------
    BR: Resolve um identificador de canal de comunidade para seu nome exibível.
    EN: Resolves a community channel identifier into its display name.
------------------------------------------------]]--
function private.ResolveChannelName(communityChannel)
	local clubId, streamId = private.GetCommunityAndStreamFromChannel(communityChannel)
	if not clubId or not streamId then
		return communityChannel
	end

	return private.GetCommunityAndStreamName(clubId, streamId)
end

--[[------------------------------------------------
    BR: Resolve canais com prefixo numérico preservando o prefixo original.
        O pattern é sensível e não deve ser alterado sem validação no cliente.
    EN: Resolves numerically-prefixed channels while preserving the original prefix.
        The pattern is sensitive and should not be changed without client validation.
------------------------------------------------]]--
function private.ResolvePrefixedChannelName(communityChannelArg)
	local prefix, communityChannel = communityChannelArg:match("(%d+. )(.*)")
	return prefix .. private.ResolveChannelName(communityChannel)
end

--[[------------------------------------------------
    BR: Monta o nome decorado do remetente para exibição no chat.
        Integra Ambiguate, classe, filtros da Blizzard e ícones contextuais.
    EN: Builds the decorated sender name for chat display.
        Integrates Ambiguate, class colors, Blizzard filters, and contextual icons.
------------------------------------------------]]--
function private.GetDecoratedSenderName(event, ...)
	local _, senderName, _, _, _, _, _, channelIndex, _, _, _, senderGUID = ...
	local chatType = string.sub(event, 10)

	if string.find(chatType, "^WHISPER") then
		chatType = "WHISPER"
	end

	if string.find(chatType, "^CHANNEL") then
		chatType = "CHANNEL" .. channelIndex
	end

	local chatTypeInfo = ChatTypeInfo[chatType]
	local decoratedPlayerName = senderName

	local _, englishClass, firstName
	if senderGUID then
		_, englishClass, _, _, _, firstName = GetPlayerInfoByGUID(senderGUID)
	end

	-- Ambiguate guild chat names
	if Ambiguate and not issecretvalue(senderName) then
		if chatType == "GUILD" then
			decoratedPlayerName = Ambiguate(decoratedPlayerName, "guild")
		else
			decoratedPlayerName = Ambiguate(decoratedPlayerName, "none")
		end
	elseif firstName then
		decoratedPlayerName = firstName
	end

	-- Add timerunning icon when necessary based on player guid
	if senderGUID and not issecretvalue(senderGUID) and C_ChatInfo.IsTimerunningPlayer(senderGUID) then
		decoratedPlayerName = TimerunningUtil.AddSmallIcon(decoratedPlayerName)
	end

	if senderGUID and chatTypeInfo and GetPlayerInfoByGUID ~= nil then
		if englishClass then
			local classColor = private.GetClassColor(englishClass)

			if classColor then
				decoratedPlayerName = classColor:WrapTextInColorCode(decoratedPlayerName)
			end
		end
	end

	if ChatFrameUtil.ProcessSenderNameFilters then
		decoratedPlayerName = ChatFrameUtil.ProcessSenderNameFilters(event, decoratedPlayerName, ...)
	end
	if decoratedPlayerName then
		if not issecretvalue(decoratedPlayerName) and decoratedPlayerName == "" then
			return decoratedPlayerName
		end
		return "[" .. decoratedPlayerName .. "]"
	end
end

--[[------------------------------------------------
    BR: Normaliza dados numéricos usados em hyperlinks de comunidade.
        A formatação evita notação científica e deve ser preservada.
    EN: Normalizes numeric data used in community hyperlinks.
        The formatting avoids scientific notation and must be preserved.
------------------------------------------------]]--
local function SanitizeCommunityData(clubId, streamId, epoch, position)
	if type(clubId) == "number" then
		clubId = ("%.f"):format(clubId)
	end
	if type(streamId) == "number" then
		streamId = ("%.f"):format(streamId)
	end
	epoch = ("%.f"):format(epoch)
	position = ("%.f"):format(position)

	return clubId, streamId, epoch, position
end

--[[------------------------------------------------
    BR: Construtores de hyperlinks internos do chat.
        As strings |H...|h fazem parte do protocolo da UI Blizzard.
    EN: Builders for internal chat hyperlinks.
        The |H...|h strings are part of Blizzard UI's hyperlink protocol.
------------------------------------------------]]--
function private.GetBNPlayerCommunityLink(playerName, linkDisplayText, bnetIDAccount, clubId, streamId, epoch, position)
	clubId, streamId, epoch, position = SanitizeCommunityData(clubId, streamId, epoch, position)
	return string.format("|HBNplayerCommunity:%s:%s:%s:%s:%s:%s|h%s|h", playerName, bnetIDAccount, clubId, streamId, epoch, position, linkDisplayText)
end

function private.GetPlayerCommunityLink(playerName, linkDisplayText, clubId, streamId, epoch, position)
	clubId, streamId, epoch, position = SanitizeCommunityData(clubId, streamId, epoch, position)
	return string.format("|HBNplayerCommunity:%s:%s:%s:%s:%s|h%s|h", playerName, clubId, streamId, epoch, position, linkDisplayText)
end

function private.GetPlayerLink(characterName, linkDisplayText, lineID, chatType, chatTarget)
	return string.format("|Hplayer:%s:%s:%s:%s|h%s|h", characterName, lineID or 0, chatType or 0, chatTarget or "", linkDisplayText)
end

function private.GetBNPlayerLink(name, linkDisplayText, bnetIDAccount, lineID, chatType, chatTarget)
	return string.format("|HBNplayer:%s:%s:%s:%s:%s|h%s|h", name, bnetIDAccount, lineID, chatType, chatTarget, linkDisplayText)
end
