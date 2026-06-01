<a id="top"></a>

# Prat-3.0

### 🇧🇷 Fork ptBR com localização revisada, polimento de interface e organização modular

<p align="center">
  <a href="#pt-br">Português (Brasil)</a> |
  <a href="#en-us">English</a>
</p>

---

<a id="pt-br"></a>

## 🇧🇷 Português (Brasil)

<p align="right">
  <a href="#en-us">Read in English</a>
</p>

### 📌 Sobre este fork

Este repositório é um fork modificado do **Prat-3.0**, um addon clássico de aprimoramento do bate-papo para **World of Warcraft**.

O projeto original foi desenvolvido por **Sylvanaar** e colaboradores, e continua sendo a base técnica e histórica deste trabalho.

**Projeto original:**

https://github.com/sylvanaar/prat-3-0

Este fork nasceu com foco inicial em **localização ptBR**, mas acabou indo além de uma simples tradução. Durante o processo, várias partes da interface de configuração foram revisadas, descrições foram reescritas, opções foram reorganizadas e a estrutura de localização foi separada em arquivos próprios para facilitar manutenção futura.

A proposta não é substituir o Prat-3.0 original, nem apresentar este fork como uma reescrita completa do addon. A base modular, a lógica principal e a identidade do projeto original continuam preservadas.

O foco deste fork está em:

- tornar o addon mais claro e compreensível para os jogadores;
- centralizar e organizar os arquivos de localização;
- melhorar textos, nomes, descrições e dicas (tooltips);
- reorganizar opções de alguns módulos em grupos ou abas;
- corrigir inconsistências encontradas durante o processo de revisão;
- preparar uma base mais amigável para futuras traduções;
- preservar o comportamento original sempre que possível.

Em resumo: este é um fork de **localização, organização, manutenção e polimento de interface**, com modificações pontuais em módulos específicos.

---

### 🎯 Escopo das modificações

As alterações deste fork não se limitam a traduzir textos.

O trabalho envolveu principalmente:

- criação de uma estrutura centralizada de localização;
- consolidação de `enUS` como idioma base/fallback;
- criação e revisão do `ptBR`;
- reorganização de blocos de idioma por módulo;
- revisão de nomenclaturas exibidas ao jogador;
- adaptação de textos para linguagem natural em português brasileiro;
- ajustes em descrições, dicas e mensagens da interface;
- reorganização visual de opções em módulos selecionados;
- separação de opções por grupos ou abas quando isso melhorava a clareza;
- preservação da lógica original nos pontos sensíveis do addon.

Alguns módulos receberam apenas revisão textual ou localização. Outros tiveram reorganização de interface ou melhorias pontuais mais perceptíveis.

---

### 🌐 Estrutura de localização

Este fork organiza a localização em arquivos dedicados, separando o idioma base das traduções.

Arquivos principais:

```txt
locales/enUS.lua
locales/ptBR.lua
locales/includes.xml
```

O idioma `enUS` funciona como base/fallback principal.

O idioma `ptBR` é o foco inicial deste fork.

A estrutura foi pensada para facilitar manutenção futura e permitir expansão gradual para outros idiomas.

Ordem planejada dos idiomas:

```txt
enUS - Inglês dos Estados Unidos / idioma base e fallback
ptBR - Português do Brasil
ptPT - Português Europeu
esES - Espanhol Europeu
esMX - Espanhol Latino-americano
frFR - Francês
itIT - Italiano
deDE - Alemão
ruRU - Russo
koKR - Coreano
zhCN - Chinês simplificado
zhTW - Chinês tradicional
```

Nem todos esses idiomas estão disponíveis no momento. A lista acima representa a ordem planejada para expansão futura.

---

### 🧩 Áreas e módulos revisados

O Prat-3.0 é altamente modular. Este fork trabalhou principalmente em revisão textual, localização, organização de opções e clareza visual em vários módulos e áreas do addon.

As mudanças variam conforme o módulo: alguns receberam apenas revisão de textos e nomenclaturas; outros tiveram opções reorganizadas em grupos, abas ou descrições mais claras.

| Área | Módulos envolvidos |
| --- | --- |
| Interface, aparência e janelas | `Bubbles`, `ChatFrames / Frames`, `ChatTabs`, `Editbox`, `Fading`, `Font`, `OriginalButtons`, `Paragraph`, `SideTabs` |
| Canais, conversa e histórico | `ChannelColorMemory`, `ChannelNames`, `ChannelSticky`, `ChatLog`, `History`, `Scroll`, `Scrollback`, `Timestamps` |
| Jogadores, nomes e identificação | `AltNames`, `PlayerNames`, `ServerNames` |
| Comandos, atalhos e interação | `Alias`, `Invites`, `KeyBindings`, `PopupMessage` |
| Cópia, busca e links | `CopyChat`, `Search`, `UrlCopy`, `LinkInfoIcons` |
| Filtros, sons e personalização | `Achievements`, `CustomFilters`, `Sounds` |

