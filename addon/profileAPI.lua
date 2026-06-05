--[[
    @File:      profileAPI.lua
    @Project:   Prat-3.0

    BR: API de gerenciamento de perfis do Prat.
        - Criação e troca de perfis
        - Cópia e redefinição de configurações
        - Sincronização de módulos após alterações de perfil
        - Integração com AceDBOptions

    EN: Prat profile management API.
        - Profile creation and switching
        - Configuration copy and reset
        - Module synchronization after profile changes
        - AceDBOptions integration

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local _, private = ...

function private:ExportProfile(profileKey)
	local profile = private.db.sv.profiles[profileKey]
	if not profile then
		return
	end

	local namespaces = {}
	for namespaceKey, namespaceData in pairs(private.db.sv.namespaces) do
		if namespaceData.profiles[profileKey] then
			namespaces[namespaceKey] = {}
			namespaces[namespaceKey].profiles = {}
			namespaces[namespaceKey].profiles[profileKey] = namespaceData.profiles[profileKey]
		end
	end

	local data = {
		profile = profile,
		namespaces = namespaces,
	}
	return C_EncodingUtil.EncodeBase64(C_EncodingUtil.SerializeCBOR(data))
end

function private:ImportProfile(dataString, profileKey)
	local data = C_EncodingUtil.DeserializeCBOR(C_EncodingUtil.DecodeBase64(dataString))
	if not data then
		return false
	end

	private.db.sv.profiles[profileKey] = data.profile
	private.db.sv.profileKeys[UnitName("player") .. " - " .. GetRealmName()] = profileKey
	for namespaceKey, namespaceData in pairs(data.namespaces) do
		if not private.db.sv.namespaces[namespaceKey] then
			private.db.sv.namespaces[namespaceKey] = { profiles = {} }
		end
		private.db.sv.namespaces[namespaceKey].profiles[profileKey] = namespaceData.profiles[profileKey]
	end
end
