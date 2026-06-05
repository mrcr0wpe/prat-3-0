--[[
    @File:       ptBR.lua
    @Project:    Prat-3.0


    BR: Arquivo principal de localização Português Brasil
        (ptBR) do addon Prat-3.0.

        Responsável pela consolidação modular das strings
        traduzidas utilizadas pelos módulos e serviços do
        addon, preservando compatibilidade estrutural com
        o sistema original de locale do Prat.

    EN: Main Brazilian Portuguese (ptBR) localization
        file for the Prat-3.0 addon.

        Responsible for the modular consolidation of
        translated strings used by addon modules and
        services while preserving structural compatibility
        with the original Prat locale system.

    -------------------------------------------------------
    Revisão e Tradução: MrCr0w
    Retail Version: 11.1.5
    -------------------------------------------------------
--]]

if GetLocale() ~= "ptBR" then
    return
end

Prat_Locales = Prat_Locales or {}
Prat_Locales.ptBR = Prat_Locales.ptBR or {}
local ptBR = Prat_Locales.ptBR

-- ============================================================================
-- BR: Arquivo: addon/options.lua | Idioma: Português Brasil (ptBR)
-- EN: File: addon/options.lua | Language: Brazilian Portuguese (ptBR)
-- ============================================================================


-- ============================================================================
-- BR: Arquivo: modules/Achievements.lua | Idioma: Português Brasil (ptBR)
-- EN: File: modules/Achievements.lua | Language: Brazilian Portuguese (ptBR)
-- ============================================================================


-- ============================================================================
-- BR: REF: addon/options.lua | Strings centrais da interface de opções do addon (ptBR)
-- EN: REF: addon/options.lua | Core addon options strings (enUS reference)
-- ============================================================================
ptBR.Options = {
  -- BR: Geral | EN: General
  ["Disable"] = "Desativar",
  ["Enable"] = "Ativar",
  ["prat"] = "Prat",
  ["display_name"] = "Configurações de Exibição",
  ["display_desc"] = "Opções relacionadas à aparência, organização e comportamento visual das janelas de bate-papo.",
  ["formatting_name"] = "Formatação do Chat",
  ["formatting_desc"] = "Opções que alteram como mensagens, nomes, canais e textos aparecem no bate-papo.",
  ["extras_name"] = "Extras",
  ["extras_desc"] = "Ferramentas adicionais e recursos complementares do Prat.",
  ["modulecontrol_name"] = "Controle de Módulos",
  ["modulecontrol_desc"] = "Ativa ou desativa módulos individuais do Prat.",
  ["profiles_name"] = "Perfis",
  ["profiles_desc"] = "Gerencia perfis de configuração do Prat.",
  ["reload_required"] = "Esta alteração pode não surtir efeito completo até você %s a interface.",
  ["load_no"] = "Não Carregar",
  ["load_disabled"] = "Desativado",
  ["load_enabled"] = "Ativado",
  ["load_desc"] = "Altere este valor para ativar ou desativar o carregamento deste módulo.",
  ["unloaded_desc"] = "Este módulo não está carregado no momento.",
  ["load_disabledonrestart"] = "Desativado (reload)",
  ["load_enabledonrestart"] = "Ativado (reload)",
  ["modulecontrol_intro"] = "Ative ou desative módulos do Prat por categoria. As abas indicam a função do módulo; o estado atual aparece no seletor de cada item.",
  ["modulecontrol_display_name"] = "Configurações de Exibição",
  ["modulecontrol_display_desc"] = "Módulos ligados à aparência, comportamento e organização das janelas de bate-papo.",
  ["modulecontrol_formatting_name"] = "Formatação do Chat",
  ["modulecontrol_formatting_desc"] = "Módulos que alteram como mensagens, nomes, canais e marcas de tempo aparecem no chat.",
  ["modulecontrol_extras_name"] = "Extras",
  ["modulecontrol_extras_desc"] = "Recursos adicionais, atalhos, ferramentas auxiliares e funções complementares.",
  ["modulecontrol_advanced_name"] = "Avançados",
  ["modulecontrol_advanced_desc"] = "Módulos técnicos, diagnósticos, filtros e recursos que exigem mais cuidado.",
  ["modulecontrol_legacy_name"] = "Legado / Especiais",
  ["modulecontrol_legacy_desc"] = "Módulos antigos, específicos ou pouco usados que merecem atenção antes de ativar.",
}


-- ============================================================================
-- BR: REF: modules/Achievements.lua | Strings do módulo Achievements (ptBR)
-- EN: REF: modules/Achievements.lua | Module strings for Achievements (enUS reference)
-- ============================================================================
ptBR.Achievements = {
  -- BR: Geral | EN: General
  ["module_name"] = "Conquistas",
  ["module_desc"] = "Controla como as conquistas aparecem no bate-papo e permite configurar respostas rápidas para outros jogadores.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão geral",
  ["overview_tab_desc"] = "Resumo do comportamento do módulo de conquistas.",
  ["full_description"] = "Este módulo ajusta como as conquistas aparecem no bate-papo.\n\nVocê pode ocultar conquistas da guilda, mostrar datas de conclusão e configurar uma resposta rápida para reagir quando outro jogador obtém uma conquista.",
  ["quick_guide_header"] = "Guia rápido",
  ["quick_guide"] = "|cFFFFD100Exibição|r controla quais informações aparecem nas mensagens de conquistas.\n|cFFFFD100Resposta rápida|r configura o atalho e a mensagem usada para responder às conquistas de outros jogadores.",

  -- BR: Exibição | EN: Display
  ["display_tab_name"] = "Exibição",
  ["display_tab_desc"] = "Controla quais detalhes das conquistas são mostrados no bate-papo.",
  ["display_help"] = "Defina como as mensagens de conquistas devem aparecer no bate-papo e quais informações extras devem ser exibidas.",
  ["dont_show_achievements_name"] = "Ocultar conquistas da guilda",
  ["dont_show_achievements_desc"] = "Oculta mensagens de conquistas obtidas pela guilda, reduzindo o volume de mensagens no bate-papo.",
  ["show_completed_date_name"] = "Mostrar data de conclusão",
  ["show_completed_date_desc"] = "Mostra a data em que a conquista foi concluída, quando essa informação estiver disponível.",

  -- BR: Resposta rápida | EN: Quick Response
  ["quick_response_tab_name"] = "Resposta rápida",
  ["quick_response_tab_desc"] = "Configura o atalho e a mensagem usada para responder às conquistas de outros jogadores.",
  ["quick_response_help"] = "Defina como o Prat deve ajudar você a responder rapidamente quando outro jogador obtém uma conquista.",
  ["show_grats_link_name"] = "Mostrar atalho de resposta",
  ["show_grats_link_desc"] = "Mostra um atalho clicável ao lado da mensagem de conquista para enviar rapidamente uma resposta ao jogador.",
  ["custom_grats_name"] = "Usar mensagem personalizada",
  ["custom_grats_desc"] = "Permite definir sua própria mensagem para responder às conquistas de outros jogadores.",
  ["custom_grats_text_name"] = "Mensagem de resposta",
  ["custom_grats_text_desc"] = "Mensagem enviada ao responder a uma conquista. Use %s para inserir automaticamente o nome do jogador.",
  ["custom_grats_text_example"] = "Exemplo: Parabéns %s!\n%s será substituído pelo nome do jogador que recebeu a conquista.",

  -- BR: Texto em uso | EN: Runtime Text
  ["custom_grats_default"] = "Parabéns %s!",
  ["grats_link"] = "parabenizar",
  ["completed"] = "Concluída em %s",

  -- BR: Variações de parabéns - jogador também possui a conquista | EN: Grats Variants - Player Also Has the Achievement
  ["grats_have_1"] = "Parabéns %s!",
  ["grats_have_2"] = "Boa, %s!",
  ["grats_have_3"] = "Mandou bem, %s!",
  ["grats_have_4"] = "Muito bom, %s!",
  ["grats_have_5"] = "Aí sim, %s!",
  ["grats_have_6"] = "Parabéns pela conquista, %s!",
  ["grats_have_7"] = "Excelente, %s!",
  ["grats_have_8"] = "Grande conquista, %s!",
  ["grats_have_9"] = "Boa conquista, %s!",
  ["grats_have_10"] = "Show, %s!",

  -- BR: Variações de parabéns - jogador ainda não possui a conquista | EN: Grats Variants - Player Does Not Have the Achievement Yet
  ["grats_donthave_1"] = "Parabéns %s!",
  ["grats_donthave_2"] = "Boa, %s!",
  ["grats_donthave_3"] = "Mandou bem, %s!",
  ["grats_donthave_4"] = "Muito bom, %s!",
  ["grats_donthave_5"] = "Aí sim, %s!",
  ["grats_donthave_6"] = "Parabéns pela conquista, %s!",
  ["grats_donthave_7"] = "Excelente, %s!",
  ["grats_donthave_8"] = "Grande conquista, %s!",
  ["grats_donthave_9"] = "Boa conquista, %s!",
  ["grats_donthave_10"] = "Show, %s!",
}


-- ============================================================================
-- BR: REF: modules/AddonMessages.lua | Strings do módulo AddonMsgs (ptBR)
-- EN: REF: modules/AddonMessages.lua | Module strings for AddonMsgs (enUS reference)
-- ============================================================================
ptBR.AddonMsgs = {
  -- BR: Geral | EN: General
  ["module_name"] = "Mensagens de Addons",
  ["module_desc"] = "Exibe mensagens internas ocultas enviadas pelo canal de comunicação dos addons.",
  ["full_description"] = "Este módulo exibe mensagens internas enviadas por addons através do evento CHAT_MSG_ADDON.\n\nEle é útil principalmente para diagnóstico, depuração ou inspeção da comunicação entre addons. Para uso normal, geralmente é melhor manter este módulo desativado.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do diagnóstico de mensagens de addons.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Mensagens de Addons|r são mensagens internas de comunicação trocadas entre addons.\n\nAtivar este módulo pode gerar muita poluição visual e costuma ser útil apenas para solução de problemas.",

  -- BR: Janelas | EN: Windows
  ["windows_tab_name"] = "Janelas",
  ["windows_tab_desc"] = "Escolha onde as mensagens de addons serão exibidas.",
  ["windows_help"] = "Selecione as janelas de bate-papo onde mensagens ocultas de comunicação entre addons devem aparecer.",

  ["show_name"] = "Mostrar Mensagens de Addons",
  ["show_desc"] = "Mostra mensagens ocultas de addons nas janelas de bate-papo selecionadas.",

  -- BR: Uso diagnóstico | EN: Diagnostic Use
  ["diagnostic_tab_name"] = "Uso Diagnóstico",
  ["diagnostic_tab_desc"] = "Explica a finalidade e as limitações deste módulo.",
  ["diagnostic_help"] = "|cFFFF8000Módulo de diagnóstico:|r\nEste módulo é voltado para depuração da comunicação entre addons. Ele pode expor muitas mensagens internas que não são úteis durante o jogo normal.",
}


-- ============================================================================
-- BR: REF: modules/Alias.lua | Strings do módulo Alias (ptBR)
-- EN: REF: modules/Alias.lua | Module strings for Alias (enUS reference)
-- ============================================================================
ptBR.Alias = {
  -- BR: Geral | EN: General
  ["module_name"] = "Comandos Abreviados",
  ["module_desc"] = "Permite criar abreviações para comandos de barra ( / ) usados no bate-papo.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do funcionamento dos comandos abreviados.",
  ["full_description"] = "Este módulo permite criar comandos abreviados para comandos de barra ( / ) do jogo.\n\nCom ele, você pode transformar comandos longos em comandos menores, listar abreviações criadas, remover abreviações antigas e controlar como elas serão expandidas no bate-papo.",

  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Abreviações|r permite criar, remover, procurar e listar comandos abreviados.\n|cFFFFD100Comportamento|r controla como as abreviações serão expandidas ao digitar.\n|cFFFFD100Proteção|r explica quais comandos de barra ( / ) não devem ser usados como abreviações.",

  -- BR: Gerenciamento | EN: Management
  ["management_tab_name"] = "Abreviações",
  ["management_tab_desc"] = "Cria, remove, procura e lista comandos abreviados.",
  ["management_help"] = "Crie abreviações de forma assistida usando campos separados ou use o modo avançado para comandos de barra ( / ) mais específicos.",

  ["examples_header"] = "Exemplos",
  ["examples_text"] = "|cFFFFD100Criador assistido:|r preencha o comando, escolha o canal e escreva a mensagem.\n|cFFFFD100Exemplo:|r comando |cFFFFD100oi|r + canal |cFFFFD100Dizer|r + mensagem |cFFFFD100Olá pessoal!|r cria /oi.\n|cFFFFD100Modo avançado:|r use |cFFFFD100oi say Olá pessoal!|r apenas se quiser digitar a expansão manualmente.",
  ["input_usage"] = "No criador assistido, informe cada parte separadamente. No modo avançado, use o formato: |cFFFFD100abreviação comando mensagem|r.",

  -- BR: Criador assistido | EN: Assisted Builder
  ["builder_header"] = "Criador Assistido",
  ["builder_help"] = "Use estes campos para criar uma abreviação de mensagem sem precisar memorizar o formato técnico. Digite como ficará o comando, escolha onde a mensagem será enviada e escreva o conteúdo.",
  ["builder_alias_name"] = "Comando",
  ["builder_alias_desc"] = "Digite apenas o nome da abreviação, sem a barra. Exemplo: oi cria o comando /oi.",
  ["builder_command_name"] = "Canal",
  ["builder_command_desc"] = "Escolha para onde a mensagem será enviada quando a abreviação for usada.",
  ["builder_message_name"] = "Mensagem",
  ["builder_message_desc"] = "Texto que será enviado quando a abreviação for executada.",
  ["builder_preview_empty"] = "Resultado: digite um comando para visualizar a abreviação.",
  ["builder_preview_format"] = "Resultado: /%s -> /%s",
  ["builder_create_name"] = "Criar Abreviação",
  ["builder_create_desc"] = "Cria ou atualiza a abreviação usando os campos acima.",

  ["builder_command_say"] = "Dizer",
  ["builder_command_yell"] = "Gritar",
  ["builder_command_party"] = "Grupo",
  ["builder_command_raid"] = "Raide",
  ["builder_command_raid_warning"] = "Aviso de Raide",
  ["builder_command_guild"] = "Guilda",
  ["builder_command_officer"] = "Oficiais",
  ["builder_command_instance"] = "Instância",
  ["builder_command_emote"] = "Emote",

  ["builder_missing_alias_warning"] = "Digite o nome do comando abreviado antes de criar a abreviação.",
  ["builder_missing_command_warning"] = "Escolha o canal ou comando de destino antes de criar a abreviação.",
  ["builder_missing_message_warning"] = "Digite a mensagem antes de criar a abreviação.",

  -- BR: Modo avançado | EN: Advanced Mode
  ["advanced_header"] = "Modo Avançado",
  ["advanced_help"] = "Use este campo apenas quando quiser criar uma abreviação manualmente para outro comando de barra ( / ). Formato: abreviação comando conteúdo. O comando pode ser em inglês ou localizado pelo cliente, como say ou dizer.",

  ["manage_existing_header"] = "Abreviações Existentes",
  ["chat_send_unavailable_warning"] = "Não foi possível enviar a mensagem: nenhuma API de envio de bate-papo está disponível neste cliente.",

  ["add_name"] = "Entrada Avançada",
  ["add_desc"] = "Cria ou atualiza uma abreviação usando o formato manual: abreviação comando mensagem. Exemplo: oi say Olá pessoal!",
  ["del_name"] = "Remover Abreviação",
  ["del_desc"] = "Remove uma abreviação existente.",
  ["find_name"] = "Procurar Abreviações",
  ["find_desc"] = "Lista abreviações que contenham o termo informado.",
  ["list_name"] = "Listar Abreviações",
  ["list_desc"] = "Exibe no bate-papo todas as abreviações cadastradas.",

  -- BR: Comportamento | EN: Behavior
  ["behavior_tab_name"] = "Comportamento",
  ["behavior_tab_desc"] = "Controla como as abreviações serão expandidas.",
  ["behavior_help"] = "Ajuste como o módulo deve lidar com abreviações durante a digitação e durante a criação de novos comandos abreviados.",

  ["inline_name"] = "Expandir Durante a Digitação",
  ["inline_desc"] = "Expande a abreviação diretamente na barra de digitação quando esse comportamento estiver disponível no cliente. Em clientes modernos, algumas abreviações podem ser executadas diretamente como comandos registrados.",
  ["no_clobber_name"] = "Não Sobrescrever Abreviações",
  ["no_clobber_desc"] = "Impede que uma abreviação existente seja substituída ao criar uma nova abreviação com o mesmo nome.",

  -- BR: Proteção | EN: Protection
  ["protect_commands_name"] = "Proteger Comandos Existentes",
  ["protect_commands_desc"] = "Impede criar abreviações que usem comandos de barra ( / ) já registrados pelo jogo, pelo Prat ou por outros addons.",

  ["protection_tab_name"] = "Proteção",
  ["protection_tab_desc"] = "Explica os comandos protegidos pelo módulo.",
  ["protection_help"] = "Alguns comandos são protegidos e não podem ser usados como abreviações. O Prat também pode bloquear abreviações que entrem em conflito com comandos de barra ( / ) já registrados pelo jogo ou por outros addons.",
  ["protected_commands_header"] = "Comandos Protegidos",
  ["protected_commands_text"] = "Comandos protegidos fixos: /alias, /unalias, /prat, /script, /run, /reload, /rl, /quit e /listaliases.\n\nCom a proteção de comandos existentes ativada, o Prat também recusa abreviações como /oi quando esse comando já estiver registrado por outro addon ou pelo próprio jogo.",

  -- BR: Mensagens em uso | EN: Runtime Messages
  ["alias_select_format"] = "/%s -> /%s",
  ["nil_argument_error"] = "%s() chamado com argumento nil!",
  ["blank_argument_error"] = "%s() chamado com texto em branco!",
  ["warn_nil_argument_error"] = "warnUser() chamado com argumento nil!",
  ["warn_empty_string_error"] = "warnUser() chamado com texto vazio!",

  ["protected_alias_warning"] = "Recusando criar abreviação para \"/%s\" para evitar quebrar comandos importantes.",
  ["no_clobber_warning"] = "Proteção contra sobrescrita ativa - nova abreviação ignorada: /%s já expande para /%s.",
  ["overwrite_alias_warning"] = "Sobrescrevendo abreviação existente \"/%s\" (antes expandia para \"/%s\").",

  ["alias_created_message"] = "/%s abrevia: /%s",
  ["alias_missing_message"] = "A abreviação \"/%s\" não existe.",
  ["alias_deleted_message"] = "Removendo abreviação \"/%s\" (antes expandia para \"/%s\").",
  ["alias_internal_missing_warning"] = "Tentativa de mostrar o valor da abreviação \"%s\", mas ela não existe em module.Aliases!",
  ["alias_value_message"] = "/%s abrevia \"/%s\"",

  ["no_aliases_message"] = "Nenhuma abreviação foi definida.",
  ["matching_aliases_message"] = "Abreviações correspondentes encontradas: %d",
  ["total_aliases_message"] = "Total de abreviações: %d",
  ["undefined_alias_message"] = "Não há abreviação definida para \"%s\".",

  ["unknown_command_warning"] = "O comando de barra ( /%s ) não foi reconhecido. Use uma expansão com comando válido, por exemplo: oi say Olá pessoal! ou oi dizer Olá pessoal!",
  ["existing_command_conflict_warning"] = "Recusando criar abreviação \"/%s\": este comando de barra ( / ) já existe e pode pertencer ao jogo ou a outro addon.",
  ["saved_alias_conflict_warning"] = "A abreviação salva \"/%s\" conflita com um comando de barra ( / ) já existente e não foi registrada.",
}


