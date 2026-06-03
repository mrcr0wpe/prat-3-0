--[[
    @File:      enUS.lua
    @Project:   Prat-3.0
    @Locale:    enUS

    EN: English reference localization file.
        - Consolidates strings extracted from Prat modules.
        - Serves as the source for future translations.

    -------------------------------------------------------
    Review and Localization: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
-- -- APAGAR DAQUI PRA BAIXO, APENAS PARA AGRUPAMENTO
----
----
---
---
---
---
---
---
---
---
---
---
---
---
---
---DE ESPAÇOS EM BRANCO--]]

Prat_Locales = Prat_Locales or {}
Prat_Locales.enUS = Prat_Locales.enUS or {}
local enUS = Prat_Locales.enUS

-- ============================================================================
-- REF: addon/options.lua
-- EN: English reference strings (enUS)
-- ============================================================================


-- ============================================================================
-- REF: modules/Achievements.lua
-- EN: English reference strings (enUS)
-- ============================================================================


-- ============================================================================
-- REF: addon/options.lua
-- EN: Core addon options strings (enUS)
-- ============================================================================
enUS.Options = {
  -- General
  ["Disable"] = true,
  ["Enable"] = true,
  ["prat"] = "Prat",
  ["display_name"] = "Display Settings",
  ["display_desc"] = "Options related to the appearance, organization, and visual behavior of chat windows.",
  ["formatting_name"] = "Chat Formatting",
  ["formatting_desc"] = "Options that change how messages, names, channels, and text appear in chat.",
  ["extras_name"] = "Extras",
  ["extras_desc"] = "Additional tools and complementary Prat features.",
  ["modulecontrol_name"] = "Module Control",
  ["modulecontrol_desc"] = "Enable or disable individual Prat modules.",
  ["profiles_name"] = "Profiles",
  ["profiles_desc"] = "Manage Prat configuration profiles.",
  ["reload_required"] = "This option change may not take full effect until you %s your UI.",
  ["load_no"] = "Don't Load",
  ["load_disabled"] = "Disabled",
  ["load_enabled"] = "Enabled",
  ["load_desc"] = "Change this value to enable or disable loading this module.",
  ["unloaded_desc"] = "This module is not currently loaded.",
  ["load_disabledonrestart"] = "Disabled (reload)",
  ["load_enabledonrestart"] = "Enabled (reload)",
  ["modulecontrol_intro"] = "Enable or disable Prat modules by category. Tabs indicate the module purpose; the current state appears in each item's selector.",
  ["modulecontrol_display_name"] = "Display Settings",
  ["modulecontrol_display_desc"] = "Modules related to chat window appearance, behavior, and organization.",
  ["modulecontrol_formatting_name"] = "Chat Formatting",
  ["modulecontrol_formatting_desc"] = "Modules that change how messages, names, channels, and timestamps appear in chat.",
  ["modulecontrol_extras_name"] = "Extras",
  ["modulecontrol_extras_desc"] = "Additional features, shortcuts, helper tools, and complementary functions.",
  ["modulecontrol_advanced_name"] = "Advanced",
  ["modulecontrol_advanced_desc"] = "Technical, diagnostic, filtering, and higher-care modules.",
  ["modulecontrol_legacy_name"] = "Legacy / Special",
  ["modulecontrol_legacy_desc"] = "Old, specific, or rarely used modules that deserve attention before enabling.",
}


-- ============================================================================
-- REF: modules/Achievements.lua
-- EN: Module strings for Achievements (enUS)
-- ============================================================================
enUS.Achievements = {
  -- General
  ["module_name"] = "Achievements",
  ["module_desc"] = "Customizes how achievements are displayed in chat and lets you configure quick responses for other players.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of achievement module behavior.",
  ["full_description"] = "This module adjusts how achievements appear in chat.\n\nYou can hide guild achievements, show completion dates, and configure a quick response for reacting when another player earns an achievement.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Display|r controls which information appears in achievement messages.\n|cFFFFD100Quick Response|r configures the shortcut and message used to respond to other players' achievements.",

  -- Display
  ["display_tab_name"] = "Display",
  ["display_tab_desc"] = "Controls which achievement details are shown in chat.",
  ["display_help"] = "Define how achievement messages should appear in chat and which extra information should be shown.",
  ["dont_show_achievements_name"] = "Hide Guild Achievements",
  ["dont_show_achievements_desc"] = "Hides achievement messages earned by the guild, reducing chat message volume.",
  ["show_completed_date_name"] = "Show Completion Date",
  ["show_completed_date_desc"] = "Shows the date when the achievement was completed, when that information is available.",

  -- Quick Response
  ["quick_response_tab_name"] = "Quick Response",
  ["quick_response_tab_desc"] = "Configures the shortcut and message used to respond to other players' achievements.",
  ["quick_response_help"] = "Define how Prat should help you respond quickly when another player earns an achievement.",
  ["show_grats_link_name"] = "Show Response Shortcut",
  ["show_grats_link_desc"] = "Shows a clickable shortcut next to the achievement message for quickly sending a response to the player.",
  ["custom_grats_name"] = "Use Custom Message",
  ["custom_grats_desc"] = "Lets you define your own message to respond to other players' achievements.",
  ["custom_grats_text_name"] = "Response Message",
  ["custom_grats_text_desc"] = "Message sent when responding to an achievement. Use %s to automatically insert the player's name.",
  ["custom_grats_text_example"] = "Example: Congratulations %s!\n%s will be replaced with the name of the player who earned the achievement.",

  -- Runtime text
  ["custom_grats_default"] = "Grats %s",
  ["grats_link"] = "respond",
  ["completed"] = "Completed %s",

  -- Grats variants: player also has the achievement
  ["grats_have_1"] = "Grats %s",
  ["grats_have_2"] = "Gz %s, I have that one too",
  ["grats_have_3"] = "Wow %s that's great",
  ["grats_have_4"] = "Welcome to the club %s",
  ["grats_have_5"] = "I can still remember getting that one %s",
  ["grats_have_6"] = "That one is a rite of passage %s",
  ["grats_have_7"] = "I worked on that for ages %s, grats!",
  ["grats_have_8"] = "I remember doing that, %s, grats!",
  ["grats_have_9"] = "Nicely done %s",
  ["grats_have_10"] = "Good work %s, now we both have it",

  -- Grats variants: player does not have the achievement yet
  ["grats_donthave_1"] = "Grats %s",
  ["grats_donthave_2"] = "Gz %s, I still need that",
  ["grats_donthave_3"] = "I want that one %s, grats!",
  ["grats_donthave_4"] = "Wow %s that's great",
  ["grats_donthave_5"] = "I'm jealous %s, grats!",
  ["grats_donthave_6"] = "I have been working on that for ages %s",
  ["grats_donthave_7"] = "Still need that one %s, grats!",
  ["grats_donthave_8"] = "WTB your achievement %s",
  ["grats_donthave_9"] = "Looking forward to that one myself %s, good job!",
  ["grats_donthave_10"] = "I can't wait to get that one %s",
}


-- ============================================================================
-- REF: modules/AddonMessages.lua
-- EN: Module strings for AddonMsgs (enUS)
-- ============================================================================
enUS.AddonMsgs = {
  -- General
  ["module_name"] = "Addon Messages",
  ["module_desc"] = "Displays hidden internal messages sent through the addon communication channel.",
  ["full_description"] = "This module displays internal messages sent by addons through the CHAT_MSG_ADDON event.\n\nIt is mainly useful for diagnostics, debugging, or inspecting addon communication. For normal use, it is usually better to keep this module disabled.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of addon message diagnostics.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Addon Messages|r are internal communication messages exchanged between addons.\n\nEnabling this module can produce noisy output and is mostly useful for troubleshooting.",

  -- Windows
  ["windows_tab_name"] = "Windows",
  ["windows_tab_desc"] = "Choose where addon messages should be displayed.",
  ["windows_help"] = "Select the chat windows where hidden addon communication messages should be shown.",

  ["show_name"] = "Show Addon Messages",
  ["show_desc"] = "Shows hidden addon messages in the selected chat windows.",

  -- Diagnostic
  ["diagnostic_tab_name"] = "Diagnostic Use",
  ["diagnostic_tab_desc"] = "Explains the purpose and limitations of this module.",
  ["diagnostic_help"] = "|cFFFF8000Diagnostic module:|r\nThis module is intended for debugging addon communication. It can expose many internal messages that are not useful during normal gameplay.",
}


-- ============================================================================
-- REF: modules/Alias.lua
-- EN: Module strings for Alias (enUS)
-- ============================================================================
enUS.Alias = {
  -- General
  ["module_name"] = "Command Abbreviations",
  ["module_desc"] = "Lets you create abbreviations for slash ( / ) commands used in chat.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of how command abbreviations work.",
  ["full_description"] = "This module lets you create command abbreviations for the game's slash ( / ) commands.\n\nYou can turn long commands into shorter ones, list created abbreviations, remove old abbreviations, and control how they are expanded in chat.",

  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Abbreviations|r lets you create, remove, search, and list command abbreviations.\n|cFFFFD100Behavior|r controls how abbreviations are expanded while typing.\n|cFFFFD100Protection|r explains which slash ( / ) commands should not be used as abbreviations.",

  -- Management
  ["management_tab_name"] = "Abbreviations",
  ["management_tab_desc"] = "Creates, removes, searches, and lists command abbreviations.",
  ["management_help"] = "Create abbreviations with separated fields, or use advanced mode for more specific slash ( / ) commands.",

  ["examples_header"] = "Examples",
  ["examples_text"] = "|cFFFFD100Assisted builder:|r fill in the command, choose the channel, and write the message.\n|cFFFFD100Example:|r command |cFFFFD100hi|r + channel |cFFFFD100Say|r + message |cFFFFD100Hello everyone!|r creates /hi.\n|cFFFFD100Advanced mode:|r use |cFFFFD100hi say Hello everyone!|r only when you want to type the expansion manually.",
  ["input_usage"] = "In the assisted builder, fill in each part separately. In advanced mode, use the format: |cFFFFD100abbreviation command message|r.",

  -- Assisted Builder
  ["builder_header"] = "Assisted Builder",
  ["builder_help"] = "Use these fields to create a message abbreviation without memorizing the technical format. Enter the command name, choose where the message will be sent, and write the content.",
  ["builder_alias_name"] = "Command",
  ["builder_alias_desc"] = "Enter only the abbreviation name, without the slash. Example: hi creates the /hi command.",
  ["builder_command_name"] = "Channel",
  ["builder_command_desc"] = "Choose where the message will be sent when the abbreviation is used.",
  ["builder_message_name"] = "Message",
  ["builder_message_desc"] = "Text that will be sent when the abbreviation is executed.",
  ["builder_preview_empty"] = "Result: enter a command to preview the abbreviation.",
  ["builder_preview_format"] = "Result: /%s -> /%s",
  ["builder_create_name"] = "Create Abbreviation",
  ["builder_create_desc"] = "Creates or updates the abbreviation using the fields above.",

  ["builder_command_say"] = "Say",
  ["builder_command_yell"] = "Yell",
  ["builder_command_party"] = "Party",
  ["builder_command_raid"] = "Raid",
  ["builder_command_raid_warning"] = "Raid Warning",
  ["builder_command_guild"] = "Guild",
  ["builder_command_officer"] = "Officer",
  ["builder_command_instance"] = "Instance",
  ["builder_command_emote"] = "Emote",

  ["builder_missing_alias_warning"] = "Enter the abbreviated command name before creating the abbreviation.",
  ["builder_missing_command_warning"] = "Choose the target channel or command before creating the abbreviation.",
  ["builder_missing_message_warning"] = "Enter the message before creating the abbreviation.",

  -- Advanced Mode
  ["advanced_header"] = "Advanced Mode",
  ["advanced_help"] = "Use this field only when you want to manually create an abbreviation for another slash ( / ) command. Format: abbreviation command content. The command can be English or localized by the client, such as say or dizer.",

  ["manage_existing_header"] = "Existing Abbreviations",
  ["chat_send_unavailable_warning"] = "Could not send the message: no chat sending API is available in this client.",

  ["add_name"] = "Advanced Entry",
  ["add_desc"] = "Creates or updates an abbreviation using the manual format: abbreviation command message. Example: hi say Hello everyone!",
  ["del_name"] = "Remove Abbreviation",
  ["del_desc"] = "Removes an existing abbreviation.",
  ["find_name"] = "Search Abbreviations",
  ["find_desc"] = "Lists abbreviations that contain the provided search term.",
  ["list_name"] = "List Abbreviations",
  ["list_desc"] = "Prints all registered abbreviations in chat.",

  -- Behavior
  ["behavior_tab_name"] = "Behavior",
  ["behavior_tab_desc"] = "Controls how abbreviations are expanded.",
  ["behavior_help"] = "Adjust how the module handles abbreviations while typing and when creating new command abbreviations.",

  ["inline_name"] = "Expand While Typing",
  ["inline_desc"] = "Expands the abbreviation directly in the edit box when this behavior is available in the client. In modern clients, some abbreviations may be executed directly as registered commands.",
  ["no_clobber_name"] = "Do Not Overwrite Abbreviations",
  ["no_clobber_desc"] = "Prevents an existing abbreviation from being replaced when creating a new abbreviation with the same name.",

  -- Protection
  ["protect_commands_name"] = "Protect Existing Commands",
  ["protect_commands_desc"] = "Prevents creating abbreviations that use slash ( / ) commands already registered by the game, Prat, or other addons.",

  ["protection_tab_name"] = "Protection",
  ["protection_tab_desc"] = "Explains commands protected by the module.",
  ["protection_help"] = "Some commands are protected and cannot be used as abbreviations. Prat can also block abbreviations that conflict with slash ( / ) commands already registered by the game or other addons.",
  ["protected_commands_header"] = "Protected Commands",
  ["protected_commands_text"] = "Fixed protected commands: /alias, /unalias, /prat, /script, /run, /reload, /rl, /quit, and /listaliases.\n\nWith existing command protection enabled, Prat also refuses abbreviations such as /oi when that command is already registered by another addon or by the game.",

  -- Runtime Messages
  ["alias_select_format"] = "/%s -> /%s",
  ["nil_argument_error"] = "%s() called with nil argument!",
  ["blank_argument_error"] = "%s() called with blank string!",
  ["warn_nil_argument_error"] = "warnUser() called with nil argument!",
  ["warn_empty_string_error"] = "warnUser() called with zero length string!",

  ["protected_alias_warning"] = "Refusing to create abbreviation for \"/%s\" to avoid breaking important commands.",
  ["no_clobber_warning"] = "Overwrite protection enabled - skipping new abbreviation: /%s already expands to /%s.",
  ["overwrite_alias_warning"] = "Overwriting existing abbreviation \"/%s\" (was expanded to \"/%s\").",

  ["alias_created_message"] = "/%s abbreviates to: /%s",
  ["alias_missing_message"] = "Abbreviation \"/%s\" does not exist.",
  ["alias_deleted_message"] = "Deleting abbreviation \"/%s\" (previously expanded to \"/%s\").",
  ["alias_internal_missing_warning"] = "Tried to show value for abbreviation \"%s\", but it is undefined in module.Aliases!",
  ["alias_value_message"] = "/%s abbreviates to \"/%s\"",

  ["no_aliases_message"] = "No abbreviations have been defined.",
  ["matching_aliases_message"] = "Matching abbreviations found: %d",
  ["total_aliases_message"] = "Total abbreviations: %d",
  ["undefined_alias_message"] = "There is no abbreviation currently defined for \"%s\".",

  ["unknown_command_warning"] = "The slash command ( /%s ) was not recognized. Use an expansion with a valid command, for example: hi say Hello everyone!",
  ["existing_command_conflict_warning"] = "Refusing to create abbreviation \"/%s\": this slash ( / ) command already exists and may belong to the game or another addon.",
  ["saved_alias_conflict_warning"] = "Saved abbreviation \"/%s\" conflicts with an existing slash ( / ) command and was not registered.",
}


