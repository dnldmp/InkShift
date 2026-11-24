extends StaticBody2D

@onready var rect: NinePatchRect = $NinePatchRect
@onready var body_shape: CollisionShape2D = $CollisionShape2D
@onready var detector_shape: CollisionShape2D = $Detector/CollisionShape2D

func _ready() -> void:
	var size := rect.size
	var center := rect.position + size / 2
	body_shape.shape.size = size
	body_shape.position = center
	detector_shape.shape.size = Vector2(size.x - 4, 6)
	detector_shape.position = Vector2(center.x, rect.position.y - 3)

func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.shape.can_break:
			queue_free()
