--[[
    @File:      UrlCopy.lua
    @Project:   Prat-3.0

    BR: Detecção, formatação e cópia de URLs no chat.
        - Converte URLs, e-mails, IPs e domínios em links clicáveis
        - Exibe URL em popup ou diretamente na editbox do chat
        - Suporte a cor customizada e colchetes
        - Validação por lista de TLDs
        - Integração com o sistema de links do Prat

    EN: URL detection, formatting and copying in chat.
        - Converts URLs, emails, IPs and domains into clickable links
        - Shows URL in a popup or directly in the chat editbox
        - Custom color and bracket support
        - TLD list validation
        - Integration with Prat's link system

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade com APIs antigas e modernas da editbox do chat
    EN: Compatibility with old and modern chat editbox APIs
------------------------------------------------]]--
local ChatEdit_ChooseBoxForSend = _G.ChatEdit_ChooseBoxForSend or _G.ChatFrameUtil.ChooseBoxForSend
local ChatEdit_GetActiveWindow = _G.ChatEdit_GetActiveWindow or _G.ChatFrameUtil.GetActiveWindow
local ChatFrame_OpenChat = _G.ChatFrame_OpenChat or _G.ChatFrameUtil.OpenChat

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo de cópia/formatação de URLs
		EN: Creation of the URL copy/formatting module
	------------------------------------------------]]--
	local module = Prat:NewModule("UrlCopy")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL
	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			bracket = true,
			popup = true,
			color_url = true,
			color = {
				r = 1,
				g = 1,
				b = 1,
				a = 1
			},
		}
	})

	--[[------------------------------------------------
		BR: Registro dos padrões de detecção de URLs, e-mails e IPs
		EN: Registration of URL, email and IP detection patterns
	------------------------------------------------]]--
	do
		local function link_url(...)
			return module:link_url(...)
		end

		local function link_with_tld(...)
			return module:link_with_tld(...)
		end

		Prat:SetModulePatterns(module, {
			-- X://Y url
			{ pattern = "^(%a[%w+.-]+://%S+)", matchfunc = link_url },
			{ pattern = "%f[%S](%a[%w+.-]+://%S+)", matchfunc = link_url },
			-- www.X.Y url
			{ pattern = "^(www%.[-%w_%%]+%.(%a%a+))", matchfunc = link_with_tld },
			{ pattern = "%f[%S](www%.[-%w_%%]+%.(%a%a+))", matchfunc = link_with_tld },
			-- "W X"@Y.Z email (this is seriously a valid email)
			{ pattern = '^(%"[^%"]+%"@[%w_.-%%]+%.(%a%a+))', matchfunc = link_with_tld },
			{ pattern = '%f[%S](%"[^%"]+%"@[%w_.-%%]+%.(%a%a+))', matchfunc = link_with_tld },
			-- X@Y.Z email
			{ pattern = "(%S+@[%w_.-%%]+%.(%a%a+))", matchfunc = link_with_tld },
			-- XXX.YYY.ZZZ.WWW:VVVV/UUUUU IPv4 address with port and path
			{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)", matchfunc = link_url },
			{
				pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d/%S+)",
				matchfunc = link_url
			},
			-- XXX.YYY.ZZZ.WWW:VVVV IPv4 address with port (IP of ts server for example)
			{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc = link_url },
			{
				pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d:[0-6]?%d?%d?%d?%d)%f[%D]",
				matchfunc = link_url
			},
			-- XXX.YYY.ZZZ.WWW/VVVVV IPv4 address with path
			{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)", matchfunc = link_url },
			{ pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%/%S+)", matchfunc = link_url },
			-- XXX.YYY.ZZZ.WWW IPv4 address
			{ pattern = "^([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%)%f[%D]", matchfunc = link_url },
			{ pattern = "%f[%S]([0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%.[0-2]?%d?%d%)%f[%D]", matchfunc = link_url },
			-- X.Y.Z:WWWW/VVVVV url with port and path
			{ pattern = "^([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d/%S+)", matchfunc = link_with_tld },
			{ pattern = "%f[%S]([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d/%S+)", matchfunc = link_with_tld },
			-- X.Y.Z:WWWW url with port (ts server for example)
			{ pattern = "^([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc = link_with_tld },
			{ pattern = "%f[%S]([%w_.-%%]+[%w_-%%]%.(%a%a+):[0-6]?%d?%d?%d?%d)%f[%D]", matchfunc = link_with_tld },
			-- X.Y.Z/WWWWW url with path
			{ pattern = "^([%w_.-%%]+[%w_-%%]%.(%a%a+)/%S+)", matchfunc = link_with_tld },
			{ pattern = "%f[%S]([%w_.-%%]+[%w_-%%]%.(%a%a+)/%S+)", matchfunc = link_with_tld },
			-- X.Y.Z url
			{ pattern = "^([-%w_%%]+%.[-%w_%%]+%.(%a%a+))", matchfunc = link_with_tld },
			{ pattern = "%f[%S]([-%w_%%]+%.[-%w_%%]+%.(%a%a+))", matchfunc = link_with_tld },
			{ pattern = "^([-%w_%%]+%.(%a%a+))", matchfunc = link_with_tld },
			{ pattern = "%f[%S]([-%w_%%]+%.(%a%a+))", matchfunc = link_with_tld },
		})
	end

	--[[------------------------------------------------
		BR: Lista de TLDs aceitos para validar domínios sem protocolo
		EN: Accepted TLD list for validating protocol-less domains
	------------------------------------------------]]--
	module.tlds = {
		ONION = true,
		-- Copied from http://data.iana.org/TLD/tlds-alpha-by-domain.txt
		--# Version 2008020401, Last Updated Tue Feb  5 09:07:01 2008 UTC
		AC = true,
		AD = true,
		AE = true,
		AERO = true,
		AF = true,
		AG = true,
		AI = true,
		AL = true,
		AM = true,
		AN = true,
		AO = true,
		AQ = true,
		AR = true,
		ARPA = true,
		AS = true,
		ASIA = true,
		AT = true,
		AU = true,
		AW = true,
		AX = true,
		AZ = true,
		BA = true,
		BB = true,
		BD = true,
		BE = true,
		BF = true,
		BG = true,
		BH = true,
		BI = true,
		BIZ = true,
		BJ = true,
		BM = true,
		BN = true,
		BO = true,
		BR = true,
		BS = true,
		BT = true,
		BV = true,
		BW = true,
		BY = true,
		BZ = true,
		CA = true,
		CAT = true,
		CC = true,
		CD = true,
		CF = true,
		CG = true,
		CH = true,
		CI = true,
		CK = true,
		CL = true,
		CM = true,
		CN = true,
		CO = true,
		COM = true,
		COOP = true,
		CR = true,
		CU = true,
		CV = true,
		CX = true,
		CY = true,
		CZ = true,
		DE = true,
		DJ = true,
		DK = true,
		DM = true,
		DO = true,
		DZ = true,
		EC = true,
		EDU = true,
		EE = true,
		EG = true,
		ER = true,
		ES = true,
		ET = true,
		EU = true,
		FI = true,
		FJ = true,
		FK = true,
		FM = true,
		FO = true,
		FR = true,
		GA = true,
		GB = true,
		GD = true,
		GE = true,
		GF = true,
		GG = true,
		GH = true,
		GI = true,
		GL = true,
		GM = true,
		GN = true,
		GOV = true,
		GP = true,
		GQ = true,
		GR = true,
		GS = true,
		GT = true,
		GU = true,
		GW = true,
		GY = true,
		HK = true,
		HM = true,
		HN = true,
		HR = true,
		HT = true,
		HU = true,
		ID = true,
		IE = true,
		IL = true,
		IM = true,
		IN = true,
		INFO = true,
		INT = true,
		IO = true,
		IQ = true,
		IR = true,
		IS = true,
		IT = true,
		JE = true,
		JM = true,
		JO = true,
		JOBS = true,
		JP = true,
		KE = true,
		KG = true,
		KH = true,
		KI = true,
		KM = true,
		KN = true,
		KP = true,
		KR = true,
		KW = true,
		KY = true,
		KZ = true,
		LA = true,
		LB = true,
		LC = true,
		LI = true,
		LK = true,
		LR = true,
		LS = true,
		LT = true,
		LU = true,
		LV = true,
		LY = true,
		MA = true,
		MC = true,
		MD = true,
		ME = true,
		MG = true,
		MH = true,
		MIL = true,
		MK = true,
		ML = true,
		MM = true,
		MN = true,
		MO = true,
		MOBI = true,
		MP = true,
		MQ = true,
		MR = true,
		MS = true,
		MT = true,
		MU = true,
		MUSEUM = true,
		MV = true,
		MW = true,
		MX = true,
		MY = true,
		MZ = true,
		NA = true,
		NAME = true,
		NC = true,
		NE = true,
		NET = true,
		NF = true,
		NG = true,
		NI = true,
		NL = true,
		NO = true,
		NP = true,
		NR = true,
		NU = true,
		NZ = true,
		OM = true,
		ORG = true,
		PA = true,
		PE = true,
		PF = true,
		PG = true,
		PH = true,
		PK = true,
		PL = true,
		PM = true,
		PN = true,
		PR = true,
		PRO = true,
		PS = true,
		PT = true,
		PW = true,
		PY = true,
		QA = true,
		RE = true,
		RO = true,
		RS = true,
		RU = true,
		RW = true,
		SA = true,
		SB = true,
		SC = true,
		SD = true,
		SE = true,
		SG = true,
		SH = true,
		SI = true,
		SJ = true,
		SK = true,
		SL = true,
		SM = true,
		SN = true,
		SO = true,
		SR = true,
		ST = true,
		SU = true,
		SV = true,
		SY = true,
		SZ = true,
		TC = true,
		TD = true,
		TEL = true,
		TF = true,
		TG = true,
		TH = true,
		TJ = true,
		TK = true,
		TL = true,
		TM = true,
		TN = true,
		TO = true,
		TP = true,
		TR = true,
		TRAVEL = true,
		TT = true,
		TV = true,
		TW = true,
		TZ = true,
		UA = true,
		UG = true,
		UK = true,
		UM = true,
		US = true,
		UY = true,
		UZ = true,
		VA = true,
		VC = true,
		VE = true,
		VG = true,
		VI = true,
		VN = true,
		VU = true,
		WF = true,
		WS = true,
		YE = true,
		YT = true,
		YU = true,
		ZA = true,
		ZM = true,
		ZW = true,
	}

	--[[
	XN--0ZWM56D = true,
	XN--11B5BS3A9AJ6G = true,
	XN--80AKHBYKNJ4F = true,
	XN--9T4B11YI5A = true,
	XN--DEBA0AD = true,
	XN--G6W251D = true,
	XN--HGBK6AJ7F53BBA = true,
	XN--HLCJ6AYA9ESC7A = true,
	XN--JXALPDLP = true,
	XN--KGBECHTV = true,
	XN--ZCKZAH = true,
	]]


	--[[------------------------------------------------
		BR: Construção da interface de configuração do módulo
		EN: Module configuration interface construction
	------------------------------------------------]]--
	Prat:SetModuleOptions(module, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		args = {
			description = {
				type = "description",
				name = PL["full_description"],
				order = 10,
				width = "full",
			},

			display_group = {
				type = "group",
				name = PL["display_group_name"],
				desc = PL["display_group_desc"],
				inline = true,
				order = 100,
				args = {
					display_help = {
						type = "description",
						name = PL["display_group_help"],
						order = 10,
						width = "full",
					},

					--[[------------------------------------------------
						BR: Exibe URLs entre colchetes para facilitar a identificação visual
						EN: Shows URLs inside brackets to make visual identification easier
					------------------------------------------------]]--
					bracket = {
						name = PL["bracket_name"],
						desc = PL["bracket_desc"],
						type = "toggle",
						order = 20,
						width = 1.35,
					},

					--[[------------------------------------------------
						BR: Aplica cor própria aos links detectados no bate-papo
						EN: Applies a custom color to links detected in chat
					------------------------------------------------]]--
					color_url = {
						name = PL["color_url_name"],
						desc = PL["color_url_desc"],
						type = "toggle",
						order = 30,
						width = 1.35,
					},

					--[[------------------------------------------------
						BR: Seletor da cor usada quando a coloração de URLs está ativa
						EN: Color picker used when URL coloring is enabled
					------------------------------------------------]]--
					color = {
						name = PL["color_name"],
						desc = PL["color_desc"],
						type = "color",
						order = 40,
						width = 1.35,
						get = "GetColorValue",
						set = "SetColorValue",
						disabled = "is_set_color_disabled",
					},
				}
			},

			copy_group = {
				type = "group",
				name = PL["copy_group_name"],
				desc = PL["copy_group_desc"],
				inline = true,
				order = 200,
				args = {
					copy_help = {
						type = "description",
						name = PL["copy_group_help"],
						order = 10,
						width = "full",
					},

					--[[------------------------------------------------
						BR: Define se o clique na URL abre popup ou usa a barra de digitação
						EN: Defines whether clicking the URL opens a popup or uses the chat edit box
					------------------------------------------------]]--
					popup = {
						name = PL["popup_name"],
						desc = PL["popup_desc"],
						type = "toggle",
						order = 20,
						width = "full",
					},
				}
			},
		}
	})

	--[[------------------------------------------------
		BR: Desativa seletor de cor quando a coloração de URL está desligada

		EN: Disables color picker when URL coloring is off
	------------------------------------------------]]--
	function module:is_set_color_disabled()
		if not self.db.profile.color_url then
			return true
		end
		return false
	end

	--[[------------------------------------------------
		BR: Registra o tipo de link customizado `url`
		EN: Registers the custom `url` link type
	------------------------------------------------]]--
	function module:OnModuleEnable()
		Prat.RegisterLinkType({ linkid = "url", linkfunc = module.url_link, handler = module }, module.name)
	end

	--[[------------------------------------------------
		BR: Remove tipos de link registrados pelo módulo
		EN: Removes link types registered by the module
	------------------------------------------------]]--
	function module:OnModuleDisable()
		Prat.UnregisterAllLinkTypes(self)
	end

	--[[------------------------------------------------
		BR: Funções centrais de exibição, criação e registro de links
		EN: Core functions for displaying, creating and registering links
	------------------------------------------------]]--
	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --
	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Handler chamado ao clicar em um link de URL
		EN: Handler called when clicking an URL link
	------------------------------------------------]]--
	function module:url_link(link, frame)
		self:show_url(link, frame)
		return false
	end

	do
		local function NOP()
			return
		end

		--[[------------------------------------------------
			BR: Exibe URL em popup editável para cópia
			EN: Shows URL in an editable popup for copying
		------------------------------------------------]]--
		function module:static_popup_url(link)
			StaticPopupDialogs["SHOW_URL"] = StaticPopupDialogs["SHOW_URL"] or {
				text = "URL : %s",
				button2 = ACCEPT,
				hasEditBox = 1,
				hasWideEditBox = 1,
				editBoxWidth = 350,
				preferredIndex = 3,
				OnShow = function(this)
					this:SetWidth(420)

					local editBox = _G[this:GetName() .. "WideEditBox"] or _G[this:GetName() .. "EditBox"]

					editBox:SetText(StaticPopupDialogs["SHOW_URL"].urltext)
					editBox:SetFocus()
					editBox:HighlightText()

					local button = _G[this:GetName() .. "Button2"]
					button:ClearAllPoints()
					button:SetWidth(200)
					button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
				end,
				OnHide = NOP,
				OnAccept = NOP,
				OnCancel = NOP,
				EditBoxOnEscapePressed = function(this)
					this:GetParent():Hide()
				end,
				timeout = 0,
				whileDead = 1,
				hideOnEscape = 1
			}

			StaticPopupDialogs["SHOW_URL"].urltext = link
			StaticPopup_Show("SHOW_URL", link)
		end
	end

	--[[------------------------------------------------
		BR: Joga URL diretamente na editbox do chat
		EN: Places URL directly into the chat editbox
	------------------------------------------------]]--
	function module:edit_box_url(link, frame)
		local editBox = ChatEdit_ChooseBoxForSend(frame);

		if (editBox ~= ChatEdit_GetActiveWindow()) then
			ChatFrame_OpenChat(link, frame);
		else
			editBox:SetText(link)
		end
	end

	--[[------------------------------------------------
		BR: Decide entre popup ou editbox para exibir a URL
		EN: Chooses between popup or editbox to show the URL
	------------------------------------------------]]--
	function module:show_url(link, frame)
		link = strsub(link, 5)
		if (self.db.profile.popup) then
			self:static_popup_url(link)
		else
			self:edit_box_url(link, frame)
		end
	end