---

### ✨ Exemplos de ajustes

Alguns exemplos de ajustes realizados dentro da proposta deste fork:

- `Bubbles` recebeu reorganização visual das opções, separando melhor configurações de aparência, conteúdo e comportamento.
- `Achievements` teve sua interface de opções reorganizada para facilitar a leitura e a configuração das mensagens relacionadas a conquistas.
- `Invites` recebeu melhorias pontuais de segurança e controle, como filtro por canais, lista de bloqueio, bloqueio durante combate e cooldown anti-spam.
- `Alias` recebeu um fluxo mais claro para criação de comandos abreviados, incluindo modo assistido, modo avançado e proteção contra conflitos com comandos existentes.
- `UrlCopy` teve suas opções e descrições revisadas para deixar mais claro o comportamento de detecção, exibição e cópia de links.
- `ChannelSticky` teve suas opções reorganizadas para explicar melhor a memorização de tipos de conversa e o comportamento de grupo inteligente.
- `KeyBindings` recebeu revisão de nomenclatura e descrição, deixando mais claro que os atalhos são configurados pelo painel de atalhos do próprio World of Warcraft.
- `SideTabs` passou por revisão de textos visíveis e extração de strings para o sistema de localização.
- Vários módulos tiveram textos internos, descrições, nomes de opções e dicas revisadas para melhorar consistência e manutenção.

_As mudanças variam conforme o módulo. Algumas são apenas textuais ou organizacionais; outras envolvem melhorias pontuais de interface e fluxo de configuração._

_Também foram adotados cuidados para evitar termos duros, traduções literais demais e textos longos que prejudiquem a leitura dentro da interface do jogo._

---

### 🎮 Uso no jogo

Dentro do jogo, digite:

```txt
/prat
```

para abrir o menu de configuração do addon.

Após instalar ou atualizar o addon, também é possível recarregar a interface com:

```txt
/reload
```

---

### 🚫 O que este fork NÃO pretende ser

Para manter a proposta honesta, este fork não deve ser entendido como:

- 🚫 uma reescrita completa do Prat-3.0;
- 🚫 uma nova versão oficial do addon original;
- 🚫 uma edição de performance;
- 🚫 uma promessa de redução de memória ou CPU;
- 🚫 uma modernização completa do código;
- 🚫 uma garantia de compatibilidade superior ao projeto original.

Ele é uma versão modificada com foco em **ptBR**, **UX/UI**, **organização de locales**, **manutenção** e **melhorias pontuais**, respeitando a estrutura original do Prat-3.0.

---

### 🤝 Créditos

**Prat-3.0** foi originalmente desenvolvido por **Sylvanaar** e colaboradores.

Este fork é baseado no projeto original e busca contribuir com localização ptBR, revisão textual, organização de arquivos de idioma e polimento de interface, respeitando a estrutura e a história do addon original.

**Projeto original:**

https://github.com/sylvanaar/prat-3-0

<p align="right">
  <a href="#top">Voltar ao topo</a>
</p>

---

<a id="en-us"></a>

## 🇺🇸 English

<p align="right">
  <a href="#pt-br">Ler em Português (Brasil)</a>
</p>

### 📌 About this fork

This repository is a modified fork of **Prat-3.0**, a classic chat enhancement addon for **World of Warcraft**.

The original project was developed by **Sylvanaar** and contributors, and remains the technical and historical foundation of this work.

**Original project:**

https://github.com/sylvanaar/prat-3-0

This fork started with an initial focus on **ptBR localization**, but it became more than a simple translation. During the process, several parts of the configuration interface were reviewed, descriptions were rewritten, options were reorganized, and the localization structure was separated into dedicated files to make future maintenance easier.

The goal is not to replace the original Prat-3.0 project or present this fork as a complete rewrite of the addon. The modular foundation, core logic, and original project identity are still preserved.

This fork focuses on:

- making the addon clearer and easier to understand for players;
- centralizing and organizing localization files;
- improving texts, names, descriptions, and tooltips;
- reorganizing options in selected modules into clearer groups or tabs;
- fixing inconsistencies found during the review process;
- preparing a friendlier base for future translations;
- preserving the original behavior whenever possible.

In short: this is a **localization, organization, maintenance, and UI polish fork**, with selected module-level changes.

---

### 🎯 Modification scope

The changes in this fork are not limited to text translation.

The work mainly involved:

