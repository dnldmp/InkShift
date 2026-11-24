# Inkshift: contexto para um chat novo

Última atualização: 2026-11-24. Este arquivo guarda o que **não dá para descobrir lendo o código**: decisões, preferências e o estado atual.

## O projeto
- Jogo do Danilo para o **GitHub Game Off 2026**, tema **SHIFT**. Prazo: **2026-12-01**.
- Engine: Godot 4.7.2. O console do Godot fica em `C:\Users\danilo\Desktop\Godot\Godot_v4.7.2-stable_win64_console.exe`.
- O **GDD** e o quadro de tarefas estão no Notion, na página "GDD — Inkshift (nome provisório)", dentro de "Desenvolvimento de jogos".
- `C:\code\games\godot\inkshift\` é um **protótipo de visão** feito por IA para descartar depois. Lá está o guia que o Danilo segue: `GUIA-PASSO-A-PASSO.md`.
- O jogo de verdade é **este** projeto (`inkshift-original`), feito à mão pelo Danilo.
- O guia **não** explica o world_map. A explicação foi dada no chat e está resumida em "Próximos passos" abaixo.

## Como trabalhar com o Danilo
- Responda em **português (BR)**. Ele é **iniciante em pixel art** e está aprendendo Godot.
- **Ele escreve o próprio código.** Explique, dê dicas e mostre o trecho de código, mas não reescreva o jogo por ele.
  - Exceções que ele pediu: o sprite do weight e as fases `level_01`–`04` foram feitas por mim.
  - Gerar arte ou fases só quando ele pedir explicitamente.
- Ele prefere **cenas, nós e TileMapLayer** a código que gera fases.
- Ele gosta de **exemplos visuais**: gere PNGs ampliados com um script headless do Godot e envie para ele.
- Teste mudanças com **probes headless** do Godot (`--headless --script ...`), usando cópias e o scratchpad. Nunca mexa nos arquivos dele só para testar.
- Seja honesto sobre o que foi e o que não foi testado.
- Não faça commit nem push sem o "sim" dele. Hoje a pasta não é um repositório git.

## Regras do jogo e design
- O jogador é uma gota de tinta que **troca de forma** (Q/E ou LB/RB). As formas aprendidas ficam em `Game.unlocked_shapes` e continuam aprendidas entre as fases.
- Formas (valores em `shapes/*.tres`):

| Forma | Movimento e pulo | Gravidade e queda | Tamanho | Capacidades |
|---|---|---|---|---|
| **Gota** (drop) | speed 115, pulo -290 (~46px, ~2 tiles) | gravidade 900, max_fall 420 | 12×13 | sobe ≤2 tiles, pula poços de até 5 tiles (**falha no de 6**) |
| **Mola** (spring) | speed 100, pulo -440 (~121px, ≤6 tiles) | gravidade 800, max_fall 450 | 12×24 | pula poço de 6; **não entra** em túnel de 1 tile de altura |
| **Peso** (weight) | speed 70, pulo -150 (não sobe nem 1 tile) | gravidade 1500, max_fall **480** | 14×14 | aperta botões, quebra papel rasgado, esmaga borracha caindo em cima |

- Mudar de forma em lugar apertado é bloqueado por um `ShapeCast2D` (FitCheck).
- O Peso tinha max_fall 700 e morria ao cair numa borracha de muito alto. Por isso existe `velocity.y = min(velocity.y, shape.max_fall)` no player e max_fall 480. **Não volte isso.**
- Borracha (`eraser.gd`):
  - tem o flag `dead`;
  - `smash(body)` faz o jogador quicar (vy -150) e chama `queue_free`;
  - a Hitbox e a Head checam `dead` primeiro, porque o `queue_free` não impede outros sinais no mesmo frame.
- Botão → Portão: o sinal `pressed` é ligado em `open`. O tamanho do portão é `scale.y` = altura da coluna.

## Técnico
- Viewport 480×270, janela 1440×810, stretch `canvas_items`, filtro de textura nearest.
- Camera2D: zoom 1.5, com smoothing.
  - O "olhar à frente" usa `camera.position.x`, **não** `offset`. O `offset` ignora os limites e mostrava além da parede esquerda.
- Camadas de física: 1 world, 2 player, 3 hazards (valor 4).
- Origem dos objetos **nos pés**: a colisão fica em `y = -size.y/2`.
- O fundo de caderno é a cena `scenes/background.tscn`.
  - z_index da raiz = **-10**. O z_index vence a ordem na árvore: antes, os objetos sumiam atrás do papel.
  - A margem vermelha (`bg_red_line.png`) vem depois do papel.
- Paleta (gota, mola, peso):

| Cor | Hex |
|---|---|
| contorno | 040b14 |
| brilho | e3e6ff |
| claro | 249fde |
| médio | 285cc4 |
| escuro | 143464 |
| olho | ffffff |

- `sprites/weight.png` tem 80×16 e 5 frames: idle, respirar, piscar, pulo e queda.
  - Formato: trapézio com argola em cima e os olhos da gota, sem "KG".
  - O Danilo recusou vários formatos. Este foi aprovado depois de "parece um sino": o topo foi alargado.
- Autotile de `terrain.png` (source 1, tile 16):

| Peça | Células |
|---|---|
| tile isolado | (1,17) |
| coluna vertical | (3,16) topo / (3,17) meio / (3,18) base |
| faixa horizontal | (5,17) / (6,17) / (7,17) |
| bloco 9-slice | colunas 3/4/5, linhas 12/13/14 |

- O `tilesets/ink.tres` é a cópia do TileSet que estava embutido na `test_room`. As fases usam ele.
- Autoload `Game` (`scripts/game.gd`):
  - `LEVELS`, `current`, `completed`, `unlocked_shapes`;
  - `play_level(i)`, `finish_level()` (vai para `res://map/world_map.tscn`) e `is_unlocked(i)`.
- O `level.gd` (raiz das fases, `extends Node2D`):
  - exporta `page_title` e `intro`, mas **ninguém mostra esses textos ainda**: o HUD é o Passo 7 do guia;
  - define os limites da câmera a partir de `$Ground.get_used_rect()`. Por isso **o TileMapLayer precisa se chamar `Ground`**.
- Erros de Godot que já apareceram:
  - array tipado é passado **por referência** (`unlocked = Game.unlocked_shapes` compartilha o mesmo array);
  - para trocar de cena dentro de um callback de física, use `call_deferred`.

## As fases (`levels/level_01..04.tscn`)
- Foram geradas por `docs/ferramentas/gen_levels.gd`, a partir de mapas ASCII.
  - Legenda: `#` chão, `^` espinho, `P` jogador, `E` saída, `C` checkpoint, `S`/`W` pickups de Mola/Peso, `r` borracha, `T` papel, `1`–`4` botões, `a`–`d` portões, `X` segredo.
  - Ao empacotar cenas por código, use `instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)` e `add_child(n, true)`. Sem isso, as conexões duplicam e os nomes viram `@Area2D@`.
- Altura de 22 linhas; o chão fica nas linhas 16–21.
- Os grupos de nós são: Background, Ground, Checkpoints, Hazards, Pickups, Enemies, Puzzles, Secrets, Exit e Player.
- Fases:

| Fase | Título | Largura | O que tem |
|---|---|---|---|
| L1 | "the margin" | 150 tiles | só Gota: espinhos, borrachas, campo longo, túnel |
| L2 | "spring" | 150 tiles | ganha a Mola; muro de 6, túneis e poços de 6 alternados |
| L3 | "heavy ink" | 135 tiles | ganha o Peso; botões e portões, dois papéis empilhados, ponte de papel sobre espinhos (de Peso, morre) |
| L4 | "all together" | 160 tiles | tudo junto: corredor de rastejar, pátio de borrachas, pedestal com botão |

- São **8 segredos** no total. Hoje são só `Marker2D` chamados "Secret". A ideia é colocar ali um item colecionável no futuro.
- `docs/ferramentas/play.gd` é um robô que testa um trecho da fase. Uso: `SC=<cenário> godot --headless --script play.gd`, rodando a partir da raiz do projeto.
- O que foi testado:
  - os trechos-chave passaram;
  - também confirmei o que deve falhar: a Gota não passa o poço de 6, a Mola não entra no túnel e o Peso para antes da ponte.
- **Ainda não testado:**
  - nenhuma fase jogada do começo ao fim por um humano (o tempo das borrachas);
  - a Gota saindo do bolso da L3 depois de os papéis quebrarem.
- **Se o Danilo mexeu nas fases à mão, NÃO rode o gerador de novo**: ele sobrescreve os arquivos.

## Estado atual (2026-11-24)
- Pronto: o player com as 3 formas, borracha, espinhos, checkpoint, papel, botão, portão, pickup de forma, fundo de caderno, sprites das 3 formas, as 4 fases e o autoload Game.
- A cena principal hoje é `levels/level_01.tscn`. A `test_room` ainda existe e serve de sandbox.
- Pela metade e próximos passos:
  1. **world_map**: falta criar a pasta `map/`.
     - `map/level_dot.tscn` é um Button com `scripts/level_dot.gd`: ele exporta `level_index`, escreve o número da fase no texto, fica `disabled = not Game.is_unlocked(i)` e faz `pressed.connect(Game.play_level.bind(i))`.
     - `map/world_map.tscn`: um Node2D com Background, um Line2D (o caminho: largura 2, cor 0a0f1a) e um nó Dots com 4 LevelDots.
     - Um script opcional dá `grab_focus` na última fase liberada.
     - Depois, mudar a cena principal para o mapa.
  2. **`scripts/exit.gd`** ainda faz `reload_current_scene`. Ele deve virar `Game.finish_level()` quando o mapa existir.
  3. HUD (Passo 7): mostrar `page_title` e `intro`, e a forma atual.
  4. Colecionável nos marcadores de segredo.
  5. Opcional: animações `walk` e `land` do Peso. Som e feedback quando a troca de forma falha (está marcado com um comentário no `try_shape`).
  6. Ajustar a dificuldade das fases conforme o Danilo jogar.
