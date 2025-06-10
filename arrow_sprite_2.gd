extends Sprite2D

@export var rotation_speed_degrees: float = 90.0
var current_rotation_direction: int = 0

func _ready():
	rotation = 0

func _process(delta):
	if Input.is_action_pressed("J02_ui_mira_baixo"):
		current_rotation_direction = 1
	elif Input.is_action_pressed("J02_ui_mira_cima"):
		current_rotation_direction = -1
	else:
		current_rotation_direction = 0
	
	if current_rotation_direction != 0:
		var rotation_delta = deg_to_rad(rotation_speed_degrees) * delta * current_rotation_direction
		rotation += rotation_delta
		visible = true
		
func get_aim_direction_vector() -> Vector2:
		return Vector2.RIGHT.rotated(rotation)
		
func set_aiming_active(active: bool):
	visible =  not active
	if not active:
		current_rotation_direction = 0
		
