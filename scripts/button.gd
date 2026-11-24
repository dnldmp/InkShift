extends Area2D

signal pressed
var done: = false

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	if not done and body.is_in_group("player") and body.shape.can_press:
		done = true
		anim.play("down")
		pressed.emit()