- creating a centralized localization structure;
- consolidating `enUS` as the base/fallback language;
- creating and reviewing `ptBR`;
- reorganizing language blocks by module;
- reviewing player-facing naming;
- adapting text into natural Brazilian Portuguese;
- improving descriptions, tooltips, and interface messages;
- visually reorganizing options in selected modules;
- grouping options or using tabs when it improved clarity;
- preserving the original logic in sensitive parts of the addon.

Some modules received only text review or localization. Others received interface reorganization or more noticeable targeted improvements.

---

### 🌐 Localization structure

This fork organizes localization into dedicated files, separating the base language from translations.

Main files:

```txt
locales/enUS.lua
locales/ptBR.lua
locales/includes.xml
```

The `enUS` language works as the main base/fallback.

The `ptBR` language is the initial focus of this fork.

The structure was designed to make future maintenance easier and allow gradual expansion to other languages.

Planned language order:

```txt
enUS - English (United States) / base and fallback language
ptBR - Brazilian Portuguese
ptPT - European Portuguese
esES - European Spanish
esMX - Latin American Spanish
frFR - French
itIT - Italian
deDE - German
ruRU - Russian
koKR - Korean
zhCN - Simplified Chinese
zhTW - Traditional Chinese
```

Not all of these languages are currently available. The list above represents the planned order for future expansion.

---

### 🧩 Reviewed areas and modules

Prat-3.0 is highly modular. This fork mainly worked on text review, localization, option organization, and visual clarity across several modules and addon areas.

The scope varies by module: some received only text and naming review, while others had options reorganized into clearer groups, tabs, or descriptions.

| Area | Involved modules |
| --- | --- |
| Interface, appearance, and windows | `Bubbles`, `ChatFrames / Frames`, `ChatTabs`, `Editbox`, `Fading`, `Font`, `OriginalButtons`, `Paragraph`, `SideTabs` |
| Channels, conversation, and history | `ChannelColorMemory`, `ChannelNames`, `ChannelSticky`, `ChatLog`, `History`, `Scroll`, `Scrollback`, `Timestamps` |
| Players, names, and identification | `AltNames`, `PlayerNames`, `ServerNames` |
| Commands, shortcuts, and interaction | `Alias`, `Invites`, `KeyBindings`, `PopupMessage` |
| Copying, search, and links | `CopyChat`, `Search`, `UrlCopy`, `LinkInfoIcons` |
| Filters, sounds, and customization | `Achievements`, `CustomFilters`, `Sounds` |

---

### ✨ Adjustment examples

Some examples of adjustments made within this fork:

- `Bubbles` received visual option reorganization, better separating appearance, content, and behavior settings.
- `Achievements` had its option interface reorganized to make achievement-related messages easier to read and configure.
- `Invites` received selected safety and control improvements, such as channel filtering, block list, combat blocking, and anti-spam cooldown.
- `Alias` received a clearer flow for creating shortened commands, including assisted mode, advanced mode, and protection against existing command conflicts.
- `UrlCopy` had its options and descriptions reviewed to better explain link detection, display, and copying behavior.
- `ChannelSticky` had its options reorganized to better explain conversation type memory and smart group behavior.
- `KeyBindings` received naming and description review, making it clearer that shortcuts are configured through World of Warcraft's own key bindings panel.
- `SideTabs` received visible text review and string extraction into the localization system.
- Several modules had internal texts, descriptions, option names, and tooltips reviewed to improve consistency and maintenance.

_The scope varies by module. Some changes are only textual or organizational; others involve selected interface and configuration flow improvements._

_Care was also taken to avoid stiff wording, overly literal translations, and long texts that could hurt readability inside the game interface._

---

### 🎮 In-game usage

In game, type:

```txt
/prat
```

to open the addon configuration menu.

After installing or updating the addon, you can also reload the interface with:

```txt
/reload
```

---

### 🚫 What this fork is NOT intended to be

To keep the project scope honest, this fork should not be understood as:

- 🚫 a complete rewrite of Prat-3.0;
- 🚫 a new official version of the original addon;
- 🚫 a performance edition;
- 🚫 a promise of reduced memory or CPU usage;
- 🚫 a complete code modernization;
- 🚫 a guarantee of better compatibility than the original project.

It is a modified fork focused on **ptBR**, **UX/UI**, **locale organization**, **maintenance**, and **selected improvements**, while respecting the original structure of Prat-3.0.

---

### 🤝 Credits

**Prat-3.0** was originally developed by **Sylvanaar** and contributors.

This fork is based on the original project and aims to contribute ptBR localization, text review, locale file organization, and UI polish while respecting the structure and history of the original addon.

**Original project:**

https://github.com/sylvanaar/prat-3-0

<p align="right">
  <a href="#top">Back to top</a>
</p>