-- ============================================================================
-- REF: modules/AltNames.lua
-- EN: Module strings for AltNames (enUS)
-- ============================================================================
enUS.AltNames = {
  -- General
  ["module_name"] = "AltNames",
  ["module_desc"] = "Manages links between main and alternate characters, displaying those relationships in chat and tooltips.",

  ["links_tab_name"] = "Links",
  ["links_tab_desc"] = "Create or remove links between alternate and main characters.",
  ["links_help"] = "Use this tab to manually link an alternate character to its main character, or remove an existing link.",
  ["manual_links_group_name"] = "Manual Linking",
  ["manual_links_group_desc"] = "Create or remove Alt -> Main relationships.",
  ["link_name"] = "Link character",
  ["link_desc"] = "Enter the alt name followed by the main character name.",
  ["link_usage"] = "<alt> <main>  Example: Delyssa Moises",
  ["delete_name"] = "Remove link",
  ["delete_desc"] = "Remove an alternate character's link to its main.",
  ["delete_usage"] = "<alt>  Example: Delyssa",
  ["link_behavior_group_name"] = "Behavior",
  ["link_behavior_group_desc"] = "Controls how new links are recorded.",
  ["noclobber_name"] = "Do not replace existing links",
  ["noclobber_desc"] = "Prevents imports or new links from overwriting existing Alt -> Main relationships.",
  ["quiet_name"] = "Silent mode",
  ["quiet_desc"] = "Reduces confirmation messages sent by the module to chat.",

  ["lookup_tab_name"] = "Lookup",
  ["lookup_tab_desc"] = "Search characters and list saved links.",
  ["lookup_help"] = "Use this tab to search mains or alts, list a character's alts, or show all saved links.",
  ["lookup_group_name"] = "Search and Listing",
  ["lookup_group_desc"] = "Tools for checking existing links.",
  ["find_name"] = "Find character",
  ["find_desc"] = "Search main or alternate characters by the entered name.",
  ["find_usage"] = "<search term>",
  ["listalts_name"] = "List alts of a main",
  ["listalts_desc"] = "List all alternate characters linked to the entered main character.",
  ["listalts_usage"] = "<main>",
  ["listall_name"] = "List all links",
  ["listall_desc"] = "Show all saved Alt -> Main links.",

  ["display_tab_name"] = "Display",
  ["display_tab_desc"] = "Controls how links appear in chat and tooltips.",
  ["display_help"] = "Use this tab to define where the main name appears in chat, which colors are used, and what appears in tooltips.",
  ["chat_display_group_name"] = "Chat Display",
  ["chat_display_group_desc"] = "Controls how the main appears next to the alt in messages.",
  ["mainpos_name"] = "Main position",
  ["mainpos_desc"] = "Set where the main character name appears when a message comes from an alt.",
  ["position_left"] = "Left",
  ["position_right"] = "Right",
  ["position_start"] = "Start of message",
  ["pncol_name"] = "Class color",
  ["pncol_desc"] = "Use PlayerNames class color for the displayed name.",
  ["pncol_main"] = "Main class",
  ["pncol_alt"] = "Alt class",
  ["pncol_no"] = "Do not use",
  ["colour_name"] = "Custom color",
  ["colour_desc"] = "Set a fixed color for the main name when class color is disabled.",
  ["tooltip_group_name"] = "Tooltips",
  ["tooltip_group_desc"] = "Controls extra information shown in character tooltips.",
  ["tooltip_showmain_name"] = "Show main in tooltip",
  ["tooltip_showmain_desc"] = "Show the main character in an alt's tooltip.",
  ["tooltip_showalts_name"] = "Show alts in tooltip",
  ["tooltip_showalts_desc"] = "Show alternate characters in a main's tooltip.",

  ["import_tab_name"] = "Import",
  ["import_tab_desc"] = "Import links from guild data, LibAlts, and external addons.",
  ["import_help"] = "Use this tab to automatically fill links from guild data, shared libraries, or old addon databases.",
  ["import_options_group_name"] = "Import Options",
  ["import_options_group_desc"] = "Controls where data is read from and how it is applied.",
  ["usealtlib_name"] = "Use LibAlts data",
  ["usealtlib_desc"] = "Use information shared by LibAlts when available.",
  ["autoguildalts_name"] = "Automatically import from guild",
  ["autoguildalts_desc"] = "Attempts to import guild links automatically when the roster updates.",
  ["import_buttons_group_name"] = "Import Sources",
  ["import_buttons_group_desc"] = "Run manual imports from specific sources.",
  ["guildimport_name"] = "Import from guild",
  ["guildimport_desc"] = "Import alts from guild ranks, public notes, and officer notes.",
  ["ggimport_name"] = "Import from Guild Greet",
  ["ggimport_desc"] = "Import links from the Guild Greet addon database, if available.",
  ["importfromlok_name"] = "Import from LOKWhoIsWho",
  ["importfromlok_desc"] = "Import data from LOKWhoIsWho, if the database is available.",

  ["maintenance_tab_name"] = "Maintenance",
  ["maintenance_tab_desc"] = "Fix or clear the AltNames link database.",
  ["maintenance_help"] = "Use this tab with care. These options repair old data or delete saved links.",
  ["maintenance_group_name"] = "Maintenance Tools",
  ["maintenance_group_desc"] = "Actions for fixing or clearing saved links.",
  ["fixalts_name"] = "Fix links",
  ["fixalts_desc"] = "Attempt to fix corrupted or malformed entries in the alt list.",
  ["clearall_name"] = "Clear all links",
  ["clearall_desc"] = "Remove all saved Alt -> Main links.",

  ["ERROR: some function sent a blank message!"] = "ERROR: some function sent a blank message!",
  ["No arg string given to :addAlt()"] = "No argument string given to :addAlt().",
  ["No main name suPLied to link %s to"] = "No main name supplied to link %s to.",
  ["warning: alt %s already linked to %s"] = "Warning: alt %s is already linked to %s.",
  ["alt name exists: %s -> %s; not overwriting as set in preferences"] = "Alt link exists: %s -> %s; not overwriting because of preferences.",
  ["linked alt %s => %s"] = "Linked alt %s => %s.",
  ["character removed: %s"] = "Character removed: %s.",
  ["no characters called \"%s\" found; nothing deleted"] = "No characters called \"%s\" found; nothing deleted.",
  ["You have not yet linked any alts with their mains."] = "You have not yet linked any alts with their mains.",
  ["%s total alts linked to mains"] = "%s total alts linked to mains.",
  ["no alts or mains found matching \"%s\""] = "No alts or mains found matching \"%s\".",
  ["Found alt: %s => main: %s"] = "Found alt: %s => main: %s.",
  ["searched for: %s - total matches: %s"] = "Searched for: %s - total matches: %s.",
  ["LOKWhoIsWho lua file not found, sorry."] = "LOKWhoIsWho Lua file not found.",
  ["LOKWhoIsWho data not found"] = "LOKWhoIsWho data not found.",
  ["%s alts imported from LOKWhoIsWho"] = "%s alts imported from LOKWhoIsWho.",
  ["No Guild Greet database found"] = "No Guild Greet database found.",
  ["You are not in a guild"] = "You are not in a guild.",
  ["guild member alts found and imported: %s"] = "Guild member alts found and imported: %s.",
  ["no alts found for character "] = "No alts found for character ",
  ["%d alts found for %s: %s"] = "%d alts found for %s: %s",
  ["Main:"] = "Main:",
  ["Alts:"] = "Alts:",
  ["(.-)'s? [Aa]lt"] = "(.-)'s? [Aa]lt",
  [".*[Aa]lts?$"] = ".*[Aa]lts?$",
  [".*[Tt]wink.*$"] = ".*[Tt]wink.*$",
  ["([^%s%p%d%c%z]+)'s alt"] = "([^%s%p%d%c%z]+)'s alt",
  ["alt of ([^%s%p%d%c%z]+)"] = "alt of ([^%s%p%d%c%z]+)",

  -- Compatibility aliases / legacy keys
  ["link_options_group_name"] = "Link Options",
  ["link_options_group_desc"] = "Controls how new links are recorded.",
  ["no_clobber_name"] = "Do Not Replace Existing Links",
  ["no_clobber_desc"] = "Prevents imports or new links from overwriting existing Alt -> Main relationships.",
  ["list_alts_name"] = "List Alts of a Main",
  ["list_alts_desc"] = "List all alternate characters linked to the entered main character.",
  ["list_alts_usage"] = "<main>",
  ["list_all_name"] = "List All Links",
  ["list_all_desc"] = "Show all saved Alt -> Main links.",
  ["main_position_name"] = "Main Position",
  ["main_position_desc"] = "Set where the main character name appears when a message comes from an alt.",
  ["class_color_source_name"] = "Class Color Source",
  ["class_color_source_desc"] = "Choose whether class coloring should use the main, the alt, or no class color.",
  ["class_color_source_main"] = "Main",
  ["class_color_source_alt"] = "Alt",
  ["class_color_source_no"] = "None",
  ["custom_color_name"] = "Custom Color",
  ["custom_color_desc"] = "Choose a fixed color used when class coloring is not used.",
  ["tooltip_show_main_name"] = "Show Main in Tooltip",
  ["tooltip_show_main_desc"] = "Shows the linked main character in player tooltips.",
  ["tooltip_show_alts_name"] = "Show Alts in Tooltip",
  ["tooltip_show_alts_desc"] = "Shows linked alternate characters in player tooltips.",
  ["use_alt_lib_name"] = "Use AltLib",
  ["use_alt_lib_desc"] = "Imports alt relationships from the AltLib database when available.",
  ["auto_guild_alts_name"] = "Auto Guild Alts",
  ["auto_guild_alts_desc"] = "Automatically detects guild alt relationships from guild notes when possible.",
  ["guild_import_name"] = "Import Guild Notes",
  ["guild_import_desc"] = "Import alt relationships from guild notes.",
  ["guild_greet_import_name"] = "Import GuildGreet",
  ["guild_greet_import_desc"] = "Import alt relationships from GuildGreet data when available.",
  ["import_from_lok_name"] = "Import from LOK",
  ["import_from_lok_desc"] = "Import alt relationships from LOK data when available.",
  ["fix_alts_name"] = "Repair Alts",
  ["fix_alts_desc"] = "Attempts to repair stored alt relationships.",
  ["clear_all_name"] = "Clear All Links",
  ["clear_all_desc"] = "Deletes all stored Alt -> Main relationships.",
  ["error_blank_message"] = "Blank input is not valid.",
  ["error_no_add_alt_argument"] = "No alt/main names were provided.",
  ["error_no_main_name_for_link"] = "No main character name was provided for %s.",
  ["warning_alt_already_linked"] = "%s is already linked to %s.",
  ["warning_existing_link_not_overwritten"] = "Existing link was not overwritten: %s is already linked to %s.",
  ["msg_alt_linked"] = "Linked %s to main %s.",
  ["msg_character_removed"] = "Removed links for %s.",
  ["msg_no_character_deleted"] = "No saved link was found for %s.",
  ["msg_no_links_yet"] = "No alt links have been saved yet.",
  ["msg_total_links"] = "Total saved links: %d.",
  ["msg_no_matches_found"] = "No matches found for %s.",
  ["msg_found_alt_main"] = "%s is linked to main %s.",
  ["msg_search_summary"] = "Search for %s returned %d result(s).",
  ["msg_lok_file_not_found"] = "LOK data file was not found.",
  ["msg_lok_data_not_found"] = "No LOK alt data was found.",
  ["msg_lok_alts_imported"] = "Imported %d alt link(s) from LOK.",
  ["msg_no_guild_greet_database"] = "GuildGreet database was not found.",
  ["msg_not_in_guild"] = "You are not currently in a guild.",
  ["msg_guild_alts_imported"] = "Imported %d alt link(s) from guild data.",
  ["msg_no_alts_for_character"] = "No alts found for: ",
  ["msg_alts_found_for_character"] = "%d alt(s) found for %s: %s",
  ["label_main"] = "Main",
  ["label_alts"] = "Alts:",
  ["pattern_possessive_alt_cleanup"] = "^(.+)'s alt$",
  ["pattern_rank_alts"] = "alt",
  ["pattern_rank_twink"] = "twink",
  ["pattern_note_possessive_alt"] = "(.+)'s alt",
  ["pattern_note_alt_of"] = "alt of (.+)",
}


-- ============================================================================
-- REF: modules/Bubbles.lua
-- EN: Module strings for Bubbles (enUS)
-- ============================================================================
enUS.Bubbles = {
  -- General
  ["module_name"] = "Bubbles",
  ["module_desc"] = "Customizes the appearance and content of speech bubbles shown above characters and NPCs.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of bubble behavior.",
  ["full_description"] = "This module customizes speech bubbles shown above characters and NPCs.\n\nYou can adjust appearance, font, transparency, message formatting, raid icons, and long-message behavior.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Appearance|r controls bubble font, transparency, and colors.\n|cFFFFD100Content|r defines which Prat enhancements are applied to text.\n|cFFFFD100Behavior|r controls how long messages are displayed.",

  -- Appearance
  ["appearance_tab_name"] = "Appearance",
  ["appearance_tab_desc"] = "Controls bubble visual appearance.",
  ["appearance_help"] = "Adjust the visual appearance of bubbles shown above characters and NPCs.",
  ["color_name"] = "Color Borders",
  ["color_desc"] = "Colors the bubble border according to the message or chat type color.",
  ["transparent_name"] = "Make Bubbles Transparent",
  ["transparent_desc"] = "Removes or reduces background and border textures, making bubbles more discreet.",
  ["font_name"] = "Use Chat Font",
  ["font_desc"] = "Applies the same font used by chat windows to speech bubbles.",
  ["font_size_name"] = "Font Size",
  ["font_size_desc"] = "Sets the font size used by bubbles when the chat font option is enabled.",

  -- Content
  ["content_tab_name"] = "Content",
  ["content_tab_desc"] = "Controls content displayed inside bubbles.",
  ["content_help"] = "Control which Prat visual enhancements are also applied to the content shown inside bubbles.",
  ["format_name"] = "Apply Prat Formatting",
  ["format_desc"] = "Applies Prat-processed formatting patterns to bubble text, such as names, links, and recognized replacements.",
  ["icons_name"] = "Show Raid Icons",
  ["icons_desc"] = "Replaces tags such as {star}, {skull}, and other markers with raid icons inside bubbles.",

  -- Behavior
  ["behavior_tab_name"] = "Behavior",
  ["behavior_tab_desc"] = "Controls how bubbles behave while displayed.",
  ["behavior_help"] = "Defines behavior adjustments for bubbles while messages are displayed.",
  ["shorten_name"] = "Shorten Bubbles",
  ["shorten_desc"] = "Reduces long messages to one line while the mouse is not over the bubble. When hovered, the text expands again.",
}


