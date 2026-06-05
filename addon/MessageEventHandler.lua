--[[
    @File:      MessageEventHandler.lua
    @Project:   Prat-3.0

    BR: Manipulador central de eventos de mensagens do chat.
        - Processa eventos CHAT_MSG_* recebidos pelo cliente
        - Reconstrói mensagens usando a lógica padrão da Blizzard
        - Preserva links, canais, idiomas, nomes e metadados
        - Encaminha mensagens formatadas para o fluxo interno do Prat

    EN: Central chat message event handler.
        - Processes CHAT_MSG_* events received by the client
        - Rebuilds messages using Blizzard's default logic
        - Preserves links, channels, languages, names and metadata
        - Forwards formatted messages into Prat's internal flow

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local _, private = ...

-- Custom hacks
--[[------------------------------------------------
    BR: Resolve o alvo real da conversa para canais e whispers
    EN: Resolves the real chat target for channels and whispers
------------------------------------------------]]--
local function GetChatTarget(chatGroup, arg2, arg8)
	local chatTarget
	if chatGroup == "CHANNEL" then
		chatTarget = tostring(arg8)
	elseif chatGroup == "WHISPER" or chatGroup == "BN_WHISPER" then
		chatTarget = arg2
		if (not issecretvalue or not issecretvalue(arg2)) and strsub(arg2, 1, 2) ~= "|K" then
			chatTarget = strupper(arg2)
		end
	end

	return chatTarget
end

-- MessageEventHandler
--[[------------------------------------------------
    BR: Manipulador principal para eventos CHAT_MSG_* da interface Blizzard
    EN: Main handler for Blizzard CHAT_MSG_* events
------------------------------------------------]]--
function private.MessageEventHandler(self, event, ...)
	if strsub(event, 1, 8) ~= "CHAT_MSG" then
		return
	end
	--[[------------------------------------------------
		BR: Captura os argumentos brutos enviados pelo evento de chat
		EN: Captures the raw arguments sent by the chat event
	------------------------------------------------]]--
	local arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, _, arg16, arg17 = ...
	if (arg16) then
		-- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)
		return true
	end

	local type = strsub(event, 10)
	local info = ChatTypeInfo[type]

	--If it was a GM whisper, dispatch it to the GMChat addon.
	if arg6 == "GM" and type == "WHISPER" then
		return
	end

	local shouldDiscardMessage
	shouldDiscardMessage, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14
		= ChatFrameUtil.ProcessMessageEventFilters(self, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)

	if shouldDiscardMessage then
		return true
	end

	--[[------------------------------------------------
		BR: Obtém o nome do remetente já decorado pela lógica da Blizzard
		EN: Gets the sender name already decorated by Blizzard logic
	------------------------------------------------]]--
	local coloredName = private.GetDecoratedSenderName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)

	local channelLength = strlen(arg4)

	if type == "VOICE_TEXT" and not GetCVarBool("speechToText") then
		return
	elseif ((type == "COMMUNITIES_CHANNEL") or ((strsub(type, 1, 7) == "CHANNEL") and (type ~= "CHANNEL_LIST"))) then
		local newInfoType = "CHANNEL" .. arg8
		if newInfoType then
			info = ChatTypeInfo[newInfoType]
		end
	end

	--[[------------------------------------------------
		BR: Determina o grupo e o alvo usados para construir links de jogador/canal
		EN: Determines the group and target used to build player/channel links
	------------------------------------------------]]--
	local chatGroup = ChatFrameUtil.GetChatCategory(type)
	local chatTarget = GetChatTarget(chatGroup, arg2, arg8)

	if (type == "SYSTEM" or type == "SKILL" or type == "CURRENCY" or type == "MONEY" or
		type == "OPENING" or type == "TRADESKILLS" or type == "PET_INFO" or type == "TARGETICONS" or type == "BN_WHISPER_PLAYER_OFFLINE") then
		self:AddMessage(arg1, info.r, info.g, info.b, info.id)
	elseif (type == "LOOT") then
		self:AddMessage(arg1, info.r, info.g, info.b, info.id)
	elseif (strsub(type, 1, 7) == "COMBAT_") then
		self:AddMessage(arg1, info.r, info.g, info.b, info.id)
	elseif (strsub(type, 1, 6) == "SPELL_") then
		self:AddMessage(arg1, info.r, info.g, info.b, info.id)
	elseif (strsub(type, 1, 10) == "BG_SYSTEM_") then
		self:AddMessage(arg1, info.r, info.g, info.b, info.id)
	elseif (strsub(type, 1, 11) == "ACHIEVEMENT") then
		self:AddMessage(arg1:format(private.GetPlayerLink(arg2, ("[%s]"):format(coloredName))), info.r, info.g, info.b, info.id)
	elseif (strsub(type, 1, 18) == "GUILD_ACHIEVEMENT") then
		local message = arg1:format(private.GetPlayerLink(arg2, ("[%s]"):format(coloredName)))
		self:AddMessage(message, info.r, info.g, info.b, info.id)
	elseif (type == "PING") then
		self:AddMessage(arg1, info.r, info.g, info.b, info.id)
	elseif (type == "IGNORED") then
		self:AddMessage(string.format(CHAT_IGNORED, arg2), info.r, info.g, info.b, info.id)
	elseif (type == "FILTERED") then
		self:AddMessage(string.format(CHAT_FILTERED, arg2), info.r, info.g, info.b, info.id)
	elseif (type == "RESTRICTED") then
		self:AddMessage(CHAT_RESTRICTED_TRIAL, info.r, info.g, info.b, info.id)
	elseif (type == "CHANNEL_LIST") then
		if (channelLength > 0) then
			self:AddMessage(string.format(ChatFrameUtil.GetOutMessageFormatKey(type) .. arg1, tonumber(arg8), arg4), info.r, info.g, info.b, info.id)
		else
			self:AddMessage(arg1, info.r, info.g, info.b, info.id)
		end
	elseif (type == "CHANNEL_NOTICE_USER") then
		return
	elseif (type == "CHANNEL_NOTICE") then
		return
	elseif (type == "BN_INLINE_TOAST_ALERT") then
		return
	elseif (type == "BN_INLINE_TOAST_BROADCAST") then
		if (arg1 ~= "") then
			arg1 = C_StringUtil.RemoveContiguousSpaces(arg1)
			local linkDisplayText = ("[%s]"):format(arg2)
			--[[------------------------------------------------
				BR: Monta o link clicável do jogador, Battle.net ou comunidade
				EN: Builds the clickable player, Battle.net or community link
			------------------------------------------------]]--
			local playerLink = private.GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, ChatFrameUtil.GetChatCategory(type), 0)
			self:AddMessage(string.format(BN_INLINE_TOAST_BROADCAST, playerLink, arg1), info.r, info.g, info.b, info.id)
		end
	elseif (type == "BN_INLINE_TOAST_BROADCAST_INFORM") then
		if (arg1 ~= "") then
			self:AddMessage(BN_INLINE_TOAST_BROADCAST_INFORM, info.r, info.g, info.b, info.id)
		end
	else
		--[[------------------------------------------------
		BR: Fluxo padrão para mensagens de jogadores e comunidades
		EN: Default flow for player and community messages
	------------------------------------------------]]--
	local playerName, lineID, bnetIDAccount = arg2, arg11, arg13

		--[[------------------------------------------------
			BR: Reconstrói visualmente a mensagem conforme regras da Blizzard
			EN: Visually rebuilds the message according to Blizzard rules
		------------------------------------------------]]--
		local function MessageFormatter(msg)
			-- Add AFK/DND flags
			--[[------------------------------------------------
				BR: Adiciona marcadores AFK/DND quando existirem
				EN: Adds AFK/DND flags when present
			------------------------------------------------]]--
			local pflag = ChatFrameUtil.GetPFlag(arg6, arg7, arg8)

			if (type == "WHISPER_INFORM" and GMChatFrame_IsGM and GMChatFrame_IsGM(arg2)) then
				return
			end

			local showLink = 1
			if (strsub(type, 1, 7) == "MONSTER" or strsub(type, 1, 9) == "RAID_BOSS") then
				showLink = nil
			else
				msg = C_StringUtil.EscapeLuaFormatString(msg)
			end

			-- Search for icon links and replace them with texture links.
			msg = C_ChatInfo.ReplaceIconAndGroupExpressions(msg, arg17, not ChatFrameUtil.CanChatGroupPerformExpressionExpansion(chatGroup)) -- If arg17 is true, don't convert to raid icons

			--Remove groups of many spaces
			msg = C_StringUtil.RemoveContiguousSpaces(msg, 4)

			local playerLink
			local playerLinkDisplayText = coloredName
			local relevantDefaultLanguage = self.defaultLanguage
			if ((type == "SAY") or (type == "YELL")) then
				relevantDefaultLanguage = self.alternativeDefaultLanguage
			end
			local usingDifferentLanguage = (arg3 ~= "") and (arg3 ~= relevantDefaultLanguage)
			local usingEmote = (type == "EMOTE") or (type == "TEXT_EMOTE")

			if (usingDifferentLanguage or not usingEmote) then
				playerLinkDisplayText = ("[%s]"):format(coloredName)
			end

			local isCommunityType = type == "COMMUNITIES_CHANNEL"
			if (isCommunityType) then
				local isBattleNetCommunity = bnetIDAccount ~= nil
				local messageInfo, clubId, streamId = C_Club.GetInfoFromLastCommunityChatLine()
				if (messageInfo ~= nil) then
					if (isBattleNetCommunity) then
						playerLink = private.GetBNPlayerCommunityLink(playerName, playerLinkDisplayText, bnetIDAccount, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position)
					else
						playerLink = private.GetPlayerCommunityLink(playerName, playerLinkDisplayText, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position)
					end
				else
					playerLink = playerLinkDisplayText
				end
			else
				if (type == "BN_WHISPER" or type == "BN_WHISPER_INFORM") then
					playerLink = private.GetBNPlayerLink(playerName, playerLinkDisplayText, bnetIDAccount, lineID, chatGroup, chatTarget)
				else
					playerLink = private.GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
				end
			end

			local message = msg
			-- isMobile
			if arg14 then
				message = ChatFrameUtil.GetMobileEmbeddedTexture(info.r, info.g, info.b) .. message
			end

			local outMsg
			--[[------------------------------------------------
				BR: Adiciona cabeçalho de idioma quando a mensagem usa outro idioma
				EN: Adds a language header when the message uses another language
			------------------------------------------------]]--
			if (usingDifferentLanguage) then
				local languageHeader = "[" .. arg3 .. "] "
				if showLink then
					outMsg = string.format(ChatFrameUtil.GetOutMessageFormatKey(type) .. languageHeader .. message, pflag .. playerLink)
				else
					outMsg = string.format(ChatFrameUtil.GetOutMessageFormatKey(type) .. languageHeader .. message, pflag .. arg2)
				end
			else
				if not showLink then
					if (type == "TEXT_EMOTE") then
						outMsg = message
					else
						outMsg = string.format(ChatFrameUtil.GetOutMessageFormatKey(type) .. message, pflag .. arg2, arg2)
					end
				else
					if (type == "EMOTE") then
						outMsg = string.format(ChatFrameUtil.GetOutMessageFormatKey(type) .. message, pflag .. playerLink)
					elseif (type == "TEXT_EMOTE") then
						outMsg = message
					elseif (type == "GUILD_ITEM_LOOTED") then
						outMsg = string.gsub(message, "$s", private.GetPlayerLink(arg2, playerLinkDisplayText))
					else
						outMsg = string.format(ChatFrameUtil.GetOutMessageFormatKey(type) .. message, pflag .. playerLink)
					end
				end
			end

			-- Add Channel
			--[[------------------------------------------------
				BR: Adiciona o link do canal antes da mensagem final
				EN: Adds the channel link before the final message
			------------------------------------------------]]--
			if (channelLength > 0) then
				outMsg = "|Hchannel:channel:" .. arg8 .. "|h[" .. private.ResolvePrefixedChannelName(arg4) .. "]|h " .. outMsg
			end

			return outMsg
		end

		--[[------------------------------------------------
			BR: Mantém suporte ao sistema de censura/aprovação do chat
			EN: Preserves support for the chat censor/approval system
		------------------------------------------------]]--
		local isChatLineCensored = C_ChatInfo.IsChatLineCensored(lineID)
		local msg = isChatLineCensored and arg1 or MessageFormatter(arg1)
		local accessID = 0
		local typeID = 0

		-- The message formatter is captured so that the original message can be reformatted when a censored message
		-- is approved to be shown.
		local eventArgs = SafePack(...)
		self:AddMessage(msg, info.r, info.g, info.b, info.id, accessID, typeID, event, eventArgs, MessageFormatter)
	end

	--[[------------------------------------------------
		BR: Executa alertas sonoros e visuais para whispers
		EN: Runs sound and visual alerts for whispers
	------------------------------------------------]]--
	if (type == "WHISPER" or type == "BN_WHISPER") then
		if (not self.tellTimer or (GetTime() > self.tellTimer)) then
			PlaySound(SOUNDKIT.TELL_MESSAGE)
		end
		self.tellTimer = GetTime() + ChatFrameConstants.WhisperSoundAlertCooldown

		-- We don't flash the app icon for front end chat for now.
		if FlashClientIcon then
			FlashClientIcon()
		end
	end

	ChatFrameUtil.FlashTabIfNotShown(self, info, type, chatGroup, chatTarget)

	return true
end
