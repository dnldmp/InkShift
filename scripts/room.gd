extends Node2D

const CELL_SIZE = 16

const WALL = preload("res://sprites/wall.png")
const FLOOR = preload("res://sprites/floor.png")
const EXIT = preload("res://sprites/exit.png")
const DANGER = preload("res://sprites/danger.png")
const TOY = preload("res://sprites/toy.png")
const BOX = preload("res://sprites/box.png")

var level: Array[String] = []
var toy_cell: Vector2i
var box_cells: Array[Vector2i] = []
var pieces: Array[Sprite2D] = []

func mount(new_level: Array[String]):
	level = new_level
	box_cells.clear()

	for piece in pieces:
		piece.queue_free()
	pieces.clear()

	for y in level.size():
		for x in level[y].length():
			var cell = Vector2i(x, y)
			match level[y][x]:
				"B":
					toy_cell = cell
					create_piece(TOY, cell)
				"C":
					box_cells.append(cell)
					create_piece(BOX, cell)

	queue_redraw()

func create_piece(texture: Texture2D, cell: Vector2i):
	var sprite = Sprite2D.new()
	sprite.texture = texture
	sprite.centered = false
	sprite.position = Vector2(cell * CELL_SIZE)
	add_child(sprite)
	pieces.append(sprite)

func _draw():
	for y in level.size():
		for x in level[y].length():
			var symbol = level[y][x]
			var screen_position = Vector2(x, y) * CELL_SIZE

			if symbol == "#":
				draw_texture(WALL, screen_position)
				continue

			# Toda célula que não é parede tem chão por baixo
			draw_texture(FLOOR, screen_position)

			if symbol == "S":
				draw_texture(EXIT, screen_position)
			elif symbol == "^":
				draw_texture(DANGER, screen_position)