-- ============================================================================
-- REF: modules/Buttons.lua
-- EN: Module strings for Buttons (enUS)
-- ============================================================================
enUS.Buttons = {
  -- General
  ["module_name"] = "Chat Controls",
  ["module_desc"] = "Controls the display of buttons and visual elements on chat windows.",
  ["full_description"] = "This module controls the buttons and visual elements on chat windows.\n\nUse these options to simplify the interface by hiding controls you do not use, or to keep navigation and quick-access features visible.",

  -- Navigation
  ["navigation_header"] = "Navigation",

  ["show_arrows_name"] = "Show Navigation Arrows",
  ["show_arrows_desc"] = "Shows or hides the arrows used to navigate through message history in each chat window.",

  ["scroll_reminder_name"] = "Show Return-to-Bottom Button",
  ["scroll_reminder_desc"] = "Shows a return-to-bottom button when you scroll up in a chat window while new messages continue arriving.",

  -- Interface
  ["interface_header"] = "Interface",

  ["show_bnet_name"] = "Show Social Menu",
  ["show_bnet_desc"] = "Shows or hides the social/Battle.net integration button associated with the chat window.",

  ["show_menu_name"] = "Show Chat Menu",
  ["show_menu_desc"] = "Shows or hides the main menu button for the chat window.",

  ["show_minimize_name"] = "Show Minimize Button",
  ["show_minimize_desc"] = "Shows or hides the button used to minimize undocked chat windows.",

  ["show_voice_name"] = "Show Voice Buttons",
  ["show_voice_desc"] = "Shows or hides voice control buttons, such as mute or deafen, when available.",

  ["show_channel_name"] = "Show Channel Button",
  ["show_channel_desc"] = "Shows or hides the button used to access options and controls related to chat channels.",
}


-- ============================================================================
-- REF: modules/ChannelColorMemory.lua
-- EN: Module strings for ChannelColorMemory (enUS)
-- ============================================================================
enUS.ChannelColorMemory = {
  -- General
  ["module_name"] = "Channel Color Memory",
  ["module_desc"] = "Remembers the color assigned to each channel by name, even when the channel number changes.",

  -- Information
  ["info_group_name"] = "How It Works",
  ["info_group_desc"] = "Explains the automatic behavior of this module.",
  ["info_text"] = "This module saves the chosen color for each channel by name. When you join the same channel again, the color will be restored automatically, even if the channel appears under a different number.",
  ["info_note"] = "There are no additional options here: keep this module enabled so it can automatically remember and restore channel colors.",

  -- Technical Patterns
  ["channel_name_pattern"] = "(%S+)%s?(.*)",
}


-- ============================================================================
-- REF: modules/ChannelNames.lua
-- EN: Module strings for ChannelNames (enUS)
-- ============================================================================
enUS.ChannelNames = {
  -- General
  ["module_name"] = "Channel Names",
  ["module_desc"] = "Controls abbreviations, replacements, and nicknames for channel names and chat types.",

  -- Chat Types
  ["channel_types_tab_name"] = "Chat Types",
  ["channel_types_tab_desc"] = "Configure how fixed types and numbered channels will appear in chat.",

  ["chat_types_group_name"] = "Fixed Types",
  ["chat_types_group_desc"] = "Configure abbreviations for say, party, guild, raid, whisper, and other fixed types.",
  ["chat_types_select_group_name"] = "Fixed Types",
  ["chat_types_select_group_desc"] = "Configure abbreviations for say, party, guild, raid, whisper, and other fixed types.",

  ["numbered_channels_group_name"] = "Numbered Channels",
  ["numbered_channels_group_desc"] = "Configure abbreviations for numbered channels, such as Channel 1, Channel 2, and so on.",
  ["numbered_channels_select_group_name"] = "Numbered Channels",
  ["numbered_channels_select_group_desc"] = "Configure abbreviations for numbered channels, such as Channel 1, Channel 2, and so on.",

  -- Channel Nicknames
  ["channel_nicknames_tab_name"] = "Channel Nicknames",
  ["channel_nicknames_tab_desc"] = "Configure custom nicknames for specific channels.",
  ["custom_nicknames_group_name"] = "Detected Channels",
  ["custom_nicknames_group_desc"] = "Lists detected channels so custom nicknames can be assigned.",

  -- Formatting
  ["format_options_tab_name"] = "Other Options",
  ["format_options_tab_desc"] = "Control formatting details applied to abbreviations.",
  ["format_group_name"] = "Abbreviation Formatting",
  ["format_group_desc"] = "Control spacing and colons after channel abbreviations.",

  ["space_name"] = "Add Space",
  ["space_desc"] = "Add a space after the channel abbreviation.",
  ["colon_name"] = "Add Colon",
  ["colon_desc"] = "Add a colon between the player name and the message.",

  -- Dynamic Options
  ["chat_type_settings_desc"] = "Configure the abbreviation used for %s.",
  ["channel_nickname_settings_desc"] = "Configure the custom nickname for %s.",
  ["selected_type_help"] = "Choose an item from the list above and define how it will appear in chat.",
  ["replacement_text_name"] = "Abbreviation shown in chat",
  ["short_name_desc"] = "Set the text that will replace %s.",
  ["replace_name"] = "Use this replacement",
  ["replace_desc"] = "Enable or disable replacement for this chat type.",
  ["channel_number_name"] = "Channel %d",

  -- Nicknames
  ["add_nick_name"] = "Add Nickname",
  ["add_nick_desc"] = "Set a custom nickname for this channel.",
  ["remove_nick_name"] = "Remove Nickname",
  ["remove_nick_desc"] = "Remove the custom nickname for this channel.",

  -- Battle.net Labels
  ["bn_whisper_label"] = "Outgoing Battle.net Whisper",
  ["bn_whisper_incoming_label"] = "Incoming Battle.net Whisper",
  ["bn_conversation_label"] = "Battle.net Conversation",

  -- Default Short Names
  ["short_say"] = "[S]",
  ["short_whisper"] = "[W To]",
  ["short_whisper_incoming"] = "[W From]",
  ["short_bn_whisper"] = "[W To]",
  ["short_bn_whisper_incoming"] = "[W From]",
  ["short_yell"] = "[Y]",
  ["short_party"] = "[P]",
  ["short_party_leader"] = "[PL]",
  ["short_guild"] = "[G]",
  ["short_officer"] = "[O]",
  ["short_raid"] = "[R]",
  ["short_raid_leader"] = "[RL]",
  ["short_raid_warning"] = "[RW]",
  ["short_instance"] = "[I]",
  ["short_instance_leader"] = "[IL]",
  ["short_channel_1"] = "[1]",
  ["short_channel_2"] = "[2]",
  ["short_channel_3"] = "[3]",
  ["short_channel_4"] = "[4]",
  ["short_channel_5"] = "[5]",
  ["short_channel_6"] = "[6]",
  ["short_channel_7"] = "[7]",
  ["short_channel_8"] = "[8]",
  ["short_channel_9"] = "[9]",
  ["short_channel_10"] = "[10]",
}


-- ============================================================================
-- REF: modules/ChannelSticky.lua
-- EN: Module strings for ChannelSticky (enUS)
-- ============================================================================
enUS.ChannelSticky = {
  -- General
  ["module_name"] = "Conversation Memory",
  ["module_desc"] = "Automatically remembers the last chat type used.",

  -- Description
  ["full_description"] = "This module controls which conversation types remain active after you send a message.\n\nWhen a type is remembered, chat stays on that type after sending, so you do not need to select the same channel repeatedly.",

  -- Chat Types
  ["channel_name"] = "Channel",

  ["memory_group_name"] = "Remembered Conversation Types",
  ["memory_group_desc"] = "Choose which conversation types should remain active after sending messages.",
  ["memory_group_help"] = "Select the conversation types Prat should keep active after you send a message.",

  ["remember_type_name"] = "Remember %s",
  ["remember_type_desc"] = "Keep %s as the active conversation type after sending messages.",

  ["bn_whisper_short"] = "Battle.net Whisper",
  ["bn_conversation_short"] = "Battle.net Conversation",

  -- Smart Group
  ["smart_group_group_name"] = "Smart Group",
  ["smart_group_group_desc"] = "Configures automatic selection of the best available group chat type.",
  ["smart_group_group_help"] = "Smart Group automatically chooses the best available destination for group messages: instance, raid, party, or say.",

  ["smart_group_name"] = "Use Smart Group",
  ["smart_group_desc"] = "Enables the /smart and /smrt commands to send messages to the best available group chat type: instance, raid, party, or say.",
}


-- ============================================================================
-- REF: modules/ChatLog.lua
-- EN: Module strings for ChatLog (enUS)
-- ============================================================================
enUS.ChatLog = {
  -- General
  ["module_name"] = "Chat Logging",
  ["module_desc"] = "Automatically controls chat and combat logging in the game's log files.",
  ["full_description"] = "This module can record chat messages and combat events into World of Warcraft log files.\n\nChat log:\n|cFFFFD100Logs\\WoWChatLog.txt|r\n\nCombat log:\n|cFFFFD100Logs\\WoWCombatLog.txt|r",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of chat and combat logging.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Chat Logging|r records chat messages.\n|cFFFFD100Combat Logging|r records combat events.\n|cFFFFD100Quiet Mode|r hides feedback messages when logging is changed.\n\nThe game may only finish writing log files after logging out or closing World of Warcraft.",

  -- Logs
  ["logs_tab_name"] = "Logs",
  ["logs_tab_desc"] = "Enable or disable chat and combat logging.",
  ["logs_help"] = "Choose which logs should be enabled automatically when this module is active.",

  ["chat_log_name"] = "Chat Logging",
  ["chat_log_desc"] = "Enables or disables chat message logging.\n\nGenerated file:\nLogs\\WoWChatLog.txt",

  ["combat_log_name"] = "Combat Logging",
  ["combat_log_desc"] = "Enables or disables combat event logging.\n\nGenerated file:\nLogs\\WoWCombatLog.txt",

  -- Behavior
  ["behavior_tab_name"] = "Behavior",
  ["behavior_tab_desc"] = "Controls feedback messages shown by this module.",
  ["behavior_help"] = "These options only affect feedback messages from Prat. They do not change whether the game records the log files.",

  ["quiet_name"] = "Quiet Mode",
  ["quiet_desc"] = "Hides informational messages shown when logs are enabled or disabled.",

  ["important_note"] = "|cFFFF8000Important:|r\nLog files are controlled by the game itself. In some cases, they may only be updated or finalized after logging out of the character or closing World of Warcraft.",

  -- Runtime Messages
  ["chat_log_enabled"] = "Chat logging enabled.",
  ["chat_log_disabled"] = "Chat logging disabled.",
  ["chat_log_path"] = "The chat log will be saved to: <WoW Installation>\\Logs\\WoWChatLog.txt",

  ["combat_log_enabled"] = "Combat logging enabled.",
  ["combat_log_disabled"] = "Combat logging disabled.",
  ["combat_log_path"] = "The combat log will be saved to: <WoW Installation>\\Logs\\WoWCombatLog.txt",
}


-- ============================================================================
-- REF: modules/ChatTabs.lua
-- EN: Module strings for ChatTabs (enUS)
-- ============================================================================
enUS.ChatTabs = {
  -- General
  ["module_name"] = "Chat Tabs",
  ["module_desc"] = "Controls appearance, visibility, and alerts for chat window tabs.",
  ["full_description"] = "This module controls chat window tabs.\n\nYou can adjust visibility, transparency, font size, textures, and visual alerts when new messages arrive.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of chat tab behavior.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Visibility|r controls when tabs appear and their transparency.\n|cFFFFD100Alerts|r controls flashing, color changes, and alert duration for new messages.\n|cFFFFD100Per-window configuration|r allows different effects for each chat window.",

  -- Visibility
  ["visibility_tab_name"] = "Visibility",
  ["visibility_tab_desc"] = "Controls display, transparency, and basic tab appearance.",
  ["visibility_help"] = "Use this tab to define when tabs appear, what transparency they use when active or inactive, whether textures are shown, and what font size is used for tab names.",

  ["display_mode_name"] = "Display Mode per Window",
  ["display_mode_desc"] = "Sets tab display mode for each chat window. The selection may allow default behavior, force showing, or force hiding depending on the selected state.",

  ["active_alpha_name"] = "Active Tab Transparency",
  ["active_alpha_desc"] = "Sets the transparency of the currently selected chat window tab.",

  ["inactive_alpha_name"] = "Inactive Tab Transparency",
  ["inactive_alpha_desc"] = "Sets the transparency of tabs for chat windows that are not selected.",

  ["show_tab_textures_name"] = "Show Tab Textures",
  ["show_tab_textures_desc"] = "Shows or hides visual textures on chat tabs.",

  ["tab_font_size_name"] = "Tab Font Size",
  ["tab_font_size_desc"] = "Sets the font size used for chat tab names.",

  -- Alerts
  ["alerts_tab_name"] = "Alerts",
  ["alerts_tab_desc"] = "Controls flashing, highlighting, and visual tab alerts.",
  ["alerts_help"] = "Use this tab to control how tabs notify you when new messages arrive. You can disable flashes, keep alerts visible longer, and configure different effects for each window.",

  ["disable_flash_name"] = "Disable Flash",
  ["disable_flash_desc"] = "Prevents tabs from flashing when new messages arrive.",

  ["forever_alert_name"] = "Keep Alert Until Clicked",
  ["forever_alert_desc"] = "Keeps the visual alert active until you click the corresponding tab.",

  ["keep_highlight_inactive_name"] = "Keep Highlight on Inactive Tabs",
  ["keep_highlight_inactive_desc"] = "Keeps the visual highlight when the tab is not selected.",

  ["alert_timeout_name"] = "Alert Duration",
  ["alert_timeout_desc"] = "Defines how long flashes and highlights should remain visible.",

  -- Per-Window Alerts
  ["per_window_header"] = "Per-Window Alerts",
  ["per_window_help"] = "Each chat window can have its own effects. Enable flash, font color change, or both according to the importance of that window.",

  ["flash_row_name"] = "Tab Flash",
  ["flash_row_desc"] = "Configures the visual flash for this window's tab.",
  ["set_flash_name"] = "Flash on Message",
  ["set_flash_desc"] = "Makes the tab flash when this window receives a new message.",
  ["flash_color_name"] = "Flash Color",
  ["flash_color_desc"] = "Sets the color used for this tab's flash.",

  ["font_row_name"] = "Tab Text Color",
  ["font_row_desc"] = "Configures the temporary color change for the tab name.",
  ["change_font_name"] = "Change Color on Message",
  ["change_font_desc"] = "Temporarily changes the tab text color when this window receives a new message.",
  ["font_color_name"] = "Text Color",
  ["font_color_desc"] = "Sets the temporary color used for the tab text.",
}


-- ============================================================================
-- REF: modules/Clear.lua
-- EN: Module strings for Clear (enUS)
-- ============================================================================
enUS.Clear = {
  -- General
  ["module_name"] = "Clear Chat",
  ["module_desc"] = "Enables commands to clear the current chat window or all chat windows.",
  ["full_description"] = "This module enables quick clearing commands for chat windows.\n\nIt does not change channels, settings, filters, saved history, or Prat preferences. It only clears the messages currently visible in chat windows.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of clear chat commands.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100/clear|r and |cFFFFD100/cls|r clear the currently selected chat window.\n|cFFFFD100/clearall|r and |cFFFFD100/clsall|r clear all existing chat windows.",

  -- Commands
  ["commands_tab_name"] = "Commands",
  ["commands_tab_desc"] = "Available commands for clearing chat windows.",
  ["commands_help"] = "Use these slash commands directly in chat to clear visible messages.",

  ["current_window_commands"] = "|cFFFFD100/clear|r or |cFFFFD100/cls|r\nClears only the currently selected chat window.",

  ["all_windows_commands"] = "|cFFFFD100/clearall|r or |cFFFFD100/clsall|r\nClears all existing chat windows.",

  ["important_note"] = "|cFFFF8000Important:|r\nClearing removes only the visible window content. No saved conversation, setting, channel, saved scrollback, or persistent history is deleted.",
}


