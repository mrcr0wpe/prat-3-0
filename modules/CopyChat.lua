--[[
    @File:      CopyChat.lua
    @Project:   Prat-3.0

    BR: Sistema de cópia de texto das janelas de chat.
        - Botão visual para copiar chat
        - Cópia do histórico visível e completo
        - Cópia por clique no timestamp
        - Suporte a texto puro, BBCode, HTML e formato WowAce
        - Modo de seleção nativo do chat
        - Integração com o módulo Timestamps
        - Uso do frame próprio PratCCFrame

    EN: Chat window text copy system.
        - Visual button for copying chat
        - Visible and full history copy
        - Timestamp-click line copy
        - Plain text, BBCode, HTML and WowAce format support
        - Native chat selection mode
        - Timestamps module integration
        - PratCCFrame UI usage

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Compatibilidade com APIs antigas e modernas da editbox do chat
    EN: Compatibility with old and modern chat editbox APIs
------------------------------------------------]]--
local ChatEdit_GetActiveWindow = _G.ChatEdit_GetActiveWindow or _G.ChatFrameUtil.GetActiveWindow
local ChatEdit_ChooseBoxForSend = _G.ChatEdit_ChooseBoxForSend or _G.ChatFrameUtil.ChooseBoxForSend

local ChatFrame_OpenChat = _G.ChatFrame_OpenChat or _G.ChatFrameUtil.OpenChat
local StripHyperlinks = _G.StripHyperlinks or _G.C_StringUtil.StripHyperlinks

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo de cópia com suporte a hooks e timers
		EN: Creation of the copy module with hook and timer support
	------------------------------------------------]]--
	local module = Prat:NewModule("CopyChat", "AceHook-3.0", "AceTimer-3.0")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			show_button = { ["*"] = true },
			button_position = "TOPLEFT",
			copy_format = "plain",
			copy_timestamps = true,
			active_alpha = 0.9,
			inactive_alpha = 0.2,
		}
	})

	--[[------------------------------------------------
		BR: Construção da interface de configuração do módulo
		EN: Module configuration interface construction
	------------------------------------------------]]--
	Prat:SetModuleOptions(module.name, {
		name = PL["module_name"],
		desc = PL["module_desc"],
		type = "group",
		args = {
			button_group = {
				type = "group",
				name = PL["button_group_name"],
				desc = PL["button_group_desc"],
				inline = true,
				order = 100,
				args = {
					show_button = {
						name = PL["show_button_name"],
						desc = PL["show_button_desc"],
						type = "multiselect",
						values = Prat.FrameList,
						order = 10,
						width = "full",
						get = "GetSubValue",
						set = "SetSubValue",
					},

					button_position = {
						name = PL["button_position_name"],
						desc = PL["button_position_desc"],
						type = "select",
						order = 20,
						width = 1.35,
						get = "GetValue",
						set = "SetValue",
						values = {
							["TOPLEFT"] = PL["position_top_left"],
							["TOPRIGHT"] = PL["position_top_right"],
							["BOTTOMLEFT"] = PL["position_bottom_left"],
							["BOTTOMRIGHT"] = PL["position_bottom_right"],
						},
					},

					button_spacer = {
						type = "description",
						name = " ",
						order = 25,
						width = 0.15,
					},

					copy = {
						name = PL["copy_name"],
						desc = PL["copy_desc"],
						type = "execute",
						order = 30,
						width = 1.25,
						func = "menu_scrape",
					},
				}
			},

			format_group = {
				type = "group",
				name = PL["format_group_name"],
				desc = PL["format_group_desc"],
				inline = true,
				order = 200,
				args = {
					copy_format = {
						name = PL["copy_format_name"],
						desc = PL["copy_format_desc"],
						type = "select",
						order = 10,
						width = 1.35,
						get = "GetValue",
						set = "SetValue",
						values = {
							["plain"] = PL["format_plain"],
							["bbcode"] = PL["format_bbcode"],
							["html"] = PL["format_html"],
							["wowace"] = PL["format_wowace"],
						},
					},

					format_spacer = {
						type = "description",
						name = " ",
						order = 15,
						width = 0.15,
					},

					copy_timestamps = {
						name = PL["copy_timestamps_name"],
						desc = PL["copy_timestamps_desc"],
						type = "toggle",
						order = 20,
						width = 1.35,
					},
				}
			},

			appearance_group = {
				type = "group",
				name = PL["appearance_group_name"],
				desc = PL["appearance_group_desc"],
				inline = true,
				order = 300,
				args = {
					active_alpha = {
						name = PL["active_alpha_name"],
						desc = PL["active_alpha_desc"],
						type = "range",
						order = 10,
						width = 1.25,
						min = 0,
						max = 1.0,
						step = 0.1,
					},

					alpha_spacer = {
						type = "description",
						name = " ",
						order = 15,
						width = 0.15,
					},

					inactive_alpha = {
						name = PL["inactive_alpha_name"],
						desc = PL["inactive_alpha_desc"],
						type = "range",
						order = 20,
						width = 1.25,
						min = 0,
						max = 1.0,
						step = 0.1,
					},
				}
			},

			usage_group = {
				type = "group",
				name = PL["usage_group_name"],
				desc = PL["usage_group_desc"],
				inline = true,
				order = 50,
				args = {
					usage = {
						type = "description",
						name = PL["usage_text"],
						order = 10,
						width = "full",
					},
				}
			},
		}
	})

	--[[------------------------------------------------
		BR: Inicialização do frame de cópia, comandos e link de timestamp
		EN: Initialization of copy frame, commands and timestamp link
	------------------------------------------------]]--
	Prat:SetModuleInit(module.name, function(self)
		PratCCFrameScrollText:SetScript("OnTextChanged", function(this)
			self:on_text_changed(this)
		end)
		PratCCFrameScrollText:SetScript("OnEscapePressed", function()
			PratCCFrame:Hide()
			self.str = nil
		end)

		Prat.RegisterChatCommand("copychat", function()
			local frame = SELECTED_CHAT_FRAME
			if frame then
				self:scrape_chat_frame(frame)
			end
		end)

		Prat.RegisterChatCommand("copychatfull", function()
			local frame = SELECTED_CHAT_FRAME
			if frame then
				self:scrape_full_chat_frame(frame)
			end
		end)

		Prat.RegisterLinkType({ linkid = "pratcopy", linkfunc = self.copy_link, handler = module }, self.name)

		module.timestamps = Prat:GetModule("Timestamps")

		if self.timestamps then
			self:RawHook(self.timestamps, "GetTime")
		end
	end)

	--[[------------------------------------------------
		BR: Migra nomes antigos de profile para o padrão snake_case
		EN: Migrates old profile names to the snake_case standard
	------------------------------------------------]]--
	function module:migrate_profile()
		local profile = self.db and self.db.profile
		if not profile then
			return
		end

		local migration_map = {
			showbutton = "show_button",
			buttonpos = "button_position",
			copyformat = "copy_format",
			copytimestamps = "copy_timestamps",
			activealpha = "active_alpha",
			inactivealpha = "inactive_alpha",
		}

		for old_key, new_key in pairs(migration_map) do
			if profile[new_key] == nil and profile[old_key] ~= nil then
				profile[new_key] = profile[old_key]
			end
			profile[old_key] = nil
		end
	end

	--[[------------------------------------------------
		BR: Cria botões por chatframe e registra atualização de frames
		EN: Creates per-chatframe buttons and registers frame updates
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self:migrate_profile()
		self.buttons = {}
		for k, v in pairs(Prat.Frames) do
			self.buttons[k] = self:make_reminder(v:GetID())
			self:set_button_shown(k, self.db.profile.show_button[k])
		end

		Prat.RegisterChatEvent(self, Prat.Events.FRAMES_UPDATED)
	end

	--[[------------------------------------------------
		BR: Retorna descrição localizada do módulo
		EN: Returns localized module description
	------------------------------------------------]]--
	function module:GetDescription()
		return PL["module_desc"]
	end

	--[[------------------------------------------------
		BR: Cria botão de cópia para novos frames de chat
		EN: Creates copy button for newly added chat frames
	------------------------------------------------]]--
	function module:Prat_FramesUpdated(_, _, chatFrame)
		local id = chatFrame:GetID()
		self.buttons[id] = self:make_reminder(id)
		self:set_button_shown(id, self.db.profile.show_button[1])
	end

	--[[------------------------------------------------
		BR: Remove eventos, esconde botões e fecha frame de cópia
		EN: Removes events, hides buttons and closes copy frame
	------------------------------------------------]]--
	function module:OnModuleDisable()
		Prat.UnregisterAllChatEvents(self)
		self:hide_buttons()
		PratCCFrame:Hide()
	end

	--[[------------------------------------------------
		BR: Ativa modo nativo de seleção/cópia do chat
		EN: Enables native chat selection/copy mode
	------------------------------------------------]]--
	function module:enter_select_mode(frame)
		frame = frame or SELECTED_CHAT_FRAME

		frame:SetTextCopyable(true)
		frame:EnableMouse(true)
		frame:SetOnTextCopiedCallback(function(this)
			this:SetTextCopyable(false)
			this:EnableMouse(false)
			this:SetOnTextCopiedCallback(nil)
		end)
	end

	--[[------------------------------------------------
		BR: Remove hyperlinks e protege textos secretos antes da cópia
		EN: Removes hyperlinks and protects secret text before copying
	------------------------------------------------]]--
	local function clean_text(text)
		text = text:gsub("|K.-|k", "???")
		return StripHyperlinks(text, false, true)
	end

	--[[------------------------------------------------
		BR: Funções centrais de cópia, formatação e scraping do chat
		EN: Core chat copy, formatting and scraping functions
	------------------------------------------------]]--
	--[[------------------------------------------------
		Core Functions
	------------------------------------------------]] --
	--[[------------------------------------------------
		BR: Copia a linha visível quando o timestamp clicável é usado
		EN: Copies the visible line when the clickable timestamp is used
	------------------------------------------------]]--
	function module:copy_link(_, frame)
		if frame and self.db.profile.on and self.db.profile.copy_timestamps then
			for _, visible_line in ipairs(frame.visibleLines) do
				local is_mouse_over = visible_line:IsMouseOver()
				if (not issecretvalue or not issecretvalue(is_mouse_over)) and is_mouse_over then
					local info = visible_line.messageInfo
					if info and info.message then
						local text = issecretvalue and issecretvalue(info.message) and "<SECRET>" or clean_text(info.message)
						local edit_box = ChatEdit_ChooseBoxForSend(frame);

						if (edit_box ~= ChatEdit_GetActiveWindow()) then
							ChatFrame_OpenChat(text, frame);
						else
							edit_box:SetText(text);
						end
					end
					return false
				end
			end
		end

		return false
	end

	--[[------------------------------------------------
		BR: Hooka timestamp para transformá-lo em link clicável de cópia
		EN: Hooks timestamp to turn it into a clickable copy link
	------------------------------------------------]]--
	function module:GetTime(...)
		local stamp = self.hooks[self.timestamps].GetTime(...)
		if module.db.profile.on and module.db.profile.copy_timestamps then
			return "|Hpratcopy|h" .. stamp .. "|h"
		end

		return stamp
	end

	--[[------------------------------------------------
		BR: Estado temporário usado durante a montagem do texto copiado
		EN: Temporary state used while building copied text
	------------------------------------------------]]--
	module.lines = {}
	module.str = nil

	--[[------------------------------------------------
		BR: Formata linha copiada como texto puro, BBCode, HTML ou WowAce
		EN: Formats copied line as plain text, BBCode, HTML or WowAce
	------------------------------------------------]]--
	function module:get_formatted_line(line, r, g, b)
		local fmt = self.copy_format or self.db.profile.copy_format
		local CLR = Prat.CLR

		line = line:gsub("|c00000000|r", "")

		if fmt == "plain" then
			return line
		end

		if fmt == "bbcode" or fmt == "wowace" then
			local fline = line:gsub("|c[fF][fF](%w%w%w%w%w%w)", "[color=#%1]"):gsub("|r", "[/color]")
			return "[color=#" .. CLR:GetHexColor(r, g, b) .. "]" .. fline .. "[/color]"
		end

		if fmt == "html" then
			local fline = line:gsub("|c[fF][fF](%w%w%w%w%w%w)", "<font color='#%1'>"):gsub("|r", "</font>")
			return "<p><font color='#" .. CLR:GetHexColor(r, g, b) .. "' face='monospace'>" .. fline .. "</font></p>"
		end
	end

	--[[------------------------------------------------
		BR: Copia conteúdo visível/atual do chatframe
		EN: Copies visible/current chatframe content
	------------------------------------------------]]--
	function module:scrape_chat_frame(frame, noshow)
		self:do_copy_chat(frame, noshow)
	end

	--[[------------------------------------------------
		BR: Copia histórico completo disponível no historyBuffer
		EN: Copies full history available in historyBuffer
	------------------------------------------------]]--
	function module:scrape_full_chat_frame(frame)
		self:do_copy_chat_scroll(frame)
	end

	--[[------------------------------------------------
		BR: Executa cópia a partir da janela de chat selecionada
		EN: Runs copy from the selected chat window
	------------------------------------------------]]--
	function module:menu_scrape()
		self:scrape_chat_frame(SELECTED_CHAT_FRAME)
	end

	--[[------------------------------------------------
		BR: Monta texto do histórico completo e exibe no PratCCFrame
		EN: Builds full history text and displays it in PratCCFrame
	------------------------------------------------]]--
	function module:do_copy_chat_scroll(frame)
		local scrape_lines = {}
		local str

		if frame:GetNumMessages() == 0 then
			return
		end

		for i = frame:GetNumMessages(), 1, -1 do
			local msg = frame.historyBuffer:GetEntryAtIndex(i)
			msg = msg and msg.message

			if msg then
				scrape_lines[#scrape_lines + 1] = issecretvalue and issecretvalue(msg) and "<SECRET>" or clean_text(msg)
			end
		end

		str = table.concat(scrape_lines, "\n")

		PratCCFrameScrollText:SetText(str or "")
		PratCCText:SetText(PL["copy_window_title"]:format(frame:GetName():gsub("ChatFrame", "")))
		PratCCFrame:Show()
	end

	--[[------------------------------------------------
		BR: Callback auxiliar para execução diferida da cópia
		EN: Helper callback for delayed copy execution
	------------------------------------------------]]--
	function module:do_copy_chat_arg(arg)
		self:do_copy_chat(unpack(arg))
	end

	--[[------------------------------------------------
		BR: Monta texto copiável do chatframe atual
		EN: Builds copyable text from the current chatframe
	------------------------------------------------]]--
	function module:do_copy_chat(frame, noshow)
		local lines = {}

		for i = 1, frame:GetNumMessages() do
			local msg = frame:GetMessageInfo(i)

			if msg then
				if issecretvalue and issecretvalue(msg) then
					lines[#lines + 1] = "<SECRET>"
				else
					lines[#lines + 1] = clean_text(msg)
				end
			end
		end

		local str = table.concat(lines, "\n")

		if not noshow then
			if (self.copy_format and self.copy_format == "wowace") or self.db.profile.copy_format == "wowace" then
				str = "[bgcolor=black]" .. str .. "[/bgcolor]"
			end

			PratCCFrameScrollText:SetText(str or "")
			PratCCText:SetText(PL["copy_window_title"]:format(frame:GetName():gsub("ChatFrame", "")))
			PratCCFrame:Show()
		end
	end

	--[[------------------------------------------------
		BR: Atalho público para copiar a janela de chat selecionada
		EN: Public shortcut to copy the selected chat window
	------------------------------------------------]]--
	function module:copy_chat()
		module:scrape_chat_frame(SELECTED_CHAT_FRAME)
	end

	-- BR: Método público usado pelo Bindings.xml.
	-- EN: Public method used by Bindings.xml.
	function module:CopyChat()
		return self:copy_chat()
	end

	-- BR: Aliases legados para chamadas internas/externas antigas.
	-- EN: Legacy aliases for old internal/external calls.
	module.ScrapeChatFrame = module.scrape_chat_frame
	module.ScrapeFullChatFrame = module.scrape_full_chat_frame
	module.MenuScrape = module.menu_scrape
	module.DoCopyChatScroll = module.do_copy_chat_scroll
	module.DoCopyChatArg = module.do_copy_chat_arg
	module.DoCopyChat = module.do_copy_chat
	module.CopyLink = module.copy_link
	module.GetFormattedLine = module.get_formatted_line

	--[[------------------------------------------------
		BR: Mantém scroll do frame de cópia no final e protege texto interno
		EN: Keeps copy frame scrolled to bottom and protects internal text
	------------------------------------------------]]--
	function module:on_text_changed(this)
		if self.str and this:GetText() ~= self.str then
			this:SetText(self.str)
			self.str = nil
		end
		local s = PratCCFrameScrollScrollBar
		this:GetParent():UpdateScrollChildRect()
		local _, m = s:GetMinMaxValues()
		if m > 0 and this.max ~= m then
			this.max = m
			s:SetValue(m)
		end
	end

	module.OnTextChanged = module.on_text_changed

	--[[------------------------------------------------
		BR: Esconde todos os botões de cópia criados
		EN: Hides all created copy buttons
	------------------------------------------------]]--
	function module:hide_buttons()
		for _, v in pairs(self.buttons) do
			v:Hide()
		end
	end

	--[[------------------------------------------------
		BR: Mostra ou esconde botão de cópia de um frame específico
		EN: Shows or hides a specific frame copy button
	------------------------------------------------]]--
	function module:set_button_shown(id, show)
		local b = self.buttons[id]
		if show then
			b:Show()
		else
			b:Hide()
		end
	end

	module.HideButtons = module.hide_buttons
	module.hidebuttons = module.hide_buttons
	module.SetButtonShown = module.set_button_shown
	module.showbutton = module.set_button_shown

	--[[------------------------------------------------
		BR: Handlers do botão de cópia no chatframe
		EN: Chatframe copy button handlers
	------------------------------------------------]]--
	do
		local function reminder_on_click(self, button)
			PlaySound(SOUNDKIT.IG_CHAT_BOTTOM);
			if button == "RightButton" then
				module:enter_select_mode(self:GetParent())
			else
				if (IsShiftKeyDown()) then
					module:enter_select_mode(self:GetParent())
				elseif (IsControlKeyDown()) then
					module:scrape_full_chat_frame(self:GetParent())
				else
					module:scrape_chat_frame(self:GetParent())
				end
			end

			module.copy_format = nil
		end

		local function reminder_on_enter(self)
			self:SetAlpha(module.db.profile.active_alpha)
		end

		local function reminder_on_leave(self)
			self:SetAlpha(module.db.profile.inactive_alpha)
		end

		--[[------------------------------------------------
			BR: Cria/reutiliza botão visual de cópia para um chatframe
			EN: Creates/reuses visual copy button for a chatframe
		------------------------------------------------]]--
		function module:make_reminder(id)
			local cf = _G["ChatFrame" .. id]
			local name = "ChatFrame" .. id .. "PratCCReminder"
			local b = _G[name]
			if not b then
				b = CreateFrame("Button", name, cf)
				b:SetFrameStrata("MEDIUM")
				b:SetWidth(24)
				b:SetHeight(24)
				b:SetNormalTexture("Interface\\Addons\\Prat-3.0\\textures\\prat-chatcopy2")
				b:SetPushedTexture("Interface\\Addons\\Prat-3.0\\textures\\prat-chatcopy")
				b:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
				b:SetPoint(self.db.profile.button_position, cf, self.db.profile.button_position, 0, 0)
				b:SetScript("OnClick", reminder_on_click)
				b:SetScript("OnEnter", reminder_on_enter)
				b:SetScript("OnLeave", reminder_on_leave)
				b:SetAlpha(module.db.profile.inactive_alpha)
				b:RegisterForClicks("AnyUp")
				b:Hide()
			end

			return b
		end
	end

	--[[------------------------------------------------
		BR: Reposiciona botões quando as opções mudam
		EN: Repositions buttons when options change
	------------------------------------------------]]--
	function module:OnValueChanged()
		for k, v in pairs(Prat.Frames) do
			local cf = _G["ChatFrame" .. v:GetID()]
			local btn = self.buttons[k]
			btn:ClearAllPoints()
			btn:SetPoint(self.db.profile.button_position, cf, self.db.profile.button_position, 0, 0)
			btn:SetAlpha(module.db.profile.inactive_alpha)
		end
	end

	return
end)
