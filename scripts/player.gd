extends CharacterBody2D

@onready var camera: Camera2D = $Camera2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var fit_check: ShapeCast2D = $FitCheck

@export var all_shapes: Array[ShapeData]

const COYOTE_TIME := 0.1      # ainda pula logo depois de sair da borda
const JUMP_BUFFER := 0.12     # apertar um pouco antes de tocar o chão também vale

var coyote := 0.0
var jump_buffer := 0.0

var shape: ShapeData
var unlocked: Array[ShapeData] = []

var respawn_point: Vector2

func _ready() -> void:
	respawn_point = global_position
	unlocked.append(all_shapes[0])
	apply_shape(all_shapes[0])
	

func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("move_left", "move_right")
	velocity.x = move_toward(velocity.x, dir * shape.speed, shape.accel * delta)
	velocity.y += shape.gravity * delta

	if is_on_floor():
		coyote = COYOTE_TIME
	else:
		coyote -= delta

	if Input.is_action_just_pressed("jump"):
		jump_buffer = JUMP_BUFFER
	else:
		jump_buffer -= delta

	if jump_buffer > 0 and coyote > 0:
		velocity.y = shape.jump_velocity
		jump_buffer = 0
		coyote = 0

	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= shape.jump_cut
	
	update_anim()
	
	move_and_slide()
	
	if dir != 0:
		camera.offset.x = lerp(camera.offset.x, dir * 40.0, 2.0 * delta)
		sprite.flip_h = dir < 0
	
	if Input.is_action_just_pressed("shape_next"):
		next_shape(1)
	if Input.is_action_just_pressed("shape_prev"):
		next_shape(-1)
	
	if Input.is_action_just_pressed("restart"):
		die()

func apply_shape(new_shape: ShapeData) -> void:
	shape = new_shape
	collision.shape.size = shape.size
	collision.position.y = -shape.size.y / 2
	
	if shape.frames:
		sprite.sprite_frames = shape.frames
		var frame := shape.frames.get_frame_texture("default", 0)
		sprite.offset.y = -frame.get_height() / 2.0
		sprite.play("default")

func next_shape(step: int) -> void:
	var i := unlocked.find(shape)
	try_shape(unlocked[posmod(i + step, unlocked.size())])

func try_shape(new_shape: ShapeData) -> void:
	var test := RectangleShape2D.new()
	test.size = new_shape.size - Vector2(1, 1)
	fit_check.shape = test
	fit_check.position.y = -new_shape.size.y / 2 - 0.5
	fit_check.force_shapecast_update()
	if fit_check.is_colliding():
		return   # aqui: tocar um som de "não" e tremer a tela
	apply_shape(new_shape)

func die() -> void:
	set_physics_process(false)
	visible = false
	await get_tree().create_timer(0.2).timeout
	global_position = respawn_point
	reset_physics_interpolation()
	velocity = Vector2.ZERO
	apply_shape(all_shapes[0])
	visible = true
	set_physics_process(true)

func learn(new_shape: ShapeData) -> void:
	if not unlocked.has(new_shape):
		unlocked.append(new_shape)
	try_shape(new_shape)

func update_anim() -> void:
	var anim := "default"
	if not is_on_floor():
		anim = "jump" if velocity.y < 0 else "fall"
	if sprite.sprite_frames.has_animation(anim):
		sprite.play(anim)
