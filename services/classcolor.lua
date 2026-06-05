--[[
    @File:      classcolor.lua
    @Project:   Prat-3.0

    BR: Serviço utilitário para resolução de cores de classe.
        - Compatibilidade com APIs modernas e legadas
        - Integração com CUSTOM_CLASS_COLORS
        - Resolução de classes localizadas
        - Fallback seguro de cores

    EN: Utility service for class color resolution.
        - Compatibility with modern and legacy APIs
        - Integration with CUSTOM_CLASS_COLORS
        - Localized class name resolution
        - Safe color fallback handling

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local _, private = ...

local defaultColor = CreateColor(0.63, 0.63, 0.63)

--[[------------------------------------------------
    BR: Resolve a cor da classe do jogador.
    EN: Resolves the player's class color.
------------------------------------------------]]--
function private.GetClassColor(class, isLocal)
	if not class then
		return defaultColor
	end

	--[[--------------------------------------------
	    BR: Resolve nomes localizados de classes.
	    EN: Resolves localized class names.
	--------------------------------------------]]--
	if isLocal then
		local found

		for k, v in next, LOCALIZED_CLASS_NAMES_FEMALE do
			if v == class then
				class = k
				found = true
				break
			end
		end

		if not found then
			for k, v in next, LOCALIZED_CLASS_NAMES_MALE do
				if v == class then
					class = k
					break
				end
			end
		end
	end

	--[[--------------------------------------------
	    BR: API moderna de cores de classe.
	    EN: Modern class color API.
	--------------------------------------------]]--
	if C_ClassColor then
		return C_ClassColor.GetClassColor(class) or defaultColor
	end

	--[[--------------------------------------------
	    BR: Compatibilidade com addons de cor customizada.
	    EN: Compatibility with custom class color addons.
	--------------------------------------------]]--
	if CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] then
		local color = CUSTOM_CLASS_COLORS[class]
		return CreateColor(color.r, color.g, color.b)
	end

	--[[--------------------------------------------
	    BR: Fallback legado padrão da Blizzard.
	    EN: Blizzard legacy fallback.
	--------------------------------------------]]--
	return RAID_CLASS_COLORS and RAID_CLASS_COLORS[class] or defaultColor
end
