extends SceneTree
# Gera levels/level_01..04.tscn a partir de mapas em grade.
# Legenda: # chão  ^ espinho  P jogador  E saída  C checkpoint  S mola  W peso
#          r borracha  B botão  G portão (coluna)  T papel rasgado

const H := 22
var W := 64
var grid: Array = []

func blank(w: int) -> void:
	W = w
	grid = []
	for y in H:
		var row := []
		for x in W: row.append(".")
		grid.append(row)
	rect(0, 0, 0, H - 1)          # parede esquerda
	rect(W - 1, 0, W - 1, H - 1)  # parede direita
	rect(0, 16, W - 1, H - 1)     # chão

func rect(x0: int, y0: int, x1: int, y1: int, ch := "#") -> void:
	for y in range(y0, y1 + 1):
		for x in range(x0, x1 + 1):
			grid[y][x] = ch

func at(x: int, y: int, ch: String) -> void:
	grid[y][x] = ch

# ---------------------------------------------------------------- fases
# Gota: sobe 2, pula 3 de vão, passa em túnel de 1.
# Mola: sobe 6, pula 6 de vão, NÃO passa em túnel de 1.
# Peso: não pula; quebra papel, aperta botão, esmaga borracha caindo.
func level_1() -> void:
	blank(150)
	at(3, 15, "P")
	rect(8, 15, 9, 15)                 # degrau de 1
	rect(12, 14, 14, 15)               # degrau de 2
	rect(15, 12, 17, 12); at(16, 11, "X")   # segredo: pule do degrau para cima
	rect(20, 16, 22, 16, "^")          # poço de 3
	at(24, 15, "C")
	at(27, 15, "#"); at(32, 15, "r")   # cercado 1
	rect(40, 14, 42, 14)               # plataformas sobre espinhos
	rect(45, 12, 48, 12)
	rect(44, 16, 49, 16, "^")
	rect(50, 10, 53, 10); at(52, 9, "X")    # segredo: da plataforma 2 para cima
	at(55, 15, "C")
	at(58, 15, "#")                    # escadaria
	rect(60, 14, 61, 15)
	rect(63, 12, 70, 15)
	at(68, 11, "C")
	rect(71, 16, 73, 16, "^")
	at(76, 15, "#"); at(80, 15, "r")   # dois cercados de borracha
	rect(84, 14, 85, 15)
	at(90, 15, "r"); at(95, 15, "#")
	rect(98, 16, 112, 16, "^")         # longo campo de espinhos
	rect(100, 14, 101, 14)
	rect(104, 13, 105, 13)
	rect(108, 14, 110, 14)
	at(116, 15, "C")
	rect(120, 0, 130, 14)              # túnel baixo
	at(135, 15, "C")
	rect(140, 15, 142, 15)
	at(146, 15, "E")

func level_2() -> void:
	blank(150)
	at(3, 15, "P")
	at(8, 15, "S")                     # aprende a Mola
	rect(14, 10, 16, 15)               # muro de 6
	at(20, 15, "C")
	rect(24, 0, 40, 14)                # túnel: só a Gota
	rect(44, 16, 49, 16, "^")          # poço de 6: só a Mola
	at(52, 15, "C")
	rect(58, 11, 66, 15)               # platô (5 acima)
	rect(67, 6, 72, 15)                # platô alto (+5)
	rect(62, 2, 64, 2); at(63, 1, "X") # segredo no alto
	at(75, 15, "C")
	rect(77, 0, 82, 14)                # túnel 1
	rect(84, 16, 89, 16, "^")          # poço de 6 logo depois
	at(91, 15, "C")
	rect(93, 0, 99, 14)                # túnel 2
	rect(102, 12, 103, 15)             # cerca alta (4)
	rect(108, 12, 109, 15)
	at(105, 15, "r")
	at(111, 15, "C")
	rect(116, 11, 118, 15)             # subida final
	rect(121, 6, 140, 15)
	rect(121, 15, 130, 15, ".")        # segredo: túnel escondido na base
	at(130, 15, "X")
	at(136, 5, "E")