-- ============================================================================
-- BR: REF: modules/AltNames.lua | Strings do módulo AltNames (ptBR)
-- EN: REF: modules/AltNames.lua | Module strings for AltNames (enUS reference)
-- ============================================================================
ptBR.AltNames = {
  -- BR: Geral | EN: General
  ["module_name"] = "AltNames",
  ["module_desc"] = "Gerencia vínculos entre personagens principais e alternativos, exibindo essas relações no chat e nas dicas.",

  ["links_tab_name"] = "Vínculos",
  ["links_tab_desc"] = "Cria ou remove vínculos entre personagens alternativos e principais.",
  ["links_help"] = "Use esta aba para vincular manualmente um personagem alternativo ao seu personagem principal, ou remover um vínculo existente.",
  ["manual_links_group_name"] = "Vinculação Manual",
  ["manual_links_group_desc"] = "Crie ou remova relações Alt -> Main.",
  ["link_name"] = "Vincular personagem",
  ["link_desc"] = "Informe o nome do alt seguido do nome do personagem principal.",
  ["link_usage"] = "<alt> <main>  Exemplo: Delyssa Moises",
  ["delete_name"] = "Remover vínculo",
  ["delete_desc"] = "Remove o vínculo de um personagem alternativo com seu main.",
  ["delete_usage"] = "<alt>  Exemplo: Delyssa",
  ["link_behavior_group_name"] = "Comportamento",
  ["link_behavior_group_desc"] = "Controla como novos vínculos são registrados.",
  ["noclobber_name"] = "Não substituir vínculos existentes",
  ["noclobber_desc"] = "Impede que importações ou novos vínculos sobrescrevam relações Alt -> Main já cadastradas.",
  ["quiet_name"] = "Modo silencioso",
  ["quiet_desc"] = "Reduz mensagens de confirmação enviadas pelo módulo no chat.",

  ["lookup_tab_name"] = "Consulta",
  ["lookup_tab_desc"] = "Pesquisa personagens e lista vínculos cadastrados.",
  ["lookup_help"] = "Use esta aba para procurar mains ou alts, listar os alts de um personagem ou exibir todos os vínculos cadastrados.",
  ["lookup_group_name"] = "Pesquisa e Listagem",
  ["lookup_group_desc"] = "Ferramentas para consultar os vínculos existentes.",
  ["find_name"] = "Encontrar personagem",
  ["find_desc"] = "Pesquisa personagens principais ou alternativos pelo nome informado.",
  ["find_usage"] = "<termo de busca>",
  ["listalts_name"] = "Listar alts de um main",
  ["listalts_desc"] = "Lista todos os personagens alternativos vinculados ao personagem principal informado.",
  ["listalts_usage"] = "<main>",
  ["listall_name"] = "Listar todos os vínculos",
  ["listall_desc"] = "Mostra todos os vínculos Alt -> Main cadastrados.",

  ["display_tab_name"] = "Exibição",
  ["display_tab_desc"] = "Controla como os vínculos aparecem no chat e nas dicas.",
  ["display_help"] = "Use esta aba para definir onde o nome do personagem principal aparece no chat, quais cores serão usadas e o que será exibido nas dicas.",
  ["chat_display_group_name"] = "Exibição no Chat",
  ["chat_display_group_desc"] = "Controla como o main aparece ao lado do alt nas mensagens.",
  ["mainpos_name"] = "Posição do main",
  ["mainpos_desc"] = "Define onde o nome do personagem principal será exibido quando a mensagem vier de um alt.",
  ["position_left"] = "Esquerda",
  ["position_right"] = "Direita",
  ["position_start"] = "Início da mensagem",
  ["pncol_name"] = "Cor por classe",
  ["pncol_desc"] = "Usa a cor de classe do PlayerNames para colorir o nome exibido.",
  ["pncol_main"] = "Classe do main",
  ["pncol_alt"] = "Classe do alt",
  ["pncol_no"] = "Não usar",
  ["colour_name"] = "Cor personalizada",
  ["colour_desc"] = "Define uma cor fixa para o nome do personagem principal quando a cor por classe estiver desativada.",
  ["tooltip_group_name"] = "Dicas",
  ["tooltip_group_desc"] = "Controla informações extras exibidas nas dicas dos personagens.",
  ["tooltip_showmain_name"] = "Mostrar main na dica",
  ["tooltip_showmain_desc"] = "Mostra o personagem principal na dica de um alt.",
  ["tooltip_showalts_name"] = "Mostrar alts na dica",
  ["tooltip_showalts_desc"] = "Mostra os personagens alternativos na dica de um main.",

  ["import_tab_name"] = "Importação",
  ["import_tab_desc"] = "Importa vínculos de guilda, LibAlts e addons externos.",
  ["import_help"] = "Use esta aba para preencher vínculos automaticamente a partir da guilda, de bibliotecas compartilhadas ou de bancos de dados de addons antigos.",
  ["import_options_group_name"] = "Opções de Importação",
  ["import_options_group_desc"] = "Controla de onde os dados serão lidos e como serão aplicados.",
  ["usealtlib_name"] = "Usar dados do LibAlts",
  ["usealtlib_desc"] = "Usa informações compartilhadas pela biblioteca LibAlts quando disponíveis.",
  ["autoguildalts_name"] = "Importar automaticamente da guilda",
  ["autoguildalts_desc"] = "Tenta importar vínculos da guilda automaticamente ao atualizar a lista de membros.",
  ["import_buttons_group_name"] = "Fontes de Importação",
  ["import_buttons_group_desc"] = "Executa importações manuais a partir de fontes específicas.",
  ["guildimport_name"] = "Importar da guilda",
  ["guildimport_desc"] = "Importa alts a partir de ranks, notas públicas e notas de oficiais da guilda.",
  ["ggimport_name"] = "Importar do Guild Greet",
  ["ggimport_desc"] = "Importa vínculos a partir do banco de dados do addon Guild Greet, se existir.",
  ["importfromlok_name"] = "Importar do LOKWhoIsWho",
  ["importfromlok_desc"] = "Importa dados do LOKWhoIsWho, se o banco de dados estiver disponível.",

  ["maintenance_tab_name"] = "Manutenção",
  ["maintenance_tab_desc"] = "Corrige ou limpa o banco de vínculos do AltNames.",
  ["maintenance_help"] = "Use esta aba com cuidado. As opções aqui corrigem dados antigos ou apagam vínculos cadastrados.",
  ["maintenance_group_name"] = "Ferramentas de Manutenção",
  ["maintenance_group_desc"] = "Ações para corrigir ou limpar vínculos cadastrados.",
  ["fixalts_name"] = "Corrigir vínculos",
  ["fixalts_desc"] = "Tenta corrigir entradas corrompidas ou mal formatadas na lista de alts.",
  ["clearall_name"] = "Limpar todos os vínculos",
  ["clearall_desc"] = "Remove todos os vínculos Alt -> Main cadastrados.",

  ["ERROR: some function sent a blank message!"] = "ERRO: alguma função enviou uma mensagem vazia!",
  ["No arg string given to :addAlt()"] = "Nenhum argumento informado para :addAlt().",
  ["No main name suPLied to link %s to"] = "Nenhum main informado para vincular %s.",
  ["warning: alt %s already linked to %s"] = "Aviso: o alt %s já está vinculado a %s.",
  ["alt name exists: %s -> %s; not overwriting as set in preferences"] = "O vínculo já existe: %s -> %s; não será sobrescrito por causa das preferências.",
  ["linked alt %s => %s"] = "Alt vinculado: %s => %s.",
  ["character removed: %s"] = "Personagem removido: %s.",
  ["no characters called \"%s\" found; nothing deleted"] = "Nenhum personagem chamado \"%s\" foi encontrado; nada foi removido.",
  ["You have not yet linked any alts with their mains."] = "Você ainda não vinculou nenhum alt ao seu main.",
  ["%s total alts linked to mains"] = "%s alts vinculados a mains no total.",
  ["no alts or mains found matching \"%s\""] = "Nenhum alt ou main encontrado com \"%s\".",
  ["Found alt: %s => main: %s"] = "Alt encontrado: %s => main: %s.",
  ["searched for: %s - total matches: %s"] = "Pesquisa por: %s - total encontrado: %s.",
  ["LOKWhoIsWho lua file not found, sorry."] = "Arquivo Lua do LOKWhoIsWho não encontrado.",
  ["LOKWhoIsWho data not found"] = "Dados do LOKWhoIsWho não encontrados.",
  ["%s alts imported from LOKWhoIsWho"] = "%s alts importados do LOKWhoIsWho.",
  ["No Guild Greet database found"] = "Banco de dados do Guild Greet não encontrado.",
  ["You are not in a guild"] = "Você não está em uma guilda.",
  ["guild member alts found and imported: %s"] = "Alts de membros da guilda encontrados e importados: %s.",
  ["no alts found for character "] = "Nenhum alt encontrado para o personagem ",
  ["%d alts found for %s: %s"] = "%d alts encontrados para %s: %s",
  ["Main:"] = "Main:",
  ["Alts:"] = "Alts:",
  ["(.-)'s? [Aa]lt"] = "(.-)'s? [Aa]lt",
  [".*[Aa]lts?$"] = ".*[Aa]lts?$",
  [".*[Tt]wink.*$"] = ".*[Tt]wink.*$",
  ["([^%s%p%d%c%z]+)'s alt"] = "([^%s%p%d%c%z]+)'s alt",
  ["alt of ([^%s%p%d%c%z]+)"] = "alt of ([^%s%p%d%c%z]+)",

  -- Compatibility aliases / legacy keys
  ["link_options_group_name"] = "Opções de Vínculo",
  ["link_options_group_desc"] = "Controla como novos vínculos serão registrados.",
  ["no_clobber_name"] = "Não Substituir Vínculos Existentes",
  ["no_clobber_desc"] = "Impede que importações ou novos vínculos sobrescrevam relações Alt -> Main já cadastradas.",
  ["list_alts_name"] = "Listar Alts de um Main",
  ["list_alts_desc"] = "Lista todos os personagens alternativos vinculados ao personagem principal informado.",
  ["list_alts_usage"] = "<main>",
  ["list_all_name"] = "Listar Todos os Vínculos",
  ["list_all_desc"] = "Mostra todos os vínculos Alt -> Main cadastrados.",
  ["main_position_name"] = "Posição do Main",
  ["main_position_desc"] = "Define onde o nome do personagem principal será exibido quando a mensagem vier de um alt.",
  ["class_color_source_name"] = "Origem da Cor de Classe",
  ["class_color_source_desc"] = "Escolha se a cor de classe deve usar o main, o alt ou nenhuma cor de classe.",
  ["class_color_source_main"] = "Main",
  ["class_color_source_alt"] = "Alt",
  ["class_color_source_no"] = "Nenhuma",
  ["custom_color_name"] = "Cor Personalizada",
  ["custom_color_desc"] = "Escolha uma cor fixa usada quando a cor de classe não for aplicada.",
  ["tooltip_show_main_name"] = "Mostrar Main na Tooltip",
  ["tooltip_show_main_desc"] = "Mostra o personagem principal vinculado nas tooltips de jogadores.",
  ["tooltip_show_alts_name"] = "Mostrar Alts na Tooltip",
  ["tooltip_show_alts_desc"] = "Mostra personagens alternativos vinculados nas tooltips de jogadores.",
  ["use_alt_lib_name"] = "Usar AltLib",
  ["use_alt_lib_desc"] = "Importa relações de personagens alternativos do banco AltLib quando disponível.",
  ["auto_guild_alts_name"] = "Alts Automáticos da Guilda",
  ["auto_guild_alts_desc"] = "Detecta automaticamente relações de alts nas notas da guilda quando possível.",
  ["guild_import_name"] = "Importar Notas da Guilda",
  ["guild_import_desc"] = "Importa relações de alts a partir das notas da guilda.",
  ["guild_greet_import_name"] = "Importar GuildGreet",
  ["guild_greet_import_desc"] = "Importa relações de alts dos dados do GuildGreet quando disponíveis.",
  ["import_from_lok_name"] = "Importar do LOK",
  ["import_from_lok_desc"] = "Importa relações de alts dos dados do LOK quando disponíveis.",
  ["fix_alts_name"] = "Reparar Alts",
  ["fix_alts_desc"] = "Tenta reparar relações de alts armazenadas.",
  ["clear_all_name"] = "Limpar Todos os Vínculos",
  ["clear_all_desc"] = "Apaga todos os vínculos Alt -> Main armazenados.",
  ["error_blank_message"] = "Entrada em branco não é válida.",
  ["error_no_add_alt_argument"] = "Nenhum nome de alt/main foi informado.",
  ["error_no_main_name_for_link"] = "Nenhum nome de main foi informado para %s.",
  ["warning_alt_already_linked"] = "%s já está vinculado a %s.",
  ["warning_existing_link_not_overwritten"] = "O vínculo existente não foi sobrescrito: %s já está vinculado a %s.",
  ["msg_alt_linked"] = "%s foi vinculado ao main %s.",
  ["msg_character_removed"] = "Vínculos removidos para %s.",
  ["msg_no_character_deleted"] = "Nenhum vínculo salvo foi encontrado para %s.",
  ["msg_no_links_yet"] = "Nenhum vínculo de alt foi salvo ainda.",
  ["msg_total_links"] = "Total de vínculos salvos: %d.",
  ["msg_no_matches_found"] = "Nenhuma correspondência encontrada para %s.",
  ["msg_found_alt_main"] = "%s está vinculado ao main %s.",
  ["msg_search_summary"] = "A busca por %s retornou %d resultado(s).",
  ["msg_lok_file_not_found"] = "Arquivo de dados do LOK não encontrado.",
  ["msg_lok_data_not_found"] = "Nenhum dado de alt do LOK foi encontrado.",
  ["msg_lok_alts_imported"] = "%d vínculo(s) de alt importado(s) do LOK.",
  ["msg_no_guild_greet_database"] = "Banco de dados do GuildGreet não encontrado.",
  ["msg_not_in_guild"] = "Você não está em uma guilda no momento.",
  ["msg_guild_alts_imported"] = "%d vínculo(s) de alt importado(s) dos dados da guilda.",
  ["msg_no_alts_for_character"] = "Nenhum alt encontrado para: ",
  ["msg_alts_found_for_character"] = "%d alt(s) encontrado(s) para %s: %s",
  ["label_main"] = "Main",
  ["label_alts"] = "Alts:",
  ["pattern_possessive_alt_cleanup"] = "^alt de (.+)$",
  ["pattern_rank_alts"] = "alt",
  ["pattern_rank_twink"] = "twink",
  ["pattern_note_possessive_alt"] = "alt de (.+)",
  ["pattern_note_alt_of"] = "alt de (.+)",
}


-- ============================================================================
-- BR: REF: modules/Bubbles.lua | Strings do módulo Bubbles (ptBR)
-- EN: REF: modules/Bubbles.lua | Module strings for Bubbles (enUS reference)
-- ============================================================================
ptBR.Bubbles = {
  -- BR: Geral | EN: General
  ["module_name"] = "Balões",
  ["module_desc"] = "Personaliza a aparência e o conteúdo dos balões de fala exibidos sobre personagens e NPCs.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do funcionamento dos balões.",
  ["full_description"] = "Este módulo personaliza os balões de fala exibidos sobre personagens e NPCs.\n\nVocê pode ajustar aparência, fonte, transparência, formatação das mensagens, ícones de raide e comportamento de mensagens longas.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Aparência|r controla fonte, transparência e cores dos balões.\n|cFFFFD100Conteúdo|r define quais melhorias do Prat serão aplicadas ao texto.\n|cFFFFD100Comportamento|r controla como mensagens longas serão exibidas.",

  -- BR: Aparência | EN: Appearance
  ["appearance_tab_name"] = "Aparência",
  ["appearance_tab_desc"] = "Controla a aparência visual dos balões.",
  ["appearance_help"] = "Ajuste a aparência visual dos balões exibidos sobre personagens e NPCs.",
  ["color_name"] = "Colorir Bordas",
  ["color_desc"] = "Coloriza a borda do balão conforme a cor da mensagem ou do tipo de bate-papo.",
  ["transparent_name"] = "Deixar Balões Transparentes",
  ["transparent_desc"] = "Remove ou reduz as texturas de fundo e borda, deixando os balões mais discretos.",
  ["font_name"] = "Usar Fonte do Bate-papo",
  ["font_desc"] = "Aplica aos balões a mesma fonte usada nas janelas de bate-papo.",
  ["font_size_name"] = "Tamanho da Fonte",
  ["font_size_desc"] = "Define o tamanho da fonte usada nos balões quando a opção de fonte do bate-papo estiver ativada.",

  -- BR: Conteúdo | EN: Content
  ["content_tab_name"] = "Conteúdo",
  ["content_tab_desc"] = "Controla o conteúdo exibido dentro dos balões.",
  ["content_help"] = "Controle quais melhorias visuais do Prat também serão aplicadas ao conteúdo exibido dentro dos balões.",
  ["format_name"] = "Aplicar Formatação do Prat",
  ["format_desc"] = "Aplica ao texto dos balões os padrões de formatação processados pelo Prat, como nomes, links e substituições reconhecidas.",
  ["icons_name"] = "Mostrar Ícones de Raide",
  ["icons_desc"] = "Substitui marcações como {estrela}, {caveira} e outros marcadores por ícones de raide dentro dos balões.",

  -- BR: Comportamento | EN: Behavior
  ["behavior_tab_name"] = "Comportamento",
  ["behavior_tab_desc"] = "Controla como os balões se comportam durante a exibição.",
  ["behavior_help"] = "Define ajustes de comportamento dos balões durante a exibição das mensagens.",
  ["shorten_name"] = "Encurtar Balões",
  ["shorten_desc"] = "Reduz mensagens longas para uma linha enquanto o mouse não estiver sobre o balão. Ao passar o mouse, o texto volta a expandir.",
}


-- ============================================================================
-- BR: REF: modules/Buttons.lua | Strings do módulo Buttons (ptBR)
-- EN: REF: modules/Buttons.lua | Module strings for Buttons (enUS reference)
-- ============================================================================
ptBR.Buttons = {
  -- BR: Geral | EN: General
  ["module_name"] = "Controles do Bate-papo",
  ["module_desc"] = "Controla a exibição dos botões e elementos visuais das janelas de bate-papo.",
  ["full_description"] = "Este módulo controla os botões e elementos visuais das janelas de bate-papo.\n\nUse estas opções para simplificar a interface, ocultando controles que você não utiliza, ou para manter visíveis recursos de navegação e acesso rápido.",

  -- BR: Navegação | EN: Navigation
  ["navigation_header"] = "Navegação",

  ["show_arrows_name"] = "Mostrar Setas de Navegação",
  ["show_arrows_desc"] = "Mostra ou oculta as setas usadas para navegar pelo histórico de mensagens em cada janela de bate-papo.",

  ["scroll_reminder_name"] = "Mostrar Botão Voltar ao Final",
  ["scroll_reminder_desc"] = "Mostra um botão de retorno ao final quando você sobe o histórico da janela de bate-papo e novas mensagens continuam chegando.",

  -- BR: Interface | EN: Interface
  ["interface_header"] = "Interface",

  ["show_bnet_name"] = "Mostrar Menu Social",
  ["show_bnet_desc"] = "Mostra ou oculta o botão social/integração Battle.net associado à janela de bate-papo.",

  ["show_menu_name"] = "Mostrar Menu do Bate-papo",
  ["show_menu_desc"] = "Mostra ou oculta o botão principal do menu da janela de bate-papo.",

  ["show_minimize_name"] = "Mostrar Botão de Minimizar",
  ["show_minimize_desc"] = "Mostra ou oculta o botão usado para minimizar janelas de bate-papo não acopladas.",

  ["show_voice_name"] = "Mostrar Botões de Voz",
  ["show_voice_desc"] = "Mostra ou oculta os botões de controle de voz, como silenciar ou ensurdecer, quando disponíveis.",

  ["show_channel_name"] = "Mostrar Botão dos Canais",
  ["show_channel_desc"] = "Mostra ou oculta o botão usado para acessar opções e controles relacionados aos canais de bate-papo.",
}


-- ============================================================================
-- BR: REF: modules/ChannelColorMemory.lua | Strings do módulo ChannelColorMemory (ptBR)
-- EN: REF: modules/ChannelColorMemory.lua | Module strings for ChannelColorMemory (enUS reference)
-- ============================================================================
ptBR.ChannelColorMemory = {
  -- BR: Geral | EN: General
  ["module_name"] = "Lembrar Cor do Canal",
  ["module_desc"] = "Memoriza a cor atribuída a cada canal pelo nome, mesmo que o número do canal mude.",

  -- BR: Informação | EN: Information
  ["info_group_name"] = "Como funciona",
  ["info_group_desc"] = "Explica o comportamento automático deste módulo.",
  ["info_text"] = "Este módulo salva a cor escolhida para cada canal pelo nome. Ao entrar novamente no mesmo canal, a cor será restaurada automaticamente, mesmo que o canal apareça com outro número.",
  ["info_note"] = "Não há opções adicionais aqui: basta manter o módulo ativado para que ele memorize e restaure as cores dos canais automaticamente.",

  -- BR: Padrões técnicos | EN: Technical Patterns
  ["channel_name_pattern"] = "(%S+)%s?(.*)",
}