--[[------------------------------------------------
		BR: Monta hyperlink visual do Prat para a URL detectada
		EN: Builds Prat's visual hyperlink for the detected URL
	------------------------------------------------]]--
	-- Utility Function (called by gsub)
	function module:raw_link(link)
		local returnedLink = ""

		if self.db.profile.color_url then
			local c = self.db.profile.color
			local color = string.format("%02x%02x%02x", c.r * 255, c.g * 255, c.b * 255)
			returnedLink = "|cff" .. color
		end

		link = link:gsub('%%', '%%%%')

		returnedLink = returnedLink .. "|Hurl:" .. link .. "|h"

		if (self.db.profile.bracket) then
			returnedLink = returnedLink .. "[" .. link .. "]"
		else
			returnedLink = returnedLink .. link
		end

		returnedLink = returnedLink .. "|h|r"

		return returnedLink
	end

	--[[------------------------------------------------
		BR: Converte URL direta em link registrado pelo Prat
		EN: Converts direct URL into a Prat-registered link
	------------------------------------------------]]--
	function module:link_url(link)
		if link == nil then
			return ""
		end

		return self:add_link(self:raw_link(link))
	end

	--[[------------------------------------------------
		BR: Converte domínio somente se o TLD for reconhecido
		EN: Converts domain only if the TLD is recognized
	------------------------------------------------]]--
	function module:link_with_tld(link, tld)
		if link == nil or tld == nil then
			return ""
		end

		if self.tlds[tld:upper()] then
			link = self:raw_link(link)
		end

		return self:add_link(link)
	end

	--[[------------------------------------------------
		BR: Registra correspondência final no sistema de mensagens do Prat
		EN: Registers final match in Prat's message system
	------------------------------------------------]]--
	function module:add_link(link)
		return Prat:RegisterMatch(link)
	end

	return
end) -- Prat:AddModuleToLoad