-- ============================================================================
-- REF: modules/CopyChat.lua
-- EN: Module strings for CopyChat (enUS)
-- ============================================================================
enUS.CopyChat = {
  -- General
  ["module_name"] = "Copy Messages",
  ["module_desc"] = "Allows copying messages from chat windows, including visible history, full history, and timestamp-clicked lines.",

  -- Copy Button
  ["button_group_name"] = "Copy Button",
  ["button_group_desc"] = "Controls which windows show the copy button and where it is positioned.",
  ["show_button_name"] = "Show Button on Windows",
  ["show_button_desc"] = "Choose which chat windows will display the copy button.",
  ["button_position_name"] = "Button Location",
  ["button_position_desc"] = "Set which corner of the chat window displays the copy button.",
  ["copy_name"] = "Copy Text Now",
  ["copy_desc"] = "Copy the selected chat window text into an edit box.",

  -- Copy Format
  ["format_group_name"] = "Copy Format",
  ["format_group_desc"] = "Controls the copied text format and whether timestamps can be clicked for copying.",
  ["copy_format_name"] = "Copied Text Format",
  ["copy_format_desc"] = "Set whether copied text is plain or includes color markup for BBCode, HTML, or WowAce.",
  ["copy_timestamps_name"] = "Copy from Timestamp",
  ["copy_timestamps_desc"] = "Allow clicking a message timestamp to copy that line.",

  -- Button Appearance
  ["appearance_group_name"] = "Button Appearance",
  ["appearance_group_desc"] = "Controls button opacity while hovered or idle.",
  ["active_alpha_name"] = "Hover Opacity",
  ["active_alpha_desc"] = "Set the button opacity while the mouse is over it.",
  ["inactive_alpha_name"] = "Idle Opacity",
  ["inactive_alpha_desc"] = "Set the button opacity while the mouse is not over it.",

  -- How to Use
  ["usage_group_name"] = "How to Use",
  ["usage_group_desc"] = "Explains copy button shortcuts.",
  ["usage_text"] = "Left click: copy visible text from the window.\nCTRL + click: copy the full available history.\nSHIFT + click or right click: enable the native chat selection mode.\nIf timestamp copying is enabled, click a message timestamp to copy only that line.",

  -- Button Positions
  ["position_top_left"] = "Top Left",
  ["position_top_right"] = "Top Right",
  ["position_bottom_left"] = "Bottom Left",
  ["position_bottom_right"] = "Bottom Right",

  -- Formats
  ["format_plain"] = "Plain Text",
  ["format_bbcode"] = "BBCode",
  ["format_html"] = "HTML",
  ["format_wowace"] = "WowAce Forums",

  -- Copy Window
  ["copy_window_title"] = "Chat Frame %s - Text",
}


-- ============================================================================
-- REF: modules/CustomFilters.lua
-- EN: Module strings for CustomFilters (enUS)
-- ============================================================================
enUS.CustomFilters = {
  -- General
  ["module_name"] = "Custom Filters",
  ["module_desc"] = "Creates manual rules to find, alter, block, highlight, play sounds, or redirect chat messages.",
  ["full_description"] = "This module works as a rule builder for chat. You create Inbound filters for received messages and Outbound filters for messages sent by you. Each filter can search for a text pattern and, when a match is found, perform actions such as replacing text, blocking the message, highlighting the match, playing a sound, or sending a copy to another output.",
  ["global_help"] = "|cFFFF8000Where to start:|r\nOpen Inbound or Outbound, create a filter with Add Filter, and then configure the actions inside the newly created filter. Secondary output options only appear inside the filter when Secondary Output is enabled.",

  -- Modes
  ["inbound_name"] = "Inbound",
  ["inbound_desc"] = "Filters applied to incoming chat messages.",
  ["inbound_help"] = "|cFFFF8000Inbound Filters:|r\nAffect messages that appear in your chat, such as channel, party, guild, whisper, raid, and game notices. Use them to block messages, highlight important terms, play sounds, or copy matched messages to another output.",

  ["outbound_name"] = "Outbound",
  ["outbound_desc"] = "Filters applied to messages sent by you.",
  ["outbound_help"] = "|cFFFF8000Outbound Filters:|r\nAffect messages you type before they are sent. Use with care: they can replace text, block sending, or process patterns in messages leaving your character.",

  -- Filter Management
  ["filter_management_header"] = "Manage Filters",
  ["filter_management_help"] = "After adding a filter, a new section with its name will appear on this screen. Open that section to configure search pattern, replacement, blocking, highlighting, sound, monitored channels, and secondary output.",
  ["add_pattern_name"] = "Add Filter",
  ["add_pattern_desc"] = "Enter the initial text or pattern this filter should search for. After creation, the filter will appear as a new configurable section.",
  ["remove_pattern_name"] = "Remove Filter",
  ["remove_pattern_desc"] = "Removes an existing filter from this tab. Only available when filters exist.",
  ["string_usage"] = "<text or pattern>",

  -- Single Filter
  ["single_filter_help"] = "Configure this filter's behavior here. First set the search pattern; then choose what should happen when a message matches that pattern.",
  ["identity_header"] = "Filter Identity",

  ["filter_name_name"] = "Filter Name",
  ["filter_name_desc"] = "Friendly name used to identify this filter in the list.",
  ["enabled_name"] = "Enabled",
  ["enabled_desc"] = "Enables or disables this filter without removing it.",

  -- Pattern
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Basic identity and summary for this filter.",
  ["overview_help"] = "This overview identifies the filter and whether it is currently active.",

  ["pattern_tab_name"] = "Search and Replacement",
  ["pattern_group_desc"] = "Defines what the filter should search for and, if needed, what text should replace it.",
  ["pattern_help"] = "Set the search pattern and optional replacement text. Lua patterns are supported, so advanced expressions can be used carefully.",

  ["search_pattern_name"] = "Search Pattern",
  ["search_pattern_desc"] = "Text or Lua pattern searched in the message. It can be a simple word or a more advanced pattern.",

  ["replacement_text_name"] = "Replacement Text",
  ["replacement_text_desc"] = "Text used to replace the found match. Disabled when the filter is configured to block or send to secondary output.",
  ["replacement_help"] = "|cFFFF8000Tip about %1:|r\n%1 represents the text found by the search pattern. Example: if the search finds Delyssa and the replacement is [%1], the result will be [Delyssa].",

  ["replacement_is_code_name"] = "Replacement is Lua Code",
  ["replacement_is_code_desc"] = "Treats the replacement text as Lua code. Use only if you understand the risks.",

  ["output_message_only_name"] = "Output Message Only",
  ["output_message_only_desc"] = "When sending to secondary output, sends only the message text instead of the full formatted chat line.",

  -- Actions
  ["actions_tab_name"] = "Actions",
  ["actions_group_desc"] = "Defines what happens when the message matches the search pattern.",
  ["actions_help"] = "Choose whether the message should be blocked, highlighted, played with sound, or copied to another output.",

  ["block_message_name"] = "Block Message",
  ["block_message_desc"] = "Prevents the matching message from appearing in chat.",

  ["highlight_match_name"] = "Highlight Match",
  ["highlight_match_desc"] = "Highlights the matched text in the message.",
  ["highlight_color_name"] = "Highlight Color",
  ["highlight_color_desc"] = "Color used when highlighting matched text.",

  ["play_sound_name"] = "Play Sound",
  ["play_sound_desc"] = "Plays the selected sound when the filter matches.",

  ["secondary_output_name"] = "Secondary Output",
  ["secondary_output_desc"] = "Shows options to send the matching message to another destination, in addition to normal processing.",

  -- Channels
  ["channels_tab_name"] = "Channels",
  ["channels_group_name"] = "Monitored Channels",
  ["channels_help"] = "Choose which chat types or channels this filter should monitor.",
  ["in_channels_desc"] = "Controls where this filter is allowed to run.",
  ["channel_scope_desc"] = "Enable this filter for %s (%s).",

  -- Secondary Output
  ["secondary_output_tab_name"] = "Secondary Output",
  ["secondary_output_group_desc"] = "Controls where matched messages are copied when Secondary Output is enabled.",
  ["secondary_output_help"] = "Secondary output sends a copy of the matched message to another destination. This is useful for monitoring important terms without losing the original chat flow.",
  ["secondary_output_config_header"] = "Output Settings",

  ["chatframesink_name"] = "Chat Frame",
  ["chatframesink_desc"] = "Send matched messages to a selected chat frame.",

  -- Compatibility aliases / legacy keys
  ["Pattern Options"] = "Pattern Options",
}


-- ============================================================================
-- REF: modules/Editbox.lua
-- EN: Module strings for Editbox (enUS)
-- ============================================================================
enUS.Editbox = {
  -- General
  ["module_name"] = "Edit Box",
  ["module_desc"] = "Customizes the chat input box appearance, position, textures, colors, and behavior.",
  ["full_description"] = "This module customizes the chat edit box, also known as the input bar where you type messages.\n\nYou can adjust its position, font, border, background, colors, arrow-key behavior, and compatibility with modern Blizzard chat handling.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of edit box customization options.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Position|r controls where the edit box attaches to the chat window.\n|cFFFFD100Appearance|r controls font, border, background, and colors.\n|cFFFFD100Behavior|r controls how keyboard arrows interact with chat history.",

  -- Position
  ["position_tab_name"] = "Position",
  ["position_tab_desc"] = "Controls where the edit box is attached.",
  ["position_help"] = "Choose where the edit box should appear relative to the chat window.",
  ["attach_name"] = "Attach To",
  ["attach_desc"] = "Sets the position of the edit box relative to the chat window.",
  ["attach_top"] = "Top",
  ["attach_bottom"] = "Bottom",
  ["attach_free"] = "Free",
  ["attach_locked"] = "Locked",

  -- Appearance
  ["appearance_tab_name"] = "Appearance",
  ["appearance_tab_desc"] = "Controls edit box visual appearance.",
  ["appearance_help"] = "Adjust font, border, background, and colors used by the chat edit box.",

  ["font_group_name"] = "Font",
  ["font_group_desc"] = "Controls the edit box font.",
  ["font_face_name"] = "Font",
  ["font_face_desc"] = "Choose the font used by the edit box.",
  ["font_size_name"] = "Font Size",
  ["font_size_desc"] = "Sets the edit box font size.",

  ["background_name"] = "Background Texture",
  ["background_desc"] = "Chooses the background texture used by the edit box.",
  ["border_name"] = "Border Texture",
  ["border_desc"] = "Chooses the border texture used by the edit box.",

  ["color_by_channel_name"] = "Color Border by Channel",
  ["color_by_channel_desc"] = "Colors the edit box border according to the active chat channel type.",
  ["border_color_name"] = "Border Color",
  ["border_color_desc"] = "Sets the default border color when channel coloring is not applied.",
  ["background_color_name"] = "Background Color",
  ["background_color_desc"] = "Sets the edit box background color and transparency.",

  -- Border
  ["border_group_name"] = "Border",
  ["border_group_desc"] = "Controls border measurements and spacing.",
  ["border_help"] = "Fine-tune the edit box border. Very high values can make the border look oversized or distorted depending on the selected texture.",
  ["edge_size_name"] = "Edge Size",
  ["edge_size_desc"] = "Sets the visual border thickness.",
  ["inset_name"] = "Inset",
  ["inset_desc"] = "Sets the inner spacing between the border and the background.",
  ["tile_size_name"] = "Tile Size",
  ["tile_size_desc"] = "Sets the size used to repeat the background texture.",

  -- Behavior
  ["behavior_tab_name"] = "Behavior",
  ["behavior_tab_desc"] = "Controls keyboard behavior while typing.",
  ["behavior_help"] = "Adjust how the edit box reacts to keyboard arrows and chat history navigation.",
  ["use_alt_key_name"] = "Use Alt for Arrow Keys",
  ["use_alt_key_desc"] = "Requires holding Alt while pressing arrow keys to navigate chat input history.",

  -- Compatibility aliases / legacy keys
  ["placement_group_name"] = "Position",
  ["placement_group_desc"] = "Controls where the edit box is positioned.",
  ["placement_help"] = "Choose where the edit box should appear relative to the chat window.",
  ["font_name"] = "Font",
  ["font_desc"] = "Chooses the font used by the edit box.",
}


-- ============================================================================
-- REF: modules/EventNames.lua
-- EN: Module strings for EventNames (enUS)
-- ============================================================================
enUS.EventNames = {
  -- General
  ["module_name"] = "Event Names",
  ["module_desc"] = "Shows the technical chat event name at the end of messages.",
  ["full_description"] = "This module displays the technical chat event name that generated each message.\n\nIt is mostly useful for diagnostics, testing, development, and understanding which WoW chat events are being processed by Prat.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Explains what event name display is for.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Windows|r controls which chat windows display event names.\n|cFFFFD100Processing|r controls whether Prat should process all chat events.\n\nExample event names include CHAT_MSG_GUILD, CHAT_MSG_SAY, CHAT_MSG_WHISPER, and similar technical event identifiers.",

  -- Windows
  ["windows_tab_name"] = "Windows",
  ["windows_tab_desc"] = "Choose which windows should display event names.",
  ["windows_help"] = "Select the chat windows where the technical event name should be appended to messages.",

  ["show_name"] = "Show Event Names",
  ["show_desc"] = "Enable technical event name display on the selected windows.",

  -- Processing
  ["processing_tab_name"] = "Event Processing",
  ["processing_tab_desc"] = "Control whether Prat should process events that would normally be ignored.",
  ["processing_help"] = "Use this option only when you need to inspect events. It may increase the number of messages processed by Prat.",

  ["all_events_name"] = "Process All Events",
  ["all_events_desc"] = "Force Prat to process all chat events so their names can be displayed.",

  -- Compatibility aliases / legacy keys
  ["help_group_name"] = "Overview",
  ["help_group_desc"] = "Explains what event name display is for.",
}


-- ============================================================================
-- REF: modules/Fading.lua
-- EN: Module strings for Fading (enUS)
-- ============================================================================
enUS.Fading = {
  -- General
  ["module_name"] = "Fading",
  ["module_desc"] = "Controls the gradual disappearance of messages in chat windows.",
  ["full_description"] = "This module controls how long messages remain visible in chat windows before gradually fading out.\n\nYou can choose which windows are affected and adjust the message visibility duration.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of fading behavior.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Windows|r controls which chat windows use fading.\n|cFFFFD100Timing|r controls how long messages stay visible before fading.\n\nDisabling fading on a window keeps its messages visible until the chat frame updates normally.",

  -- Windows
  ["windows_tab_name"] = "Windows",
  ["windows_tab_desc"] = "Choose which chat windows use message fading.",
  ["windows_help"] = "Select the chat windows where messages should gradually fade out after remaining visible for the configured duration.",

  ["text_fade_name"] = "Enable Fading",
  ["text_fade_desc"] = "Enable or disable gradual message fading for this chat window.",

  -- Timing
  ["timing_tab_name"] = "Timing",
  ["timing_tab_desc"] = "Controls how long messages remain visible before fading.",
  ["timing_help"] = "Set how long messages remain visible before they begin to fade out.",

  ["duration_name"] = "Visibility Duration",
  ["duration_desc"] = "Set how many seconds messages remain visible before gradually fading out.",
}


