<a id="topo"></a>

# <img src="https://flagcdn.com/28x21/br.png" width="28" height="21" alt="Brasil" /> Prat-3.0 3.9.100 — Notas da versão

<p align="center">
  <a href="./enUS.md">
    <img src="https://flagcdn.com/28x21/us.png" width="28" height="21" alt="Estados Unidos" />
    <strong>Read in English</strong>
  </a>
  &nbsp;&nbsp;|&nbsp;&nbsp;
  <a href="../../../README.md">
    <strong>Voltar ao README</strong>
  </a>
</p>

---

## 📌 Visão geral

Esta é a primeira versão pública e instalável deste fork do **Prat-3.0**, preparada a partir do pacote final auditado, sincronizado e testado diretamente no World of Warcraft.

A atualização estabelece uma base centralizada de localização, apresenta a primeira localização completa em `ptBR`, preserva `enUS` como idioma-base e fallback e reúne ajustes de organização, interface e manutenção realizados ao longo do fork.

O objetivo não é reescrever o Prat-3.0 do zero nem substituir o projeto original. A proposta é preservar o que já funciona, organizar a base de localização, reduzir textos espalhados pelo código, melhorar a clareza da interface e preparar o projeto para expansão progressiva de idiomas.

---

## ✨ Principais destaques

- Estrutura centralizada de locales em pasta própria.
- `enUS` preservado como idioma-base e fallback.
- `ptBR` incluído como primeira localização completa e revisada.
- Textos, descrições, rótulos, opções e guias rápidos revisados.
- Módulos e serviços auditados individualmente.
- Organização das opções e do controle de módulos.
- Padronização controlada de nomes internos próprios do fork.
- Preservação de APIs Blizzard, Ace3 e Prat.
- Inclusão das bibliotecas e dos arquivos runtime necessários.
- Limpeza de arquivos legados, temporários e exclusivos de desenvolvimento.
- Galeria bilíngue adicionada ao README do projeto.

---

## 🎨 Recursos demonstrados

- Personalização de fontes e aparência do chat.
- Marcas de tempo configuráveis.
- Barra de digitação reposicionável e personalizável.
- Controle de módulos organizado por categoria.
- Alertas e nomes monitorados.
- Atalhos de teclado integrados às opções do jogo.
- Interface disponível em `ptBR` e `enUS`.

<p align="center">
  <img src="../../screenshots/ptBR/chat-customization.png"
       alt="Personalização do chat, fontes, barra de digitação e marcas de tempo em ptBR"
       width="100%">
</p>

---

## 🧪 Validação

O pacote anexado a esta versão foi:

- gerado a partir da branch `master`;
- instalado a partir de um ZIP limpo;
- testado sem utilizar a pasta de desenvolvimento;
- carregado corretamente no jogo;
- validado com locale, opções e módulos funcionando;
- testado sem erros Lua ou comportamentos inesperados observados.

Teste principal realizado no **World of Warcraft: The War Within**.

---

## 📦 Instalação

1. Baixe o arquivo ZIP anexado à versão.
2. Extraia a pasta `Prat-3.0` para:

```text
World of Warcraft\_retail_\Interface\AddOns
```

3. Confirme que o caminho final ficou assim:

```text
Interface\AddOns\Prat-3.0\Prat-3.0.toc
```

4. Ative **Prat 3.0** na tela de AddOns.

> Para instalar o addon, prefira o ZIP anexado manualmente à versão. Os arquivos automáticos **Source code** representam o repositório completo e não o pacote runtime preparado e testado.

---

## 🌍 Estrutura de idiomas

Esta versão inclui:

- <img src="https://flagcdn.com/28x21/us.png" width="28" height="21" alt="Estados Unidos" /> `enUS` — idioma-base e fallback;
- <img src="https://flagcdn.com/28x21/br.png" width="28" height="21" alt="Brasil" /> `ptBR` — primeira localização completa e revisada.

A estrutura foi preparada para receber, progressivamente:

`ptPT`, `esES`, `esMX`, `frFR`, `itIT`, `deDE`, `ruRU`, `koKR`, `zhCN` e `zhTW`.

A presença de um idioma no planejamento não significa que sua localização já esteja concluída.

---

## ⚠️ Escopo desta versão

Esta versão:

- não é uma reescrita completa do Prat-3.0;
- não pretende substituir o projeto original;
- não afirma que todos os idiomas planejados já estejam concluídos;
- não promete otimização total de desempenho ou memória;
- não altera APIs externas sem necessidade;
- preserva a arquitetura e o comportamento original sempre que possível.

---

## 🙏 Créditos

Este projeto é um fork do **Prat-3.0**, originalmente desenvolvido por **Sylvanaar** e colaboradores.

A base técnica, a licença e os créditos do projeto original permanecem preservados.

<p align="right">
  <a href="#topo">⬆️ <strong>Voltar ao início desta página</strong></a>
</p>
