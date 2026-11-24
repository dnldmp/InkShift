# game.gd
extends Node

const LEVELS := [
	"res://levels/level_01.tscn",
	"res://levels/level_02.tscn",
	"res://levels/level_03.tscn",
	"res://levels/level_04.tscn",
]
var current := 0
var completed: Array[int] = []
var unlocked_shapes: Array[ShapeData] = []

func play_level(i: int) -> void:
	current = i
	get_tree().change_scene_to_file.call_deferred(LEVELS[i])

func finish_level() -> void:
	if not completed.has(current):
		completed.append(current)
	get_tree().change_scene_to_file.call_deferred("res://map/world_map.tscn")

func is_unlocked(i: int) -> bool:
	return i == 0 or completed.has(i - 1)
