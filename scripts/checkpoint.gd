extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.respawn_point = global_position
		anim.play("on")
