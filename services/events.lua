--[[
    @File:      events.lua
    @Project:   Prat-3.0

    BR: Serviço de controle e roteamento de eventos do chat.
        - Definição de tipos de processamento
        - Mapeamento de eventos suportados
        - Controle dinâmico de processamento
        - Gerenciamento do pipeline de eventos

    EN: Chat event routing and processing control service.
        - Processing type definitions
        - Supported event mapping
        - Dynamic processing control
        - Event pipeline management

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local _, private = ...

--[[------------------------------------------------
    BR: Tipos de processamento utilizados no pipeline.
    EN: Processing types used in the pipeline.
------------------------------------------------]]--
private.EventProcessingType = {
	Full = 1,
	PatternsOnly = 2,
}

--[[------------------------------------------------
    BR: Mapeamento de eventos processados pelo addon.
    EN: Mapping of events processed by the addon.
------------------------------------------------]]--
local eventMap = {
	CHAT_MSG_CHANNEL = private.EventProcessingType.Full,
	CHAT_MSG_SAY = private.EventProcessingType.Full,
	CHAT_MSG_GUILD = private.EventProcessingType.Full,
	CHAT_MSG_WHISPER = private.EventProcessingType.Full,
	CHAT_MSG_WHISPER_INFORM = private.EventProcessingType.Full,
	CHAT_MSG_YELL = private.EventProcessingType.Full,
	CHAT_MSG_PARTY = private.EventProcessingType.Full,
	CHAT_MSG_PARTY_LEADER = private.EventProcessingType.Full,
	CHAT_MSG_OFFICER = private.EventProcessingType.Full,
	CHAT_MSG_RAID = private.EventProcessingType.Full,
	CHAT_MSG_RAID_LEADER = private.EventProcessingType.Full,
	CHAT_MSG_RAID_WARNING = private.EventProcessingType.Full,
	CHAT_MSG_INSTANCE_CHAT = private.EventProcessingType.Full,
	CHAT_MSG_INSTANCE_CHAT_LEADER = private.EventProcessingType.Full,
	CHAT_MSG_SYSTEM = private.EventProcessingType.Full,
	CHAT_MSG_DND = private.EventProcessingType.Full,
	CHAT_MSG_AFK = private.EventProcessingType.Full,
	CHAT_MSG_BN_WHISPER = private.EventProcessingType.Full,
	CHAT_MSG_BN_WHISPER_INFORM = private.EventProcessingType.Full,
	CHAT_MSG_BN_CONVERSATION = private.EventProcessingType.Full,
	CHAT_MSG_COMMUNITIES_CHANNEL = private.EventProcessingType.Full,

	--[[--------------------------------------------
	    BR: Eventos que utilizam apenas matching/patterns.
	    EN: Events using pattern-only processing.
	--------------------------------------------]]--
	CHAT_MSG_LOOT = private.EventProcessingType.PatternsOnly,
}

--[[------------------------------------------------
    BR: Habilita, altera ou desabilita processamento de evento.
    EN: Enables, changes or disables event processing.
------------------------------------------------]]--
function private.EnableProcessingForEvent(event, flag)
	if flag == nil or flag == true then
		eventMap[event] = private.EventProcessingType.Full

	elseif flag ~= false then
		eventMap[event] = flag

	else
		eventMap[event] = nil
	end
end

--[[------------------------------------------------
    BR: Verifica se um evento possui processamento ativo.
    EN: Checks whether an event has active processing.
------------------------------------------------]]--
function private.EventIsProcessed(event)
	return eventMap[event]
end
