extends Camera2D

@onready var player1: CharacterBody2D = $"../JOGADOR1"
@onready var player2: CharacterBody2D = $"../JOGADOR2"

var turno_jogador: int = 1

func _ready() -> void:
	position_smoothing_enabled = true

func _process(delta):
	if turno_jogador == 1:
		position = player1.position
	elif turno_jogador == 2:
		position = player2.position
		
	if Input.is_action_just_pressed("ui_k"):
		if turno_jogador == 1:
			turno_jogador = 2
		else:
			turno_jogador = 1