-- ============================================================================
-- BR: REF: modules/ChannelNames.lua | Strings do módulo ChannelNames (ptBR)
-- EN: REF: modules/ChannelNames.lua | Module strings for ChannelNames (enUS reference)
-- ============================================================================
ptBR.ChannelNames = {
  -- BR: Geral | EN: General
  ["module_name"] = "Nomes de Canais",
  ["module_desc"] = "Controla abreviações, substituições e apelidos dos nomes de canais e tipos de bate-papo.",

  -- BR: Tipos de bate-papo | EN: Chat Types
  ["channel_types_tab_name"] = "Tipos de Bate-papo",
  ["channel_types_tab_desc"] = "Configura como os tipos fixos e canais numerados aparecerão no bate-papo.",

  ["chat_types_group_name"] = "Tipos Fixos",
  ["chat_types_group_desc"] = "Configura abreviações para dizer, grupo, guilda, raide, sussurro e outros tipos fixos.",
  ["chat_types_select_group_name"] = "Tipos Fixos",
  ["chat_types_select_group_desc"] = "Configura abreviações para dizer, grupo, guilda, raide, sussurro e outros tipos fixos.",

  ["numbered_channels_group_name"] = "Canais Numerados",
  ["numbered_channels_group_desc"] = "Configura abreviações para canais numerados, como Canal 1, Canal 2 e assim por diante.",
  ["numbered_channels_select_group_name"] = "Canais Numerados",
  ["numbered_channels_select_group_desc"] = "Configura abreviações para canais numerados, como Canal 1, Canal 2 e assim por diante.",

  -- BR: Apelidos de canais | EN: Channel Nicknames
  ["channel_nicknames_tab_name"] = "Apelidos de Canais",
  ["channel_nicknames_tab_desc"] = "Configura apelidos personalizados para canais específicos.",
  ["custom_nicknames_group_name"] = "Canais Detectados",
  ["custom_nicknames_group_desc"] = "Lista os canais encontrados para permitir apelidos personalizados.",

  -- BR: Formatação | EN: Formatting
  ["format_options_tab_name"] = "Outras Opções",
  ["format_options_tab_desc"] = "Controla detalhes de formatação aplicados às abreviações.",
  ["format_group_name"] = "Formatação das Abreviações",
  ["format_group_desc"] = "Controla espaço e dois-pontos após as abreviações dos canais.",

  ["space_name"] = "Adicionar Espaço",
  ["space_desc"] = "Adiciona um espaço depois da abreviação do canal.",
  ["colon_name"] = "Adicionar Dois-pontos",
  ["colon_desc"] = "Adiciona dois-pontos entre o nome do jogador e a mensagem.",

  -- BR: Opções dinâmicas | EN: Dynamic Options
  ["chat_type_settings_desc"] = "Configura a abreviação usada para %s.",
  ["channel_nickname_settings_desc"] = "Configura o apelido personalizado para %s.",
  ["selected_type_help"] = "Escolha um item na lista acima e defina como ele aparecerá no bate-papo.",
  ["replacement_text_name"] = "Abreviação exibida no bate-papo",
  ["short_name_desc"] = "Define o texto que substituirá %s.",
  ["replace_name"] = "Usar esta substituição",
  ["replace_desc"] = "Ativa ou desativa a substituição deste tipo de bate-papo.",
  ["channel_number_name"] = "Canal %d",

  -- BR: Apelidos | EN: Nicknames
  ["add_nick_name"] = "Adicionar Apelido",
  ["add_nick_desc"] = "Define um apelido personalizado para este canal.",
  ["remove_nick_name"] = "Remover Apelido",
  ["remove_nick_desc"] = "Remove o apelido personalizado deste canal.",

  -- BR: Rótulos Battle.net | EN: Battle.net Labels
  ["bn_whisper_label"] = "Sussurro Battle.net enviado",
  ["bn_whisper_incoming_label"] = "Sussurro Battle.net recebido",
  ["bn_conversation_label"] = "Conversa Battle.net",

  -- BR: Abreviações padrão | EN: Default Short Names
  ["short_say"] = "[D]",
  ["short_whisper"] = "[S Para]",
  ["short_whisper_incoming"] = "[S De]",
  ["short_bn_whisper"] = "[BN Para]",
  ["short_bn_whisper_incoming"] = "[BN De]",
  ["short_yell"] = "[G]",
  ["short_party"] = "[Gp]",
  ["short_party_leader"] = "[Líder Gp]",
  ["short_guild"] = "[Gu]",
  ["short_officer"] = "[Of]",
  ["short_raid"] = "[R]",
  ["short_raid_leader"] = "[Líder R]",
  ["short_raid_warning"] = "[Aviso R]",
  ["short_instance"] = "[I]",
  ["short_instance_leader"] = "[Líder I]",
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
-- BR: REF: modules/ChannelSticky.lua | Strings do módulo ChannelSticky (ptBR)
-- EN: REF: modules/ChannelSticky.lua | Module strings for ChannelSticky (enUS reference)
-- ============================================================================
ptBR.ChannelSticky = {
  -- BR: Geral | EN: General
  ["module_name"] = "Memória de Conversa",
  ["module_desc"] = "Lembra automaticamente o último tipo de conversa usado no bate-papo.",

  -- BR: Descrição | EN: Description
  ["full_description"] = "Este módulo controla quais tipos de conversa continuam ativos depois que você envia uma mensagem.\n\nQuando um tipo está memorizado, o bate-papo permanece nele após o envio, evitando que você precise selecionar o mesmo canal repetidamente.",

  -- BR: Tipos de bate-papo | EN: Chat Types
  ["channel_name"] = "Canal",

  ["memory_group_name"] = "Tipos de Conversa Memorizados",
  ["memory_group_desc"] = "Escolha quais tipos de conversa devem permanecer ativos após o envio de mensagens.",
  ["memory_group_help"] = "Marque os tipos de conversa que o Prat deve manter ativos depois que você enviar uma mensagem.",

  ["remember_type_name"] = "Memorizar %s",
  ["remember_type_desc"] = "Mantém %s como tipo de conversa ativo após o envio de mensagens.",

  ["bn_whisper_short"] = "Sussurro Battle.net",
  ["bn_conversation_short"] = "Conversa Battle.net",

  -- BR: Grupo inteligente | EN: Smart Group
  ["smart_group_group_name"] = "Grupo Inteligente",
  ["smart_group_group_desc"] = "Configura a escolha automática do melhor tipo de conversa em grupo.",
  ["smart_group_group_help"] = "O Grupo Inteligente escolhe automaticamente o melhor destino disponível ao enviar mensagens de grupo: instância, raide, grupo ou dizer.",

  ["smart_group_name"] = "Usar Grupo Inteligente",
  ["smart_group_desc"] = "Ativa os comandos /smart e /smrt para enviar mensagens ao melhor tipo de conversa em grupo disponível: instância, raide, grupo ou dizer.",
}


-- ============================================================================
-- BR: REF: modules/ChatLog.lua | Strings do módulo ChatLog (ptBR)
-- EN: REF: modules/ChatLog.lua | Module strings for ChatLog (enUS reference)
-- ============================================================================
ptBR.ChatLog = {
  -- BR: Geral | EN: General
  ["module_name"] = "Registro do Bate-papo",
  ["module_desc"] = "Controla automaticamente o registro do bate-papo e do combate em arquivos de log do jogo.",
  ["full_description"] = "Este módulo permite gravar mensagens do bate-papo e eventos de combate em arquivos de log do World of Warcraft.\n\nRegistro do bate-papo:\n|cFFFFD100Logs\\WoWChatLog.txt|r\n\nRegistro de combate:\n|cFFFFD100Logs\\WoWCombatLog.txt|r",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo dos registros de bate-papo e combate.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Registro do Bate-papo|r grava mensagens do bate-papo.\n|cFFFFD100Registro de Combate|r grava eventos de combate.\n|cFFFFD100Modo Silencioso|r oculta mensagens de feedback quando o registro é alterado.\n\nO jogo pode finalizar a gravação dos arquivos apenas ao sair do personagem ou fechar o World of Warcraft.",

  -- BR: Registros | EN: Logs
  ["logs_tab_name"] = "Registros",
  ["logs_tab_desc"] = "Ativa ou desativa o registro do bate-papo e do combate.",
  ["logs_help"] = "Escolha quais registros devem ser ativados automaticamente quando este módulo estiver ativo.",

  ["chat_log_name"] = "Registro do Bate-papo",
  ["chat_log_desc"] = "Ativa ou desativa o registro das mensagens de bate-papo.\n\nArquivo gerado:\nLogs\\WoWChatLog.txt",

  ["combat_log_name"] = "Registro de Combate",
  ["combat_log_desc"] = "Ativa ou desativa o registro dos eventos de combate.\n\nArquivo gerado:\nLogs\\WoWCombatLog.txt",

  -- BR: Comportamento | EN: Behavior
  ["behavior_tab_name"] = "Comportamento",
  ["behavior_tab_desc"] = "Controla as mensagens de feedback exibidas por este módulo.",
  ["behavior_help"] = "Estas opções afetam apenas as mensagens de feedback do Prat. Elas não alteram se o jogo grava ou não os arquivos de log.",

  ["quiet_name"] = "Modo Silencioso",
  ["quiet_desc"] = "Oculta mensagens informativas exibidas quando os registros são ativados ou desativados.",

  ["important_note"] = "|cFFFF8000Importante:|r\nOs arquivos de log são controlados pelo próprio jogo. Em alguns casos, eles podem ser atualizados ou finalizados apenas ao sair do personagem ou encerrar o World of Warcraft.",

  -- BR: Mensagens em uso | EN: Runtime Messages
  ["chat_log_enabled"] = "Registro do bate-papo ativado.",
  ["chat_log_disabled"] = "Registro do bate-papo desativado.",
  ["chat_log_path"] = "O registro do bate-papo será salvo em: <Instalação do WoW>\\Logs\\WoWChatLog.txt",

  ["combat_log_enabled"] = "Registro de combate ativado.",
  ["combat_log_disabled"] = "Registro de combate desativado.",
  ["combat_log_path"] = "O registro de combate será salvo em: <Instalação do WoW>\\Logs\\WoWCombatLog.txt",
}


-- ============================================================================
-- BR: REF: modules/ChatTabs.lua | Strings do módulo ChatTabs (ptBR)
-- EN: REF: modules/ChatTabs.lua | Module strings for ChatTabs (enUS reference)
-- ============================================================================
ptBR.ChatTabs = {
  -- BR: Geral | EN: General
  ["module_name"] = "Guias de Bate-papo",
  ["module_desc"] = "Controla aparência, visibilidade e alertas das guias das janelas de bate-papo.",
  ["full_description"] = "Este módulo controla as guias das janelas de bate-papo.\n\nVocê pode ajustar visibilidade, transparência, tamanho da fonte, texturas e alertas visuais quando novas mensagens chegam.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do funcionamento das guias de bate-papo.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Visibilidade|r controla quando as guias aparecem e o nível de transparência.\n|cFFFFD100Alertas|r controla flash, mudança de cor e duração dos avisos por novas mensagens.\n|cFFFFD100Configuração por janela|r permite definir efeitos diferentes para cada janela de bate-papo.",

  -- BR: Visibilidade | EN: Visibility
  ["visibility_tab_name"] = "Visibilidade",
  ["visibility_tab_desc"] = "Controla exibição, transparência e aparência básica das guias.",
  ["visibility_help"] = "Use esta aba para definir quando as guias aparecem, qual transparência usam quando estão ativas ou inativas, se exibem texturas e qual tamanho de fonte será usado nos nomes das guias.",

  ["display_mode_name"] = "Modo de Exibição por Janela",
  ["display_mode_desc"] = "Define o modo de exibição da guia para cada janela de bate-papo. A seleção pode permitir comportamento padrão, forçar exibição ou forçar ocultação dependendo do estado escolhido.",

  ["active_alpha_name"] = "Transparência da Guia Ativa",
  ["active_alpha_desc"] = "Define a transparência da guia da janela de bate-papo atualmente selecionada.",

  ["inactive_alpha_name"] = "Transparência das Guias Inativas",
  ["inactive_alpha_desc"] = "Define a transparência das guias das janelas de bate-papo que não estão selecionadas.",

  ["show_tab_textures_name"] = "Mostrar Texturas das Guias",
  ["show_tab_textures_desc"] = "Mostra ou oculta as texturas visuais das guias de bate-papo.",

  ["tab_font_size_name"] = "Tamanho da Fonte das Guias",
  ["tab_font_size_desc"] = "Define o tamanho da fonte usada nos nomes das guias de bate-papo.",

  -- BR: Alertas | EN: Alerts
  ["alerts_tab_name"] = "Alertas",
  ["alerts_tab_desc"] = "Controla flash, destaque e avisos visuais das guias.",
  ["alerts_help"] = "Use esta aba para controlar como as guias avisam quando novas mensagens chegam. Você pode desativar flashes, manter alertas visíveis por mais tempo e configurar efeitos diferentes para cada janela.",

  ["disable_flash_name"] = "Desativar Flash",
  ["disable_flash_desc"] = "Impede que as guias pisquem quando novas mensagens chegarem.",

  ["forever_alert_name"] = "Manter Alerta até Clicar",
  ["forever_alert_desc"] = "Mantém o alerta visual ativo até que você clique na guia correspondente.",

  ["keep_highlight_inactive_name"] = "Manter Destaque em Guias Inativas",
  ["keep_highlight_inactive_desc"] = "Mantém o destaque visual quando a guia não estiver selecionada.",

  ["alert_timeout_name"] = "Duração do Alerta",
  ["alert_timeout_desc"] = "Define por quanto tempo flashes e destaques devem permanecer visíveis.",

  -- BR: Alertas por janela | EN: Per-Window Alerts
  ["per_window_header"] = "Alertas por Janela",
  ["per_window_help"] = "Cada janela de bate-papo pode ter seus próprios efeitos. Ative flash, alteração de cor da fonte ou ambos conforme a importância daquela janela.",

  ["flash_row_name"] = "Flash da Guia",
  ["flash_row_desc"] = "Configura o flash visual da guia para esta janela.",
  ["set_flash_name"] = "Piscar ao Receber Mensagem",
  ["set_flash_desc"] = "Faz a guia piscar quando esta janela receber uma nova mensagem.",
  ["flash_color_name"] = "Cor do Flash",
  ["flash_color_desc"] = "Define a cor usada no flash desta guia.",

  ["font_row_name"] = "Cor do Texto da Guia",
  ["font_row_desc"] = "Configura a mudança temporária da cor do nome da guia.",
  ["change_font_name"] = "Alterar Cor ao Receber Mensagem",
  ["change_font_desc"] = "Altera temporariamente a cor do texto da guia quando esta janela receber uma nova mensagem.",
  ["font_color_name"] = "Cor do Texto",
  ["font_color_desc"] = "Define a cor temporária usada no texto da guia.",
}


-- ============================================================================
-- BR: REF: modules/Clear.lua | Strings do módulo Clear (ptBR)
-- EN: REF: modules/Clear.lua | Module strings for Clear (enUS reference)
-- ============================================================================
ptBR.Clear = {
  -- BR: Geral | EN: General
  ["module_name"] = "Limpar Bate-papo",
  ["module_desc"] = "Habilita comandos para limpar a janela atual ou todas as janelas de bate-papo.",
  ["full_description"] = "Este módulo habilita comandos de limpeza rápida para as janelas de bate-papo.\n\nEle não altera canais, configurações, filtros, histórico salvo ou preferências do Prat. Ele apenas limpa as mensagens atualmente visíveis nas janelas de bate-papo.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo dos comandos de limpeza do bate-papo.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100/clear|r e |cFFFFD100/cls|r limpam a janela de bate-papo atualmente selecionada.\n|cFFFFD100/clearall|r e |cFFFFD100/clsall|r limpam todas as janelas de bate-papo existentes.",

  -- BR: Comandos | EN: Commands
  ["commands_tab_name"] = "Comandos",
  ["commands_tab_desc"] = "Comandos disponíveis para limpar janelas de bate-papo.",
  ["commands_help"] = "Use estes comandos diretamente no bate-papo para limpar as mensagens visíveis.",

  ["current_window_commands"] = "|cFFFFD100/clear|r ou |cFFFFD100/cls|r\nLimpa apenas a janela de bate-papo atualmente selecionada.",

  ["all_windows_commands"] = "|cFFFFD100/clearall|r ou |cFFFFD100/clsall|r\nLimpa todas as janelas de bate-papo existentes.",

  ["important_note"] = "|cFFFF8000Importante:|r\nA limpeza remove apenas o conteúdo visível da janela. Nenhuma conversa salva, configuração, canal, scrollback salvo ou histórico persistente é apagado.",
}


-- ============================================================================
-- BR: REF: modules/CopyChat.lua | Strings do módulo CopyChat (ptBR)
-- EN: REF: modules/CopyChat.lua | Module strings for CopyChat (enUS reference)
-- ============================================================================
ptBR.CopyChat = {
  -- BR: Geral | EN: General
  ["module_name"] = "Copiar Mensagens",
  ["module_desc"] = "Permite copiar mensagens das janelas de bate-papo, incluindo histórico visível, histórico completo e linhas pelo timestamp.",

  -- BR: Botão de cópia | EN: Copy Button
  ["button_group_name"] = "Botão de Cópia",
  ["button_group_desc"] = "Controla em quais janelas o botão de cópia aparece e onde ele fica posicionado.",
  ["show_button_name"] = "Mostrar Botão nas Janelas",
  ["show_button_desc"] = "Escolha quais janelas de bate-papo exibirão o botão de cópia.",
  ["button_position_name"] = "Localização do Botão",
  ["button_position_desc"] = "Define em qual canto da janela o botão de cópia será exibido.",
  ["copy_name"] = "Copiar Texto Agora",
  ["copy_desc"] = "Copia o texto da janela de bate-papo selecionada para uma caixa de edição.",

  -- BR: Formato da cópia | EN: Copy Format
  ["format_group_name"] = "Formato da Cópia",
  ["format_group_desc"] = "Controla o formato do texto copiado e se marcas de tempo poderão ser copiadas.",
  ["copy_format_name"] = "Formato do Texto Copiado",
  ["copy_format_desc"] = "Define se o texto será copiado puro ou com marcações de cor para BBCode, HTML ou WowAce.",
  ["copy_timestamps_name"] = "Copiar pelo Timestamp",
  ["copy_timestamps_desc"] = "Permite clicar na marca de tempo da mensagem para copiar aquela linha.",

  -- BR: Aparência do botão | EN: Button Appearance
  ["appearance_group_name"] = "Aparência do Botão",
  ["appearance_group_desc"] = "Controla a transparência do botão quando o mouse está sobre ele ou fora dele.",
  ["active_alpha_name"] = "Opacidade ao Passar o Mouse",
  ["active_alpha_desc"] = "Define a opacidade do botão quando o mouse está sobre ele.",
  ["inactive_alpha_name"] = "Opacidade em Repouso",
  ["inactive_alpha_desc"] = "Define a opacidade do botão quando o mouse não está sobre ele.",

  -- BR: Como usar | EN: How to Use
  ["usage_group_name"] = "Como Usar",
  ["usage_group_desc"] = "Explica os atalhos disponíveis no botão de cópia.",
  ["usage_text"] = "Clique esquerdo: copia o texto visível da janela.\nCTRL + clique: copia o histórico completo disponível.\nSHIFT + clique ou clique direito: ativa o modo nativo de seleção do chat.\nSe a cópia pelo timestamp estiver ativa, clique na marca de tempo de uma mensagem para copiar apenas aquela linha.",

  -- BR: Posições do botão | EN: Button Positions
  ["position_top_left"] = "Superior Esquerda",
  ["position_top_right"] = "Superior Direita",
  ["position_bottom_left"] = "Inferior Esquerda",
  ["position_bottom_right"] = "Inferior Direita",

  -- BR: Formatos | EN: Formats
  ["format_plain"] = "Texto Simples",
  ["format_bbcode"] = "BBCode",
  ["format_html"] = "HTML",
  ["format_wowace"] = "Fóruns WowAce",

  -- BR: Janela de cópia | EN: Copy Window
  ["copy_window_title"] = "Janela de Chat %s - Texto",
}


-- ============================================================================
-- BR: REF: modules/CustomFilters.lua | Strings do módulo CustomFilters (ptBR)
-- EN: REF: modules/CustomFilters.lua | Module strings for CustomFilters (enUS reference)
-- ============================================================================
ptBR.CustomFilters = {
  -- BR: Geral | EN: General
  ["module_name"] = "Filtros Personalizados",
  ["module_desc"] = "Cria regras manuais para localizar, alterar, bloquear, destacar, tocar sons ou redirecionar mensagens do bate-papo.",
  ["full_description"] = "Este módulo funciona como um construtor de regras para o chat. Você cria filtros de Entrada para mensagens recebidas e filtros de Saída para mensagens enviadas por você. Cada filtro pode procurar um padrão de texto e, quando encontrar uma correspondência, executar ações como substituir texto, bloquear a mensagem, destacar a correspondência, tocar um som ou enviar uma cópia para outra saída.",
  ["global_help"] = "|cFFFF8000Por onde começar:|r\nAbra Entrada ou Saída, crie um filtro em Adicionar Filtro e depois configure as ações dentro do filtro criado. As opções de saída secundária só aparecem dentro do filtro quando Saída Secundária estiver ativada.",

  -- BR: Modos | EN: Modes
  ["inbound_name"] = "Entrada",
  ["inbound_desc"] = "Filtros aplicados às mensagens recebidas no bate-papo.",
  ["inbound_help"] = "|cFFFF8000Filtros de Entrada:|r\nAtuam sobre mensagens que aparecem no seu chat, como canal, grupo, guilda, sussurro, raide e avisos do jogo. Use para bloquear mensagens, destacar termos importantes, tocar sons ou copiar mensagens encontradas para outra saída.",

  ["outbound_name"] = "Saída",
  ["outbound_desc"] = "Filtros aplicados às mensagens enviadas por você.",
  ["outbound_help"] = "|cFFFF8000Filtros de Saída:|r\nAtuam sobre mensagens que você digita antes de serem enviadas. Use com cuidado: eles podem substituir texto, bloquear envio ou processar padrões nas mensagens que saem do seu personagem.",

  -- BR: Gerenciamento de filtros | EN: Filter Management
  ["filter_management_header"] = "Gerenciar Filtros",
  ["filter_management_help"] = "Após adicionar um filtro, uma nova seção com o nome dele aparecerá nesta tela. Abra essa seção para configurar padrão de busca, substituição, bloqueio, destaque, som, canais monitorados e saída secundária.",
  ["add_pattern_name"] = "Adicionar Filtro",
  ["add_pattern_desc"] = "Digite o texto ou padrão inicial que o filtro deve procurar. Depois de criado, o filtro aparecerá como uma nova seção configurável.",
  ["remove_pattern_name"] = "Remover Filtro",
  ["remove_pattern_desc"] = "Remove um filtro existente desta aba. Só fica disponível quando houver filtros criados.",
  ["string_usage"] = "<texto ou padrão>",

  -- BR: Filtro individual | EN: Single Filter
  ["single_filter_help"] = "Configure aqui o comportamento deste filtro. Primeiro defina o padrão de busca; depois escolha o que deve acontecer quando uma mensagem combinar com esse padrão.",
  ["identity_header"] = "Identificação do Filtro",

  ["filter_name_name"] = "Nome do Filtro",
  ["filter_name_desc"] = "Nome amigável usado para identificar este filtro na lista.",
  ["enabled_name"] = "Ativado",
  ["enabled_desc"] = "Ativa ou desativa este filtro sem precisar removê-lo.",

  -- BR: Padrão | EN: Pattern
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Identidade básica e resumo deste filtro.",
  ["overview_help"] = "Esta visão geral identifica o filtro e mostra se ele está ativo no momento.",

  ["pattern_tab_name"] = "Busca e Substituição",
  ["pattern_group_desc"] = "Define o que o filtro deve procurar e, se necessário, qual texto deve substituir a correspondência.",
  ["pattern_help"] = "Defina o padrão de busca e o texto opcional de substituição. Padrões Lua são aceitos, então expressões avançadas podem ser usadas com cuidado.",

  ["search_pattern_name"] = "Padrão de Busca",
  ["search_pattern_desc"] = "Texto ou padrão Lua procurado na mensagem. Pode ser uma palavra simples ou um padrão mais avançado.",

  ["replacement_text_name"] = "Texto de Substituição",
  ["replacement_text_desc"] = "Texto usado para substituir a correspondência encontrada. Fica desativado quando o filtro está configurado para bloquear ou enviar para uma saída secundária.",
  ["replacement_help"] = "|cFFFF8000Dica sobre %1:|r\n%1 representa o texto encontrado pelo padrão de busca. Exemplo: se a busca encontra Delyssa e a substituição é [%1], o resultado será [Delyssa].",

  ["replacement_is_code_name"] = "Substituição é Código Lua",
  ["replacement_is_code_desc"] = "Trata o texto de substituição como código Lua. Use apenas se você entender os riscos.",

  ["output_message_only_name"] = "Enviar Apenas a Mensagem",
  ["output_message_only_desc"] = "Ao enviar para a saída secundária, envia apenas o texto da mensagem em vez da linha completa formatada do bate-papo.",

  -- BR: Ações | EN: Actions
  ["actions_tab_name"] = "Ações",
  ["actions_group_desc"] = "Define o que acontece quando a mensagem corresponde ao padrão de busca.",
  ["actions_help"] = "Escolha se a mensagem deve ser bloqueada, destacada, tocar som ou ser copiada para outra saída.",

  ["block_message_name"] = "Bloquear Mensagem",
  ["block_message_desc"] = "Impede que a mensagem correspondente apareça no bate-papo.",

  ["highlight_match_name"] = "Destacar Correspondência",
  ["highlight_match_desc"] = "Destaca o texto encontrado na mensagem.",
  ["highlight_color_name"] = "Cor do Destaque",
  ["highlight_color_desc"] = "Cor usada ao destacar o texto encontrado.",

  ["play_sound_name"] = "Tocar Som",
  ["play_sound_desc"] = "Toca o som selecionado quando o filtro encontra uma correspondência.",

  ["secondary_output_name"] = "Saída Secundária",
  ["secondary_output_desc"] = "Mostra opções para enviar a mensagem correspondente para outro destino, além do processamento normal.",

  -- BR: Canais | EN: Channels
  ["channels_tab_name"] = "Canais",
  ["channels_group_name"] = "Canais Monitorados",
  ["channels_help"] = "Escolha quais tipos de bate-papo ou canais este filtro deve monitorar.",
  ["in_channels_desc"] = "Controla onde este filtro pode ser executado.",
  ["channel_scope_desc"] = "Ativa este filtro para %s (%s).",

  -- BR: Saída secundária | EN: Secondary Output
  ["secondary_output_tab_name"] = "Saída Secundária",
  ["secondary_output_group_desc"] = "Controla para onde as mensagens encontradas são copiadas quando Saída Secundária está ativada.",
  ["secondary_output_help"] = "A saída secundária envia uma cópia da mensagem encontrada para outro destino. Isso é útil para monitorar termos importantes sem perder o fluxo original do bate-papo.",
  ["secondary_output_config_header"] = "Configurações de Saída",

  ["chatframesink_name"] = "Janela de Bate-papo",
  ["chatframesink_desc"] = "Envia mensagens encontradas para uma janela de bate-papo selecionada.",

  -- Compatibility aliases / legacy keys
  ["Pattern Options"] = "Opções de Padrão",
}


-- ============================================================================
-- BR: REF: modules/Editbox.lua | Strings do módulo Editbox (ptBR)
-- EN: REF: modules/Editbox.lua | Module strings for Editbox (enUS reference)
-- ============================================================================
ptBR.Editbox = {
  -- BR: Geral | EN: General
  ["module_name"] = "Barra de Digitação",
  ["module_desc"] = "Personaliza aparência, posição, texturas, cores e comportamento da barra de digitação do chat.",
  ["full_description"] = "Este módulo personaliza a barra de digitação do chat, ou seja, o campo onde você escreve mensagens.\n\nVocê pode ajustar posição, fonte, borda, fundo, cores, comportamento das setas e compatibilidade com o sistema moderno de chat da Blizzard.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo das opções de personalização da barra de digitação.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Posição|r controla onde a barra de digitação fica presa à janela de bate-papo.\n|cFFFFD100Aparência|r controla fonte, borda, fundo e cores.\n|cFFFFD100Comportamento|r controla como as setas do teclado interagem com o histórico do chat.",

  -- BR: Posição | EN: Position
  ["placement_group_name"] = "Posição",
  ["placement_group_desc"] = "Controla onde a barra de digitação será posicionada.",
  ["placement_help"] = "Escolha onde a barra de digitação deve aparecer em relação à janela de bate-papo.",
  ["attach_name"] = "Fixar em",
  ["attach_desc"] = "Define a posição da barra de digitação em relação à janela de bate-papo.",
  ["attach_top"] = "Superior",
  ["attach_bottom"] = "Inferior",
  ["attach_free"] = "Livre",
  ["attach_locked"] = "Travada",

  -- BR: Fonte | EN: Font
  ["font_name"] = "Fonte",
  ["font_desc"] = "Escolhe a fonte usada na barra de digitação.",

  -- BR: Aparência | EN: Appearance
  ["appearance_tab_name"] = "Aparência",
  ["appearance_tab_desc"] = "Controla a aparência visual da barra de digitação.",
  ["appearance_help"] = "Ajuste fonte, borda, fundo e cores usadas pela barra de digitação do chat.",

  ["background_name"] = "Textura do Fundo",
  ["background_desc"] = "Escolhe a textura de fundo usada pela barra de digitação.",
  ["border_name"] = "Textura da Borda",
  ["border_desc"] = "Escolhe a textura da borda usada pela barra de digitação.",

  ["color_by_channel_name"] = "Colorir Borda pelo Canal",
  ["color_by_channel_desc"] = "Coloriza a borda da barra de digitação conforme o tipo de canal ativo.",
  ["border_color_name"] = "Cor da Borda",
  ["border_color_desc"] = "Define a cor padrão da borda quando a coloração por canal não estiver sendo aplicada.",
  ["background_color_name"] = "Cor do Fundo",
  ["background_color_desc"] = "Define a cor e transparência do fundo da barra de digitação.",

  -- BR: Borda | EN: Border
  ["border_group_name"] = "Borda",
  ["border_group_desc"] = "Controla medidas e espaçamento da moldura.",
  ["border_help"] = "Ajuste fino da moldura da barra de digitação. Valores muito altos podem deixar a borda exagerada ou deformada, dependendo da textura escolhida.",
  ["edge_size_name"] = "Tamanho da Borda",
  ["edge_size_desc"] = "Define a espessura visual da borda.",
  ["inset_name"] = "Margem Interna",
  ["inset_desc"] = "Define o recuo interno entre a borda e o fundo da barra.",
  ["tile_size_name"] = "Tamanho da Repetição",
  ["tile_size_desc"] = "Define o tamanho usado para repetir a textura de fundo.",

  -- BR: Comportamento | EN: Behavior
  ["behavior_tab_name"] = "Comportamento",
  ["behavior_tab_desc"] = "Controla o comportamento do teclado durante a digitação.",
  ["behavior_help"] = "Ajuste como a barra de digitação reage às setas do teclado e à navegação pelo histórico de mensagens.",
  ["use_alt_key_name"] = "Usar Alt nas Setas",
  ["use_alt_key_desc"] = "Exige segurar Alt ao pressionar as setas do teclado para navegar pelo histórico da barra de digitação.",


  -- BR: Posição | EN: Position
  ["position_tab_name"] = "Posição",
  ["position_tab_desc"] = "Controla onde a barra de digitação fica anexada.",
  ["position_help"] = "Escolha onde a barra de digitação deve aparecer em relação à janela de bate-papo.",

  -- BR: Fonte | EN: Font
  ["font_group_name"] = "Fonte",
  ["font_group_desc"] = "Controla a fonte da barra de digitação.",
  ["font_face_name"] = "Fonte",
  ["font_face_desc"] = "Escolha a fonte usada pela barra de digitação.",
  ["font_size_name"] = "Tamanho da Fonte",
  ["font_size_desc"] = "Define o tamanho da fonte da barra de digitação.",
}


-- ============================================================================
-- BR: REF: modules/EventNames.lua | Strings do módulo EventNames (ptBR)
-- EN: REF: modules/EventNames.lua | Module strings for EventNames (enUS reference)
-- ============================================================================
ptBR.EventNames = {
  -- BR: Geral | EN: General
  ["module_name"] = "Nomes de Eventos",
  ["module_desc"] = "Mostra o nome técnico do evento de chat ao final das mensagens.",
  ["full_description"] = "Este módulo exibe o nome técnico do evento de chat que gerou cada mensagem.\n\nEle é mais útil para diagnóstico, testes, desenvolvimento e para entender quais eventos de chat do WoW estão sendo processados pelo Prat.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Explica para que serve a exibição dos eventos.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Janelas|r controla quais janelas exibem os nomes dos eventos.\n|cFFFFD100Processamento|r controla se o Prat deve processar todos os eventos de chat.\n\nExemplos de nomes de evento incluem CHAT_MSG_GUILD, CHAT_MSG_SAY, CHAT_MSG_WHISPER e identificadores técnicos semelhantes.",

  -- BR: Janelas | EN: Windows
  ["windows_tab_name"] = "Janelas",
  ["windows_tab_desc"] = "Escolha em quais janelas os nomes dos eventos serão exibidos.",
  ["windows_help"] = "Selecione as janelas de bate-papo onde o nome técnico do evento deve ser adicionado ao final das mensagens.",

  ["show_name"] = "Mostrar Nomes de Eventos",
  ["show_desc"] = "Ativa a exibição do nome técnico do evento nas janelas selecionadas.",

  -- BR: Processamento | EN: Processing
  ["processing_tab_name"] = "Processamento de Eventos",
  ["processing_tab_desc"] = "Controla se o Prat deve processar eventos que normalmente seriam ignorados.",
  ["processing_help"] = "Use esta opção apenas quando precisar investigar eventos. Ela pode aumentar a quantidade de mensagens processadas pelo Prat.",

  ["all_events_name"] = "Processar Todos os Eventos",
  ["all_events_desc"] = "Força o Prat a processar todos os eventos de chat para que seus nomes possam ser exibidos.",

  -- Compatibility aliases / legacy keys
  ["help_group_name"] = "Visão Geral",
  ["help_group_desc"] = "Explica para que serve a exibição dos nomes de eventos.",
}


-- ============================================================================
-- BR: REF: modules/Fading.lua | Strings do módulo Fading (ptBR)
-- EN: REF: modules/Fading.lua | Module strings for Fading (enUS reference)
-- ============================================================================
ptBR.Fading = {
  -- BR: Geral | EN: General
  ["module_name"] = "Esmaecimento",
  ["module_desc"] = "Controla o desaparecimento gradual das mensagens nas janelas de bate-papo.",
  ["full_description"] = "Este módulo controla por quanto tempo as mensagens permanecem visíveis nas janelas de bate-papo antes de desaparecerem gradualmente.\n\nVocê pode escolher quais janelas serão afetadas e ajustar o tempo de visibilidade das mensagens.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do comportamento do esmaecimento.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Janelas|r controla quais janelas de bate-papo usam esmaecimento.\n|cFFFFD100Tempo|r controla por quanto tempo as mensagens permanecem visíveis antes de desaparecer.\n\nDesativar o esmaecimento em uma janela mantém as mensagens visíveis até a atualização normal da janela de bate-papo.",

  -- BR: Janelas | EN: Windows
  ["windows_tab_name"] = "Janelas",
  ["windows_tab_desc"] = "Escolha quais janelas de bate-papo usam esmaecimento das mensagens.",
  ["windows_help"] = "Selecione as janelas de bate-papo onde as mensagens devem desaparecer gradualmente após permanecerem visíveis pelo tempo configurado.",

  ["text_fade_name"] = "Ativar Esmaecimento",
  ["text_fade_desc"] = "Ativa ou desativa o desaparecimento gradual das mensagens nesta janela de bate-papo.",

  -- BR: Tempo | EN: Timing
  ["timing_tab_name"] = "Tempo",
  ["timing_tab_desc"] = "Controla por quanto tempo as mensagens permanecem visíveis antes de desaparecer.",
  ["timing_help"] = "Defina por quanto tempo as mensagens permanecerão visíveis antes de começarem a desaparecer gradualmente.",

  ["duration_name"] = "Tempo de Visibilidade",
  ["duration_desc"] = "Define por quantos segundos as mensagens permanecem visíveis antes de desaparecerem gradualmente.",
}


-- ============================================================================
-- BR: REF: modules/Filtering.lua | Strings do módulo Filtering (ptBR)
-- EN: REF: modules/Filtering.lua | Module strings for Filtering (enUS reference)
-- ============================================================================
ptBR.Filtering = {
  -- BR: Geral | EN: General
  ["module_name"] = "Filtragem",
  ["module_desc"] = "Fornece filtros avançados para reduzir avisos repetidos, spam e mensagens indesejadas no bate-papo.",
  ["full_description"] = "Este módulo reduz mensagens indesejadas, avisos automáticos e spam repetido nos canais de bate-papo.\n\nO Filtro de IA usa um classificador treinável para identificar mensagens suspeitas e pode aprender com exemplos marcados manualmente.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do funcionamento da filtragem.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Filtros Básicos|r ocultam avisos repetidos, spam de comércio e mensagens AFK/DND repetidas.\n|cFFFFD100Filtro de IA|r usa um classificador treinável para detectar possível spam.\n|cFFFFD100Treinamento|r adiciona controles clicáveis para ensinar ao filtro o que é spam ou mensagem legítima.",

  -- BR: Filtros básicos | EN: Basic Filters
  ["basic_tab_name"] = "Filtros Básicos",
  ["basic_tab_desc"] = "Controla filtros simples para avisos e mensagens repetidas.",
  ["basic_help"] = "Use estas opções para ocultar avisos automáticos e mensagens repetidas que poderiam poluir o bate-papo.",

  ["notices_name"] = "Filtrar Avisos de Canal",
  ["notices_desc"] = "Oculta mensagens automáticas de entrada, saída e alterações em canais.",

  ["trade_spam_name"] = "Ocultar Spam Repetido",
  ["trade_spam_desc"] = "Oculta mensagens repetidas em canais e gritos quando aparecem novamente em um curto intervalo de tempo.",

  ["afk_dnd_name"] = "Ocultar AFK/DND Repetidos",
  ["afk_dnd_desc"] = "Oculta mensagens repetidas de ausente (AFK) ou ocupado (DND).",

  -- BR: Filtro de IA | EN: AI Filter
  ["ai_tab_name"] = "Filtro de IA contra Spam",
  ["ai_tab_desc"] = "Controla o filtro treinável usado para identificar possíveis mensagens de spam.",
  ["ai_help"] = "O filtro de IA é baseado em um classificador treinável. Ele pode aprender com exemplos marcados manualmente quando o modo de treinamento estiver ativado.",

  ["use_ai_name"] = "Filtro de IA",
  ["use_ai_desc"] = "Usa um classificador treinável para identificar e ocultar possíveis mensagens de spam em canais de bate-papo.",

  ["training_name"] = "Treinar Filtro de IA",
  ["training_desc"] = "Mostra controles clicáveis nas mensagens para ensinar ao filtro o que deve ser tratado como spam ou mensagem legítima.",
  ["training_help"] = "|cFFFF8000Como funciona o treinamento:|r\nQuando ativado, o chat pode mostrar controles como [--] e [++] ao lado da pontuação da mensagem. Use [++] para marcar como spam e [--] para marcar como mensagem legítima. Quanto mais exemplos corretos forem marcados, melhor o filtro tende a se ajustar.",

  -- BR: Mensagens em uso | EN: Runtime Messages
  ["learning_prefix"] = "Aprendendo: ",
  ["unlearning_prefix"] = "Desfazendo aprendizado: ",
  ["learning_as"] = " como ",
  ["spam_label"] = "SPAM",
  ["not_spam_label"] = "NÃO SPAM",

  -- Compatibility aliases / legacy keys
  ["basic_group_name"] = "Filtros Básicos",
  ["basic_group_desc"] = "Controla filtros simples para avisos e mensagens repetidas.",
}


-- ============================================================================
-- BR: REF: modules/Font.lua | Strings do módulo Font (ptBR)
-- EN: REF: modules/Font.lua | Module strings for Font (enUS reference)
-- ============================================================================
ptBR.Font = {
  -- BR: Geral | EN: General
  ["module_name"] = "Fonte",
  ["module_desc"] = "Controla a fonte, o tamanho e o estilo do texto nas janelas de bate-papo.",
  ["full_description"] = "Este módulo controla a aparência do texto nas janelas de bate-papo.\n\nVocê pode escolher a fonte, ajustar tamanhos por janela, aplicar contorno, usar modo monocromático e alterar a cor da sombra do texto.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo das opções de fonte.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Fonte|r escolhe a família tipográfica usada no bate-papo.\n|cFFFFD100Tamanho|r ajusta o tamanho do texto por janela.\n|cFFFFD100Estilo|r controla contorno, monocromia e sombra do texto.",

  -- BR: Família da fonte | EN: Font Family
  ["font_family_group_name"] = "Fonte",
  ["font_family_group_desc"] = "Controla a família da fonte usada no bate-papo.",
  ["font_family_help"] = "Escolha a fonte usada nas janelas de bate-papo. A opção de lembrar fonte mantém sua escolha mesmo após alterações externas feitas pelo jogo ou por outros addons.",

  ["font_face_name"] = "Fonte",
  ["font_face_desc"] = "Escolhe a fonte usada nas janelas de bate-papo.",

  ["remember_font_name"] = "Lembrar Fonte",
  ["remember_font_desc"] = "Mantém a fonte escolhida e tenta restaurá-la automaticamente quando o jogo ou outro addon alterar a fonte.",

  -- BR: Tamanho da fonte | EN: Font Size
  ["font_size_group_name"] = "Tamanho",
  ["font_size_group_desc"] = "Controla o tamanho do texto em cada janela de bate-papo.",
  ["size_help"] = "Ajuste o tamanho do texto separadamente para cada janela de bate-papo. Algumas abas especiais, como sussurros e batalha de mascotes, podem aparecer dependendo da versão do jogo e das configurações ativas.",

  ["font_size_desc"] = "Define o tamanho da fonte para esta janela de bate-papo.",
  ["whisper_tabs"] = "Abas de Sussurro",
  ["pet_battle_tab"] = "Aba de Batalha de Mascotes",

  -- BR: Estilo da fonte | EN: Font Style
  ["font_style_group_name"] = "Estilo",
  ["font_style_group_desc"] = "Controla efeitos visuais aplicados ao texto.",
  ["font_style_help"] = "Use esta aba para aplicar contorno, modo monocromático e cor de sombra ao texto do bate-papo. Esses efeitos podem melhorar a leitura dependendo do fundo da interface.",

  ["outline_mode_name"] = "Contorno",
  ["outline_mode_desc"] = "Define o tipo de contorno aplicado ao texto.",

  ["outline_none"] = "Nenhum",
  ["outline_normal"] = "Contorno",
  ["outline_thick"] = "Contorno Grosso",

  ["monochrome_name"] = "Modo Monocromático",
  ["monochrome_desc"] = "Aplica renderização monocromática ao texto. Pode deixar a fonte mais rígida ou mais nítida, dependendo da fonte escolhida.",

  ["shadow_color_name"] = "Cor da Sombra",
  ["shadow_color_desc"] = "Define a cor da sombra do texto.",
}


-- ============================================================================
-- BR: REF: modules/ChatFrames.lua | Strings do módulo Frames (ptBR)
-- EN: REF: modules/ChatFrames.lua | Module strings for Frames (enUS reference)
-- ============================================================================
ptBR.Frames = {
  -- BR: Geral | EN: General
  ["module_name"] = "Janelas de Bate-papo",
  ["module_desc"] = "Controla limites de tamanho, posicionamento e opacidade do fundo das janelas de bate-papo.",
  ["full_description"] = "Este módulo controla aspectos estruturais das janelas de bate-papo.\n\nVocê pode ajustar limites mínimos e máximos de tamanho, permitir movimentação mais livre perto das bordas da tela e controlar como a opacidade do fundo das janelas se comporta.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo das opções estruturais das janelas de bate-papo.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Limites de Tamanho|r controla o quanto as janelas podem ficar pequenas ou grandes.\n|cFFFFD100Posição e Opacidade|r controla movimentação próxima às bordas da tela e comportamento da transparência do fundo.\n\nAlgumas alterações ficam mais fáceis de perceber depois de desbloquear, mover ou redimensionar uma janela de bate-papo.",

  -- BR: Limites de tamanho | EN: Size Limits
  ["size_limits_tab_name"] = "Limites de Tamanho",
  ["size_limits_tab_desc"] = "Define as dimensões mínimas e máximas permitidas para as janelas de bate-papo.",
  ["size_limits_help"] = "Ajuste os limites usados ao redimensionar as janelas de bate-papo. Estes valores se aplicam a todas as janelas gerenciadas pelo Prat.",

  ["min_chat_height_name"] = "Altura Mínima",
  ["min_chat_height_desc"] = "Define a menor altura permitida para as janelas de bate-papo.",

  ["max_chat_height_name"] = "Altura Máxima",
  ["max_chat_height_desc"] = "Define a maior altura permitida para as janelas de bate-papo.",

  ["min_chat_width_name"] = "Largura Mínima",
  ["min_chat_width_desc"] = "Define a menor largura permitida para as janelas de bate-papo.",

  ["max_chat_width_name"] = "Largura Máxima",
  ["max_chat_width_desc"] = "Define a maior largura permitida para as janelas de bate-papo.",

  -- BR: Posição e opacidade | EN: Position and Opacity
  ["position_opacity_tab_name"] = "Posição e Opacidade",
  ["position_opacity_tab_desc"] = "Controla movimentação, limites da tela e opacidade visual das janelas de bate-papo.",
  ["position_opacity_help"] = "Ajuste como as janelas podem ser posicionadas na tela e como a opacidade do fundo delas se comporta.",

  ["remove_clamp_name"] = "Permitir Mover Livremente",
  ["remove_clamp_desc"] = "Permite mover as janelas de bate-papo com menos restrições, inclusive mais próximas das bordas da tela.",

  ["frame_alpha_static_name"] = "Manter Opacidade Fixa",
  ["frame_alpha_static_desc"] = "Mantém a opacidade do fundo da janela fixa, evitando alterações automáticas ao passar o mouse.",

  ["default_frame_alpha_name"] = "Opacidade Padrão do Fundo",
  ["default_frame_alpha_desc"] = "Define a opacidade padrão do fundo das janelas de bate-papo. Valores menores deixam o fundo mais transparente; valores maiores deixam o fundo mais visível.",
}


-- ============================================================================
-- BR: REF: modules/Highlight.lua | Strings do módulo Highlight (ptBR)
-- EN: REF: modules/Highlight.lua | Module strings for Highlight (enUS reference)
-- ============================================================================
ptBR.Highlight = {
  -- BR: Geral | EN: General
  ["module_name"] = "Destaque",
  ["module_desc"] = "Destaca visualmente seu nome e possíveis nomes de guilda nas mensagens do bate-papo.",
  ["full_description"] = "Este módulo ajuda a localizar rapidamente o nome do seu personagem e possíveis nomes de guilda em mensagens movimentadas do bate-papo.\n\nO destaque de guildas considera textos entre sinais de menor e maior, como <Nome da Guilda>, como possível nome de guilda.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do funcionamento dos destaques.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Nome do Jogador|r destaca o nome do seu próprio personagem quando ele aparece no bate-papo.\n|cFFFFD100Nomes de Guilda|r destaca textos entre < > como possíveis nomes de guilda.",

  -- BR: Destaques | EN: Highlights
  ["highlights_tab_name"] = "Destaques",
  ["highlights_tab_desc"] = "Escolha o que deve ser destacado no bate-papo.",
  ["highlights_help"] = "Ative ou desative os tipos de texto que devem receber destaque visual.",

  ["player_name"] = "Destacar Próprio Nome",
  ["player_desc"] = "Destaca o nome do seu personagem quando ele aparecer nas mensagens do bate-papo.",

  ["guild_name"] = "Destacar Nomes de Guilda",
  ["guild_desc"] = "Destaca textos entre < > como possíveis nomes de guilda.",
}


-- ============================================================================
-- BR: REF: modules/History.lua | Strings do módulo History (ptBR)
-- EN: REF: modules/History.lua | Module strings for History (enUS reference)
-- ============================================================================
ptBR.History = {
  -- BR: Geral | EN: General
  ["module_name"] = "Histórico",
  ["module_desc"] = "Controla a quantidade de linhas salvas no bate-papo e o histórico de comandos digitados.",
  ["full_description"] = "Este módulo controla dois tipos de histórico.\n\nO primeiro é a quantidade de linhas mantidas nas janelas de bate-papo. O segundo é o histórico de comandos digitados na barra de digitação, que pode ser preservado entre sessões.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo das opções de histórico.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Linhas de Bate-papo|r define quantas mensagens cada janela pode manter no histórico visível.\n|cFFFFD100Histórico de Comandos|r salva comandos digitados para reutilização posterior.\n\nAumentar muito a quantidade de linhas pode consumir mais memória, especialmente em janelas muito movimentadas.",

  -- BR: Linhas de bate-papo | EN: Chat Lines
  ["chat_lines_group_name"] = "Linhas de Bate-papo",
  ["chat_lines_group_desc"] = "Controla quantas linhas cada janela de bate-papo pode armazenar.",
  ["chat_lines_help"] = "Escolha quais janelas terão o limite de linhas controlado por este módulo. Depois defina a quantidade máxima de linhas que essas janelas poderão manter.",

  ["chat_lines_frames_name"] = "Aplicar nas seguintes janelas",
  ["chat_lines_frames_desc"] = "Define quais janelas de bate-papo usarão o limite de linhas configurado abaixo.",

  ["chat_lines_name"] = "Quantidade de Linhas",
  ["chat_lines_desc"] = "Define a quantidade máxima de linhas armazenadas pelas janelas selecionadas.",

  -- BR: Histórico de comandos | EN: Command History
  ["command_history_group_name"] = "Histórico de Comandos",
  ["command_history_group_desc"] = "Controla se comandos digitados serão salvos entre sessões.",
  ["command_history_help"] = "Quando ativado, o Prat preserva comandos digitados na barra de digitação para que possam ser reutilizados depois.\n\nEste histórico é diferente das mensagens visíveis no bate-papo.",

  ["save_history_name"] = "Salvar Comandos",
  ["save_history_desc"] = "Salva o histórico de comandos digitados entre sessões.",

  ["max_lines_name"] = "Limite de Comandos",
  ["max_lines_desc"] = "Define quantos comandos digitados serão mantidos no histórico.",

  -- BR: Extensão Scrollback | EN: Scrollback Extension
  ["scrollback_group_name"] = "Restauração de Mensagens",
  ["scrollback_group_desc"] = "Controla a restauração das mensagens entre sessões.",
  ["scrollback_name"] = "Restaurar Mensagens Anteriores",
  ["scrollback_desc"] = "Armazena as mensagens das janelas de bate-papo para restaurá-las na próxima sessão.",
  ["scrollback_duration_name"] = "Duração do Histórico",
  ["scrollback_duration_desc"] = "Define por quantas horas as mensagens salvas serão mantidas.",
  ["remove_spam_name"] = "Remover Spam",
  ["remove_spam_desc"] = "Remove mensagens repetitivas de addons ao restaurar o histórico.",
  ["divider"] = "========== Fim do Histórico ==========",
  ["bnet_removed"] = "<BNET REMOVIDO>",
}


-- ============================================================================
-- BR: REF: modules/HoverTips.lua | Strings do módulo HoverTips (ptBR)
-- EN: REF: modules/HoverTips.lua | Module strings for HoverTips (enUS reference)
-- ============================================================================
ptBR.HoverTips = {
  -- BR: Geral | EN: General
  ["module_name"] = "Dicas ao Passar o Mouse",
  ["module_desc"] = "Mostra tooltips ao passar o mouse sobre links compatíveis no bate-papo.",
  ["full_description"] = "Este módulo exibe uma tooltip quando você passa o mouse sobre links compatíveis no bate-papo.\n\nEle suporta links comuns do jogo, como itens, encantamentos, magias, missões, conquistas, moedas e mascotes de batalha.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do funcionamento das dicas ao passar o mouse.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "Passe o mouse sobre um link compatível no bate-papo para exibir a tooltip perto do cursor.\n\nA tooltip é ocultada automaticamente quando o mouse sai do link.",

  -- BR: Links compatíveis | EN: Supported Links
  ["supported_links_tab_name"] = "Links Compatíveis",
  ["supported_links_tab_desc"] = "Lista os tipos de links do bate-papo tratados por este módulo.",
  ["supported_links_help"] = "Tipos de links compatíveis:\n\n|cFFFFD100Itens|r\n|cFFFFD100Encantamentos|r\n|cFFFFD100Magias|r\n|cFFFFD100Missões|r\n|cFFFFD100Conquistas|r\n|cFFFFD100Moedas|r\n|cFFFFD100Mascotes de Batalha|r",
}


-- ============================================================================
-- BR: REF: modules/Invites.lua | Strings do módulo Invites (ptBR)
-- EN: REF: modules/Invites.lua | Module strings for Invites (enUS reference)
-- ============================================================================
ptBR.Invites = {
  -- BR: Geral | EN: General
  ["module_name"] = "Convites",
  ["module_desc"] = "Facilita convites para grupo a partir do bate-papo, com atalhos, links clicáveis, filtros de detecção e travas de segurança.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do funcionamento dos convites.",
  ["full_description"] = "Este módulo facilita convites para grupo diretamente pelo bate-papo.\n\nVocê pode usar ALT+clique em nomes de jogadores, transformar pedidos de convite em links clicáveis e controlar onde essas detecções devem acontecer.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Ações|r controla os atalhos usados para convidar jogadores.\n|cFFFFD100Detecção|r define em quais canais o Prat deve transformar pedidos de convite em links clicáveis.\n|cFFFFD100Segurança|r adiciona blacklist, bloqueio em combate e cooldown contra convites repetidos.",

  -- BR: Ações | EN: Actions
  ["actions_tab_name"] = "Ações",
  ["actions_tab_desc"] = "Controla as formas rápidas de convidar jogadores.",
  ["actions_help"] = "Defina quais atalhos o Prat deve oferecer para facilitar convites a partir do bate-papo.",
  ["alt_invite_name"] = "ALT+Clique para Convidar",
  ["alt_invite_desc"] = "Permite convidar um jogador ao segurar ALT e clicar no nome ou link dele no bate-papo.",
  ["link_invite_name"] = "Criar Links de Convite",
  ["link_invite_desc"] = "Transforma pedidos de convite detectados no bate-papo em links clicáveis para convidar o jogador.",

  -- BR: Detecção | EN: Detection
  ["detection_tab_name"] = "Detecção",
  ["detection_tab_desc"] = "Define onde os pedidos de convite serão detectados.",
  ["detection_help"] = "Escolha em quais tipos de bate-papo o Prat deve procurar palavras como invite, inv e variações reconhecidas. Estas opções só afetam os links clicáveis de convite.",
  ["detect_whisper_name"] = "Sussurros",
  ["detect_whisper_desc"] = "Detecta pedidos de convite recebidos por sussurro.",
  ["detect_guild_name"] = "Guilda e Oficiais",
  ["detect_guild_desc"] = "Detecta pedidos de convite nos canais de guilda e oficiais.",
  ["detect_group_name"] = "Grupo e Raide",
  ["detect_group_desc"] = "Detecta pedidos de convite em grupo, raide, líder de raide e aviso de raide.",
  ["detect_say_yell_name"] = "Dizer e Gritar",
  ["detect_say_yell_desc"] = "Detecta pedidos de convite em mensagens próximas, como Dizer e Gritar.",
  ["detect_channel_name"] = "Canais Públicos",
  ["detect_channel_desc"] = "Detecta pedidos de convite em canais personalizados ou públicos, como Geral, Comércio, Defesa Local e canais semelhantes.",

  -- BR: Segurança | EN: Safety
  ["safety_tab_name"] = "Segurança",
  ["safety_tab_desc"] = "Define travas para evitar convites indesejados ou repetidos.",
  ["safety_help"] = "Use estas opções para impedir convites acidentais, evitar repetição contra o mesmo jogador e bloquear nomes específicos.",
  ["block_combat_name"] = "Não Convidar Durante o Combate",
  ["block_combat_desc"] = "Impede que o Prat envie convites enquanto você estiver em combate.",
  ["invite_cooldown_name"] = "Intervalo Entre Convites",
  ["invite_cooldown_desc"] = "Tempo mínimo, em segundos, antes que o mesmo jogador possa receber outro convite pelo módulo. Use 0 para desativar esta trava.",
  ["blacklist_help"] = "Informe os nomes que nunca devem receber links ou convites por este módulo. Separe os nomes por linha, vírgula, ponto e vírgula ou espaço.\n\nExemplo:\nJogadorum\nJogadordois-Reino",
  ["blacklist_name"] = "Lista de Bloqueio",
  ["blacklist_desc"] = "Jogadores nesta lista serão ignorados pelo módulo de convites.",
}


-- ============================================================================
-- BR: REF: modules/Keybindings.lua | Strings do módulo KeyBindings (ptBR)
-- EN: REF: modules/Keybindings.lua | Module strings for KeyBindings (enUS reference)
-- ============================================================================
ptBR.KeyBindings = {
  -- BR: Geral | EN: General
  ["module_name"] = "Atalhos de Teclado",
  ["module_desc"] = "Adiciona atalhos de teclado do Prat ao painel de atalhos do WoW. Configure as teclas em Opções > Atalhos do Teclado > AddOns > Prat.",

  -- BR: Cabeçalho | EN: Header
  ["binding_header_name"] = "Prat",

  -- BR: Canais de bate-papo | EN: Chat Channels
  ["officer_channel_name"] = "Canal de Oficiais",
  ["guild_channel_name"] = "Canal da Guilda",
  ["party_channel_name"] = "Canal de Grupo",
  ["raid_channel_name"] = "Canal de Raide",
  ["raid_warning_channel_name"] = "Canal de Aviso de Raide",
  ["instance_channel_name"] = "Canal de Instância",
  ["say_name"] = "Dizer",
  ["yell_name"] = "Gritar",
  ["whisper_name"] = "Sussurro",
  ["channel_name_format"] = "Canal %d",
  ["smart_group_channel_name"] = "Canal de Grupo Inteligente",

  -- BR: Atalhos utilitários | EN: Utility Bindings
  ["next_chat_tab_name"] = "Próxima Guia de Bate-papo",
  ["copy_selected_chat_frame_name"] = "Copiar Janela de Bate-papo Selecionada",
  ["tell_target_name"] = "Sussurrar para o Alvo",
  ["scroll_to_bottom_name"] = "Rolar até o Final",
  ["scroll_to_top_name"] = "Rolar até o Início",
}


-- ============================================================================
-- BR: REF: modules/LinkInfoIcons.lua | Strings do módulo LinkInfoIcons (ptBR)
-- EN: REF: modules/LinkInfoIcons.lua | Module strings for LinkInfoIcons (enUS reference)
-- ============================================================================
ptBR.LinkInfoIcons = {
  -- BR: Geral | EN: General
  ["module_name"] = "Informações dos Links",
  ["module_desc"] = "Adiciona ícones e informações extras aos links exibidos no bate-papo.",
  ["full_description"] = "Este módulo adiciona ícones e informações extras aos links exibidos no bate-papo.\n\nEle pode enriquecer links de itens, feitiços, conquistas e jogadores com ícones visuais, detalhes de item, informações de classe e informações de raça quando disponíveis.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo das opções de informações dos links.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Links de Itens|r podem mostrar ícone, tipo, espaço de equipamento e nível do item.\n|cFFFFD100Links de Feitiços|r podem mostrar ícones dos feitiços.\n|cFFFFD100Links de Conquistas|r podem mostrar ícones das conquistas.\n|cFFFFD100Links de Jogadores|r podem mostrar ícone da classe, nome da classe e nome da raça.",

  -- BR: Itens | EN: Items
  ["item_group_name"] = "Links de Itens",
  ["item_group_desc"] = "Controla informações extras exibidas nos links de itens.",
  ["item_help"] = "Escolha quais detalhes devem ser adicionados aos links de itens exibidos no bate-papo.",

  ["icon_name"] = "Ícone",
  ["item_icon_desc"] = "Mostra o ícone do item antes do link.",

  ["item_type_name"] = "Tipo do Item",
  ["item_type_desc"] = "Mostra o tipo, subtipo ou espaço de equipamento dentro do link quando disponível.",

  ["item_level_name"] = "Nível do Item",
  ["item_level_desc"] = "Mostra o nível do item dentro do link quando disponível.",

  -- BR: Feitiços | EN: Spells
  ["spell_group_name"] = "Links de Feitiços",
  ["spell_group_desc"] = "Controla informações extras exibidas nos links de feitiços.",
  ["spell_help"] = "Escolha se links de feitiços devem mostrar ícones dos feitiços.",

  ["spell_icon_desc"] = "Mostra o ícone do feitiço antes do link.",

  -- BR: Conquistas | EN: Achievements
  ["achievement_group_name"] = "Links de Conquistas",
  ["achievement_group_desc"] = "Controla informações extras exibidas nos links de conquistas.",
  ["achievement_help"] = "Escolha se links de conquistas devem mostrar ícones das conquistas.",

  ["achievement_icon_desc"] = "Mostra o ícone da conquista antes do link.",

  -- BR: Jogadores | EN: Players
  ["player_group_name"] = "Links de Jogadores",
  ["player_group_desc"] = "Controla informações extras exibidas nos nomes dos jogadores.",
  ["player_help"] = "Escolha quais detalhes do personagem devem aparecer antes dos nomes dos jogadores quando essa informação estiver disponível.",

  ["class_icon_name"] = "Ícone da Classe",
  ["class_icon_desc"] = "Mostra o ícone da classe antes do nome do jogador.",

  ["class_label_name"] = "Nome da Classe",
  ["class_label_desc"] = "Mostra o nome da classe antes do nome do jogador.",

  ["race_label_name"] = "Nome da Raça",
  ["race_label_desc"] = "Mostra o nome da raça antes do nome do jogador.",
}


-- ============================================================================
-- BR: REF: modules/Memory.lua | Strings do módulo Memory (ptBR)
-- EN: REF: modules/Memory.lua | Module strings for Memory (enUS reference)
-- ============================================================================
ptBR.Memory = {
  -- BR: Geral | EN: General
  ["module_name"] = "Memória",
  ["module_desc"] = "Salva e restaura configurações das janelas de bate-papo da Blizzard.",

  -- BR: Aviso | EN: Warning
  ["warning_group_name"] = "Módulo Experimental",
  ["warning_group_desc"] = "Aviso importante sobre o funcionamento deste módulo.",
  ["warning_text"] = "|cffff6666ESTE MÓDULO É EXPERIMENTAL.|r\n\nEle tenta salvar e restaurar configurações internas do chat da Blizzard. Em versões modernas do jogo, algumas restaurações podem causar limitações, falhas visuais ou problemas de taint, especialmente em recursos ligados ao modo de edição.",

  -- BR: Ações | EN: Actions
  ["actions_group_name"] = "Comandos",
  ["actions_group_desc"] = "Salve ou carregue manualmente as configurações do bate-papo.",
  ["save_name"] = "Salvar configurações",
  ["save_desc"] = "Salva o layout atual das janelas de bate-papo, canais, cores e opções relacionadas.",
  ["load_name"] = "Carregar configurações",
  ["load_desc"] = "Restaura as configurações de bate-papo salvas anteriormente.",

  -- BR: Opções | EN: Options
  ["options_group_name"] = "Opções",
  ["options_group_desc"] = "Controla o carregamento automático das configurações salvas.",
  ["auto_load_name"] = "Carregar automaticamente",
  ["auto_load_desc"] = "Tenta carregar automaticamente as configurações salvas ao entrar no mundo.",
  ["auto_load_help"] = "Use com cuidado. O carregamento automático pode ser útil em personagens novos ou perfis diferentes, mas também pode sobrescrever ajustes feitos manualmente depois.",

  -- BR: Escopo | EN: Scope
  ["scope_group_name"] = "O Que Este Módulo Salva",
  ["scope_group_desc"] = "Lista os principais dados armazenados pelo módulo.",
  ["scope_text"] = "Este módulo pode salvar nomes e posições das janelas, tamanho da fonte, cores, transparência, canais, grupos de mensagens e algumas CVars relacionadas ao bate-papo.\n\nNo Retail, parte da restauração visual de janelas pode ser limitada para evitar problemas com o modo de edição.",

  -- BR: Mensagens | EN: Messages
  ["msg_settings_saved"] = "Configurações do bate-papo salvas.",
  ["msg_settings_loaded"] = "Configurações do bate-papo carregadas.",
  ["msg_no_settings"] = "Nenhuma configuração de bate-papo foi salva ainda.",
  ["msg_load_failed"] = "Não foi possível carregar as configurações do bate-papo.",
}


-- ============================================================================
-- BR: REF: modules/Mentions.lua | Strings do módulo Mentions (ptBR)
-- EN: REF: modules/Mentions.lua | Module strings for Mentions (enUS reference)
-- ============================================================================
ptBR.Mentions = {
  -- BR: Geral | EN: General
  ["module_name"] = "Menções",
  ["module_desc"] = "Permite mencionar jogadores usando @nome e oferece preenchimento automático com TAB.",

  -- BR: Descrição | EN: Description
  ["full_description"] = "Este módulo adiciona suporte experimental a menções de jogadores no bate-papo. Ao usar @nome em uma mensagem enviada, o Prat identifica o jogador mencionado e envia uma notificação privada para ele.",

  -- BR: Como funciona | EN: How It Works
  ["how_it_works_header"] = "Como Funciona",
  ["how_it_works"] = "Digite @nome em uma mensagem enviada pelo bate-papo. Quando a mensagem for processada, o Prat envia um sussurro automático para o jogador mencionado, incluindo a mensagem original e a origem da conversa.",

  -- BR: Recursos | EN: Features
  ["features_header"] = "Recursos",
  ["features"] = "|cFFFFD100•|r Suporte a menções no formato @nome.\n|cFFFFD100•|r Preenchimento automático com TAB.\n|cFFFFD100•|r Integração com nomes de jogadores conhecidos.\n|cFFFFD100•|r Integração com nomes de reinos quando disponível.",

  -- BR: Exemplo | EN: Example
  ["example_header"] = "Exemplo",
  ["example"] = "Mensagem enviada:\n|cFFFFD100@Danny olha isso aqui|r\n\nO jogador Danny receberá um sussurro automático contendo a mensagem e o local de origem.",

  -- BR: Aviso | EN: Warning
  ["warning"] = "|cFFFF8000Importante:|r\nEste recurso é experimental. Ele pode não funcionar durante combate no Retail e depende das informações disponíveis nos módulos de nomes de jogadores e reinos.",

  -- BR: Texto em uso | EN: Runtime Text
  ["mention_whisper_prefix"] = "(em %s) ",
  ["too_many_matches"] = "%d resultados encontrados. Continue digitando para refinar.",
}


-- ============================================================================
-- BR: REF: modules/NewcomersChat.lua | Strings do módulo NewcomersChat (ptBR)
-- EN: REF: modules/NewcomersChat.lua | Module strings for NewcomersChat (enUS reference)
-- ============================================================================
ptBR.NewcomersChat = {
  -- BR: Geral | EN: General
  ["module_name"] = "Chat de Novatos",
  ["module_desc"] = "Controla ícones e rótulos exibidos para Guias e Novatos no sistema de mentoria do Retail.",
  ["full_description"] = "Este módulo controla as marcações visuais usadas pelo sistema de mentoria do World of Warcraft Retail.\n\nEle pode mostrar ícones de Novato, ícones de Guia e rótulos de Guia de formas diferentes dependendo se você está participando como Novato ou como Guia.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do funcionamento das marcações do Chat de Novatos.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Como Novato|r controla o que você vê quando é considerado Novato.\n|cFFFFD100Como Guia|r controla o que você vê quando é Guia.\n\nCada marcação pode aparecer dentro do canal de Novatos, fora dele, ou nos dois.",

  -- BR: Como novato | EN: As Newcomer
  ["as_newcomer_tab_name"] = "Como Novato",
  ["as_newcomer_tab_desc"] = "Define quais marcações você verá quando estiver participando como novato.",
  ["as_newcomer_help"] = "Use esta aba para escolher como ícones e rótulos aparecem quando você é considerado Novato pelo sistema de mentoria da Blizzard.",

  -- BR: Como guia | EN: As Guide
  ["as_guide_tab_name"] = "Como Guia",
  ["as_guide_tab_desc"] = "Define quais marcações você verá quando estiver participando como guia.",
  ["as_guide_help"] = "Use esta aba para escolher como ícones e rótulos aparecem quando você é Guia no sistema de mentoria da Blizzard.",

  -- BR: Grupos de marcação | EN: Marker Groups
  ["newcomer_icon_group_name"] = "Ícone de Novato",
  ["newcomer_icon_group_desc"] = "Controla onde o ícone de Novato será exibido.",

  ["guide_icon_group_name"] = "Ícone de Guia",
  ["guide_icon_group_desc"] = "Controla onde o ícone de Guia será exibido.",

  ["guide_label_group_name"] = "Rótulo de Guia",
  ["guide_label_group_desc"] = "Controla onde o texto Guia será exibido ao lado do nome.",

  -- BR: Locais | EN: Locations
  ["in_newcomers_chat_name"] = "No Chat de Novatos",
  ["in_newcomers_chat_desc"] = "Mostra esta marcação dentro do canal de Novatos.",

  ["in_normal_chat_name"] = "No Bate-papo Normal",
  ["in_normal_chat_desc"] = "Mostra esta marcação fora do canal de Novatos, em conversas normais.",

  -- BR: Mensagens em uso | EN: Runtime
  ["guide_label_text"] = "Guia",
}


-- ============================================================================
-- BR: REF: modules/OriginalButtons.lua | Strings do módulo OriginalButtons (ptBR)
-- EN: REF: modules/OriginalButtons.lua | Module strings for OriginalButtons (enUS reference)
-- ============================================================================
ptBR.OriginalButtons = {
  -- BR: Geral | EN: General
  ["module_name"] = "Interface Blizzard",
  ["module_desc"] = "Controla os botões e elementos nativos das janelas de bate-papo da Blizzard.",
  ["full_description"] = "Este módulo controla os elementos nativos das janelas de bate-papo da Blizzard, como setas de navegação, menu do bate-papo, botão de retorno ao final, moldura dos botões, posição e transparência.\n\nUse este módulo quando quiser preservar ou ajustar o comportamento clássico dos controles originais do jogo.",

  -- BR: Janelas | EN: Windows
  ["windows_header"] = "Aplicar nas Janelas",

  ["chat_arrows_name"] = "Mostrar Setas",
  ["chat_arrows_desc"] = "Define em quais janelas as setas originais de navegação do bate-papo devem aparecer.",

  -- BR: Elementos | EN: Elements
  ["elements_header"] = "Elementos Visíveis",

  ["chat_menu_name"] = "Mostrar Menu do Bate-papo",
  ["chat_menu_desc"] = "Mostra ou oculta o botão original do menu do bate-papo da Blizzard.",

  ["reminder_name"] = "Mostrar Botão de Retorno",
  ["reminder_desc"] = "Mostra um botão para retornar ao final da janela quando você estiver lendo mensagens antigas.",

  ["button_frame_name"] = "Mostrar Moldura dos Botões",
  ["button_frame_desc"] = "Mostra ou oculta a moldura original que agrupa os botões de navegação da janela de bate-papo.",

  -- BR: Aparência | EN: Appearance
  ["appearance_header"] = "Aparência",

  ["position_name"] = "Posição dos Botões",
  ["position_desc"] = "Define onde os botões originais da janela de bate-papo serão posicionados.",

  ["position_default"] = "Padrão",
  ["position_right_inside"] = "Direita, Dentro da Janela",
  ["position_right_outside"] = "Direita, Fora da Janela",

  ["alpha_name"] = "Transparência",
  ["alpha_desc"] = "Define a transparência dos botões originais do bate-papo.",

  -- BR: Aviso | EN: Warning
  ["conflict_warning"] = "|cFFFF8000Importante:|r\nEste módulo controla os botões originais da Blizzard e pode conflitar com o módulo Controles do Bate-papo. Ao ativar este módulo, o Prat desativa automaticamente o módulo moderno de controles para evitar conflito.",
}


-- ============================================================================
-- BR: REF: modules/Paragraph.lua | Strings do módulo Paragraph (ptBR)
-- EN: REF: modules/Paragraph.lua | Module strings for Paragraph (enUS reference)
-- ============================================================================
ptBR.Paragraph = {
  -- BR: Geral | EN: General
  ["module_name"] = "Alinhamento de Texto",
  ["module_desc"] = "Permite ajustar o alinhamento do texto e o espaçamento entre linhas das janelas de bate-papo.",
  ["full_description"] = "Este módulo controla o alinhamento horizontal do texto e o espaçamento entre linhas nas janelas de bate-papo.\n\nCada janela pode usar seu próprio alinhamento, enquanto o espaçamento entre linhas é aplicado globalmente a todas as janelas de bate-papo.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do funcionamento do alinhamento de texto.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Alinhamento|r controla se cada janela usa texto à esquerda, centralizado ou à direita.\n|cFFFFD100Espaçamento|r controla o espaço vertical entre as linhas do bate-papo.",

  -- BR: Alinhamento | EN: Alignment
  ["alignment_tab_name"] = "Alinhamento",
  ["alignment_tab_desc"] = "Controla o alinhamento horizontal por janela de bate-papo.",
  ["alignment_help"] = "Escolha o alinhamento horizontal do texto para cada janela de bate-papo. O alinhamento à esquerda é a opção mais segura para links clicáveis.",
  ["alignment_group_name"] = "Alinhamento das Janelas",
  ["alignment_group_desc"] = "Define o alinhamento horizontal do texto em cada janela de bate-papo.",
  ["alignment_option_desc"] = "Escolha o alinhamento do texto para esta janela.",

  ["align_left"] = "Esquerda",
  ["align_center"] = "Centro",
  ["align_right"] = "Direita",

  -- BR: Espaçamento | EN: Spacing
  ["spacing_tab_name"] = "Espaçamento entre Linhas",
  ["spacing_tab_desc"] = "Controla o espaçamento vertical entre as linhas do bate-papo.",
  ["spacing_help"] = "Ajuste o espaço vertical entre as mensagens do bate-papo. Valores maiores deixam as mensagens mais separadas.",
  ["spacing_name"] = "Espaçamento entre Linhas",
  ["spacing_desc"] = "Define o espaçamento entre linhas para todas as janelas de bate-papo.",

  -- BR: Aviso | EN: Warning
  ["alignment_warning"] = "|cFFFF8000IMPORTANTE:|r\nLinks de jogadores, itens e outros hyperlinks podem deixar de funcionar quando o alinhamento estiver definido como Centro ou Direita.",
}


-- ============================================================================
-- BR: REF: modules/PlayerNames.lua | Strings do módulo PlayerNames (ptBR)
-- EN: REF: modules/PlayerNames.lua | Module strings for PlayerNames (enUS reference)
-- ============================================================================
ptBR.PlayerNames = {
  
  -- BR: Geral | EN: General
  ["module_name"] = "Nomes de Jogadores",
  ["module_desc"] = "Controla aparência, informações extras, Battle.net, autocompletar e cache dos nomes de jogadores.",

  -- BR: Aparência | EN: Appearance
  ["appearance_tab_name"] = "Aparência",
  ["appearance_tab_desc"] = "Controla colchetes, cores e modos de coloração dos nomes.",

  ["bracket_group_name"] = "Colchetes",
  ["bracket_group_desc"] = "Define o estilo e a cor dos colchetes usados ao redor dos nomes.",
  ["brackets_name"] = "Estilo dos Colchetes",
  ["brackets_desc"] = "Escolhe o tipo de colchete usado ao redor dos nomes dos jogadores.",
  ["brackets_square"] = "Quadrados",
  ["brackets_angled"] = "Angulares",
  ["brackets_none"] = "Nenhum",
  ["brackets_common_color_name"] = "Cor Comum nos Colchetes",
  ["brackets_common_color_desc"] = "Usa uma cor fixa para todos os colchetes dos nomes.",
  ["brackets_color_name"] = "Cor dos Colchetes",
  ["brackets_color_desc"] = "Define a cor comum usada nos colchetes.",

  ["color_group_name"] = "Cores dos Nomes",
  ["color_group_desc"] = "Controla como os nomes e níveis dos jogadores serão coloridos.",
  ["color_mode_name"] = "Cor dos Jogadores",
  ["color_mode_desc"] = "Define como os nomes dos jogadores serão coloridos.",
  ["level_color_name"] = "Cor do Nível",
  ["level_color_desc"] = "Define como o nível dos jogadores será colorido.",
  ["color_random"] = "Aleatória",
  ["color_class"] = "Classe",
  ["color_none"] = "Nenhuma",
  ["level_color_player"] = "Usar Cor do Jogador",
  ["level_color_channel"] = "Usar Cor do Canal",
  ["level_color_difficulty"] = "Colorir pela Diferença de Nível",
  ["level_color_none"] = "Sem Cor Adicional",
  ["use_common_color_name"] = "Cor Comum para Desconhecidos",
  ["use_common_color_desc"] = "Usa uma cor fixa para jogadores cuja classe ainda não foi identificada.",
  ["unknown_color_name"] = "Cor dos Desconhecidos",
  ["unknown_color_desc"] = "Define a cor usada para jogadores desconhecidos.",
  ["color_everywhere_name"] = "Colorir Nomes Globalmente",
  ["color_everywhere_desc"] = "Aplica a coloração dos nomes em todos os locais processados pelo Prat.",

  -- BR: Informações | EN: Information
  ["information_tab_name"] = "Informações",
  ["information_tab_desc"] = "Controla informações extras exibidas junto ao nome do jogador.",
  ["extra_info_group_name"] = "Informações Exibidas",
  ["extra_info_group_desc"] = "Escolhe quais informações adicionais aparecerão junto aos nomes.",
  ["level_name"] = "Mostrar Nível",
  ["level_desc"] = "Mostra o nível conhecido do jogador junto ao nome.",
  ["subgroup_name"] = "Mostrar Subgrupo da Raide",
  ["subgroup_desc"] = "Mostra o número do subgrupo da raide junto ao nome do jogador, quando disponível.",
  ["show_target_icon_name"] = "Mostrar Ícone de Alvo",
  ["show_target_icon_desc"] = "Mostra o ícone de alvo de raide aplicado ao jogador.",
  ["bnet_client_icon_name"] = "Mostrar Ícone do Cliente Battle.net",
  ["bnet_client_icon_desc"] = "Mostra o ícone do jogo ou cliente Battle.net associado ao contato.",

  -- BR: Battle.net | EN: Battle.net
  ["battle_net_tab_name"] = "Battle.net",
  ["battle_net_tab_desc"] = "Controla exibição e coloração de contatos Battle.net.",
  ["battle_net_group_name"] = "Contatos Battle.net",
  ["battle_net_group_desc"] = "Define como nomes Battle.net serão exibidos e coloridos.",
  ["real_id_color_name"] = "Cor Battle.net",
  ["real_id_color_desc"] = "Define como nomes Battle.net serão coloridos.",
  ["real_id_name_name"] = "Mostrar Nome do Personagem",
  ["real_id_name_desc"] = "Mostra o nome do personagem jogado pelo contato em vez do nome Battle.net, quando essa informação estiver disponível.",

  -- BR: Autocompletar | EN: Autocomplete
  ["autocomplete_tab_name"] = "Autocompletar",
  ["autocomplete_tab_desc"] = "Controla o preenchimento automático de nomes conhecidos.",
  ["autocomplete_group_name"] = "Preenchimento Automático",
  ["autocomplete_group_desc"] = "Permite completar nomes conhecidos automaticamente ao pressionar TAB no bate-papo.",
  ["tab_complete_name"] = "Ativar Preenchimento com TAB",
  ["tab_complete_desc"] = "Completa automaticamente nomes conhecidos ao pressionar TAB. Usa nomes já vistos, amigos, grupo, guilda e dados armazenados pelo módulo.",
  ["tab_complete_limit_name"] = "Limite de Sugestões",
  ["tab_complete_limit_desc"] = "Define quantas sugestões podem aparecer antes de o Prat mostrar um aviso de excesso de nomes encontrados.",

  -- BR: Cache | EN: Cache
  ["cache_tab_name"] = "Cache",
  ["cache_tab_desc"] = "Controla armazenamento e consulta de informações de jogadores.",
  ["cache_group_name"] = "Armazenamento de Dados",
  ["cache_group_desc"] = "Controla como o Prat memoriza classe, nível, grupo e outros dados de jogadores vistos no bate-papo.",
  ["keep_name"] = "Salvar Dados de Amigos e Guilda",
  ["keep_desc"] = "Mantém entre sessões os dados conhecidos de amigos e membros da guilda, como classe e nível.",
  ["keep_lots_name"] = "Salvar Dados de Todos os Jogadores",
  ["keep_lots_desc"] = "Mantém entre sessões os dados de todos os jogadores encontrados, exceto personagens de outros reinos.",
  ["use_who_name"] = "Consultar Jogadores Desconhecidos",
  ["use_who_desc"] = "Consulta o servidor para tentar descobrir classe e nível de jogadores desconhecidos. Esse processo é lento e não salva os dados consultados.",
  ["reset_name"] = "Limpar Dados Armazenados",
  ["reset_desc"] = "Apaga os dados armazenados de jogadores, como classes e níveis conhecidos.",

  -- BR: Mensagens | EN: Messages
  ["msg_stored_data_cleared"] = "Dados armazenados de jogadores foram apagados.",
  ["too_many_matches"] = "Muitas correspondências (%d possíveis)",
}


-- ============================================================================
-- BR: REF: modules/PopupMessage.lua | Strings do módulo PopupMessage (ptBR)
-- EN: REF: modules/PopupMessage.lua | Module strings for PopupMessage (enUS reference)
-- ============================================================================
ptBR.PopupMessage = {
  -- BR: Geral | EN: General
  ["module_name"] = "Alertas",
  ["module_desc"] = "Detecta quando seu nome ou nomes monitorados aparecem nas mensagens e gera alertas visuais ou sonoros.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Explica o que este módulo monitora e quando ele gera alertas.",
  ["full_description"] = "Este módulo monitora mensagens do bate-papo procurando pelo nome do seu personagem e pelos nomes monitorados cadastrados.\n\nQuando uma correspondência é encontrada, o Prat pode gerar um alerta visual, tocar som e enviar a mensagem para uma das saídas configuradas abaixo. Use os nomes monitorados para incluir apelidos, variações do seu nome ou outros termos importantes.",

  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Saída|r controla para onde os alertas serão enviados.\n|cFFFFD100Janelas Monitoradas|r controla quais janelas de bate-papo serão verificadas.\n|cFFFFD100Nomes Monitorados|r permite adicionar apelidos, grafias alternativas ou termos importantes.\n|cFFFFD100Aparência|r controla a opacidade da janela popup.",

  -- BR: Saída | EN: Output
  ["output_tab_name"] = "Destino dos Alertas",
  ["output_tab_desc"] = "Escolha para onde os alertas serão enviados.",
  ["output_help"] = "Configure a saída usada quando uma mensagem monitorada for encontrada. A opção Popup usa a janela visual própria deste módulo.",

  ["sink_group_name"] = "Saída dos Alertas",
  ["sink_group_desc"] = "Define onde os alertas serão exibidos.",
  ["popup_sink_name"] = "Popup",
  ["popup_sink_desc"] = "Mostra mensagens em uma janela popup.",
  ["sink_subsection_name"] = "Subseção",
  ["sink_subsection_desc"] = "Escolha o canal, janela ou destino específico usado pela saída selecionada.",

  -- BR: Janelas monitoradas | EN: Monitored Windows
  ["windows_tab_name"] = "Janelas Monitoradas",
  ["windows_tab_desc"] = "Escolha quais janelas de bate-papo serão monitoradas.",
  ["windows_help"] = "Selecione as janelas de bate-papo onde o módulo deve procurar seu nome e os nomes monitorados.",

  ["show_all_name"] = "Monitorar Todas as Janelas",
  ["show_all_desc"] = "Gera alertas para mensagens correspondentes vindas de qualquer janela de bate-papo.",

  ["show_name"] = "Monitorar Janelas Selecionadas",
  ["show_desc"] = "Gera alertas apenas para mensagens vindas das janelas selecionadas.",

  -- BR: Nomes monitorados | EN: Monitored Names
  ["names_tab_name"] = "Nomes Monitorados",
  ["names_tab_desc"] = "Cadastre apelidos, variações do seu nome ou outros termos importantes.",
  ["names_help"] = "O nome do seu personagem já é monitorado automaticamente. Use esta lista para adicionar apelidos, grafias alternativas ou outros nomes que também devem gerar alerta.",

  ["names_group_name"] = "Lista de Nomes",
  ["names_group_desc"] = "Gerencie nomes extras que também disparam alertas.",

  ["add_name"] = "Adicionar Nome",
  ["add_desc"] = "Adiciona um nome, apelido ou termo importante à lista monitorada.",
  ["add_usage"] = "<nome ou termo>",

  ["remove_name"] = "Remover Nome",
  ["remove_desc"] = "Remove um nome da lista monitorada.",

  ["clear_name"] = "Limpar Lista",
  ["clear_desc"] = "Remove todos os nomes monitorados adicionados manualmente.",

  -- BR: Aparência | EN: Appearance
  ["appearance_tab_name"] = "Aparência",
  ["appearance_tab_desc"] = "Controla a janela visual de popup.",
  ["appearance_help"] = "Ajuste a opacidade usada quando o popup está totalmente visível. O popup continuará surgindo e desaparecendo automaticamente.",

  ["frame_alpha_name"] = "Opacidade do Popup",
  ["frame_alpha_desc"] = "Define a opacidade da janela popup quando estiver totalmente visível.",
}


-- ============================================================================
-- BR: REF: modules/Scroll.lua | Strings do módulo Scroll (ptBR)
-- EN: REF: modules/Scroll.lua | Module strings for Scroll (enUS reference)
-- ============================================================================
ptBR.Scroll = {
  -- BR: Geral | EN: General
  ["module_name"] = "Rolagem",
  ["module_desc"] = "Controla a rolagem das janelas de bate-papo com mouse, atalhos e retorno automático ao final.",
  ["full_description"] = "Este módulo controla como as janelas de bate-papo respondem à rolagem.\n\nVocê pode ativar a rolagem com o mouse por janela, ajustar velocidades, usar atalhos com teclas modificadoras e configurar retorno automático ao final da conversa.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo das opções de rolagem.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Rolagem com Mouse|r controla quais janelas aceitam a roda do mouse e a velocidade da rolagem.\n|cFFFFD100Retorno Automático|r leva a janela de volta ao final após um tempo definido.\n|cFFFFD100Avançado|r mantém opções legadas ou desativadas por limitações do jogo.",

  -- BR: Rolagem com mouse | EN: Mouse Wheel
  ["mousewheel_tab_name"] = "Rolagem com Mouse",
  ["mousewheel_tab_desc"] = "Controla o uso da roda do mouse nas janelas de bate-papo.",
  ["mousewheel_help"] = "Escolha em quais janelas a roda do mouse ficará ativa.\n\nUse a rolagem normal para subir ou descer mensagens. Segure Shift para rolar mais rápido. Segure Ctrl para saltar diretamente para o topo ou para o final.",

  ["mousewheel_name"] = "Ativar nas seguintes janelas",
  ["mousewheel_desc"] = "Define quais janelas de bate-papo respondem à roda do mouse.",

  ["normal_scroll_speed_name"] = "Velocidade da Rolagem",
  ["normal_scroll_speed_desc"] = "Define quantas linhas serão roladas a cada movimento normal da roda do mouse.",

  ["shift_scroll_speed_name"] = "Velocidade com Shift",
  ["shift_scroll_speed_desc"] = "Define quantas linhas serão roladas ao usar Shift + roda do mouse.",

  -- BR: Retorno automático | EN: Automatic Return
  ["low_down_tab_name"] = "Retorno Automático",
  ["low_down_tab_desc"] = "Controla o retorno automático da janela ao final da conversa.",
  ["low_down_help"] = "Quando você sobe o histórico de mensagens, este recurso pode levar a janela de volta ao final automaticamente após alguns segundos.\n\nÉ útil para evitar que uma janela fique parada no meio do histórico enquanto novas mensagens chegam.",

  ["low_down_name"] = "Ativar nas seguintes janelas",
  ["low_down_desc"] = "Define quais janelas usarão retorno automático ao final.",

  ["low_down_delay_name"] = "Tempo para Retornar",
  ["low_down_delay_desc"] = "Define quantos segundos o módulo deve esperar antes de levar a janela de volta ao final.",

  -- BR: Avançado | EN: Advanced
  ["advanced_tab_name"] = "Avançado",
  ["advanced_tab_desc"] = "Opções legadas e comportamentos especiais.",
  ["advanced_help"] = "Esta aba reúne opções antigas ou mantidas por compatibilidade. Algumas opções podem permanecer ocultas por limitações ou bugs do próprio jogo.",

  ["scroll_direction_name"] = "Direção de Inserção",
  ["scroll_direction_desc"] = "Define a direção de inserção do texto. Esta opção está oculta por causa de uma limitação antiga da Blizzard.",
  ["scroll_direction_top"] = "Superior",
  ["scroll_direction_bottom"] = "Inferior",
}


-- ============================================================================
-- BR: REF: modules/Search.lua | Strings do módulo Search (ptBR)
-- EN: REF: modules/Search.lua | Module strings for Search (enUS reference)
-- ============================================================================
ptBR.Search = {
  -- BR: Geral | EN: General
  ["module_name"] = "Pesquisa no Histórico",
  ["module_desc"] = "Adiciona caixas de pesquisa às janelas de bate-papo e permite localizar mensagens antigas com o comando /find.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Explica como a pesquisa no histórico do bate-papo funciona.",
  ["full_description"] = "Este módulo adiciona uma caixa de pesquisa em cada janela de bate-papo e permite buscar mensagens já exibidas no histórico.\n\nVocê também pode usar o comando /find para pesquisar na janela de bate-papo selecionada.",

  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "Use a caixa de pesquisa em uma janela de bate-papo ou digite:\n\n/find <texto>\n\nExemplo:\n/find convite",

  -- BR: Aparência | EN: Appearance
  ["appearance_tab_name"] = "Aparência",
  ["appearance_tab_desc"] = "Controla a transparência da caixa de pesquisa quando está ativa ou em repouso.",
  ["appearance_help"] = "Ajuste a visibilidade da caixa de pesquisa quando ela estiver em foco ou inativa. Uma opacidade menor em repouso mantém o bate-papo mais limpo enquanto a caixa não está sendo usada.",

  ["search_inactive_alpha_name"] = "Opacidade em Repouso",
  ["search_inactive_alpha_desc"] = "Define a opacidade da caixa de pesquisa quando ela não está em foco.",

  ["search_active_alpha_name"] = "Opacidade Durante Uso",
  ["search_active_alpha_desc"] = "Define a opacidade da caixa de pesquisa quando ela está ativa ou em foco.",

  -- BR: Mensagens em uso | EN: Runtime Messages
  ["find_results"] = "Resultados da pesquisa",
  ["err_too_short"] = "Digite pelo menos dois caracteres para pesquisar.",
  ["err_not_found"] = "Nenhuma mensagem encontrada.",
  ["result_summary_single"] = "Encontrado %d resultado para: \"%s\"",
  ["result_summary_plural"] = "Encontrados %d resultados para: \"%s\"",
  ["end_search_marker"] = "\n------------------ FIM DA PESQUISA ------------------",
  ["bnet_removed"] = "<BNET REMOVIDO>",
}


-- ============================================================================
-- BR: REF: modules/ServerNames.lua | Strings do módulo ServerNames (ptBR)
-- EN: REF: modules/ServerNames.lua | Module strings for ServerNames (enUS reference)
-- ============================================================================
ptBR.ServerNames = {
  -- BR: Geral | EN: General
  ["module_name"] = "Nomes de Reinos",
  ["module_desc"] = "Controla como os nomes dos reinos aparecem no bate-papo.",

  -- BR: Comportamento | EN: Behavior
  ["behavior_tab_name"] = "Exibição",
  ["behavior_tab_desc"] = "Controla o comportamento geral dos nomes de reinos no bate-papo.",
  ["behavior_group_name"] = "Comportamento dos Reinos",
  ["behavior_group_desc"] = "Define se os nomes dos reinos serão ocultados, abreviados ou coloridos.",
  ["behavior_help"] = "Essas opções afetam todos os nomes de reinos exibidos no bate-papo. As configurações por reino ficam disponíveis conforme o Prat detecta jogadores de outros reinos.",

  ["hide_name"] = "Ocultar Reino",
  ["hide_desc"] = "Remove o nome do reino das mensagens exibidas no bate-papo.",
  ["auto_abbreviate_name"] = "Abreviar Automaticamente",
  ["auto_abbreviate_desc"] = "Mostra apenas uma abreviação curta do nome do reino.",
  ["random_color_name"] = "Usar Cores Aleatórias",
  ["random_color_desc"] = "Aplica uma cor aleatória diferente para cada reino detectado.",

  -- BR: Reinos detectados | EN: Detected Realms
  ["detected_servers_tab_name"] = "Reinos Detectados",
  ["detected_servers_tab_desc"] = "Permite ajustar abreviações e cores de reinos encontrados no bate-papo.",
  ["server_settings_desc"] = "Configura como o reino %s será exibido.",
  ["server_selected_help"] = "Ajuste abaixo como o reino %s aparecerá no bate-papo.",

  ["replace_name"] = "Usar Nome Personalizado",
  ["replace_desc"] = "Substitui o nome original do reino por um texto personalizado.",
  ["short_name_name"] = "Nome Exibido",
  ["short_name_desc"] = "Define o texto que substituirá o nome original do reino.",
  ["custom_color_name"] = "Usar Cor Personalizada",
  ["custom_color_desc"] = "Usa uma cor fixa para este reino específico.",
  ["color_name"] = "Cor do Reino",
  ["color_desc"] = "Define a cor personalizada usada para este reino.",
}


-- ============================================================================
-- BR: REF: modules/SideTabs.lua | Strings do módulo SideTabs (ptBR)
-- EN: REF: modules/SideTabs.lua | Module strings for SideTabs (enUS reference)
-- ============================================================================
ptBR.SideTabs = {
  -- BR: Geral | EN: General
  ["module_name"] = "Abas Laterais",
  ["module_desc"] = "Move as abas das janelas de bate-papo para a lateral e as organiza verticalmente.",

  -- BR: Posição | EN: Position
  ["position_tab_name"] = "Posição",
  ["position_tab_desc"] = "Define onde as abas laterais ficam em relação à janela de bate-papo.",
  ["position_help"] = "Use esta seção para escolher o lado das abas e ajustar o encaixe delas em relação à janela do bate-papo.",

  ["layout_group_name"] = "Posicionamento",
  ["layout_group_desc"] = "Controla o lado e o posicionamento geral das abas laterais.",

  ["side_name"] = "Lado",
  ["side_desc"] = "Escolhe em qual lado da janela de bate-papo as abas ficarão ancoradas.",
  ["side_left"] = "Esquerda",
  ["side_right"] = "Direita",

  ["x_offset_name"] = "Deslocamento X",
  ["x_offset_desc"] = "Move as abas horizontalmente a partir da borda de referência.",
  ["y_offset_name"] = "Deslocamento Y",
  ["y_offset_desc"] = "Move a primeira aba verticalmente a partir do topo da janela.",
  ["spacing_name"] = "Espaçamento",
  ["spacing_desc"] = "Define o espaço entre as abas empilhadas verticalmente.",

  -- BR: Tamanho | EN: Size
  ["size_tab_name"] = "Tamanho",
  ["size_tab_desc"] = "Controla largura, altura e escala das abas laterais.",
  ["size_help"] = "Use esta seção para ajustar o tamanho visual das abas. A largura cresce para a direita para deixar o ajuste mais previsível.",

  ["sizing_group_name"] = "Medidas",
  ["sizing_group_desc"] = "Controla largura, altura e escala das abas laterais.",

  ["tab_width_name"] = "Largura da Aba",
  ["tab_width_desc"] = "Define a largura fixa das abas. A largura cresce para a direita para tornar o ajuste mais intuitivo.",
  ["tab_height_name"] = "Altura da Aba",
  ["tab_height_desc"] = "Define a altura das abas na pilha vertical.",
  ["tab_scale_name"] = "Escala da Aba",
  ["tab_scale_desc"] = "Ajusta a escala visual das abas sem alterar diretamente largura e altura.",
  ["normalize_ui_scale_name"] = "Normalizar pela Escala da UI",
  ["normalize_ui_scale_desc"] = "Compensa tamanho e deslocamentos usando a escala nativa da interface do WoW.",

  -- BR: Texto | EN: Text
  ["text_tab_name"] = "Texto",
  ["text_tab_desc"] = "Controla a aparência do texto exibido nas abas.",
  ["text_help"] = "Use esta seção para ajustar fonte, tamanho e cor dos textos das abas.",

  ["text_group_name"] = "Aparência do Texto",
  ["text_group_desc"] = "Controla fonte, tamanho e cor do texto das abas.",

  ["font_face_name"] = "Fonte",
  ["font_face_desc"] = "Escolhe a fonte usada no texto das abas.",
  ["font_size_name"] = "Tamanho da Fonte",
  ["font_size_desc"] = "Define o tamanho da fonte usada nas abas.",
  ["font_color_name"] = "Cor da Fonte",
  ["font_color_desc"] = "Define a cor do texto das abas.",

  -- BR: Visual | EN: Visual
  ["visual_tab_name"] = "Visual",
  ["visual_tab_desc"] = "Controla aparência geral e aplicação em janelas desacopladas.",
  ["visual_help"] = "Use esta seção para definir se o módulo também afeta janelas desacopladas e se as abas usarão um visual mais limpo.",

  ["behavior_group_name"] = "Aplicação e Aparência",
  ["behavior_group_desc"] = "Controla aplicação em janelas desacopladas e aparência simplificada.",

  ["undocked_name"] = "Aplicar em janelas desacopladas",
  ["undocked_desc"] = "Também move as abas de janelas de bate-papo que não estão acopladas ao dock principal.",
  ["simple_skin_name"] = "Usar visual simples",
  ["simple_skin_desc"] = "Oculta a arte padrão das abas e usa um fundo simples para uma aparência mais limpa.",

  -- BR: Rótulos | EN: Labels
  ["tab_labels_tab_name"] = "Rótulos",
  ["tab_labels_group_desc"] = "Permite substituir o texto das abas por símbolos, formas ou textos personalizados.",

  ["labels_enabled_name"] = "Ativar rótulos por aba",
  ["labels_enabled_desc"] = "Permite configurar um rótulo diferente para cada aba de bate-papo.",
  ["tab_labels_help"] = "Configure cada aba abaixo. O modo Padrão mantém o nome original; Símbolo, Forma Colorida e Texto Personalizado substituem o rótulo exibido.",
  ["tab_label_frame_help"] = "Escolha como esta aba específica será exibida.",

  ["label_mode_name"] = "Modo do Rótulo",
  ["label_mode_desc"] = "Define como o rótulo desta aba será exibido.",
  ["label_mode_default"] = "Nome Padrão",
  ["label_mode_preset"] = "Símbolo / Ícone",
  ["label_mode_shape"] = "Forma Colorida",
  ["label_mode_custom"] = "Texto Personalizado",

  ["label_preset_name"] = "Símbolo / Ícone",
  ["label_preset_desc"] = "Escolha um marcador visual nativo para esta aba.",

  ["preset_star"] = "Estrela",
  ["preset_circle"] = "Círculo",
  ["preset_diamond"] = "Diamante",
  ["preset_triangle"] = "Triângulo",
  ["preset_moon"] = "Lua",
  ["preset_skull"] = "Caveira",

  ["label_shape_name"] = "Forma",
  ["label_shape_desc"] = "Escolha uma forma simples para representar esta aba.",
  ["shape_square"] = "Quadrado",
  ["shape_circle"] = "Círculo",

  ["label_color_name"] = "Cor da Forma",
  ["label_color_desc"] = "Define a cor da forma exibida nesta aba.",

  ["custom_label_name"] = "Texto Personalizado",
  ["custom_label_desc"] = "Define um texto, símbolo ou emoji personalizado para esta aba.",
}


-- ============================================================================
-- BR: REF: modules/Sounds.lua | Strings do módulo Sounds (ptBR)
-- EN: REF: modules/Sounds.lua | Module strings for Sounds (enUS reference)
-- ============================================================================
ptBR.Sounds = {
  -- BR: Geral | EN: General
  ["module_name"] = "Sons",
  ["module_desc"] = "Permite tocar sons diferentes para tipos específicos de mensagens do bate-papo.",
  ["full_description"] = "Este módulo toca sons quando tipos específicos de mensagens do bate-papo são recebidos ou enviados.\n\nVocê pode configurar sons separados para mensagens recebidas, mensagens enviadas, líderes de grupo, sussurros, sussurros Battle.net e canais personalizados detectados.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do comportamento dos sons.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100Sons de Entrada|r controla sons para mensagens recebidas de outros jogadores.\n|cFFFFD100Sons de Saída|r controla sons para mensagens enviadas por você.\n|cFFFFD100Canais Personalizados|r permite que canais detectados usem sons próprios.\n\nSelecionar um som reproduz ele imediatamente como prévia. Use \"Nenhum\" para desativar um som.",

  -- BR: Sons de entrada | EN: Incoming Sounds
  ["incoming_tab_name"] = "Sons de Entrada",
  ["incoming_tab_desc"] = "Define sons para mensagens recebidas de outros jogadores.",
  ["incoming_help"] = "Escolha qual som será tocado quando cada tipo de mensagem recebida for detectado.",

  -- BR: Sons de saída | EN: Outgoing Sounds
  ["outgoing_tab_name"] = "Sons de Saída",
  ["outgoing_tab_desc"] = "Define sons para mensagens enviadas por você.",
  ["outgoing_help"] = "Escolha qual som será tocado quando cada tipo de mensagem enviada for detectado.",

  -- BR: Canais personalizados | EN: Custom Channels
  ["custom_channels_tab_name"] = "Canais Personalizados",
  ["custom_channels_tab_desc"] = "Define sons para canais personalizados detectados pelo Prat.",
  ["custom_channels_help"] = "Os canais personalizados detectados aparecem abaixo. Você pode atribuir um som para cada nome de canal.",
  ["custom_channels_group_name"] = "Canais Detectados",
  ["custom_channels_group_desc"] = "Seleção de som para canais personalizados detectados.",
  ["custom_channel_desc"] = "Som usado para mensagens do canal personalizado: %s.",

  -- BR: Rótulos de direção | EN: Direction Labels
  ["incoming"] = "entrada",
  ["outgoing"] = "saída",

  -- BR: Tipos de mensagem | EN: Message Types
  ["party_name"] = "Grupo",
  ["party_desc"] = "Som usado para mensagens de %s no grupo.",
  ["raid_name"] = "Raide",
  ["raid_desc"] = "Som usado para mensagens de %s no raide.",
  ["guild_name"] = "Guilda",
  ["guild_desc"] = "Som usado para mensagens de %s na guilda.",
  ["officer_name"] = "Oficial",
  ["officer_desc"] = "Som usado para mensagens de %s no canal de oficiais.",
  ["whisper_name"] = "Sussurro",
  ["whisper_desc"] = "Som usado para mensagens de %s por sussurro.",
  ["bn_whisper_name"] = "Sussurro Battle.net",
  ["bn_whisper_desc"] = "Som usado para mensagens de %s por sussurro Battle.net.",
  ["group_lead_name"] = "Líder do Grupo",
  ["group_lead_desc"] = "Som usado para mensagens de %s vindas de líderes, guias ou avisos de raide.",
}


-- ============================================================================
-- BR: REF: modules/Substitutions.lua | Strings do módulo Substitutions (ptBR)
-- EN: REF: modules/Substitutions.lua | Module strings for Substitutions (enUS reference)
-- ============================================================================
ptBR.Substitutions = {
  -- BR: Geral | EN: General
  ["Substitutions"] = "Substituições",
  ["A module to provide basic chat substitutions."] = "Um módulo para fornecer substituições básicas no chat.",
  ["User defined substitutions"] = "Substituições definidas pelo usuário",
  ["Options for setting and removing user defined substitutions. (NB: users may define custom values for existing substitutions, but they will revert to the default value if the user definition is deleted.)"] = "Opções para definir e remover substituições criadas pelo usuário. (Obs.: usuários podem definir valores personalizados para substituições existentes, mas elas retornarão ao valor padrão se a definição criada pelo usuário for apagada.)",
  ["Set substitution"] = "Definir substituição",
  ["Set the value of a user defined substitution (NB: this may be the same as an existing default substitution; to reset it to the default, just remove the user created definition)."] = "Define o valor de uma substituição criada pelo usuário. (Obs.: isto pode ser igual a uma substituição padrão existente; para restaurar o padrão, basta remover a definição criada pelo usuário.)",
  ["subname = text after expansion -- NOTE: sub name without the prefix \"%\""] = "nomesub = texto após expansão -- NOTA: nome da substituição sem o prefixo \"%\"",
  ["List substitutions"] = "Listar substituições",
  ["Lists all current subtitutions in the default chat frame"] = "Lista todas as substituições atuais na janela de chat padrão",
  ["Delete substitution"] = "Apagar substituição",
  ["Deletes a user defined substitution"] = "Apaga uma substituição definida pelo usuário",
  ["subname -- NOTE: sub name without the prefix '%'"] = "nomesub -- NOTA: nome da substituição sem o prefixo '%'",
  ["Are you sure?"] = "Tem certeza?",
  ["Delete all"] = "Apagar tudo",
  ["Deletes all user defined substitutions"] = "Apaga todas as substituições definidas pelo usuário",
  ["Are you sure - this will delete all user defined substitutions and reset defaults?"] = "Tem certeza? Isto apagará todas as substituições definidas pelo usuário e restaurará os padrões.",
  ["List of available substitutions"] = "Lista de substituições disponíveis",
  ["List of available substitutions defined by this module. (NB: users may define custom values for existing substitutions, but they will revert to the default value if the user definition is deleted.)"] = "Lista de substituições disponíveis definidas por este módulo. (Obs.: usuários podem definir valores personalizados para substituições existentes, mas elas retornarão ao valor padrão se a definição criada pelo usuário for apagada.)",
  ["NO MATCHFUNC FOUND"] = "NENHUMA MATCHFUNC ENCONTRADA",
  ["current-prompt"] = "Marcador: '%s'\n\nClique para copiar. Cole no chat (Ctrl+V).\nDigite o token manualmente para substituir.",
  ["no substitution name given"] = "nenhum nome de substituição informado",
  ["no value given for subtitution \"%s\""] = "nenhum valor informado para a substituição \"%s\"",
  ["|cffff0000warning:|r subtitution \"%s\" already defined as \"%s\", overwriting"] = "|cffff0000aviso:|r substituição \"%s\" já definida como \"%s\", sobrescrevendo",
  ["defined %s: expands to => %s"] = "%s definida: expande para => %s",
  ["no substitution name supplied for deletion"] = "nenhum nome de substituição fornecido para exclusão",
  ["no user defined subs found"] = "nenhuma substituição definida pelo usuário encontrada",
  ["user defined substition \"%s\" not found"] = "substituição definida pelo usuário \"%s\" não encontrada",
  ["user substitutions index (usersubs_idx) doesn't exist! oh dear."] = "índice de substituições do usuário (usersubs_idx) não existe! vixe.",
  ["can't find substitution index for a substitution named '%s'"] = "não foi possível encontrar o índice da substituição chamada '%s'",
  ["removing user defined substitution \"%s\"; previously expanded to => \"%s\""] = "removendo substituição definida pelo usuário \"%s\"; anteriormente expandia para => \"%s\"",
  ["substitution: %s defined as => %s"] = "substituição: %s definida como => %s",
  ["%d total user defined substitutions"] = "%d substituições definidas pelo usuário no total",
  ["module:buildUserSubsIndex(): warning: module patterns not defined!"] = "module:buildUserSubsIndex(): aviso: patterns do módulo não definidos!",
  ["<notarget>"] = "<semalvo>",
  ["male"] = "masculino",
  ["female"] = "feminino",
  ["unknown sex"] = "sexo desconhecido",
  ["<noguild>"] = "<semguilda>",
  ["his"] = "dele",
  ["hers"] = "dela",
  ["its"] = "dele/dela",
  ["him"] = "ele",
  ["her"] = "ela",
  ["it"] = "ele/ela",
  ["usersub_"] = "usersub_",
  ["TargetHealthDeficit"] = "TargetHealthDeficit",
  ["TargetPercentHP"] = "TargetPercentHP",
  ["TargetPronoun"] = "TargetPronoun",
  ["PlayerHP"] = "PlayerHP",
  ["PlayerName"] = "PlayerName",
  ["PlayerMaxHP"] = "PlayerMaxHP",
  ["PlayerHealthDeficit"] = "PlayerHealthDeficit",
  ["PlayerPercentHP"] = "PlayerPercentHP",
  ["PlayerCurrentMana"] = "PlayerCurrentMana",
  ["PlayerMaxMana"] = "PlayerMaxMana",
  ["PlayerPercentMana"] = "PlayerPercentMana",
  ["PlayerManaDeficit"] = "PlayerManaDeficit",
  ["TargetName"] = "TargetName",
  ["TargetTargetName"] = "TargetTargetName",
  ["MouseoverTargetName"] = "MouseoverTargetName",
  ["TargetClass"] = "TargetClass",
  ["TargetHealth"] = "TargetHealth",
  ["TargetRace"] = "TargetRace",
  ["TargetGender"] = "TargetGender",
  ["TargetLevel"] = "TargetLevel",
  ["TargetPossesive"] = "TargetPossesive",
  ["TargetManaDeficit"] = "TargetManaDeficit",
  ["TargetGuild"] = "TargetGuild",
  ["TargetIcon"] = "TargetIcon",
  ["MapZone"] = "MapZone",
  ["MapLoc"] = "MapLoc",
  ["MapPos"] = "MapPos",
  ["MapYPos"] = "MapYPos",
  ["MapXPos"] = "MapXPos",
  ["RandNum"] = "RandNum",
  ["PlayerAverageItemLevel"] = "PlayerAverageItemLevel",
  ["%tn = current target"] = "%tn = alvo atual",
  ["%pn = player name"] = "%pn = nome do jogador",
  ["%hc = your current health"] = "%hc = sua vida atual",
  ["%hm = your max health"] = "%hm = sua vida máxima",
  ["%hp = your percentage health"] = "%hp = seu percentual de vida",
  ["%hd = your current health deficit"] = "%hd = seu déficit de vida atual",
  ["%mc = your current mana"] = "%mc = sua mana atual",
  ["%mm = your max mana"] = "%mm = sua mana máxima",
  ["%mp = your percentage mana"] = "%mp = seu percentual de mana",
  ["%md = your current mana deficit"] = "%md = seu déficit de mana atual",
  ["%thp = target's percentage health"] = "%thp = percentual de vida do alvo",
  ["%th = target's current health"] = "%th = vida atual do alvo",
  ["%td = target's health deficit"] = "%td = déficit de vida do alvo",
  ["%tc = class of target"] = "%tc = classe do alvo",
  ["%tr = race of target"] = "%tr = raça do alvo",
  ["%ts = sex of target"] = "%ts = sexo do alvo",
  ["%tl = level of target"] = "%tl = nível do alvo",
  ["%ti = raid icon of target"] = "%ti = ícone de raide do alvo",
  ["%tps = possesive for target (his/hers/its)"] = "%tps = possessivo do alvo (dele/dela/dele ou dela)",
  ["%tpn = pronoun for target (him/her/it)"] = "%tpn = pronome do alvo (ele/ela/ele ou ela)",
  ["%tg = target's guild"] = "%tg = guilda do alvo",
  ["%mn = mouseover target name"] = "%mn = nome do alvo sob o mouse",
  ["%zon = your current zone"] = "%zon = sua zona atual",
  ["%loc = your current subzone (as shown on the minimap)"] = "%loc = sua subzona atual (como exibida no minimapa)",
  ["%pos = your current coordinates (x,y)"] = "%pos = suas coordenadas atuais (x,y)",
  ["%ypos = your current y coordinate"] = "%ypos = sua coordenada y atual",
  ["%xpos = your current x coordinate"] = "%xpos = sua coordenada x atual",
  ["%rnd = a random number between 1 and 100"] = "%rnd = um número aleatório entre 1 e 100",
  ["%ail = your average item level"] = "%ail = seu nível médio de item",
}


-- ============================================================================
-- BR: REF: modules/TellTarget.lua | Strings do módulo TellTarget (ptBR)
-- EN: REF: modules/TellTarget.lua | Module strings for TellTarget (enUS reference)
-- ============================================================================
ptBR.TellTarget = {
  -- BR: Geral | EN: General
  ["module_name"] = "Sussurrar para o Alvo",
  ["module_desc"] = "Adiciona o comando /tt para iniciar rapidamente um sussurro com o jogador selecionado.",
  ["full_description"] = "Este módulo adiciona o comando /tt, permitindo enviar um sussurro para o jogador atualmente selecionado como alvo.\n\nSe o alvo estiver em outro reino, o Prat usa o nome completo com reino quando necessário.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Resumo do comando Sussurrar para o Alvo.",
  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "|cFFFFD100/tt mensagem|r envia um sussurro para o jogador atualmente selecionado como alvo.\n\nSelecione um jogador, digite /tt seguido da mensagem, e o Prat converte isso em um sussurro.",

  -- BR: Comandos | EN: Commands
  ["commands_tab_name"] = "Comando",
  ["commands_tab_desc"] = "Mostra exemplos de uso do Sussurrar para o Alvo.",
  ["commands_help"] = "O comando funciona pela barra de digitação do chat. Ele exige que um jogador válido esteja selecionado como alvo.",

  ["examples_header"] = "Exemplos",
  ["example_text"] = "/tt Olá!\n/tt Pode me ajudar?\n/tt Quer entrar no grupo?",

  -- BR: Mensagens em uso | EN: Runtime
  ["no_target_message"] = "Nenhum jogador selecionado para receber o sussurro.",
  ["/tt"] = "/tt",
}


-- ============================================================================
-- BR: REF: modules/Timestamps.lua | Strings do módulo Timestamps (ptBR)
-- EN: REF: modules/Timestamps.lua | Module strings for Timestamps (enUS reference)
-- ============================================================================
ptBR.Timestamps = {
  -- BR: Geral | EN: General
  ["module_name"] = "Marcas de Tempo",
  ["module_desc"] = "Controla a exibição, formato, cor e posição das marcas de tempo nas janelas de bate-papo.",

  -- BR: Visão geral | EN: Overview
  ["overview_tab_name"] = "Visão Geral",
  ["overview_tab_desc"] = "Introdução e guia rápido.",
  ["full_description"] = "As marcas de tempo adicionam horário e opcionalmente data às mensagens do bate-papo.\n\nVocê pode escolher onde elas aparecem, como são formatadas, se utilizam horário local ou do servidor e como serão exibidas.",

  ["quick_guide_header"] = "Guia Rápido",
  ["quick_guide"] = "Exemplos:\n\n[14:35:22] Olá!\n\n<14:35> Olá!\n\n31/05/26 14:35 Olá!",

  -- BR: Exibição | EN: Display
  ["display_tab_name"] = "Exibição",
  ["display_tab_desc"] = "Onde as marcas de tempo serão exibidas.",
  ["display_help"] = "Escolha em quais janelas as marcas de tempo serão exibidas e defina se elas usarão o horário local do computador ou o horário do servidor.",

  ["show_name"] = "Mostrar nas seguintes janelas",
  ["show_desc"] = "Ativa ou desativa as marcas de tempo em cada janela de bate-papo.",

  ["local_time_name"] = "Usar Horário Local",
  ["local_time_desc"] = "Usa o horário do computador. Quando desativado, utiliza o horário do servidor.",

  -- BR: Formatação | EN: Formatting
  ["format_tab_name"] = "Formatação",
  ["format_tab_desc"] = "Configura o formato e a disposição da marca de tempo.",
  ["format_help"] = "Configure como a marca de tempo será montada. O prefixo e o sufixo funcionam como delimitadores, por exemplo: [14:35:22], <14:35> ou (14:35).",

  ["format_prefix_name"] = "Prefixo",
  ["format_prefix_desc"] = "Texto inserido antes da marca de tempo, como [, (, < ou qualquer outro caractere.",

  ["format_suffix_name"] = "Sufixo",
  ["format_suffix_desc"] = "Texto inserido após a marca de tempo, como ], ), > ou qualquer outro caractere.",

  ["time_format_name"] = "Formato da Hora",
  ["time_format_desc"] = "Escolhe o formato usado para exibir a hora.",

  ["date_format_name"] = "Formato da Data",
  ["date_format_desc"] = "Escolhe se a data será exibida junto com a hora.",

  ["space_name"] = "Inserir Espaço Após Timestamp",
  ["space_desc"] = "Insere um espaço entre a marca de tempo e a mensagem.",

  ["example_header"] = "Exemplo",
  ["example_text"] = "[14:35:22] Mensagem de exemplo",
  ["example_message"] = "Mensagem de exemplo",

  -- BR: Aparência | EN: Appearance
  ["appearance_tab_name"] = "Aparência",
  ["appearance_tab_desc"] = "Configura as cores da marca de tempo.",
  ["appearance_help"] = "Controla a aparência visual das marcas de tempo. Quando a cor personalizada estiver desativada, o seletor de cor ficará indisponível.",

  ["color_timestamp_name"] = "Usar Cor Personalizada",
  ["color_timestamp_desc"] = "Aplica uma cor personalizada à marca de tempo.",

  ["timestamp_color_name"] = "Cor da Marca de Tempo",
  ["timestamp_color_desc"] = "Define a cor usada na marca de tempo.",

  -- BR: Formatos de hora | EN: Time Formats
  ["time_format_12_hour_seconds_ampm"] = "HH:MM:SS AM (12 horas)",
  ["time_format_12_hour_seconds"] = "HH:MM:SS (12 horas)",
  ["time_format_24_hour_seconds"] = "HH:MM:SS (24 horas)",
  ["time_format_12_hour_minutes_ampm"] = "HH:MM AM (12 horas)",
  ["time_format_12_hour_minutes"] = "HH:MM (12 horas)",
  ["time_format_24_hour_minutes"] = "HH:MM (24 horas)",
  ["time_format_minutes_seconds"] = "MM:SS",

  -- BR: Formatos de data | EN: Date Formats
  ["date_format_none"] = "Nenhum",
  ["date_format_day_month_year"] = "dd/mm/aa",
  ["date_format_month_day_year"] = "mm/dd/aa",
  ["date_format_day_month"] = "dd/mm",
  ["date_format_month_day"] = "mm/dd",
}


-- ============================================================================
-- BR: REF: modules/UrlCopy.lua | Strings do módulo UrlCopy (ptBR)
-- EN: REF: modules/UrlCopy.lua | Module strings for UrlCopy (enUS reference)
-- ============================================================================
ptBR.UrlCopy = {

  -- BR: Geral | EN: General
  ["module_name"] = "Copiar URL",
  ["module_desc"] = "Facilita a identificação e cópia de URLs enviadas no bate-papo.",

  -- BR: Descrição | EN: Description
  ["full_description"] = "Este módulo detecta URLs, e-mails, endereços IP e domínios enviados no bate-papo, transformando-os em links clicáveis.\n\nAo clicar em um link detectado, você pode copiar o endereço por uma janela própria ou enviá-lo para a barra de digitação.",

  -- BR: Exibição dos links | EN: Link Display
  ["display_group_name"] = "Exibição dos Links",
  ["display_group_desc"] = "Controla como URLs e outros endereços detectados aparecem no bate-papo.",
  ["display_group_help"] = "Ajuste a aparência dos links detectados nas mensagens do bate-papo.",
  ["bracket_name"] = "Mostrar Colchetes",
  ["bracket_desc"] = "Exibe URLs entre colchetes para facilitar a identificação dos links no bate-papo.",
  ["color_url_name"] = "Colorir URLs",
  ["color_url_desc"] = "Aplica cor às URLs detectadas, tornando os links mais visíveis no bate-papo.",
  ["color_name"] = "Definir Cor",
  ["color_desc"] = "Escolhe a cor usada nas URLs quando a opção de colorir links estiver ativada.",

  -- BR: Cópia de URL | EN: URL Copy
  ["copy_group_name"] = "Cópia de URL",
  ["copy_group_desc"] = "Controla como a URL será exibida ao clicar no link.",
  ["copy_group_help"] = "Defina se o endereço clicado será aberto em uma janela própria de cópia ou enviado para a barra de digitação.",
  ["popup_name"] = "Usar Janela de Cópia",
  ["popup_desc"] = "Abre uma janela com a URL selecionada, facilitando a cópia manual do endereço.",
}
