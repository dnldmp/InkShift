extends CharacterBody2D

@export var speed := 28.0
var dir := -1.0
var dead: bool = false

@onready var head: Area2D = $Flip/Head
@onready var wall_check: RayCast2D = $Flip/WallCheck
@onready var floor_check: RayCast2D = $Flip/FloorCheck
@onready var flip: Node2D = $Flip

func smash(body: Node2D) -> void:
	dead = true
	body.velocity.y = -150
	queue_free()

func _physics_process(delta: float) -> void:
	velocity.y += 900 * delta
	if is_on_floor() and (wall_check.is_colliding() or not floor_check.is_colliding()):
		dir = -dir
		flip.scale.x = -dir
	velocity.x = dir * speed
	move_and_slide()

func _on_head_body_entered(body: Node2D) -> void:
	if dead: return
	if body.is_in_group("player") and body.shape.can_smash and body.velocity.y > 0:
		smash(body)


func _on_hitbox_body_entered(body: Node2D) -> void:
	if dead: return
	if body.is_in_group("player"):
		if body.shape.can_smash and body.velocity.y > 0:
			return smash(body)
		body.die()
