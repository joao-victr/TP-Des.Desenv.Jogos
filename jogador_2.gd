extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
@onready var anim_walk := $AnimatedSprite2D_2 

@export var pode_andar: bool = true
var direction: int

# Variável de estado para controlar se a animação de habilidade está ativa
var is_skill_active: bool = false 

func _ready() -> void:
	anim_walk.animation_finished.connect(_on_anim_mago_animation_finished)
	pass
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("J02_ui_confirmar_acao"):
		pode_andar = not pode_andar
		velocity = Vector2(0, 0)
		
	direction = Input.get_axis("J02_ui_left", "J02_ui_right")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	#
	if is_skill_active:
		velocity.x = 0 
		move_and_slide()
		return 

	
	if pode_andar:
		if Input.is_action_just_pressed("J02_ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		if direction:
			velocity.x = direction * SPEED
			
			if anim_walk.animation != "Walk":
				anim_walk.play("Walk")
			
			anim_walk.flip_h = direction < 0
				
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if is_on_floor() and anim_walk.animation != "Idle":
				anim_walk.play("Idle")
	else: 
		velocity.x = move_toward(velocity.x, 0, SPEED) 
		if anim_walk.animation != "Idle":
			anim_walk.play("Idle")

	move_and_slide()


func _on_anim_mago_animation_finished():
	
	if anim_walk.animation == "Skill": 
		is_skill_active = false 
		if anim_walk.animation != "Idle": 
			anim_walk.play("Idle")
