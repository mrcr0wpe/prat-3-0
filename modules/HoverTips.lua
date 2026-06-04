--[[
    @File:      HoverTips.lua
    @Project:   Prat-3.0

    BR: Exibe tooltips ao passar o mouse sobre links do chat.
        - Suporte a itens, encantamentos, magias, missões e conquistas
        - Suporte a moedas e mascotes de batalha
        - Hooks em hyperlinks das janelas de chat
        - Tooltip ancorado no cursor
        - Limpeza preventiva de tooltips residuais

    EN: Displays tooltips when hovering over chat links.
        - Supports items, enchants, spells, quests and achievements
        - Supports currencies and battle pets
        - Hooks chat window hyperlinks
        - Tooltip anchored to the cursor
        - Preventive cleanup of residual tooltips

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade entre APIs antigas e modernas de janelas de chat
    EN: Compatibility between old and modern chat window APIs
------------------------------------------------]]--
local num_chat_windows = NUM_CHAT_WINDOWS or Constants.ChatFrameConstants.MaxChatWindows

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo de tooltips flutuantes
		EN: Creation of the hover tooltip module
	------------------------------------------------]]--
	local module = Prat:NewModule("HoverTips", "AceHook-3.0")

	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	--[[------------------------------------------------
		BR: Valores padrão do módulo
		EN: Module default values
	------------------------------------------------]]--
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
		}
	})

	--[[------------------------------------------------
		BR: Interface de configuração do módulo
		EN: Module configuration interface
	------------------------------------------------]]--
	Prat:SetModuleOptions(module.name, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		childGroups = "tab",
		args = {
			overview = {
				type = "group",
				name = PL["overview_tab_name"],
				desc = PL["overview_tab_desc"],
				order = 10,
				args = {
					full_description = {
						type = "description",
						name = PL["full_description"],
						order = 10,
						width = "full",
					},

					quick_guide_header = {
						type = "header",
						name = PL["quick_guide_header"],
						order = 20,
					},

					quick_guide = {
						type = "description",
						name = PL["quick_guide"],
						order = 30,
						width = "full",
					},
				},
			},

			supported_links = {
				type = "group",
				name = PL["supported_links_tab_name"],
				desc = PL["supported_links_tab_desc"],
				order = 100,
				args = {
					supported_links_help = {
						type = "description",
						name = PL["supported_links_help"],
						order = 10,
						width = "full",
					},
				},
			},
		},
	})

	--[[------------------------------------------------
		BR: Tipos de hyperlinks suportados pelo tooltip
		EN: Hyperlink types supported by the tooltip
	------------------------------------------------]]--
	local link_types = {
		item = true,
		enchant = true,
		spell = true,
		quest = true,
		achievement = true,
		currency = true,
		battlepet = true,
	}

	--[[------------------------------------------------
		BR: Controle do tooltip atualmente exibido
		EN: Tracks the tooltip currently being displayed
	------------------------------------------------]]--
	local showing_tooltip = false

	--[[------------------------------------------------
		BR: Instala hooks de hyperlink em todas as janelas de chat
		EN: Installs hyperlink hooks on all chat windows
	------------------------------------------------]]--
	function module:enable_hover_tips()
		for i = 1, num_chat_windows do
			local frame = _G["ChatFrame" .. i]
			if frame and not self:IsHooked(frame, "OnHyperlinkEnter") then
				self:HookScript(frame, "OnHyperlinkEnter", "on_hyperlink_enter")
			end
			if frame and not self:IsHooked(frame, "OnHyperlinkLeave") then
				self:HookScript(frame, "OnHyperlinkLeave", "on_hyperlink_leave")
			end
		end
	end

	--[[------------------------------------------------
		BR: Remove hooks instalados pelo módulo
		EN: Removes hooks installed by the module
	------------------------------------------------]]--
	function module:disable_hover_tips()
		for i = 1, num_chat_windows do
			local frame = _G["ChatFrame" .. i]
			if frame and self:IsHooked(frame, "OnHyperlinkEnter") then
				self:Unhook(frame, "OnHyperlinkEnter")
			end
			if frame and self:IsHooked(frame, "OnHyperlinkLeave") then
				self:Unhook(frame, "OnHyperlinkLeave")
			end
		end
	end

	--[[------------------------------------------------
		BR: Ativação do módulo pelo padrão Prat
		EN: Module activation using the Prat convention
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:enable_hover_tips()
	end

	--[[------------------------------------------------
		BR: Desativação do módulo pelo padrão Prat
		EN: Module deactivation using the Prat convention
	------------------------------------------------]]--
	function module:OnModuleDisable()
		self:disable_hover_tips()
	end

	--[[------------------------------------------------
		BR: Compatibilidade com o padrão AceAddon original deste módulo
		EN: Compatibility with this module's original AceAddon pattern
	------------------------------------------------]]--
	function module:OnEnable()
		self:enable_hover_tips()
	end

	function module:OnDisable()
		self:disable_hover_tips()
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Exibe tooltip apropriado ao passar mouse sobre hyperlink
		EN: Displays the appropriate tooltip when hovering hyperlinks
	------------------------------------------------]]--
	function module:on_hyperlink_enter(_, link, text)
		local link_type = link and link:match("^([^:]+):")

		-- BR: Evita que tooltips de NPC deixem barras de vida ou resíduos visuais.
		-- EN: Prevents NPC tooltips from leaving health bars or visual leftovers.
		GameTooltip:Hide()

		if link_type == "battlepet" then
			showing_tooltip = BattlePetTooltip
			GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
			BattlePetToolTip_ShowLink(text)
		elseif link_types[link_type] then
			showing_tooltip = GameTooltip
			GameTooltip:SetOwner(UIParent, "ANCHOR_CURSOR")
			GameTooltip:SetHyperlink(link)
			GameTooltip:Show()
		end
	end

	--[[------------------------------------------------
		BR: Fecha tooltip ao sair do hyperlink
		EN: Hides tooltip when leaving the hyperlink
	------------------------------------------------]]--
	function module:on_hyperlink_leave()
		if showing_tooltip then
			showing_tooltip:Hide()
			showing_tooltip = false
		end
	end

	--[[------------------------------------------------
		BR: Aliases legados para reduzir risco com chamadas antigas/hooks por string
		EN: Legacy aliases to reduce risk from older calls/string hooks
	------------------------------------------------]]--
	module.OnHyperlinkEnter = module.on_hyperlink_enter
	module.OnHyperlinkLeave = module.on_hyperlink_leave
	module.EnableHoverTips = module.enable_hover_tips
	module.DisableHoverTips = module.disable_hover_tips

	return
end)
