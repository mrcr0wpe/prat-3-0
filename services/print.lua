--[[
    @File:      print.lua
    @Project:   Prat-3.0

    BR: Serviço interno de impressão e depuração do Prat.
        - Monta mensagens com prefixo visual do addon
        - Envia saída para o chat padrão do WoW
        - Injeta métodos auxiliares de impressão nos ChatFrames

    EN: Internal Prat print and debug service.
        - Builds messages with the addon's visual prefix
        - Sends output to the default WoW chat frame
        - Injects auxiliary print methods into ChatFrames

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local _, private = ...

local NUM_CHAT_WINDOWS = NUM_CHAT_WINDOWS or Constants.ChatFrameConstants.MaxChatWindows

--[[------------------------------------------------
    BR: Monta o texto final exibido pelo método de impressão interno.
    EN: Builds the final text displayed by the internal print method.
------------------------------------------------]]--
local function buildText(...)
	local text = "|cffffff78" .. tostring(private) .. ":|r "

	for i = 1, select("#", ...) do
		local parm = select(i, ...)
		if type(parm) == "string" then
			text = text .. parm
		else
			text = text .. tostring(parm) .. " "
		end
	end

	if text == nil or #text == 0 then
		return ""
	end

	return text
end

--[[------------------------------------------------
    BR: Método de impressão inspirado no AceConsole-3.0.
        Envia mensagens formatadas para o chat padrão.
    EN: Print method inspired by AceConsole-3.0.
        Sends formatted messages to the default chat frame.
------------------------------------------------]]--
if not private.Print then
	function private.Print(self, ...)
		local text = (self == private) and buildText(...) or buildText(self, ...)

		if text == nil or #text == 0 then
			return
		end

		DEFAULT_CHAT_FRAME:AddMessage(text)
	end
end

--[[------------------------------------------------
    BR: Método literal de depuração usando Blizzard_DebugTools.
        Mantido como utilitário interno para inspeção de valores.
    EN: Literal debug method using Blizzard_DebugTools.
        Kept as an internal utility for inspecting values.
------------------------------------------------]]--
if not private.PrintLiteral then
	function private.PrintLiteral(_, ...)
		UIParentLoadAddOn("Blizzard_DebugTools")
		DevTools_Dump((...))
		DevTools_Dump(select(2, ...))
	end
end

--[[------------------------------------------------
    BR: Injeta métodos auxiliares de impressão nos frames de chat.
        O método dbg permanece vazio por compatibilidade interna.
    EN: Injects auxiliary print methods into chat frames.
        The dbg method remains empty for internal compatibility.
------------------------------------------------]]--
if not private.AddPrintMethod then
	function private.AddPrintMethod(_, frame)
		function frame:print(...)
			private.Print(self, ...)
		end

		function frame:dbg()
		end
	end
end

--[[------------------------------------------------
    BR: Registra a instalação dos métodos de impressão em todos os ChatFrames.
        A tarefa é adicionada à fila interna de inicialização do Prat.
    EN: Registers print method installation for all ChatFrames.
        The task is added to Prat's internal initialization queue.
------------------------------------------------]]--
if not private.AddPrintMethods then
	function private.AddPrintMethods()
		for i = 1, NUM_CHAT_WINDOWS do
			private.AddPrintMethod(private, _G["ChatFrame" .. i])
		end
	end

	private.EnableTasks[#private.EnableTasks + 1] = private.AddPrintMethods
end
