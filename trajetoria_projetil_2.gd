extends Line2D

@onready var seta: Sprite2D = $"../ArrowSprite_2"
@onready var arma: Sprite2D = $"../Armas_2"

@export var gravidade: float = 980.0
@export var simulation_time: float = 1.5
@export var num_pontos_trajetoria: int = 50

func desenha_trajetoria(posicao_inicial: Vector2, forca: float):
	clear_points()
	visible = true
	
	global_position = posicao_inicial + arma.offset
	add_point(Vector2.ZERO)
	var direcao_mira = seta.get_aim_direction_vector()
	var velocidade = direcao_mira * forca
	var current_time = 0.0
	var dt = simulation_time / num_pontos_trajetoria
	
	for i in range(num_pontos_trajetoria):
		current_time += dt
		var x = velocidade.x * current_time
		var y = velocidade.y * current_time + 0.5 * gravidade * (current_time * current_time)
		add_point(Vector2(x, y))
	
	
	
	
