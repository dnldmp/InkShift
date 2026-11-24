extends Node2D

@export var page_title := "page 1"
@export_multiline var intro := "the margin"

func _ready() -> void:
	var rect: Rect2i = $Ground.get_used_rect()
	var cam: Camera2D = $Player/Camera2D
	cam.limit_left = rect.position.x * 16
	cam.limit_right = rect.end.x * 16
	cam.limit_top = rect.position.y * 16
	cam.limit_bottom = rect.end.y * 16
