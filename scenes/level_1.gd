extends Node

@onready var pivot: Node2D = $Pivot
@onready var bodies: Array[RigidBody2D] = [
	$Pivot/Content/Player,
	$Pivot/Content/Box,
]

const ROTATION_TIME = 0.8

var is_rotating := false
var target_rotation := 0.0

func _process(_delta: float) -> void:
	if is_rotating:
		return

	if Input.is_action_just_pressed("move_left"):
		rotate_room(-PI / 2)
	elif Input.is_action_just_pressed("move_right"):
		rotate_room(PI / 2)

func rotate_room(angle: float) -> void:
	is_rotating = true
	target_rotation += angle
	
	for body in bodies:
		body.freeze = true

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(pivot, "rotation", target_rotation, ROTATION_TIME)
	await tween.finished
	
	for body in bodies:
		body.freeze = false

	is_rotating = false
