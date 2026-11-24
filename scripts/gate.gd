extends StaticBody2D

func open() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3)
	tween.parallel().tween_property(self, "scale:x", 0.0, 0.3) 
	tween.tween_callback(queue_free)
