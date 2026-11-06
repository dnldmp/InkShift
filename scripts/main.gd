extends Node

const LEVELS = [
	"res://levels/level_01.txt",
	"res://levels/level_02.txt",
]

var current_level := 0

@onready var room: Node2D = $Room

func _ready():
	start_level()

func start_level():
	room.mount(load_level(LEVELS[current_level]))

func next_level():
	current_level += 1
	if current_level < LEVELS.size():
		start_level()
	else:
		print("Fim do jogo!")


func load_level(path: String) -> Array[String]:
	var rows: Array[String] = []
	var file = FileAccess.open(path, FileAccess.READ)

	if file == null:
		push_error("Could not open: " + path)
		return rows

	while not file.eof_reached():
		var row = file.get_line().strip_edges()
		if row != "":
			rows.append(row)

	return rows
