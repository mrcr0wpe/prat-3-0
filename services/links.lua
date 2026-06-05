--[[
    @File:      links.lua
    @Project:   Prat-3.0

    BR: Serviço de infraestrutura e gerenciamento de hyperlinks.
        - Construção e formatação de links
        - Registro dinâmico de tipos de hyperlink
        - Hooks de tooltip e hyperlinks
        - Integração com frames do chat

    EN: Hyperlink infrastructure and management service.
        - Link building and formatting
        - Dynamic hyperlink type registration
        - Tooltip and hyperlink hooks
        - Chat frame integration

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local _, private = ...

local pairs, ipairs = pairs, ipairs
local tinsert, tremove, tconcat = table.insert, table.remove, table.concat

--[[------------------------------------------------
    BR: Constrói hyperlinks coloridos completos.
    EN: Builds complete colored hyperlinks.
------------------------------------------------]]--
function private.BuildLink(linktype, data, text, color, link_start, link_end)
	return "|cff" .. (color or "ffffff") .. "|H" .. linktype .. ":" .. data .. "|h" .. (link_start or "[") .. text .. (link_end or "]") .. "|h|r"
end

--[[------------------------------------------------
    BR: Formata hyperlinks utilizando parâmetros variáveis.
    EN: Formats hyperlinks using variable parameters.
------------------------------------------------]]--
function private.FormatLink(linkType, linkDisplayText, ...)
	local linkFormatTable = { ("|H%s"):format(linkType), ... }
	local returnLink = tconcat(linkFormatTable, ":")

	if linkDisplayText then
		return returnLink .. ("|h%s|h"):format(linkDisplayText)
	end

	return returnLink .. "|h"
end

do
	local LinkRegistry = {}

	--[[--------------------------------------------
	    BR: Registro interno de tipos de hyperlink.
	    EN: Internal hyperlink type registry.
	--------------------------------------------]]--

	-- linktype = { linkid, linkfunc, handler }

	--[[--------------------------------------------
	    BR: Registra um novo tipo de hyperlink.
	    EN: Registers a new hyperlink type.
	--------------------------------------------]]--
	function private.RegisterLinkType(linktype, who)
		if linktype and linktype.linkid and linktype.linkfunc then
			linktype.owner = who

			tinsert(LinkRegistry, linktype)

			return #LinkRegistry
		end
	end

	--[[--------------------------------------------
	    BR: Remove todos os tipos registrados por um owner.
	    EN: Removes all link types registered by an owner.
	--------------------------------------------]]--
	function private.UnregisterAllLinkTypes(who)
		for i, linktype in ipairs(LinkRegistry) do
			if linktype.owner == who then
				private.UnregisterLinkType(i)
			end
		end
	end

	--[[--------------------------------------------
	    BR: Remove um tipo de hyperlink registrado.
	    EN: Removes a registered hyperlink type.
	--------------------------------------------]]--
	function private.UnregisterLinkType(idx)
		tremove(LinkRegistry, idx)
	end

	--[[--------------------------------------------
	    BR: Hook principal de hyperlinks/tooltips.
	    EN: Main hyperlink/tooltip hook.
	--------------------------------------------]]--
	function private.SetHyperlinkHook(hooks, tooltip, link, ...)
		for _, reg_link in ipairs(LinkRegistry) do
			if reg_link.linkid == link:sub(1, (reg_link.linkid):len()) then
				local frame

				--[[--------------------------------
				    BR: Detecta frame atualmente ativo.
				    EN: Detects currently active frame.
				--------------------------------]]--
				for _, v in pairs(private.HookedFrames) do
					if v:IsMouseOver() and v:IsVisible() then
						frame = v
						break
					end
				end

				if reg_link.linkfunc(reg_link.handler, link, frame, ...) == false then
					return false
				end
			end
		end

		hooks.SetHyperlink(tooltip, link, ...)
	end
end
