--[[
    @File:      SoundWidget.lua
    @Project:   Prat-3.0 / AceGUISharedMediaWidgets

    BR: Widget AceGUI para seleção e prévia de sons registrados no LibSharedMedia.
        - Usado por opções com dialogControl = "LSM30_Sound"
        - Exibe lista de sons disponíveis
        - Permite pré-escutar sons pelo ícone de alto-falante
        - Mantém chaves internas do LibSharedMedia intactas
        - Localiza apenas rótulos exibidos ao usuário

    EN: AceGUI widget for selecting and previewing LibSharedMedia sounds.
        - Used by options with dialogControl = "LSM30_Sound"
        - Displays the available sound list
        - Allows previewing sounds through the speaker icon
        - Keeps LibSharedMedia internal keys intact
        - Localizes only user-facing labels

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

-- Widget is based on the AceGUIWidget-DropDown.lua supplied with AceGUI-3.0
-- Widget created by Yssaril


local AceGUI = LibStub("AceGUI-3.0")
local Media = LibStub("LibSharedMedia-3.0")

local AGSMW = LibStub("AceGUISharedMediaWidgets-1.0")

--[[------------------------------------------------
	BR: Localização mínima do widget.
		A chave interna do som continua sendo "None"; somente o texto
		exibido ao usuário muda conforme o idioma.
	EN: Minimal widget localization.
		The internal sound key remains "None"; only the text displayed
		to the user changes according to locale.
------------------------------------------------]]--
local locale = GetLocale()

local L = {
	-- ============================================================================
	-- EN: File: widgets/SoundWidget.lua | Language: English (enUS)
	-- EN: File: widgets/SoundWidget.lua | Language: English (enUS)
	-- ============================================================================
	enUS = {
		None = "None",
	},

	-- ============================================================================
	-- BR: Arquivo: widgets/SoundWidget.lua | Idioma: Português Brasil (ptBR)
	-- EN: File: widgets/SoundWidget.lua | Language: Brazilian Portuguese (ptBR)
	-- ============================================================================
	ptBR = {
		None = "Nenhum",
	},

	-- ============================================================================
	-- PT: Ficheiro: widgets/SoundWidget.lua | Idioma: Português Europeu (ptPT)
	-- EN: File: widgets/SoundWidget.lua | Language: European Portuguese (ptPT)
	-- ============================================================================
	ptPT = {
		None = "Nenhum",
	},

	-- ============================================================================
	-- ES: Archivo: widgets/SoundWidget.lua | Idioma: Español (España) (esES)
	-- EN: File: widgets/SoundWidget.lua | Language: Spanish (Spain) (esES)
	-- ============================================================================
	esES = {
		None = "Ninguno",
	},

	-- ============================================================================
	-- ES: Archivo: widgets/SoundWidget.lua | Idioma: Español (Latinoamérica) (esMX)
	-- EN: File: widgets/SoundWidget.lua | Language: Latin American Spanish (esMX)
	-- ============================================================================
	esMX = {
		None = "Ninguno",
	},

	-- ============================================================================
	-- FR: Fichier: widgets/SoundWidget.lua | Langue: Français (frFR)
	-- EN: File: widgets/SoundWidget.lua | Language: French (frFR)
	-- ============================================================================
	frFR = {
		None = "Aucun",
	},

	-- ============================================================================
	-- IT: File: widgets/SoundWidget.lua | Lingua: Italiano (itIT)
	-- EN: File: widgets/SoundWidget.lua | Language: Italian (itIT)
	-- ============================================================================
	itIT = {
		None = "Nessuno",
	},

	-- ============================================================================
	-- DE: Datei: widgets/SoundWidget.lua | Sprache: Deutsch (deDE)
	-- EN: File: widgets/SoundWidget.lua | Language: German (deDE)
	-- ============================================================================
	deDE = {
		None = "Nichts",
	},

	-- ============================================================================
	-- RU: Файл: widgets/SoundWidget.lua | Язык: Русский (ruRU)
	-- EN: File: widgets/SoundWidget.lua | Language: Russian (ruRU)
	-- ============================================================================
	ruRU = {
		None = "Нет",
	},

	-- ============================================================================
	-- KO: 파일: widgets/SoundWidget.lua | 언어: 한국어 (koKR)
	-- EN: File: widgets/SoundWidget.lua | Language: Korean (koKR)
	-- ============================================================================
	koKR = {
		None = "없음",
	},

	-- ============================================================================
	-- ZH: 文件: widgets/SoundWidget.lua | 语言: 简体中文 (zhCN)
	-- EN: File: widgets/SoundWidget.lua | Language: Simplified Chinese (zhCN)
	-- ============================================================================
	zhCN = {
		None = "无",
	},

	-- ============================================================================
	-- ZH: 檔案: widgets/SoundWidget.lua | 語言: 繁體中文 (zhTW)
	-- EN: File: widgets/SoundWidget.lua | Language: Traditional Chinese (zhTW)
	-- ============================================================================
	zhTW = {
		None = "無",
	},
}

local activeLocale = L[locale] or L.enUS

local function GetDisplayText(key)
	if key == "None" then
		return activeLocale.None or key
	end

	return activeLocale[key] or key
end

local function GetInternalKey(self, displayText)
	if not self or not self.list then
		return displayText
	end

	for key in pairs(self.list) do
		if GetDisplayText(key) == displayText then
			return key
		end
	end

	return displayText
end

do
	local widgetType = "LSM30_Sound"
	local widgetVersion = 1301 -- BR/EN: Prat localized/fixed fork

	local contentFrameCache = {}
	local function ReturnSelf(self)
		self:ClearAllPoints()
		self:Hide()
		self.check:Hide()
		table.insert(contentFrameCache, self)
	end

	local function ContentOnClick(this, button)
		local self = this.obj
		self:Fire("OnValueChanged", this.value)
		if self.dropdown then
			self.dropdown = AGSMW:ReturnDropDownFrame(self.dropdown)
		end
	end

	local function ContentSpeakerOnClick(this, button)
		local self = this.frame.obj
		local sound = this.frame.value

		if not sound then
			return
		end

		PlaySoundFile(self.list[sound] ~= sound and self.list[sound] or Media:Fetch("sound", sound), "Master")
	end

	local function GetContentLine()
		local frame
		if next(contentFrameCache) then
			frame = table.remove(contentFrameCache)
		else
			frame = CreateFrame("Button", nil, UIParent)
				--frame:SetWidth(200)
				frame:SetHeight(18)
				frame:SetHighlightTexture([[Interface\QuestFrame\UI-QuestTitleHighlight]], "ADD")
				frame:SetScript("OnClick", ContentOnClick)
			local check = frame:CreateTexture("OVERLAY")
				check:SetWidth(16)
				check:SetHeight(16)
				check:SetPoint("LEFT",frame,"LEFT",1,-1)
				check:SetTexture("Interface\\Buttons\\UI-CheckBox-Check")
				check:Hide()
			frame.check = check

			local soundbutton = CreateFrame("Button", nil, frame)
				soundbutton:SetWidth(16)
				soundbutton:SetHeight(16)
				soundbutton:SetPoint("RIGHT",frame,"RIGHT",-1,0)
				soundbutton.frame = frame
				soundbutton:SetScript("OnClick", ContentSpeakerOnClick)
			frame.soundbutton = soundbutton

			local speaker = soundbutton:CreateTexture(nil, "BACKGROUND")
				speaker:SetTexture("Interface\\Common\\VoiceChat-Speaker")
				speaker:SetAllPoints(soundbutton)
			frame.speaker = speaker
			local speakeron = soundbutton:CreateTexture(nil, "HIGHLIGHT")
				speakeron:SetTexture("Interface\\Common\\VoiceChat-On")
				speakeron:SetAllPoints(soundbutton)
			frame.speakeron = speakeron

			local text = frame:CreateFontString(nil,"OVERLAY","GameFontWhite")
				text:SetPoint("TOPLEFT", check, "TOPRIGHT", 1, 0)
				text:SetPoint("BOTTOMRIGHT", soundbutton, "BOTTOMLEFT", -2, 0)
				text:SetJustifyH("LEFT")
				text:SetText("Test Test Test Test Test Test Test")
			frame.text = text
			frame.ReturnSelf = ReturnSelf
		end
		frame:Show()
		return frame
	end

	local function OnAcquire(self)
		self:SetHeight(44)
		self:SetWidth(200)
	end

	local function OnRelease(self)
		self:SetText("")
		self:SetLabel("")
		self:SetDisabled(false)

		self.value = nil
		self.list = nil
		self.open = nil
		self.hasClose = nil

		self.frame:ClearAllPoints()
		self.frame:Hide()
	end

	local function SetValue(self, value) -- Set the value to an item in the List.
		self.value = value
		self:SetText(value or "")
	end

	local function GetValue(self)
		return self.value
	end

	local function SetList(self, list) -- Set the list of values for the dropdown (key => value pairs)
		self.list = list or Media:HashTable("sound")
	end

	local function SetText(self, text) -- Set the text displayed in the box.
		self.frame.text:SetText(text and GetDisplayText(text) or "")
	end

	local function SetLabel(self, text) -- Set the text for the label.
		self.frame.label:SetText(text or "")
	end

	local function AddItem(self, key, value) -- Add an item to the list.
		self.list = self.list or {}
		self.list[key] = value
	end
	local SetItemValue = AddItem -- Set the value of a item in the list. <<same as adding a new item>>

	local function SetMultiselect(self, flag) end -- Toggle multi-selecting. <<Dummy function to stay inline with the dropdown API>>
	local function GetMultiselect() return false end-- Query the multi-select flag. <<Dummy function to stay inline with the dropdown API>>
	local function SetItemDisabled(self, key) end-- Disable one item in the list. <<Dummy function to stay inline with the dropdown API>>

	local function SetDisabled(self, disabled) -- Disable the widget.
		self.disabled = disabled
		if disabled then
			self.frame:Disable()
			self.speaker:SetDesaturated(true)
			self.speakeron:SetDesaturated(true)
		else
			self.frame:Enable()
			self.speaker:SetDesaturated(false)
			self.speakeron:SetDesaturated(false)
		end
	end

	local function textSort(a,b)
		return string.upper(a) < string.upper(b)
	end

	local sortedlist = {}
	local function ToggleDrop(this)
		local self = this.obj
		if self.dropdown then
			self.dropdown = AGSMW:ReturnDropDownFrame(self.dropdown)
			AceGUI:ClearFocus()
		else
			AceGUI:SetFocus(self)
			self.dropdown = AGSMW:GetDropDownFrame()
			local width = self.frame:GetWidth()
			self.dropdown:SetPoint("TOPLEFT", self.frame, "BOTTOMLEFT")
			self.dropdown:SetPoint("TOPRIGHT", self.frame, "BOTTOMRIGHT", width < 160 and (160 - width) or 0, 0)
			for k, v in pairs(self.list) do
				sortedlist[#sortedlist+1] = k
			end
			table.sort(sortedlist, textSort)
			for i, k in ipairs(sortedlist) do
				local f = GetContentLine()
				f.value = k
				f.text:SetText(GetDisplayText(k))
				if k == self.value then
					f.check:Show()
				end
				f.obj = self
				self.dropdown:AddFrame(f)
			end
			wipe(sortedlist)
		end
	end

	local function ClearFocus(self)
		if self.dropdown then
			self.dropdown = AGSMW:ReturnDropDownFrame(self.dropdown)
		end
	end

	local function OnHide(this)
		local self = this.obj
		if self.dropdown then
			self.dropdown = AGSMW:ReturnDropDownFrame(self.dropdown)
		end
	end

	local function Drop_OnEnter(this)
		this.obj:Fire("OnEnter")
	end

	local function Drop_OnLeave(this)
		this.obj:Fire("OnLeave")
	end

	local function WidgetPlaySound(this)
		local self = this.obj
		local sound = self.value

		if not sound then
			return
		end

		PlaySoundFile(self.list[sound] ~= sound and self.list[sound] or Media:Fetch("sound", sound), "Master")
	end

	local function Constructor()
		local frame = AGSMW:GetBaseFrame()
		local self = {}

		self.type = widgetType
		self.frame = frame
		frame.obj = self
		frame.dropButton.obj = self
		frame.dropButton:SetScript("OnEnter", Drop_OnEnter)
		frame.dropButton:SetScript("OnLeave", Drop_OnLeave)
		frame.dropButton:SetScript("OnClick",ToggleDrop)
		frame:SetScript("OnHide", OnHide)


		local soundbutton = CreateFrame("Button", nil, frame)
			soundbutton:SetWidth(16)
			soundbutton:SetHeight(16)
			soundbutton:SetPoint("LEFT",frame.DLeft,"LEFT",26,1)
			soundbutton:SetScript("OnClick", WidgetPlaySound)
			soundbutton.obj = self
		self.soundbutton = soundbutton
		frame.text:SetPoint("LEFT",soundbutton,"RIGHT",2,0)


		local speaker = soundbutton:CreateTexture(nil, "BACKGROUND")
			speaker:SetTexture("Interface\\Common\\VoiceChat-Speaker")
			speaker:SetAllPoints(soundbutton)
		self.speaker = speaker
		local speakeron = soundbutton:CreateTexture(nil, "HIGHLIGHT")
			speakeron:SetTexture("Interface\\Common\\VoiceChat-On")
			speakeron:SetAllPoints(soundbutton)
		self.speakeron = speakeron

		self.alignoffset = 31

		self.OnRelease = OnRelease
		self.OnAcquire = OnAcquire
		self.ClearFocus = ClearFocus
		self.SetText = SetText
		self.SetValue = SetValue
		self.GetValue = GetValue
		self.SetList = SetList
		self.SetLabel = SetLabel
		self.SetDisabled = SetDisabled
		self.AddItem = AddItem
		self.SetMultiselect = SetMultiselect
		self.GetMultiselect = GetMultiselect
		self.SetItemValue = SetItemValue
		self.SetItemDisabled = SetItemDisabled
		self.ToggleDrop = ToggleDrop

		AceGUI:RegisterAsWidget(self)
		return self
	end

	AceGUI:RegisterWidgetType(widgetType, Constructor, widgetVersion)

end