func level_3() -> void:
	blank(135)
	at(3, 15, "P")
	at(6, 15, "W")                     # aprende o Peso
	at(8, 15, "C")
	at(12, 15, "1")                    # botão 1 -> portão a
	rect(18, 0, 18, 11)
	rect(18, 12, 18, 15, "a")
	at(24, 16, "T"); at(25, 16, "T")   # papel: só o Peso quebra
	rect(30, 0, 31, 15)
	rect(24, 17, 37, 19, ".")          # corredor de baixo
	rect(35, 16, 37, 16, ".")
	at(35, 19, "#")
	rect(36, 18, 36, 19)
	rect(37, 17, 37, 19)
	rect(33, 10, 35, 10); at(34, 9, "X")    # segredo (precisa da Mola)
	at(41, 15, "C")
	rect(43, 14, 44, 15)               # degrau: de Peso, caia na borracha
	at(48, 15, "r")
	rect(52, 16, 54, 16, "^")
	# dois papéis empilhados até o botão 2
	rect(60, 16, 70, 19, ".")
	rect(62, 16, 67, 16)
	at(60, 16, "T"); at(61, 16, "T")
	at(60, 18, "T"); at(61, 18, "T")
	at(65, 19, "2")                    # botão 2 -> portão b
	at(68, 19, "#")
	rect(69, 18, 69, 19)
	rect(70, 17, 70, 19)
	rect(74, 0, 74, 11)
	rect(74, 12, 74, 15, "b")
	at(76, 15, "C")
	rect(78, 16, 86, 17, ".")          # fosso com borracha
	at(82, 17, "r")
	rect(87, 17, 88, 17, "."); at(88, 17, "X")   # segredo: buraquinho no fosso
	rect(90, 0, 98, 14)                # túnel
	at(102, 16, "T"); at(103, 16, "T") # tampa do buraco do botão 3
	rect(102, 17, 103, 17, ".")
	at(103, 17, "3")                   # botão 3 -> portão c
	rect(107, 0, 107, 11)
	rect(107, 12, 107, 15, "c")
	at(110, 15, "C")
	rect(113, 15, 119, 15, "T")        # ponte de papel: Peso cai nos espinhos
	rect(113, 16, 119, 16, "^")
	at(128, 15, "E")

func level_4() -> void:
	blank(160)
	at(3, 15, "P")
	at(5, 15, "C")
	at(7, 15, "S")
	rect(10, 10, 22, 15)               # bloco alto (Mola)
	at(18, 9, "W")
	at(23, 10, "T"); at(24, 10, "T")   # papel sobre o poço
	at(24, 15, "1")                    # botão 1 -> portão a
	rect(25, 10, 35, 13)
	at(34, 9, "X")                     # segredo em cima do bloco
	rect(36, 0, 36, 13)
	rect(36, 14, 36, 15, "a")
	at(39, 15, "C")
	rect(42, 16, 50, 17, ".")          # fosso da borracha
	at(46, 17, "r")
	rect(54, 0, 62, 14)                # túnel
	at(64, 15, "C")
	rect(66, 16, 71, 16, "^")          # poço de 6
	at(76, 16, "T"); at(77, 16, "T")   # papel -> corredor de baixo
	rect(80, 0, 80, 15)                # parede
	rect(76, 17, 90, 19, ".")
	rect(82, 17, 86, 18)               # rastejar (1 de altura)
	rect(89, 16, 90, 16, ".")          # saída: Mola pula 4
	at(93, 15, "C")
	at(96, 15, "#"); at(121, 15, "#")  # pátio das borrachas
	rect(98, 12, 101, 12)
	rect(106, 12, 109, 12)
	rect(114, 12, 117, 12)
	at(103, 15, "r"); at(111, 15, "r"); at(119, 15, "r")
	rect(146, 10, 148, 10); at(147, 9, "X")  # segredo: Mola antes da saída
	at(124, 15, "C")
	rect(126, 11, 128, 15)             # pedestal do botão 2
	at(127, 10, "2")                   # botão 2 -> portão b
	rect(132, 15, 137, 15, "T")        # ponte de papel
	rect(132, 16, 137, 16, "^")
	rect(140, 0, 140, 11)
	rect(140, 12, 140, 15, "b")
	at(143, 15, "C")
	at(152, 15, "E")

# ---------------------------------------------------------------- montagem
var tileset: TileSet
const PATHS := {
	"bg": "res://scenes/background.tscn",
	"player": "res://scenes/player.tscn",
	"spikes": "res://scenes/spikes.tscn",
	"checkpoint": "res://scenes/checkpoint.tscn",
	"exit": "res://scenes/exit.tscn",
	"pickup": "res://scenes/shape_pickup.tscn",
	"eraser": "res://scenes/eraser.tscn",
	"paper": "res://scenes/torn_paper.tscn",
	"gate": "res://scenes/gate.tscn",
	"button": "res://scenes/button.tscn",
}

func solid(x: int, y: int) -> bool:
	if x < 0 or y < 0 or x >= W or y >= H: return false
	return grid[y][x] == "#"

func tile_for(x: int, y: int) -> Vector2i:
	var n := solid(x, y - 1); var e := solid(x + 1, y)
	var s := solid(x, y + 1); var w := solid(x - 1, y)
	if not (n or e or s or w): return Vector2i(1, 17)
	if not e and not w:
		if n and s: return Vector2i(3, 17)
		return Vector2i(3, 16) if s else Vector2i(3, 18)
	if not n and not s:
		if e and w: return Vector2i(6, 17)
		return Vector2i(5, 17) if e else Vector2i(7, 17)
	var col := 4
	if not w: col = 3
	elif not e: col = 5
	var row := 13
	if not n: row = 12
	elif not s: row = 14
	return Vector2i(col, row)

