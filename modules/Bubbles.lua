--[[
    @File:      Bubbles.lua
    @Project:   Prat-3.0

    BR: Personalização visual das bolhas de chat.
        - Redução das bolhas para uma linha
        - Coloração das bordas conforme o tipo de chat
        - Aplicação da formatação do Prat ao texto
        - Exibição de ícones de raid nas bolhas
        - Ajuste de fonte, tamanho e transparência

    EN: Visual customization of chat bubbles.
        - Shortening bubbles to a single line
        - Border coloring based on chat type
        - Applying Prat formatting to bubble text
        - Displaying raid icons inside bubbles
        - Font, size and transparency adjustments

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

--[[------------------------------------------------
    BR: Registro tardio do módulo para carregamento controlado pelo Prat
    EN: Deferred module registration for Prat-controlled loading
------------------------------------------------]]--
Prat:AddModuleToLoad(function()
	--[[------------------------------------------------
		BR: Criação do módulo de personalização das bolhas de chat
		EN: Creation of the chat bubble customization module
	------------------------------------------------]]--
	local module = Prat:NewModule("Bubbles")
	--[[------------------------------------------------
		BR: Referência local às strings centralizadas de localização
		EN: Local reference to centralized localization strings
	------------------------------------------------]]--
	local PL = module.PL

	--[[------------------------------------------------
		BR: Detecta comportamento específico do cliente Classic Era
		EN: Detects Classic Era specific client behavior
	------------------------------------------------]]--
	module._classic_era = _G.WOW_PROJECT_ID == _G.WOW_PROJECT_CLASSIC

	Prat:SetModuleDefaults(module.name, {
		profile = {
			on = true,
			shorten = false,
			color = true,
			format = true,
			icons = true,
			font = true,
			transparent = false,
			font_size = 14,
		}
	})

	--[[------------------------------------------------
		BR: Configuração das opções da interface do módulo
		EN: Module interface options configuration
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
					description = {
						type = "description",
						name = PL["full_description"],
						order = 10,
						width = "full",
					},

					spacer_after_description = {
						type = "description",
						name = "\n",
						order = 15,
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

			appearance_group = {
				type = "group",
				name = PL["appearance_tab_name"],
				desc = PL["appearance_tab_desc"],
				order = 20,
				args = {
					appearance_help = {
						type = "description",
						name = PL["appearance_help"],
						order = 10,
						width = "full",
					},

					color = {
						type = "toggle",
						name = PL["color_name"],
						desc = PL["color_desc"],
						order = 20,
						width = 1.25,
					},

					transparent = {
						type = "toggle",
						name = PL["transparent_name"],
						desc = PL["transparent_desc"],
						order = 30,
						width = 1.25,
					},

					font = {
						type = "toggle",
						name = PL["font_name"],
						desc = PL["font_desc"],
						order = 40,
						width = 1.25,
					},

					font_size = {
						type = "range",
						name = PL["font_size_name"],
						desc = PL["font_size_desc"],
						order = 50,
						width = 1.25,
						min = 8,
						max = 32,
						step = 1,
						disabled = function(info)
							return not info.handler.db.profile.font
						end,
					},
				},
			},

			content_group = {
				type = "group",
				name = PL["content_tab_name"],
				desc = PL["content_tab_desc"],
				order = 30,
				args = {
					content_help = {
						type = "description",
						name = PL["content_help"],
						order = 10,
						width = "full",
					},

					format = {
						type = "toggle",
						name = PL["format_name"],
						desc = PL["format_desc"],
						order = 20,
						width = 1.35,
					},

					icons = {
						type = "toggle",
						name = PL["icons_name"],
						desc = PL["icons_desc"],
						order = 30,
						width = 1.35,
					},
				},
			},

			behavior_group = {
				type = "group",
				name = PL["behavior_tab_name"],
				desc = PL["behavior_tab_desc"],
				order = 40,
				args = {
					behavior_help = {
						type = "description",
						name = PL["behavior_help"],
						order = 10,
						width = "full",
					},

					shorten = {
						type = "toggle",
						name = PL["shorten_name"],
						desc = PL["shorten_desc"],
						order = 20,
						width = "full",
					},
				},
			},
		}
	})

	--[[------------------------------------------------
		BR: Intervalo mínimo entre varreduras das bolhas de chat
		EN: Minimum interval between chat bubble scans
	------------------------------------------------]]--
	local bubble_scan_throttle = 0.1

	--[[------------------------------------------------
		BR: Ativação do módulo e criação do frame de atualização
		EN: Module activation and update frame creation
	------------------------------------------------]]--
	function module:OnModuleEnable()
		self.update_frame = self.update_frame or CreateFrame('Frame');
		self.throttle = bubble_scan_throttle

		self.update_frame:SetScript("OnUpdate", function(frame, elapsed)
			self.throttle = self.throttle - elapsed
			if frame:IsShown() and self.throttle < 0 then
				self.throttle = bubble_scan_throttle
				self:format_bubbles()
			end
		end)

		self:restore_defaults()
		self:apply_options()
	end

	--[[------------------------------------------------
		BR: Aplica opções salvas ao comportamento atual das bolhas
		EN: Applies saved options to the current bubble behavior
	------------------------------------------------]]--
	function module:apply_options()
		self.shorten = self.db.profile.shorten
		self.color = self.db.profile.color
		self.format = self.db.profile.format
		self.icons = self.db.profile.icons
		self.font = self.db.profile.font
		self.font_size = self.db.profile.font_size
		self.transparent = self.db.profile.transparent

		if self.shorten or self.color or self.format or self.icons or self.font or self.transparent then
			self.update_frame:Show()
		else
			self.update_frame:Hide()
		end
	end


	--[[------------------------------------------------
		BR: Reaplica opções quando uma configuração é alterada
		EN: Reapplies options when a setting is changed
	------------------------------------------------]]--
	function module:OnValueChanged()
		self:restore_defaults()

		self:apply_options()
	end

	function module:OnModuleDisable()
		self:restore_defaults()
	end

	--[[------------------------------------------------
		BR: Inicia a formatação das bolhas atualmente visíveis
		EN: Starts formatting currently visible bubbles
	------------------------------------------------]]--
	function module:format_bubbles()
		self:iterate_chat_bubbles("format_callback")
	end

	--[[------------------------------------------------
		BR: Restaura aparência padrão das bolhas de chat
		EN: Restores the default appearance of chat bubbles
	------------------------------------------------]]--
	function module:restore_defaults()
		self.update_frame:Hide()

		self:iterate_chat_bubbles("restore_defaults_callback")
	end

	--[[------------------------------------------------
		BR: Partes visuais da textura usada pelas bolhas de chat
		EN: Visual texture parts used by chat bubbles
	------------------------------------------------]]--
	local texture_uvs = {
		"TopLeftCorner", "TopRightCorner",
		"BottomLeftCorner", "BottomRightCorner",
		"TopEdge", "BottomEdge",
		"LeftEdge", "RightEdge"
	}
	-- Called for each chatbubble, passed the bubble's frame and its font_string
	--[[------------------------------------------------
		BR: Aplica cor, fonte, transparência, ícones e formatação ao texto
		EN: Applies color, font, transparency, icons and formatting to the text
	------------------------------------------------]]--
	function module:format_callback(frame, font_string)
		if not frame:IsShown() then
			font_string.last_text = nil
			return
		end

		if self.color then
			-- Color the bubble border the same as the chat
			local r, g, b, a = font_string:GetTextColor()
			for _, edge in pairs(texture_uvs) do
				frame[edge]:SetVertexColor(r, g, b, a)
			end
			frame.Tail:SetVertexColor(r, g, b, a)
		end

		if self.shorten then
			local wrap = font_string:CanWordWrap() or false
			-- If the mouse is over, then expand the bubble
			if frame:IsMouseOver() then
				font_string:SetWordWrap(true)
			elseif wrap == true then
				font_string:SetWordWrap(false)
			end
		end

		if self.font then
			local _, _, c = font_string:GetFont()

			font_string:SetFont(ChatFrame1:GetFont(), self.font_size, c)
		end

		if self.transparent then
			for _, edge in pairs(texture_uvs) do
				frame[edge]:SetTexture(nil)
			end
			frame.Center:SetTexture(nil)
			frame.Tail:SetTexture(nil)
		end

		local text = font_string:GetText() or ""

		if self.icons then
			if (not font_string.last_text) or (text ~= font_string.last_text) then
				local term;
				for tag in string.gmatch(text, "%b{}") do
					term = strlower(string.gsub(tag, "[{}]", ""));
					if (ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]]) then
						text = string.gsub(text, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
					end
				end
			end
		end

		if self.format then
			if (not font_string.last_text) or (text ~= font_string.last_text) then
				text = Prat:MatchPatterns(text)
				text = Prat:ReplaceMatches(text)
			end
		end

		font_string:SetText(text)
		font_string.last_text = text
		font_string:SetWidth(font_string:GetWrappedWidth())
	end

	-- Called for each chatbubble, passed the bubble's frame and its font_string
	--[[------------------------------------------------
		BR: Restaura cor, quebra de linha e largura padrão da bolha
		EN: Restores default color, word wrapping and bubble width
	------------------------------------------------]]--
	function module:restore_defaults_callback(frame, font_string)
		for _, edge in pairs(texture_uvs) do
			frame[edge]:SetVertexColor(1, 1, 1, 1)
		end
		frame.Tail:SetVertexColor(1, 1, 1, 1)
		font_string:SetWordWrap(true)
		font_string:SetWidth(font_string:GetWidth())
	end

	--[[------------------------------------------------
		BR: Percorre bolhas de chat visíveis respeitando diferenças Classic/Retail
		EN: Iterates visible chat bubbles while respecting Classic/Retail differences
	------------------------------------------------]]--
	function module:iterate_chat_bubbles(callback)
		-- includeForbidden is false by default but in case default changes at some point
		for _, chat_bubble_obj in pairs(C_ChatBubbles.GetAllChatBubbles(false)) do
			local chat_bubble
			if self._classic_era then
				-- BR: Sim, é hardcoded; no Classic Era a própria estrutura das bolhas exige isso.
				-- EN: Yes, this is hardcoded; Classic Era bubble structure requires it.
				chat_bubble = chat_bubble_obj
				chat_bubble.Center, chat_bubble.TopLeftCorner, chat_bubble.TopRightCorner, chat_bubble.BottomLeftCorner, chat_bubble.BottomRightCorner,
				chat_bubble.TopEdge, chat_bubble.BottomEdge, chat_bubble.LeftEdge, chat_bubble.RightEdge,
				chat_bubble.Tail, chat_bubble.String = chat_bubble:GetRegions()
			else
				chat_bubble = chat_bubble_obj:GetChildren()
			end
			if chat_bubble and chat_bubble.String and chat_bubble.String:GetObjectType() == "FontString" then
				if type(callback) == "function" then
					callback(chat_bubble, chat_bubble.String)
				else
					self[callback](self, chat_bubble, chat_bubble.String)
				end
			end
		end
	end

	return
end) -- Prat:AddModuleToLoad