-- ============================================================================
-- REF: modules/Filtering.lua
-- EN: Module strings for Filtering (enUS)
-- ============================================================================
enUS.Filtering = {
  -- General
  ["module_name"] = "Filtering",
  ["module_desc"] = "Provides advanced filters to reduce repeated notices, spam, and unwanted chat messages.",
  ["full_description"] = "This module reduces unwanted messages, automatic notices, and repeated spam in chat channels.\n\nThe AI Filter uses a trainable classifier to identify suspicious messages and can learn from manually marked examples.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of filtering behavior.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Basic Filters|r hide repeated notices, trade spam, and repeated AFK/DND messages.\n|cFFFFD100AI Filter|r uses a trainable classifier to detect possible spam.\n|cFFFFD100Training|r adds clickable controls to teach the filter what is spam or legitimate.",

  -- Basic Filters
  ["basic_tab_name"] = "Basic Filters",
  ["basic_tab_desc"] = "Controls simple filters for notices and repeated messages.",
  ["basic_help"] = "Use these options to hide automatic notices and repeated messages that would otherwise clutter chat.",

  ["notices_name"] = "Filter Channel Notices",
  ["notices_desc"] = "Hides automatic channel join, leave, and change notices.",

  ["trade_spam_name"] = "Hide Repeated Spam",
  ["trade_spam_desc"] = "Hides repeated messages in channels and yells when they appear again within a short time window.",

  ["afk_dnd_name"] = "Hide Repeated AFK/DND",
  ["afk_dnd_desc"] = "Hides repeated away (AFK) or busy (DND) messages.",

  -- AI Filter
  ["ai_tab_name"] = "AI Spam Filter",
  ["ai_tab_desc"] = "Controls the trainable filter used to identify possible spam messages.",
  ["ai_help"] = "The AI filter is based on a trainable classifier. It can learn from examples marked manually when training mode is enabled.",

  ["use_ai_name"] = "AI Filter",
  ["use_ai_desc"] = "Uses a trainable classifier to identify and hide possible spam messages in chat channels.",

  ["training_name"] = "Train AI Filter",
  ["training_desc"] = "Shows clickable controls on messages so you can teach the filter what should be treated as spam or legitimate.",
  ["training_help"] = "|cFFFF8000How training works:|r\nWhen enabled, chat can show controls such as [--] and [++] next to the message score. Use [++] to mark as spam and [--] to mark as legitimate. The more correct examples are marked, the better the filter can adjust.",

  -- Runtime Messages
  ["learning_prefix"] = "Learning: ",
  ["unlearning_prefix"] = "Unlearning: ",
  ["learning_as"] = " as ",
  ["spam_label"] = "SPAM",
  ["not_spam_label"] = "NOT SPAM",

  -- Compatibility aliases / legacy keys
  ["basic_group_name"] = "Basic Filters",
  ["basic_group_desc"] = "Controls simple filters for notices and repeated messages.",
}


-- ============================================================================
-- REF: modules/Font.lua
-- EN: Module strings for Font (enUS)
-- ============================================================================
enUS.Font = {
  -- General
  ["module_name"] = "Font",
  ["module_desc"] = "Controls font, size, and text style in chat windows.",
  ["full_description"] = "This module controls the appearance of text in chat windows.\n\nYou can choose the font, adjust sizes per window, apply outlines, use monochrome mode, and change the text shadow color.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of font options.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Font|r chooses the typeface used in chat.\n|cFFFFD100Size|r adjusts text size per window.\n|cFFFFD100Style|r controls outline, monochrome mode, and text shadow.",

  -- Font Family
  ["font_family_group_name"] = "Font",
  ["font_family_group_desc"] = "Controls the font family used in chat.",
  ["font_family_help"] = "Choose the font used in chat windows. The remember font option keeps your choice and attempts to restore it when the game or another addon changes the font.",

  ["font_face_name"] = "Font",
  ["font_face_desc"] = "Chooses the font used in chat windows.",

  ["remember_font_name"] = "Remember Font",
  ["remember_font_desc"] = "Keeps the selected font and attempts to restore it automatically when the game or another addon changes it.",

  -- Font Size
  ["font_size_group_name"] = "Size",
  ["font_size_group_desc"] = "Controls text size in each chat window.",
  ["size_help"] = "Adjust the text size separately for each chat window. Some special tabs, such as whispers and pet battle, may appear depending on game version and active settings.",

  ["font_size_desc"] = "Sets the font size for this chat window.",
  ["whisper_tabs"] = "Whisper Tabs",
  ["pet_battle_tab"] = "Pet Battle Tab",

  -- Font Style
  ["font_style_group_name"] = "Style",
  ["font_style_group_desc"] = "Controls visual effects applied to text.",
  ["font_style_help"] = "Use this tab to apply outline, monochrome mode, and shadow color to chat text. These effects can improve readability depending on the interface background.",

  ["outline_mode_name"] = "Outline",
  ["outline_mode_desc"] = "Sets the outline style applied to text.",

  ["outline_none"] = "None",
  ["outline_normal"] = "Outline",
  ["outline_thick"] = "Thick Outline",

  ["monochrome_name"] = "Monochrome Mode",
  ["monochrome_desc"] = "Applies monochrome rendering to text. It may make the font look sharper or more rigid depending on the selected font.",

  ["shadow_color_name"] = "Shadow Color",
  ["shadow_color_desc"] = "Sets the text shadow color.",
}


-- ============================================================================
-- REF: modules/ChatFrames.lua
-- EN: Module strings for Frames (enUS)
-- ============================================================================
enUS.Frames = {
  -- General
  ["module_name"] = "Chat Windows",
  ["module_desc"] = "Controls size limits, positioning, and background opacity for chat windows.",
  ["full_description"] = "This module controls structural aspects of chat windows.\n\nYou can adjust minimum and maximum size limits, allow freer movement near screen edges, and control how chat window background opacity behaves.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of chat window structure options.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Size Limits|r controls how small or large chat windows can become.\n|cFFFFD100Position and Opacity|r controls screen-edge movement and background transparency behavior.\n\nSome changes are easier to notice after unlocking, moving, or resizing a chat window.",

  -- Size Limits
  ["size_limits_tab_name"] = "Size Limits",
  ["size_limits_tab_desc"] = "Defines the minimum and maximum dimensions allowed for chat windows.",
  ["size_limits_help"] = "Adjust the limits used when resizing chat windows. These values apply to all chat windows managed by Prat.",

  ["min_chat_height_name"] = "Minimum Height",
  ["min_chat_height_desc"] = "Sets the smallest allowed height for chat windows.",

  ["max_chat_height_name"] = "Maximum Height",
  ["max_chat_height_desc"] = "Sets the largest allowed height for chat windows.",

  ["min_chat_width_name"] = "Minimum Width",
  ["min_chat_width_desc"] = "Sets the smallest allowed width for chat windows.",

  ["max_chat_width_name"] = "Maximum Width",
  ["max_chat_width_desc"] = "Sets the largest allowed width for chat windows.",

  -- Position and Opacity
  ["position_opacity_tab_name"] = "Position and Opacity",
  ["position_opacity_tab_desc"] = "Controls movement, screen limits, and visual opacity for chat windows.",
  ["position_opacity_help"] = "Adjust how windows can be positioned on the screen and how their background opacity behaves.",

  ["remove_clamp_name"] = "Allow Free Movement",
  ["remove_clamp_desc"] = "Allows chat windows to be moved with fewer restrictions, including closer to the screen edges.",

  ["frame_alpha_static_name"] = "Keep Opacity Fixed",
  ["frame_alpha_static_desc"] = "Keeps the chat window background opacity fixed instead of changing automatically on mouseover.",

  ["default_frame_alpha_name"] = "Default Background Opacity",
  ["default_frame_alpha_desc"] = "Sets the default background opacity for chat windows. Lower values make the background more transparent; higher values make it more visible.",
}


-- ============================================================================
-- REF: modules/Highlight.lua
-- EN: Module strings for Highlight (enUS)
-- ============================================================================
enUS.Highlight = {
  -- General
  ["module_name"] = "Highlight",
  ["module_desc"] = "Visually highlights your name and possible guild names in chat messages.",
  ["full_description"] = "This module helps you quickly spot your own character name and possible guild names in busy chat messages.\n\nGuild highlighting treats text between angle brackets, such as <Guild Name>, as a possible guild name.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of highlight behavior.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Player Name|r highlights your own character name when it appears in chat.\n|cFFFFD100Guild Names|r highlights text between < > as possible guild names.",

  -- Highlights
  ["highlights_tab_name"] = "Highlights",
  ["highlights_tab_desc"] = "Choose what should be highlighted in chat.",
  ["highlights_help"] = "Enable or disable the types of text that should receive visual highlighting.",

  ["player_name"] = "Highlight Own Name",
  ["player_desc"] = "Highlights your character name when it appears in chat messages.",

  ["guild_name"] = "Highlight Guild Names",
  ["guild_desc"] = "Highlights text between < > as possible guild names.",
}


-- ============================================================================
-- REF: modules/History.lua
-- EN: Module strings for History (enUS)
-- ============================================================================
enUS.History = {
  -- General
  ["module_name"] = "History",
  ["module_desc"] = "Controls the number of saved chat lines and typed command history.",
  ["full_description"] = "This module controls two types of history.\n\nThe first is the number of lines kept in chat windows. The second is the typed command history in the edit box, which can be preserved between sessions.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of history options.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Chat Lines|r defines how many messages each window can keep in visible history.\n|cFFFFD100Command History|r saves typed commands for later reuse.\n\nSetting the line count very high may use more memory, especially in busy windows.",

  -- Chat Lines
  ["chat_lines_group_name"] = "Chat Lines",
  ["chat_lines_group_desc"] = "Controls how many lines each chat window can store.",
  ["chat_lines_help"] = "Choose which windows will have their line limit controlled by this module. Then set the maximum number of lines those windows can keep.",

  ["chat_lines_frames_name"] = "Apply to These Windows",
  ["chat_lines_frames_desc"] = "Defines which chat windows use the configured line limit below.",

  ["chat_lines_name"] = "Line Count",
  ["chat_lines_desc"] = "Sets the maximum number of lines stored by selected windows.",

  -- Command History
  ["command_history_group_name"] = "Command History",
  ["command_history_group_desc"] = "Controls whether typed commands are saved between sessions.",
  ["command_history_help"] = "When enabled, Prat preserves commands typed in the edit box so they can be reused later.\n\nThis history is separate from visible chat messages.",

  ["save_history_name"] = "Save Commands",
  ["save_history_desc"] = "Saves typed command history between sessions.",

  ["max_lines_name"] = "Command Limit",
  ["max_lines_desc"] = "Sets how many typed commands are kept in history.",

  -- Scrollback Extension
  ["scrollback_group_name"] = "Scrollback Options",
  ["scrollback_group_desc"] = "Controls message restoration between sessions.",
  ["scrollback_name"] = "Save Scrollback",
  ["scrollback_desc"] = "Stores chat window messages so they can be restored in the next session.",
  ["scrollback_duration_name"] = "Scrollback Duration",
  ["scrollback_duration_desc"] = "Set how many hours saved messages are kept.",
  ["remove_spam_name"] = "Remove Spam",
  ["remove_spam_desc"] = "Remove repeated addon messages when restoring history.",
  ["divider"] = "========== End of Scrollback ==========",
  ["bnet_removed"] = "<BNET REMOVED>",
}


-- ============================================================================
-- REF: modules/HoverTips.lua
-- EN: Module strings for HoverTips (enUS)
-- ============================================================================
enUS.HoverTips = {
  -- General
  ["module_name"] = "Hover Tips",
  ["module_desc"] = "Shows tooltips when hovering over supported links in chat.",
  ["full_description"] = "This module displays a tooltip when you move the mouse over supported links in chat.\n\nIt supports common game links such as items, enchants, spells, quests, achievements, currencies, and battle pets.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of hover tooltip behavior.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "Move the mouse over a supported chat link to display its tooltip near the cursor.\n\nThe tooltip is hidden automatically when the mouse leaves the link.",

  -- Supported Links
  ["supported_links_tab_name"] = "Supported Links",
  ["supported_links_tab_desc"] = "Lists the chat link types handled by this module.",
  ["supported_links_help"] = "Supported link types:\n\n|cFFFFD100Items|r\n|cFFFFD100Enchants|r\n|cFFFFD100Spells|r\n|cFFFFD100Quests|r\n|cFFFFD100Achievements|r\n|cFFFFD100Currencies|r\n|cFFFFD100Battle Pets|r",
}


-- ============================================================================
-- REF: modules/Invites.lua
-- EN: Module strings for Invites (enUS)
-- ============================================================================
enUS.Invites = {
  -- General
  ["module_name"] = "Invites",
  ["module_desc"] = "Makes group invites easier from chat, with shortcuts, clickable links, detection filters, and safety checks.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of invite behavior.",
  ["full_description"] = "This module makes group invites easier directly from chat.\n\nYou can ALT-click player names, turn invite requests into clickable links, and control where those requests should be detected.",

  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Actions|r controls the shortcuts used to invite players.\n|cFFFFD100Detection|r defines which chat channels Prat should scan for clickable invite requests.\n|cFFFFD100Safety|r adds a blacklist, combat lock, and anti-spam cooldown for repeated invites.",

  -- Actions
  ["actions_tab_name"] = "Actions",
  ["actions_tab_desc"] = "Controls quick ways to invite players.",
  ["actions_help"] = "Choose which shortcuts Prat should provide to make chat-based invites easier.",

  ["alt_invite_name"] = "ALT-Click to Invite",
  ["alt_invite_desc"] = "Allows you to invite a player by holding ALT and clicking their name or player link in chat.",

  ["link_invite_name"] = "Create Invite Links",
  ["link_invite_desc"] = "Turns detected invite requests in chat into clickable links for inviting the player.",

  -- Detection
  ["detection_tab_name"] = "Detection",
  ["detection_tab_desc"] = "Defines where invite requests are detected.",
  ["detection_help"] = "Choose which chat types Prat should scan for words like invite, inv, and recognized variations. These options only affect clickable invite links.",

  ["detect_whisper_name"] = "Whispers",
  ["detect_whisper_desc"] = "Detects invite requests received through whispers.",

  ["detect_guild_name"] = "Guild and Officer",
  ["detect_guild_desc"] = "Detects invite requests in guild and officer channels.",

  ["detect_group_name"] = "Party and Raid",
  ["detect_group_desc"] = "Detects invite requests in party, raid, raid leader, and raid warning messages.",

  ["detect_say_yell_name"] = "Say and Yell",
  ["detect_say_yell_desc"] = "Detects invite requests in nearby messages, such as Say and Yell.",

  ["detect_channel_name"] = "Public Channels",
  ["detect_channel_desc"] = "Detects invite requests in custom or public channels, such as General, Trade, LocalDefense, and similar channels.",

  -- Safety
  ["safety_tab_name"] = "Safety",
  ["safety_tab_desc"] = "Defines checks to avoid unwanted or repeated invites.",
  ["safety_help"] = "Use these options to prevent accidental invites, avoid repeated invites to the same player, and block specific names.",

  ["block_combat_name"] = "Do Not Invite During Combat",
  ["block_combat_desc"] = "Prevents Prat from sending invites while you are in combat.",

  ["invite_cooldown_name"] = "Invite Cooldown",
  ["invite_cooldown_desc"] = "Minimum time, in seconds, before the same player can receive another invite through this module. Use 0 to disable this check.",

  ["blacklist_help"] = "Enter names that should never receive links or invites from this module. Separate names by line, comma, semicolon, or space.\n\nExample:\nPlayerone\nPlayertwo-Realm",

  ["blacklist_name"] = "Blacklist",
  ["blacklist_desc"] = "Players in this list will be ignored by the invite module.",
}


-- ============================================================================
-- REF: modules/Keybindings.lua
-- EN: Module strings for KeyBindings (enUS)
-- ============================================================================
enUS.KeyBindings = {
  -- General
  ["module_name"] = "Keybindings",
  ["module_desc"] = "Adds Prat keyboard shortcuts to WoW's keybindings panel. Configure keys in Options > Keybindings > AddOns > Prat.",

  -- Header
  ["binding_header_name"] = "Prat",

  -- Chat channels
  ["officer_channel_name"] = "Officer Channel",
  ["guild_channel_name"] = "Guild Channel",
  ["party_channel_name"] = "Party Channel",
  ["raid_channel_name"] = "Raid Channel",
  ["raid_warning_channel_name"] = "Raid Warning Channel",
  ["instance_channel_name"] = "Instance Channel",
  ["say_name"] = "Say",
  ["yell_name"] = "Yell",
  ["whisper_name"] = "Whisper",
  ["channel_name_format"] = "Channel %d",
  ["smart_group_channel_name"] = "Smart Group Channel",

  -- Utility bindings
  ["next_chat_tab_name"] = "Next Chat Tab",
  ["copy_selected_chat_frame_name"] = "Copy Selected Chat Window",
  ["tell_target_name"] = "Tell Target",
  ["scroll_to_bottom_name"] = "Scroll to Bottom",
  ["scroll_to_top_name"] = "Scroll to Top",
}


