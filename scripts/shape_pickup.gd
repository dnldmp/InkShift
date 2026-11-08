extends Area2D

@export var shape: ShapeData

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	collision.shape.size = shape.size
	collision.position.y = -shape.size.y / 2
	if shape.frames:
		sprite.sprite_frames = shape.frames
		var frame := shape.frames.get_frame_texture("default", 0)
		sprite.offset.y = -frame.get_height() / 2.0
		sprite.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.learn(shape)
		queue_free()