func add(parent: Node, node: Node, root: Node) -> Node:
	parent.add_child(node, true)
	node.owner = root
	return node

func inst(key: String) -> Node:
	return load(PATHS[key]).instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)

func feet(x: int, y: int) -> Vector2:
	return Vector2(x * 16 + 8, (y + 1) * 16)

func build(name: String, title: String, intro: String, file: String) -> void:
	var root := Node2D.new()
	root.name = name
	root.set_script(load("res://scripts/level.gd"))
	root.set("page_title", title)
	root.set("intro", intro)
	add(root, inst("bg"), root)
	var ground := TileMapLayer.new()
	ground.name = "Ground"
	ground.tile_set = tileset
	add(root, ground, root)
	for y in H:
		for x in W:
			if grid[y][x] == "#":
				ground.set_cell(Vector2i(x, y), 1, tile_for(x, y))
	var groups := {}
	for g in ["Checkpoints", "Hazards", "Pickups", "Enemies", "Puzzles", "Secrets"]:
		var n := Node.new(); n.name = g
		groups[g] = add(root, n, root)
	var buttons := {}
	var gates := {}
	var player: Node = null
	for y in H:
		for x in W:
			var ch: String = grid[y][x]
			if ch in ["1", "2", "3", "4"]:
				var b := inst("button"); b.position = Vector2(x * 16 + 8, y * 16 + 8); add(groups["Puzzles"], b, root)
				buttons[int(ch) - 1] = b
				continue
			if ch in ["a", "b", "c", "d"]:
				if y + 1 < H and grid[y + 1][x] == ch: continue   # só a base cria o portão
				var top := y
				while top > 0 and grid[top - 1][x] == ch: top -= 1
				var gt := inst("gate"); gt.position = feet(x, y); gt.scale = Vector2(1, y - top + 1)
				add(groups["Puzzles"], gt, root)
				gates["abcd".find(ch)] = gt
				continue
			match ch:
				"X":
					var m := Marker2D.new(); m.name = "Secret"; m.position = Vector2(x * 16 + 8, y * 16 + 8)
					add(groups["Secrets"], m, root)
				"P":
					player = inst("player"); player.position = feet(x, y)
				"E":
					var e := inst("exit"); e.position = feet(x, y); add(root, e, root)
				"C":
					var c := inst("checkpoint"); c.position = feet(x, y); add(groups["Checkpoints"], c, root)
				"^":
					var s := inst("spikes"); s.position = Vector2(x * 16 + 8, y * 16 + 8); add(groups["Hazards"], s, root)
				"S", "W":
					var p := inst("pickup"); p.position = feet(x, y)
					p.set("shape", load("res://shapes/spring.tres" if ch == "S" else "res://shapes/weight.tres"))
					add(groups["Pickups"], p, root)
				"r":
					var r := inst("eraser"); r.position = Vector2(x * 16 + 8, (y + 1) * 16 - 10); add(groups["Enemies"], r, root)
				"T":
					var t := inst("paper"); t.position = feet(x, y); add(groups["Puzzles"], t, root)
	# jogador depois dos objetos: fica desenhado por cima
	add(root, player, root)
	root.move_child(player, root.get_child_count() - 1)
	for i in buttons:
		assert(gates.has(i), "botão %d sem portão" % i)
		buttons[i].connect("pressed", Callable(gates[i], "open"), CONNECT_PERSIST)
	var packed := PackedScene.new()
	var err := packed.pack(root)
	assert(err == OK)
	print(file, " -> ", ResourceSaver.save(packed, file))
	var dump := ""
	for y in H: dump += "".join(grid[y]) + "\n"
	print(dump)
	root.free()

func _initialize() -> void:
	var room = load("res://scenes/test_room.tscn").instantiate()
	tileset = room.get_node("Ground").tile_set.duplicate(true)
	room.free()
	DirAccess.make_dir_recursive_absolute("res://tilesets")
	print("tileset -> ", ResourceSaver.save(tileset, "res://tilesets/ink.tres"))
	tileset = load("res://tilesets/ink.tres")
	level_1(); build("Level01", "page 1", "the margin", "res://levels/level_01.tscn")
	level_2(); build("Level02", "page 2", "spring", "res://levels/level_02.tscn")
	level_3(); build("Level03", "page 3", "heavy ink", "res://levels/level_03.tscn")
	level_4(); build("Level04", "page 4", "all together", "res://levels/level_04.tscn")
	quit()