-- ============================================================================
-- REF: modules/LinkInfoIcons.lua
-- EN: Module strings for LinkInfoIcons (enUS)
-- ============================================================================
enUS.LinkInfoIcons = {
  -- General
  ["module_name"] = "Link Information",
  ["module_desc"] = "Adds icons and extra information to links shown in chat.",
  ["full_description"] = "This module adds icons and extra information to links shown in chat.\n\nIt can enrich item, spell, achievement, and player links with visual icons, item details, class information, and race information when available.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of link information options.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Item Links|r can show icon, type, equipment slot, and item level.\n|cFFFFD100Spell Links|r can show spell icons.\n|cFFFFD100Achievement Links|r can show achievement icons.\n|cFFFFD100Player Links|r can show class icon, class name, and race name.",

  -- Items
  ["item_group_name"] = "Item Links",
  ["item_group_desc"] = "Controls extra information shown on item links.",
  ["item_help"] = "Choose which details should be added to item links shown in chat.",

  ["icon_name"] = "Icon",
  ["item_icon_desc"] = "Shows the item icon before the link.",

  ["item_type_name"] = "Item Type",
  ["item_type_desc"] = "Shows the item type, subtype, or equipment slot inside the link when available.",

  ["item_level_name"] = "Item Level",
  ["item_level_desc"] = "Shows the item level inside the link when available.",

  -- Spells
  ["spell_group_name"] = "Spell Links",
  ["spell_group_desc"] = "Controls extra information shown on spell links.",
  ["spell_help"] = "Choose whether spell links should show spell icons.",

  ["spell_icon_desc"] = "Shows the spell icon before the link.",

  -- Achievements
  ["achievement_group_name"] = "Achievement Links",
  ["achievement_group_desc"] = "Controls extra information shown on achievement links.",
  ["achievement_help"] = "Choose whether achievement links should show achievement icons.",

  ["achievement_icon_desc"] = "Shows the achievement icon before the link.",

  -- Players
  ["player_group_name"] = "Player Links",
  ["player_group_desc"] = "Controls extra information shown on player names.",
  ["player_help"] = "Choose which character details should be shown before player names when that information is available.",

  ["class_icon_name"] = "Class Icon",
  ["class_icon_desc"] = "Shows the class icon before the player's name.",

  ["class_label_name"] = "Class Name",
  ["class_label_desc"] = "Shows the class name before the player's name.",

  ["race_label_name"] = "Race Name",
  ["race_label_desc"] = "Shows the race name before the player's name.",
}


-- ============================================================================
-- REF: modules/Memory.lua
-- EN: Module strings for Memory (enUS)
-- ============================================================================
enUS.Memory = {
  -- General
  ["module_name"] = "Memory",
  ["module_desc"] = "Saves and restores Blizzard chat window settings.",

  -- Warning
  ["warning_group_name"] = "Experimental Module",
  ["warning_group_desc"] = "Important notice about how this module works.",
  ["warning_text"] = "|cffff6666THIS MODULE IS EXPERIMENTAL.|r\n\nIt attempts to save and restore Blizzard chat settings. In modern versions of the game, some restoration steps may cause limitations, visual issues, or taint problems, especially in features related to Edit Mode.",

  -- Actions
  ["actions_group_name"] = "Commands",
  ["actions_group_desc"] = "Save or load chat settings manually.",
  ["save_name"] = "Save Settings",
  ["save_desc"] = "Saves the current chat window layout, channels, colors, and related options.",
  ["load_name"] = "Load Settings",
  ["load_desc"] = "Restores previously saved chat settings.",

  -- Options
  ["options_group_name"] = "Options",
  ["options_group_desc"] = "Controls automatic loading of saved settings.",
  ["auto_load_name"] = "Load Automatically",
  ["auto_load_desc"] = "Attempts to automatically load saved settings when entering the world.",
  ["auto_load_help"] = "Use with care. Automatic loading can be useful for new characters or different profiles, but it may also overwrite manual adjustments made later.",

  -- Scope
  ["scope_group_name"] = "What This Module Saves",
  ["scope_group_desc"] = "Lists the main data stored by the module.",
  ["scope_text"] = "This module can save window names and positions, font size, colors, transparency, channels, message groups, and some chat-related CVars.\n\nOn Retail, part of the visual window restoration may be limited to avoid Edit Mode issues.",

  -- Messages
  ["msg_settings_saved"] = "Chat settings saved.",
  ["msg_settings_loaded"] = "Chat settings loaded.",
  ["msg_no_settings"] = "No chat settings have been saved yet.",
  ["msg_load_failed"] = "Could not load the chat settings.",
}


-- ============================================================================
-- REF: modules/Mentions.lua
-- EN: Module strings for Mentions (enUS)
-- ============================================================================
enUS.Mentions = {
  -- General
  ["module_name"] = "Mentions",
  ["module_desc"] = "Allows mentioning players with @name and provides TAB autocomplete.",

  -- Description
  ["full_description"] = "This module adds experimental support for player mentions in chat. When you use @name in an outgoing message, Prat identifies the mentioned player and sends a private notification to them.",

  -- How It Works
  ["how_it_works_header"] = "How It Works",
  ["how_it_works"] = "Type @name in a message sent through chat. When the message is processed, Prat sends an automatic whisper to the mentioned player, including the original message and where it came from.",

  -- Features
  ["features_header"] = "Features",
  ["features"] = "|cFFFFD100•|r Supports mentions in the @name format.\n|cFFFFD100•|r TAB autocomplete support.\n|cFFFFD100•|r Integration with known player names.\n|cFFFFD100•|r Realm name integration when available.",

  -- Example
  ["example_header"] = "Example",
  ["example"] = "Sent message:\n|cFFFFD100@Danny look at this|r\n\nThe player Danny will receive an automatic whisper containing the message and its origin.",

  -- Warning
  ["warning"] = "|cFFFF8000Important:|r\nThis feature is experimental. It may not work during combat on Retail and depends on the information available from the player name and realm name modules.",

  -- Runtime Text
  ["mention_whisper_prefix"] = "(in %s) ",
  ["too_many_matches"] = "%d matches found. Keep typing to refine.",
}


-- ============================================================================
-- REF: modules/NewcomersChat.lua
-- EN: Module strings for NewcomersChat (enUS)
-- ============================================================================
enUS.NewcomersChat = {
  -- General
  ["module_name"] = "Newcomers Chat",
  ["module_desc"] = "Controls icons and labels shown for Guides and Newcomers in Retail's mentorship system.",
  ["full_description"] = "This module controls visual markers used by World of Warcraft's Retail mentorship system.\n\nIt can show Newcomer icons, Guide icons, and Guide labels differently depending on whether you are participating as a Newcomer or as a Guide.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of Newcomers Chat marker behavior.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100As Newcomer|r controls what you see when you are considered a Newcomer.\n|cFFFFD100As Guide|r controls what you see when you are a Guide.\n\nEach marker can be shown inside the Newcomers channel, outside it, or both.",

  -- As Newcomer
  ["as_newcomer_tab_name"] = "As Newcomer",
  ["as_newcomer_tab_desc"] = "Set which markers you will see when participating as a newcomer.",
  ["as_newcomer_help"] = "Use this tab to choose how icons and labels appear when you are considered a Newcomer by Blizzard's mentorship system.",

  -- As Guide
  ["as_guide_tab_name"] = "As Guide",
  ["as_guide_tab_desc"] = "Set which markers you will see when participating as a guide.",
  ["as_guide_help"] = "Use this tab to choose how icons and labels appear when you are a Guide in Blizzard's mentorship system.",

  -- Marker Groups
  ["newcomer_icon_group_name"] = "Newcomer Icon",
  ["newcomer_icon_group_desc"] = "Control where the Newcomer icon is displayed.",

  ["guide_icon_group_name"] = "Guide Icon",
  ["guide_icon_group_desc"] = "Control where the Guide icon is displayed.",

  ["guide_label_group_name"] = "Guide Label",
  ["guide_label_group_desc"] = "Control where the Guide text is displayed next to the name.",

  -- Locations
  ["in_newcomers_chat_name"] = "In Newcomers Chat",
  ["in_newcomers_chat_desc"] = "Show this marker inside the Newcomers channel.",

  ["in_normal_chat_name"] = "In Normal Chat",
  ["in_normal_chat_desc"] = "Show this marker outside the Newcomers channel, in normal conversations.",

  -- Runtime
  ["guide_label_text"] = "Guide",
}


-- ============================================================================
-- REF: modules/OriginalButtons.lua
-- EN: Module strings for OriginalButtons (enUS)
-- ============================================================================
enUS.OriginalButtons = {
  -- General
  ["module_name"] = "Blizzard Interface",
  ["module_desc"] = "Controls native Blizzard buttons and elements on chat windows.",
  ["full_description"] = "This module controls native Blizzard elements on chat windows, such as navigation arrows, the chat menu, return-to-bottom button, button frame, position, and transparency.\n\nUse this module when you want to preserve or adjust the classic behavior of the game's original controls.",

  -- Windows
  ["windows_header"] = "Apply to Windows",

  ["chat_arrows_name"] = "Show Arrows",
  ["chat_arrows_desc"] = "Defines which windows should show the original Blizzard chat navigation arrows.",

  -- Elements
  ["elements_header"] = "Visible Elements",

  ["chat_menu_name"] = "Show Chat Menu",
  ["chat_menu_desc"] = "Shows or hides the original Blizzard chat menu button.",

  ["reminder_name"] = "Show Return Button",
  ["reminder_desc"] = "Shows a button to return to the bottom of the window when you are reading older messages.",

  ["button_frame_name"] = "Show Button Frame",
  ["button_frame_desc"] = "Shows or hides the original frame that groups chat window navigation buttons.",

  -- Appearance
  ["appearance_header"] = "Appearance",

  ["position_name"] = "Button Position",
  ["position_desc"] = "Defines where the original chat window buttons are positioned.",

  ["position_default"] = "Default",
  ["position_right_inside"] = "Right, Inside Window",
  ["position_right_outside"] = "Right, Outside Window",

  ["alpha_name"] = "Transparency",
  ["alpha_desc"] = "Sets the transparency of the original chat buttons.",

  -- Warning
  ["conflict_warning"] = "|cFFFF8000Important:|r\nThis module controls Blizzard's original buttons and may conflict with the Chat Controls module. When this module is enabled, Prat automatically disables the modern controls module to avoid conflicts.",
}


-- ============================================================================
-- REF: modules/Paragraph.lua
-- EN: Module strings for Paragraph (enUS)
-- ============================================================================
enUS.Paragraph = {
  -- General
  ["module_name"] = "Text Alignment",
  ["module_desc"] = "Allows adjusting text alignment and line spacing in chat windows.",
  ["full_description"] = "This module controls horizontal text alignment and line spacing in chat windows.\n\nEach window can use its own alignment, while line spacing is applied globally to all chat windows.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of paragraph behavior.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Alignment|r controls whether each chat window uses left, centered, or right-aligned text.\n|cFFFFD100Spacing|r controls the vertical space between chat lines.",

  -- Alignment
  ["alignment_tab_name"] = "Alignment",
  ["alignment_tab_desc"] = "Controls horizontal alignment per chat window.",
  ["alignment_help"] = "Choose the horizontal text alignment for each chat window. Left alignment is the safest option for clickable links.",
  ["alignment_group_name"] = "Window Alignment",
  ["alignment_group_desc"] = "Sets horizontal text alignment for each chat window.",
  ["alignment_option_desc"] = "Choose the text alignment for this window.",

  ["align_left"] = "Left",
  ["align_center"] = "Center",
  ["align_right"] = "Right",

  -- Spacing
  ["spacing_tab_name"] = "Line Spacing",
  ["spacing_tab_desc"] = "Controls vertical spacing between chat lines.",
  ["spacing_help"] = "Adjust the vertical space between chat messages. Higher values make messages more separated.",
  ["spacing_name"] = "Line Spacing",
  ["spacing_desc"] = "Sets line spacing for all chat windows.",

  -- Warning
  ["alignment_warning"] = "|cFFFF8000IMPORTANT:|r\nPlayer links, item links, and other hyperlinks may stop working when alignment is set to Center or Right.",
}


-- ============================================================================
-- REF: modules/PlayerNames.lua
-- EN: Module strings for PlayerNames (enUS)
-- ============================================================================
enUS.PlayerNames = {
  -- General
  ["module_name"] = "Player Names",
  ["module_desc"] = "Controls appearance, extra information, Battle.net, autocomplete, and cached player name data.",

  -- Appearance
  ["appearance_tab_name"] = "Appearance",
  ["appearance_tab_desc"] = "Controls brackets, colors, and player name coloring modes.",

  ["bracket_group_name"] = "Brackets",
  ["bracket_group_desc"] = "Set the style and color of brackets around player names.",
  ["brackets_name"] = "Bracket Style",
  ["brackets_desc"] = "Choose the bracket style used around player names.",
  ["brackets_square"] = "Square",
  ["brackets_angled"] = "Angled",
  ["brackets_none"] = "None",
  ["brackets_common_color_name"] = "Common Bracket Color",
  ["brackets_common_color_desc"] = "Use a fixed color for all player name brackets.",
  ["brackets_color_name"] = "Bracket Color",
  ["brackets_color_desc"] = "Set the common color used for brackets.",

  ["color_group_name"] = "Name Colors",
  ["color_group_desc"] = "Controls how player names and levels are colored.",
  ["color_mode_name"] = "Player Color",
  ["color_mode_desc"] = "Set how player names are colored.",
  ["level_color_name"] = "Level Color",
  ["level_color_desc"] = "Set how player levels are colored.",
  ["color_random"] = "Random",
  ["color_class"] = "Class",
  ["color_none"] = "None",
  ["level_color_player"] = "Use Player Color",
  ["level_color_channel"] = "Use Channel Color",
  ["level_color_difficulty"] = "Color by Level Difference",
  ["level_color_none"] = "No Additional Coloring",
  ["use_common_color_name"] = "Common Color for Unknowns",
  ["use_common_color_desc"] = "Use a fixed color for players whose class is not known yet.",
  ["unknown_color_name"] = "Unknown Player Color",
  ["unknown_color_desc"] = "Set the color used for unknown players.",
  ["color_everywhere_name"] = "Color Names Globally",
  ["color_everywhere_desc"] = "Apply player name coloring everywhere processed by Prat.",

  -- Information
  ["information_tab_name"] = "Information",
  ["information_tab_desc"] = "Controls extra information shown with player names.",
  ["extra_info_group_name"] = "Displayed Information",
  ["extra_info_group_desc"] = "Choose which additional information appears with player names.",
  ["level_name"] = "Show Level",
  ["level_desc"] = "Show the known player level next to the name.",
  ["subgroup_name"] = "Show Raid Subgroup",
  ["subgroup_desc"] = "Show the player's raid subgroup number next to the name, when available.",
  ["show_target_icon_name"] = "Show Target Icon",
  ["show_target_icon_desc"] = "Show the raid target icon currently assigned to the player.",
  ["bnet_client_icon_name"] = "Show Battle.net Client Icon",
  ["bnet_client_icon_desc"] = "Show the game or Battle.net client icon associated with the contact.",

  -- Battle.net
  ["battle_net_tab_name"] = "Battle.net",
  ["battle_net_tab_desc"] = "Controls Battle.net contact display and coloring.",
  ["battle_net_group_name"] = "Battle.net Contacts",
  ["battle_net_group_desc"] = "Sets how Battle.net names are displayed and colored.",
  ["real_id_color_name"] = "Battle.net Color",
  ["real_id_color_desc"] = "Sets how Battle.net names are colored.",
  ["real_id_name_name"] = "Show Character Name",
  ["real_id_name_desc"] = "Shows the character currently played by the contact instead of the Battle.net name, when available.",

  -- Autocomplete
  ["autocomplete_tab_name"] = "Autocomplete",
  ["autocomplete_tab_desc"] = "Controls automatic completion of known player names.",
  ["autocomplete_group_name"] = "Automatic Completion",
  ["autocomplete_group_desc"] = "Allows known names to be completed automatically by pressing TAB in chat.",
  ["tab_complete_name"] = "Enable TAB Completion",
  ["tab_complete_desc"] = "Automatically completes known names when TAB is pressed. Uses names already seen, friends, group, guild, and data stored by the module.",
  ["tab_complete_limit_name"] = "Suggestion Limit",
  ["tab_complete_limit_desc"] = "Sets how many suggestions can appear before Prat shows an overflow warning for too many matches.",

  -- Cache
  ["cache_tab_name"] = "Cache",
  ["cache_tab_desc"] = "Controls storage and lookup of player information.",
  ["cache_group_name"] = "Data Storage",
  ["cache_group_desc"] = "Controls how Prat remembers class, level, group, and other data for players seen in chat.",
  ["keep_name"] = "Save Friend and Guild Data",
  ["keep_desc"] = "Keeps known friend and guild member data between sessions, such as class and level.",
  ["keep_lots_name"] = "Save Data for All Players",
  ["keep_lots_desc"] = "Keeps data between sessions for all players encountered, except cross-realm characters.",
  ["use_who_name"] = "Query Unknown Players",
  ["use_who_desc"] = "Queries the server to discover class and level for unknown players. This is slow and queried data is not saved.",
  ["reset_name"] = "Clear Stored Data",
  ["reset_desc"] = "Deletes stored player data, such as known classes and levels.",

  -- Messages
  ["msg_stored_data_cleared"] = "Stored player data has been cleared.",
  ["too_many_matches"] = "Too many matches (%d possible)",
}


