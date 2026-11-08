extends Resource
class_name ShapeData

@export var id := "drop"
@export var size := Vector2(14, 14)
@export var frames: SpriteFrames       # animações desta forma

@export_group("Ground")
@export var speed := 115.0
@export var accel := 1100.0

@export_group("Air")
@export var air_accel := 950.0
@export var gravity := 900.0
@export var jump_velocity := -290.0
@export var jump_cut := 0.45
@export var max_fall := 420.0

@export_group("Wind")
@export var wind_factor := 0.5   # quanto o vento empurra (Peso = 0, Avião = 1)

@export_group("Powers")
@export var can_press := false   # aperta botões (Peso)
@export var can_break := false   # quebra papel rasgado (Peso)
@export var can_smash := false   # esmaga borracha caindo (Peso)
