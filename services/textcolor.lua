--[[
    @File:      textcolor.lua
    @Project:   Prat-3.0

    BR: Serviço utilitário de cores e formatação de texto.
        - Geração de cores HEX
        - Colorização de texto
        - Dessaturação de cores
        - Hash visual pseudo-estável

    EN: Utility service for color and text formatting.
        - HEX color generation
        - Text colorization
        - Color desaturation
        - Pseudo-stable visual hashing

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local _, private = ...

local tostring = tostring
local type = type
local table = table
local math = math
local string = string

local CLR = {}
private.CLR = CLR

CLR.DEFAULT = "ffffff" -- default to white
CLR.LINK = {
	"|cff", CLR.DEFAULT, "", "|r"
}
CLR.COLOR_NONE = nil

--[[------------------------------------------------
    BR: Retorna cor padrão branca.
    EN: Returns default white color.
------------------------------------------------]]--
local function GetDefaultColor()
	return 1, 1, 1, 1
end

--[[------------------------------------------------
    BR: Obtém componentes RGBA de uma tabela de cor.
    EN: Retrieves RGBA components from a color table.
------------------------------------------------]]--
local function GetColor(c)
	if type(c.r) == "number" and type(c.g) == "number" and type(c.b) == "number" and type(c.a) == "number" then
		return c.r, c.g, c.b, c.a
	end
	if type(c.r) == "number" and type(c.g) == "number" and type(c.b) == "number" then
		return c.r, c.g, c.b, 1.0
	end
	return GetDefaultColor()
end

--[[------------------------------------------------
    BR: Resolve múltiplos formatos de entrada de cor.
    EN: Resolves multiple color input formats.
------------------------------------------------]]--
local function GetVarColor(a1, a2, a3, a4)
	if type(a1) == "table" then
		return GetColor(a1)
	end
	if type(a1) == "number" and type(a2) == "number" and type(a3) == "number" and type(a4) == "number" then
		return a1, a2, a3, a4
	end
	if type(a1) == "number" and type(a2) == "number" and type(a3) == "number" and type(a4) == "nil" then
		return a1, a2, a3, 1.0
	end
	return GetDefaultColor()
end

local function Mult255(r, g, b, a)
	return r * 255, g * 255, b * 255, a
end

--[[------------------------------------------------
    BR: Converte componentes RGBA para HEX.
    EN: Converts RGBA components to HEX.
------------------------------------------------]]--
function CLR:GetHexColor(a1, a2, a3, a4)
	return string.format("%02x%02x%02x", Mult255(GetVarColor(a1, a2, a3, a4)))
end

--[[------------------------------------------------
    BR: Gera uma cor pseudo-estável baseada no texto.
    EN: Generates a pseudo-stable color based on text.
------------------------------------------------]]--
function CLR:GetHashColor(text)
	local hash = 17

	for i = 1, text:len() do
		hash = hash * 37 * text:byte(i)
	end

	local r = math.floor(math.fmod(hash / 97, 255))
	local g = math.floor(math.fmod(hash / 17, 255))
	local b = math.floor(math.fmod(hash / 227, 255))

	if ((r * 299 + g * 587 + b * 114) / 1000) < 105 then
		r = math.abs(r - 255)
		g = math.abs(g - 255)
		b = math.abs(b - 255)
	end

	return ("%02x%02x%02x"):format(r, g, b)
end

function CLR:Random(text)
	return CLR:Colorize(self:GetHashColor(text), text)
end

--[[------------------------------------------------
    BR: Aplica cor ao texto utilizando código HEX.
    EN: Applies color to text using HEX color codes.
------------------------------------------------]]--
function CLR:Colorize(hexColor, text)
	if text == nil or text == "" then
		return ""
	end

	local color = hexColor
	if type(hexColor) == "table" then
		color = self:GetHexColor(hexColor)
	end

	if color == CLR.COLOR_NONE then
		return text
	end

	local link = CLR.LINK

	link[2] = tostring(color or 'ffffff')
	link[3] = text

	return table.concat(link, "")
end

local function Desaturate(c)
	return ((c or 1.0) * 192 * 0.8 + 63) / 255
end

--[[------------------------------------------------
    BR: Dessatura componentes de cor mantendo alpha.
    EN: Desaturates color components while preserving alpha.
------------------------------------------------]]--
function CLR:Desaturate(a1, a2, a3, a4)
	local r, g, b, a = GetVarColor(a1, a2, a3, a4)

	r = Desaturate(r)
	g = Desaturate(g)
	b = Desaturate(b)

	return r, g, b, a
end
