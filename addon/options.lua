--[[
    @File:      options.lua
    @Project:   Prat-3.0

    BR: Configuração central da interface de opções do Prat.
        - Criação das categorias principais da interface
        - Registro das opções no AceConfig
        - Controle de carregamento e ativação dos módulos
        - Atualização dinâmica das listas de janelas de chat

    EN: Central configuration for Prat's options interface.
        - Main options category creation
        - AceConfig options registration
        - Module loading and enable-state control
        - Dynamic update of chat window lists

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

local _, private = ...

local pairs = pairs

local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

--[[------------------------------------------------
    BR: Localização central usada pela interface de opções
    EN: Central localization used by the options interface
------------------------------------------------]]--
local PL = private:GetLocalizer("Options")
--[[------------------------------------------------
    BR: Armazena as opções de controle de carregamento dos módulos
    EN: Stores the module loading control options
------------------------------------------------]]--
local moduleControlArgs = {}

--[[------------------------------------------------
    BR: Grupos internos usados para organizar o Controle de Módulos.
        As categorias representam a função do módulo, não seu estado atual.
    EN: Internal groups used to organize Module Control.
        Categories represent module purpose, not current enabled state.
------------------------------------------------]]--
local moduleControlCategoryOrder = {
	"display",
	"formatting",
	"extras",
	"advanced",
	"legacy",
}

local moduleControlCategoryLabels = {
	display = {
		name = PL["modulecontrol_display_name"] or "Configurações de Exibição",
		desc = PL["modulecontrol_display_desc"] or "Módulos ligados à aparência, comportamento e organização das janelas de bate-papo.",
	},
	formatting = {
		name = PL["modulecontrol_formatting_name"] or "Formatação do Chat",
		desc = PL["modulecontrol_formatting_desc"] or "Módulos que alteram como mensagens, nomes, canais e marcas de tempo aparecem no chat.",
	},
	extras = {
		name = PL["modulecontrol_extras_name"] or "Extras",
		desc = PL["modulecontrol_extras_desc"] or "Recursos adicionais, atalhos, ferramentas auxiliares e funções complementares.",
	},
	advanced = {
		name = PL["modulecontrol_advanced_name"] or "Avançados",
		desc = PL["modulecontrol_advanced_desc"] or "Módulos técnicos, diagnósticos, filtros e recursos que exigem mais cuidado.",
	},
	legacy = {
		name = PL["modulecontrol_legacy_name"] or "Legado / Especiais",
		desc = PL["modulecontrol_legacy_desc"] or "Módulos antigos, específicos ou pouco usados que merecem atenção antes de ativar.",
	},
}

local moduleControlCategoryArgs = {}

for order, categoryKey in ipairs(moduleControlCategoryOrder) do
	local categoryInfo = moduleControlCategoryLabels[categoryKey]

	moduleControlCategoryArgs[categoryKey] = {}

	moduleControlArgs[categoryKey] = {
		type = "group",
		name = categoryInfo.name,
		desc = categoryInfo.desc,
		order = order * 100,
		args = moduleControlCategoryArgs[categoryKey],
	}
end

moduleControlArgs.intro = {
	type = "description",
	name = PL["modulecontrol_intro"] or "Ative ou desative módulos do Prat por categoria. As abas indicam a função do módulo; o estado atual aparece no seletor de cada item.",
	order = 1,
	width = "full",
}

--[[------------------------------------------------
    BR: Mapa de classificação funcional dos módulos.
        Esta classificação não muda quando o módulo é ativado/desativado.
    EN: Functional classification map for modules.
        This classification does not change when modules are enabled/disabled.
------------------------------------------------]]--
local moduleControlCategoryByModule = {
	-- BR: Configurações de Exibição | EN: Display settings
	Editbox = "display",
	Buttons = "display",
	OriginalButtons = "display",
	Fading = "display",
	Font = "display",
	History = "display",
	Frames = "display",
	ChannelColorMemory = "display",
	ChannelSticky = "display",
	Scroll = "display",
	SideTabs = "display",
	ChatTabs = "display",

	-- BR: Formatação do Chat | EN: Chat formatting
	Timestamps = "formatting",
	ChannelNames = "formatting",
	PlayerNames = "formatting",
	ServerNames = "formatting",
	Paragraph = "formatting",
	PopupMessage = "formatting",

	-- BR: Extras | EN: Extras
	Achievements = "extras",
	Alias = "extras",
	AltNames = "extras",
	Bubbles = "extras",
	NewcomersChat = "extras",
	Invites = "extras",
	CopyChat = "extras",
	UrlCopy = "extras",
	Highlight = "extras",
	TellTarget = "extras",
	Memory = "extras",
	EventNames = "extras",
	Search = "extras",
	Sounds = "extras",
	LinkInfoIcons = "extras",
	HoverTips = "extras",

	-- BR: Avançados / diagnóstico | EN: Advanced / diagnostics
	ChatLog = "advanced",
	Filtering = "advanced",
	CustomFilters = "advanced",
	Mentions = "advanced",
	Clear = "advanced",
	AddonMsgs = "advanced",

	-- BR: Legado / especiais | EN: Legacy / special cases
	Substitutions = "legacy",
	KeyBindings = "legacy",
}

local function GetModuleControlCategory(moduleName)
	return moduleControlCategoryByModule[moduleName] or "advanced"
end

--[[------------------------------------------------
    BR: Estrutura principal das opções exibidas pelo AceConfig
    EN: Main options structure displayed by AceConfig
------------------------------------------------]]--
private.Options = {
	type = "group",
	childGroups = "tab",
	get = "GetValue",
	set = "SetValue",
	args = {
		display = {
			type = "group",
			name = PL["display_name"],
			desc = PL["display_desc"],
			get = "GetValue",
			set = "SetValue",
			args = {},
			order = 1,
		},
		formatting = {
			type = "group",
			name = PL["formatting_name"],
			desc = PL["formatting_desc"],
			get = "GetValue",
			set = "SetValue",
			args = {},
			order = 2,
		},
		extras = {
			type = "group",
			name = PL["extras_name"],
			desc = PL["extras_desc"],
			get = "GetValue",
			set = "SetValue",
			args = {},
			order = 3,
		},
		modulecontrol = {
			type = "group",
			name = PL["modulecontrol_name"],
			desc = PL["modulecontrol_desc"],
			get = "GetValue",
			set = "SetValue",
			childGroups = "tab",
			args = moduleControlArgs,
			order = 4,
		}
	}
}

--[[------------------------------------------------
    BR: Registra as opções do Prat na interface do Blizzard/AceConfig
    EN: Registers Prat options in the Blizzard/AceConfig interface
------------------------------------------------]]--
--[[------------------------------------------------
    BR: Registra tabelas do AceConfig e adiciona categorias à interface Blizzard
    EN: Registers AceConfig tables and adds categories to the Blizzard interface
------------------------------------------------]]--
private.EnableTasks[#private.EnableTasks + 1] = function(self)
	AceConfigRegistry:RegisterOptionsTable(PL.prat, private.Options)
	AceConfigRegistry:RegisterOptionsTable(PL.prat .. ": " .. private.Options.args.display.name, private.Options.args.display)
	AceConfigRegistry:RegisterOptionsTable(PL.prat .. ": " .. private.Options.args.formatting.name, private.Options.args.formatting)
	AceConfigRegistry:RegisterOptionsTable(PL.prat .. ": " .. private.Options.args.extras.name, private.Options.args.extras)
	AceConfigRegistry:RegisterOptionsTable(PL.prat .. ": " .. private.Options.args.modulecontrol.name, private.Options.args.modulecontrol)
	AceConfigRegistry:RegisterOptionsTable("Prat: " .. private.Options.args.profiles.name, private.Options.args.profiles)

	AceConfigDialog:AddToBlizOptions(PL.prat, PL.prat)
	AceConfigDialog:AddToBlizOptions(PL.prat .. ": " .. private.Options.args.display.name, private.Options.args.display.name, PL.prat)
	AceConfigDialog:AddToBlizOptions(PL.prat .. ": " .. private.Options.args.formatting.name, private.Options.args.formatting.name, PL.prat)
	AceConfigDialog:AddToBlizOptions(PL.prat .. ": " .. private.Options.args.extras.name, private.Options.args.extras.name, PL.prat)
	AceConfigDialog:AddToBlizOptions(PL.prat .. ": " .. private.Options.args.modulecontrol.name, private.Options.args.modulecontrol.name, PL.prat)
	AceConfigDialog:AddToBlizOptions(PL.prat .. ": " .. private.Options.args.profiles.name, private.Options.args.profiles.name, PL.prat)

	self:RegisterChatCommand(PL.prat, function()
		private:ToggleOptionsWindow()
	end)
end

do
	local function GetModuleFromShortName(shortName)
		for _, v in private.Addon:IterateModules() do
			if v.moduleName == shortName then
				return v
			end
		end
	end

	local function SetModuleLoadState(info, value)
		private.db.profile.modules[info[#info]] = value

		local moduleObject = GetModuleFromShortName(info[#info])
		if not moduleObject then
			return
		end

		if value == 2 then
			moduleObject.db.profile.on = false
			moduleObject:Disable()
		elseif value == 3 then
			moduleObject.db.profile.on = true
			moduleObject:Enable()
		end

		AceConfigRegistry:NotifyChange("Prat")
	end

	local function GetModuleLoadState(info)
		return private.db.profile.modules[info[#info]]
	end

	--[[------------------------------------------------
		BR: Monta a descrição exibida no controle de módulos
		EN: Builds the description displayed in the module control panel
	------------------------------------------------]]--
	do
		local function GetModuleDescription(info)
			local moduleObject = GetModuleFromShortName(info[#info])
			local controlMsg = "\n\n" .. private.CLR:Colorize("a0a0ff", PL.load_desc)
			if not moduleObject then
				return PL.unloaded_desc .. controlMsg
			end
			return moduleObject:GetDescription() .. controlMsg
		end

		local moduleControlOption = {
			    name = function(info)
					local moduleName = info[#info]
					local localeTable = _G.Prat_Locales and _G.Prat_Locales[GetLocale()]
					if localeTable and localeTable[moduleName] and localeTable[moduleName].module_name then
						return localeTable[moduleName].module_name
					end
       				return moduleName
    			end,
			desc = GetModuleDescription,
			type = "select",
			values = function()
				return {
					[2] = "|cffff8080" .. PL.load_disabled .. "|r",
					[3] = "|cff80ff80" .. PL.load_enabled .. "|r"
				}
			end,
			get = GetModuleLoadState,
			set = SetModuleLoadState,
			width = 1.05,
		}

		--[[------------------------------------------------
			BR: Cria a opção de controle para cada módulo registrado
			EN: Creates the control option for each registered module
		------------------------------------------------]]--
		function private:CreateModuleControlOption(name)
			local categoryKey = GetModuleControlCategory(name)
			local categoryArgs = moduleControlCategoryArgs[categoryKey] or moduleControlCategoryArgs.advanced

			categoryArgs[name] = moduleControlOption
		end
	end
end

--[[------------------------------------------------
    BR: Listas de janelas de chat disponíveis para opções por frame
    EN: Chat window lists available for per-frame options
------------------------------------------------]]--
private.FrameList = {}
private.HookedFrameList = {}

--[[------------------------------------------------
    BR: Atualiza os nomes das janelas de chat visíveis ou acopladas
    EN: Updates names for visible or docked chat windows
------------------------------------------------]]--
local function UpdateFrameNames()
	for k, v in pairs(private.HookedFrames) do
		if v.isDocked == 1 or v:IsShown() then
			private.HookedFrameList[k] = v.name
		else
			private.HookedFrameList[k] = nil
		end
	end
	for k, v in pairs(private.Frames) do
		if v.isDocked == 1 or v:IsShown() then
			private.FrameList[k] = v.name
		else
			private.FrameList[k] = nil
		end
	end

	private:UpdateOptions()
end

--[[------------------------------------------------
    BR: Notifica o AceConfig para atualizar a interface de opções
    EN: Notifies AceConfig to refresh the options interface
------------------------------------------------]]--
function private:UpdateOptions()
	AceConfigRegistry:NotifyChange("Prat")
end

private.EnableTasks[#private.EnableTasks + 1] = function(self)
	self:SecureHook("FCF_SetWindowName", UpdateFrameNames)

	FCF_SetWindowName(ChatFrame1, (GetChatWindowInfo(1)), 1)
end

--[[------------------------------------------------
    BR: Abre ou fecha a janela principal de opções do Prat
    EN: Opens or closes the main Prat options window
------------------------------------------------]]--
function private:ToggleOptionsWindow()
	if AceConfigDialog.OpenFrames["Prat"] then
		AceConfigDialog:Close("Prat")
	else
		AceConfigDialog:Open("Prat")
	end
end

Prat_ToggleOptionsWindow = private.ToggleOptionsWindow