-- ============================================================================
-- REF: modules/PopupMessage.lua
-- EN: Module strings for PopupMessage (enUS)
-- ============================================================================
enUS.PopupMessage = {
  -- General
  ["module_name"] = "Alerts",
  ["module_desc"] = "Detects when your name or monitored names appear in messages and creates visual or sound alerts.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Explains what this module monitors and when it creates alerts.",
  ["full_description"] = "This module monitors chat messages looking for your character name and any monitored names you add.\n\nWhen a match is found, Prat can create a visual alert, play a sound, and send the message to one of the outputs configured below. Use monitored names for nicknames, name variations, or other important terms.",

  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Output|r controls where alerts are sent.\n|cFFFFD100Monitored Windows|r controls which chat windows are scanned.\n|cFFFFD100Monitored Names|r lets you add nicknames, alternate spellings, or important terms.\n|cFFFFD100Appearance|r controls the opacity of the popup window.",

  -- Output
  ["output_tab_name"] = "Alert Destination",
  ["output_tab_desc"] = "Choose where alerts should be sent.",
  ["output_help"] = "Configure the output used when a monitored message is found. The Popup option uses this module's own visual popup window.",

  ["sink_group_name"] = "Alert Output",
  ["sink_group_desc"] = "Defines where alerts are displayed.",
  ["popup_sink_name"] = "Popup",
  ["popup_sink_desc"] = "Shows messages in a popup window.",
  ["sink_subsection_name"] = "Subsection",
  ["sink_subsection_desc"] = "Choose the specific channel, window, or destination used by the selected output.",

  -- Monitored Windows
  ["windows_tab_name"] = "Monitored Windows",
  ["windows_tab_desc"] = "Choose which chat windows should be monitored.",
  ["windows_help"] = "Select the chat windows where the module should look for your name and monitored names.",

  ["show_all_name"] = "Monitor All Windows",
  ["show_all_desc"] = "Creates alerts for matching messages from any chat window.",

  ["show_name"] = "Monitor Selected Windows",
  ["show_desc"] = "Creates alerts only for messages coming from the selected windows.",

  -- Monitored Names
  ["names_tab_name"] = "Monitored Names",
  ["names_tab_desc"] = "Add nicknames, name variations, or other important terms.",
  ["names_help"] = "Your character name is monitored automatically. Use this list to add nicknames, alternate spellings, or other names that should also create alerts.",

  ["names_group_name"] = "Name List",
  ["names_group_desc"] = "Manage extra names that also trigger alerts.",

  ["add_name"] = "Add Name",
  ["add_desc"] = "Adds a name, nickname, or important term to the monitored list.",
  ["add_usage"] = "<name or term>",

  ["remove_name"] = "Remove Name",
  ["remove_desc"] = "Removes a name from the monitored list.",

  ["clear_name"] = "Clear List",
  ["clear_desc"] = "Removes all manually added monitored names.",

  -- Appearance
  ["appearance_tab_name"] = "Appearance",
  ["appearance_tab_desc"] = "Controls the visual popup window.",
  ["appearance_help"] = "Adjust the opacity used when the popup is fully visible. The popup will still fade in and fade out automatically.",

  ["frame_alpha_name"] = "Popup Opacity",
  ["frame_alpha_desc"] = "Sets the opacity of the popup window when fully visible.",
}


-- ============================================================================
-- REF: modules/Scroll.lua
-- EN: Module strings for Scroll (enUS)
-- ============================================================================
enUS.Scroll = {
  -- General
  ["module_name"] = "Scrolling",
  ["module_desc"] = "Controls chat window scrolling with mouse wheel, shortcuts, and automatic return to bottom.",
  ["full_description"] = "This module controls how chat windows respond to scrolling.\n\nYou can enable mouse wheel scrolling per window, adjust speeds, use modifier-key shortcuts, and configure automatic return to the bottom of the conversation.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of scrolling options.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Mouse Wheel|r controls which windows accept mouse wheel scrolling and how fast they scroll.\n|cFFFFD100Automatic Return|r brings the window back to the bottom after a configured delay.\n|cFFFFD100Advanced|r keeps legacy or disabled options affected by game limitations.",

  -- Mouse Wheel
  ["mousewheel_tab_name"] = "Mouse Wheel",
  ["mousewheel_tab_desc"] = "Controls mouse wheel use in chat windows.",
  ["mousewheel_help"] = "Choose which windows use the mouse wheel.\n\nUse normal scrolling to move up or down. Hold Shift to scroll faster. Hold Ctrl to jump directly to the top or bottom.",

  ["mousewheel_name"] = "Enable in These Windows",
  ["mousewheel_desc"] = "Defines which chat windows respond to the mouse wheel.",

  ["normal_scroll_speed_name"] = "Scroll Speed",
  ["normal_scroll_speed_desc"] = "Sets how many lines scroll with each normal mouse wheel movement.",

  ["shift_scroll_speed_name"] = "Shift Scroll Speed",
  ["shift_scroll_speed_desc"] = "Sets how many lines scroll when using Shift + mouse wheel.",

  -- Automatic Return
  ["low_down_tab_name"] = "Automatic Return",
  ["low_down_tab_desc"] = "Controls automatic return to the bottom of the conversation.",
  ["low_down_help"] = "When you scroll up through message history, this feature can bring the window back to the bottom automatically after a few seconds.\n\nIt helps avoid leaving a window stuck in the middle of history while new messages arrive.",

  ["low_down_name"] = "Enable in These Windows",
  ["low_down_desc"] = "Defines which windows use automatic return to bottom.",

  ["low_down_delay_name"] = "Return Delay",
  ["low_down_delay_desc"] = "Sets how many seconds the module waits before returning the window to the bottom.",

  -- Advanced
  ["advanced_tab_name"] = "Advanced",
  ["advanced_tab_desc"] = "Legacy options and special behaviors.",
  ["advanced_help"] = "This tab groups old or compatibility options. Some options may remain hidden because of Blizzard limitations or old game bugs.",

  ["scroll_direction_name"] = "Insertion Direction",
  ["scroll_direction_desc"] = "Sets text insertion direction. This option is hidden because of an old Blizzard limitation.",
  ["scroll_direction_top"] = "Top",
  ["scroll_direction_bottom"] = "Bottom",
}


-- ============================================================================
-- REF: modules/Search.lua
-- EN: Module strings for Search (enUS)
-- ============================================================================
enUS.Search = {
  -- General
  ["module_name"] = "History Search",
  ["module_desc"] = "Adds search boxes to chat windows and allows old messages to be found with the /find command.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Explains how chat history search works.",
  ["full_description"] = "This module adds a search box to each chat window and allows you to search messages already shown in history.\n\nYou can also use the /find command to search the selected chat window.",

  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "Use the search box on a chat window or type:\n\n/find <text>\n\nExample:\n/find invite",

  -- Appearance
  ["appearance_tab_name"] = "Appearance",
  ["appearance_tab_desc"] = "Controls search box opacity while active or idle.",
  ["appearance_help"] = "Adjust how visible the search box is when focused or inactive. Lower idle opacity keeps the chat cleaner while the search box is not being used.",

  ["search_inactive_alpha_name"] = "Idle Opacity",
  ["search_inactive_alpha_desc"] = "Set the opacity of the search box when it is not focused.",

  ["search_active_alpha_name"] = "Active Opacity",
  ["search_active_alpha_desc"] = "Set the opacity of the search box when it is active or focused.",

  -- Runtime Messages
  ["find_results"] = "Search results",
  ["err_too_short"] = "Enter at least two characters to search.",
  ["err_not_found"] = "No messages found.",
  ["result_summary_single"] = "Found %d result for: \"%s\"",
  ["result_summary_plural"] = "Found %d results for: \"%s\"",
  ["end_search_marker"] = "\n------------------- END OF SEARCH -------------------",
  ["bnet_removed"] = "<BNET REMOVED>",
}


-- ============================================================================
-- REF: modules/ServerNames.lua
-- EN: Module strings for ServerNames (enUS)
-- ============================================================================
enUS.ServerNames = {
  -- General
  ["module_name"] = "Realm Names",
  ["module_desc"] = "Controls how realm names appear in chat.",

  -- Behavior
  ["behavior_tab_name"] = "Display",
  ["behavior_tab_desc"] = "Controls the general behavior of realm names in chat.",
  ["behavior_group_name"] = "Realm Behavior",
  ["behavior_group_desc"] = "Set whether realm names are hidden, abbreviated, or colored.",
  ["behavior_help"] = "These options affect all realm names shown in chat. Per-realm settings become available as Prat detects players from other realms.",

  ["hide_name"] = "Hide Realm",
  ["hide_desc"] = "Remove the realm name from messages shown in chat.",
  ["auto_abbreviate_name"] = "Abbreviate Automatically",
  ["auto_abbreviate_desc"] = "Show only a short abbreviation of the realm name.",
  ["random_color_name"] = "Use Random Colors",
  ["random_color_desc"] = "Apply a different random color to each detected realm.",

  -- Detected Realms
  ["detected_servers_tab_name"] = "Detected Realms",
  ["detected_servers_tab_desc"] = "Adjust abbreviations and colors for realms found in chat.",
  ["server_settings_desc"] = "Configure how the realm %s will be displayed.",
  ["server_selected_help"] = "Adjust below how the realm %s will appear in chat.",

  ["replace_name"] = "Use Custom Name",
  ["replace_desc"] = "Replace the original realm name with custom text.",
  ["short_name_name"] = "Displayed Name",
  ["short_name_desc"] = "Set the text that will replace the original realm name.",
  ["custom_color_name"] = "Use Custom Color",
  ["custom_color_desc"] = "Use a fixed color for this specific realm.",
  ["color_name"] = "Realm Color",
  ["color_desc"] = "Set the custom color used for this realm.",
}


-- ============================================================================
-- REF: modules/SideTabs.lua
-- EN: Module strings for SideTabs (enUS)
-- ============================================================================
enUS.SideTabs = {
  -- General
  ["module_name"] = "Side Tabs",
  ["module_desc"] = "Moves chat window tabs to the side and stacks them vertically.",

  -- Position
  ["position_tab_name"] = "Position",
  ["position_tab_desc"] = "Defines where side tabs sit relative to the chat window.",
  ["position_help"] = "Use this section to choose the tab side and fine-tune how they attach to the chat window.",

  ["layout_group_name"] = "Positioning",
  ["layout_group_desc"] = "Controls the side and general positioning of side tabs.",

  ["side_name"] = "Side",
  ["side_desc"] = "Choose which side of the chat window the tabs should be anchored to.",
  ["side_left"] = "Left",
  ["side_right"] = "Right",

  ["x_offset_name"] = "X Offset",
  ["x_offset_desc"] = "Move the tabs horizontally from the reference edge.",
  ["y_offset_name"] = "Y Offset",
  ["y_offset_desc"] = "Move the first tab vertically from the top of the window.",
  ["spacing_name"] = "Spacing",
  ["spacing_desc"] = "Set the space between vertically stacked tabs.",

  -- Size
  ["size_tab_name"] = "Size",
  ["size_tab_desc"] = "Controls side tab width, height, and scale.",
  ["size_help"] = "Use this section to adjust the visual size of tabs. Width grows to the right to make adjustment more predictable.",

  ["sizing_group_name"] = "Measurements",
  ["sizing_group_desc"] = "Controls side tab width, height, and scale.",

  ["tab_width_name"] = "Tab Width",
  ["tab_width_desc"] = "Set the fixed tab width. Width grows to the right to make adjustment more intuitive.",
  ["tab_height_name"] = "Tab Height",
  ["tab_height_desc"] = "Set tab height in the vertical stack.",
  ["tab_scale_name"] = "Tab Scale",
  ["tab_scale_desc"] = "Adjust the visual scale of tabs without directly changing width and height.",
  ["normalize_ui_scale_name"] = "Normalize for UI Scale",
  ["normalize_ui_scale_desc"] = "Compensate size and offsets using WoW's native UI scale.",

  -- Text
  ["text_tab_name"] = "Text",
  ["text_tab_desc"] = "Controls the appearance of text shown on tabs.",
  ["text_help"] = "Use this section to adjust tab font, size, and text color.",

  ["text_group_name"] = "Text Appearance",
  ["text_group_desc"] = "Controls tab text font, size, and color.",

  ["font_face_name"] = "Font",
  ["font_face_desc"] = "Choose the font used by tab text.",
  ["font_size_name"] = "Font Size",
  ["font_size_desc"] = "Set the font size used by tabs.",
  ["font_color_name"] = "Font Color",
  ["font_color_desc"] = "Set the tab text color.",

  -- Visual
  ["visual_tab_name"] = "Visual",
  ["visual_tab_desc"] = "Controls general appearance and undocked window behavior.",
  ["visual_help"] = "Use this section to decide whether undocked windows are affected and whether tabs use a cleaner visual style.",

  ["behavior_group_name"] = "Application and Appearance",
  ["behavior_group_desc"] = "Controls undocked window behavior and simplified appearance.",

  ["undocked_name"] = "Apply to undocked windows",
  ["undocked_desc"] = "Also move tabs for chat windows that are not docked to the main chat dock.",
  ["simple_skin_name"] = "Use simple skin",
  ["simple_skin_desc"] = "Hide default tab art and use a simple background for a cleaner appearance.",

  -- Labels
  ["tab_labels_tab_name"] = "Labels",
  ["tab_labels_group_desc"] = "Allows replacing tab text with symbols, shapes, or custom labels.",

  ["labels_enabled_name"] = "Enable per-tab labels",
  ["labels_enabled_desc"] = "Allows a different label to be configured for each chat tab.",
  ["tab_labels_help"] = "Configure each tab below. Default keeps the original name; Symbol, Colored Shape, and Custom Text replace the displayed label.",
  ["tab_label_frame_help"] = "Choose how this specific tab will be displayed.",

  ["label_mode_name"] = "Label Mode",
  ["label_mode_desc"] = "Set how this tab label should be displayed.",
  ["label_mode_default"] = "Default Name",
  ["label_mode_preset"] = "Symbol / Icon",
  ["label_mode_shape"] = "Colored Shape",
  ["label_mode_custom"] = "Custom Text",

  ["label_preset_name"] = "Symbol / Icon",
  ["label_preset_desc"] = "Choose a native visual marker for this tab.",

  ["preset_star"] = "Star",
  ["preset_circle"] = "Circle",
  ["preset_diamond"] = "Diamond",
  ["preset_triangle"] = "Triangle",
  ["preset_moon"] = "Moon",
  ["preset_skull"] = "Skull",

  ["label_shape_name"] = "Shape",
  ["label_shape_desc"] = "Choose a simple shape to represent this tab.",
  ["shape_square"] = "Square",
  ["shape_circle"] = "Circle",

  ["label_color_name"] = "Shape Color",
  ["label_color_desc"] = "Set the color of the shape shown on this tab.",

  ["custom_label_name"] = "Custom Text",
  ["custom_label_desc"] = "Set custom text, symbol, or emoji for this tab.",
}


-- ============================================================================
-- REF: modules/Sounds.lua
-- EN: Module strings for Sounds (enUS)
-- ============================================================================
enUS.Sounds = {
  -- General
  ["module_name"] = "Sounds",
  ["module_desc"] = "Allows playing different sounds for specific chat message types.",
  ["full_description"] = "This module plays sounds when selected chat message types are received or sent.\n\nYou can configure separate sounds for incoming messages, outgoing messages, group leaders, whispers, Battle.net whispers, and detected custom channels.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of sound behavior.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100Incoming Sounds|r controls sounds for messages received from other players.\n|cFFFFD100Outgoing Sounds|r controls sounds for messages sent by you.\n|cFFFFD100Custom Channels|r lets detected channels use their own sound.\n\nSelecting a sound plays it immediately as a preview. Use \"None\" to disable a sound.",

  -- Incoming Sounds
  ["incoming_tab_name"] = "Incoming Sounds",
  ["incoming_tab_desc"] = "Sets sounds for messages received from other players.",
  ["incoming_help"] = "Choose which sound should play when each incoming message type is detected.",

  -- Outgoing Sounds
  ["outgoing_tab_name"] = "Outgoing Sounds",
  ["outgoing_tab_desc"] = "Sets sounds for messages sent by you.",
  ["outgoing_help"] = "Choose which sound should play when each outgoing message type is detected.",

  -- Custom Channels
  ["custom_channels_tab_name"] = "Custom Channels",
  ["custom_channels_tab_desc"] = "Sets sounds for custom channels detected by Prat.",
  ["custom_channels_help"] = "Detected custom channels appear below. You can assign a sound to each channel name.",
  ["custom_channels_group_name"] = "Detected Channels",
  ["custom_channels_group_desc"] = "Sound selection for detected custom channels.",
  ["custom_channel_desc"] = "Sound used for messages from custom channel: %s.",

  -- Direction Labels
  ["incoming"] = "incoming",
  ["outgoing"] = "outgoing",

  -- Message Types
  ["party_name"] = "Party",
  ["party_desc"] = "Sound used for %s party messages.",
  ["raid_name"] = "Raid",
  ["raid_desc"] = "Sound used for %s raid messages.",
  ["guild_name"] = "Guild",
  ["guild_desc"] = "Sound used for %s guild messages.",
  ["officer_name"] = "Officer",
  ["officer_desc"] = "Sound used for %s officer messages.",
  ["whisper_name"] = "Whisper",
  ["whisper_desc"] = "Sound used for %s whisper messages.",
  ["bn_whisper_name"] = "Battle.net Whisper",
  ["bn_whisper_desc"] = "Sound used for %s Battle.net whisper messages.",
  ["group_lead_name"] = "Group Leader",
  ["group_lead_desc"] = "Sound used for %s messages from leaders, guides, or raid warnings.",
}


-- ============================================================================
-- REF: modules/Substitutions.lua
-- EN: Module strings for Substitutions (enUS)
-- ============================================================================
enUS.Substitutions = {
  -- General
  ["Substitutions"] = true,
  ["A module to provide basic chat substitutions."] = true,
  ["User defined substitutions"] = true,
  ["Options for setting and removing user defined substitutions. (NB: users may define custom values for existing substitutions, but they will revert to the default value if the user definition is deleted.)"] = true,
  ["Set substitution"] = true,
  ["Set the value of a user defined substitution (NB: this may be the same as an existing default substitution; to reset it to the default, just remove the user created definition)."] = true,
  ["subname = text after expansion -- NOTE: sub name without the prefix \"%\""] = true,
  ["List substitutions"] = true,
  ["Lists all current subtitutions in the default chat frame"] = true,
  ["Delete substitution"] = true,
  ["Deletes a user defined substitution"] = true,
  ["subname -- NOTE: sub name without the prefix '%'"] = true,
  ["Are you sure?"] = true,
  ["Delete all"] = true,
  ["Deletes all user defined substitutions"] = true,
  ["Are you sure - this will delete all user defined substitutions and reset defaults?"] = true,
  ["List of available substitutions"] = true,
  ["List of available substitutions defined by this module. (NB: users may define custom values for existing substitutions, but they will revert to the default value if the user definition is deleted.)"] = true,
  ["NO MATCHFUNC FOUND"] = true,
  ["current-prompt"] = "Token: '%s'\n\nClick to copy. Paste into chat (Ctrl+V).\nType the token manually to substitute.",
  ["no substitution name given"] = true,
  ["no value given for subtitution \"%s\""] = true,
  ["|cffff0000warning:|r subtitution \"%s\" already defined as \"%s\", overwriting"] = true,
  ["defined %s: expands to => %s"] = true,
  ["no substitution name supplied for deletion"] = true,
  ["no user defined subs found"] = true,
  ["user defined substition \"%s\" not found"] = true,
  ["user substitutions index (usersubs_idx) doesn't exist! oh dear."] = true,
  ["can't find substitution index for a substitution named '%s'"] = true,
  ["removing user defined substitution \"%s\"; previously expanded to => \"%s\""] = true,
  ["substitution: %s defined as => %s"] = true,
  ["%d total user defined substitutions"] = true,
  ["module:buildUserSubsIndex(): warning: module patterns not defined!"] = true,
  ["<notarget>"] = true,
  ["male"] = true,
  ["female"] = true,
  ["unknown sex"] = true,
  ["<noguild>"] = true,
  ["his"] = true,
  ["hers"] = true,
  ["its"] = true,
  ["him"] = true,
  ["her"] = true,
  ["it"] = true,
  ["usersub_"] = true,
  ["TargetHealthDeficit"] = true,
  ["TargetPercentHP"] = true,
  ["TargetPronoun"] = true,
  ["PlayerHP"] = true,
  ["PlayerName"] = true,
  ["PlayerMaxHP"] = true,
  ["PlayerHealthDeficit"] = true,
  ["PlayerPercentHP"] = true,
  ["PlayerCurrentMana"] = true,
  ["PlayerMaxMana"] = true,
  ["PlayerPercentMana"] = true,
  ["PlayerManaDeficit"] = true,
  ["TargetName"] = true,
  ["TargetTargetName"] = true,
  ["MouseoverTargetName"] = true,
  ["TargetClass"] = true,
  ["TargetHealth"] = true,
  ["TargetRace"] = true,
  ["TargetGender"] = true,
  ["TargetLevel"] = true,
  ["TargetPossesive"] = true,
  ["TargetManaDeficit"] = true,
  ["TargetGuild"] = true,
  ["TargetIcon"] = true,
  ["MapZone"] = true,
  ["MapLoc"] = true,
  ["MapPos"] = true,
  ["MapYPos"] = true,
  ["MapXPos"] = true,
  ["RandNum"] = true,
  ["PlayerAverageItemLevel"] = true,
  ["%tn = current target"] = true,
  ["%pn = player name"] = true,
  ["%hc = your current health"] = true,
  ["%hm = your max health"] = true,
  ["%hp = your percentage health"] = true,
  ["%hd = your current health deficit"] = true,
  ["%mc = your current mana"] = true,
  ["%mm = your max mana"] = true,
  ["%mp = your percentage mana"] = true,
  ["%md = your current mana deficit"] = true,
  ["%thp = target's percentage health"] = true,
  ["%th = target's current health"] = true,
  ["%td = target's health deficit"] = true,
  ["%tc = class of target"] = true,
  ["%tr = race of target"] = true,
  ["%ts = sex of target"] = true,
  ["%tl = level of target"] = true,
  ["%ti = raid icon of target"] = true,
  ["%tps = possesive for target (his/hers/its)"] = true,
  ["%tpn = pronoun for target (him/her/it)"] = true,
  ["%tg = target's guild"] = true,
  ["%mn = mouseover target name"] = true,
  ["%zon = your current zone"] = true,
  ["%loc = your current subzone (as shown on the minimap)"] = true,
  ["%pos = your current coordinates (x,y)"] = true,
  ["%ypos = your current y coordinate"] = true,
  ["%xpos = your current x coordinate"] = true,
  ["%rnd = a random number between 1 and 100"] = true,
  ["%ail = your average item level"] = true,
}


-- ============================================================================
-- REF: modules/TellTarget.lua
-- EN: Module strings for TellTarget (enUS)
-- ============================================================================
enUS.TellTarget = {
  -- General
  ["module_name"] = "Tell Target",
  ["module_desc"] = "Adds the /tt command to quickly start a whisper with the selected player.",
  ["full_description"] = "This module adds the /tt command, allowing you to send a whisper to your current player target.\n\nIf the target is from another realm, Prat uses the full name with realm when needed.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Summary of the Tell Target command.",
  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "|cFFFFD100/tt message|r sends a whisper to your current player target.\n\nSelect a player, type /tt followed by your message, and Prat converts it into a whisper.",

  -- Commands
  ["commands_tab_name"] = "Command",
  ["commands_tab_desc"] = "Shows usage examples for Tell Target.",
  ["commands_help"] = "The command works from the chat edit box. It requires a valid player target.",

  ["examples_header"] = "Examples",
  ["example_text"] = "/tt Hello!\n/tt Can you help me?\n/tt Want to join the group?",

  -- Runtime
  ["no_target_message"] = "No player target selected for the whisper.",
  ["/tt"] = "/tt",
}


-- ============================================================================
-- REF: modules/Timestamps.lua
-- EN: Module strings for Timestamps (enUS)
-- ============================================================================
enUS.Timestamps = {
  -- General
  ["module_name"] = "Timestamps",
  ["module_desc"] = "Controls timestamp display, format, color, and position in chat windows.",

  -- Overview
  ["overview_tab_name"] = "Overview",
  ["overview_tab_desc"] = "Introduction and quick guide.",
  ["full_description"] = "Timestamps add time and optionally date information to chat messages.\n\nYou can choose where they appear, how they are formatted, whether they use local or server time, and how they are displayed.",

  ["quick_guide_header"] = "Quick Guide",
  ["quick_guide"] = "Examples:\n\n[14:35:22] Hello!\n\n<14:35> Hello!\n\n31/05/26 14:35 Hello!",

  -- Display
  ["display_tab_name"] = "Display",
  ["display_tab_desc"] = "Where timestamps are shown.",
  ["display_help"] = "Choose which windows show timestamps and decide whether they use your computer's local time or the server time.",

  ["show_name"] = "Show in the following windows",
  ["show_desc"] = "Enable or disable timestamps for each chat window.",

  ["local_time_name"] = "Use Local Time",
  ["local_time_desc"] = "Uses your computer's local time. When disabled, server time is used.",

  -- Formatting
  ["format_tab_name"] = "Formatting",
  ["format_tab_desc"] = "Configure timestamp format and layout.",
  ["format_help"] = "Configure how the timestamp is built. Prefix and suffix work as delimiters, for example: [14:35:22], <14:35>, or (14:35).",

  ["format_prefix_name"] = "Prefix",
  ["format_prefix_desc"] = "Text inserted before the timestamp, such as [, (, <, or any other character.",

  ["format_suffix_name"] = "Suffix",
  ["format_suffix_desc"] = "Text inserted after the timestamp, such as ], ), >, or any other character.",

  ["time_format_name"] = "Time Format",
  ["time_format_desc"] = "Choose the format used to display the time.",

  ["date_format_name"] = "Date Format",
  ["date_format_desc"] = "Choose whether a date is shown together with the time.",

  ["space_name"] = "Insert Space After Timestamp",
  ["space_desc"] = "Inserts a space between the timestamp and the message.",

  ["example_header"] = "Example",
  ["example_text"] = "[14:35:22] Example message",
  ["example_message"] = "Example message",

  -- Appearance
  ["appearance_tab_name"] = "Appearance",
  ["appearance_tab_desc"] = "Configure timestamp colors.",
  ["appearance_help"] = "Controls the visual appearance of timestamps. When custom color is disabled, the color picker is unavailable.",

  ["color_timestamp_name"] = "Use Custom Color",
  ["color_timestamp_desc"] = "Applies a custom color to the timestamp.",

  ["timestamp_color_name"] = "Timestamp Color",
  ["timestamp_color_desc"] = "Set the color used for the timestamp.",

  -- Time Formats
  ["time_format_12_hour_seconds_ampm"] = "HH:MM:SS AM (12-hour)",
  ["time_format_12_hour_seconds"] = "HH:MM:SS (12-hour)",
  ["time_format_24_hour_seconds"] = "HH:MM:SS (24-hour)",
  ["time_format_12_hour_minutes_ampm"] = "HH:MM AM (12-hour)",
  ["time_format_12_hour_minutes"] = "HH:MM (12-hour)",
  ["time_format_24_hour_minutes"] = "HH:MM (24-hour)",
  ["time_format_minutes_seconds"] = "MM:SS",

  -- Date Formats
  ["date_format_none"] = "None",
  ["date_format_day_month_year"] = "dd/mm/yy",
  ["date_format_month_day_year"] = "mm/dd/yy",
  ["date_format_day_month"] = "dd/mm",
  ["date_format_month_day"] = "mm/dd",
}


-- ============================================================================
-- REF: modules/UrlCopy.lua
-- EN: Module strings for UrlCopy (enUS)
-- ============================================================================
enUS.UrlCopy = {
  -- General
  ["module_name"] = "URL Copy",
  ["module_desc"] = "Makes URLs sent in chat easier to identify and copy.",

  -- Description
  ["full_description"] = "This module detects URLs, email addresses, IP addresses, and domains sent in chat, turning them into clickable links.\n\nWhen clicking a detected link, you can copy the address through a dedicated copy window or send it to the chat edit box.",

  -- Link Display
  ["display_group_name"] = "Link Display",
  ["display_group_desc"] = "Controls how detected URLs and addresses appear in chat.",
  ["display_group_help"] = "Adjust the appearance of links detected in chat messages.",
  ["bracket_name"] = "Show Brackets",
  ["bracket_desc"] = "Displays URLs inside brackets to make links easier to identify in chat.",
  ["color_url_name"] = "Color URLs",
  ["color_url_desc"] = "Applies color to detected URLs, making links more visible in chat.",
  ["color_name"] = "Set Color",
  ["color_desc"] = "Chooses the color used for URLs when link coloring is enabled.",

  -- URL Copy
  ["copy_group_name"] = "URL Copy",
  ["copy_group_desc"] = "Controls how the URL is shown when clicking a link.",
  ["copy_group_help"] = "Choose whether the clicked address opens in a dedicated copy window or is sent to the chat edit box.",
  ["popup_name"] = "Use Copy Window",
  ["popup_desc"] = "Opens a window with the selected URL, making it easier to manually copy the address.",
}
