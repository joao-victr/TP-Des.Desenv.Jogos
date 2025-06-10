extends Sprite2D


@onready var arma_sprite := $"."
@onready var personagem = get_parent() # Referência ao CharacterBody2D (personagem)
@onready var seta: Sprite2D = $"../ArrowSprite"
@onready var trajetoria: Line2D = $"../TrajetoriaProjetil"

@export var offset_pistola: Vector2 = Vector2(50, 0)
@export var incremento_forca_segundo: float = 0.1
var posicao_inicial_projetil: Vector2
var gauge_scene = preload("res://gauge.tscn")
var anim_gauge


var arma_offset = Vector2(20, 0)  # Deslocamento inicial da arma
var ultima_direcao = 1  # 1 = direita, -1 = esquerda
var ProjetilScene = preload("res://tiro.tscn")
@export var max_forca: float = 6000

var carregando_forca = false
var forca := 0.0


var armas = {
	"pistola": preload("res://armas/pistola.png"),
	"kar": preload("res://armas/kar.png"),
	"awm" : preload("res://armas/awm.png")
}

var arma_atual = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	seta.visible = true
	trajetoria.visible = false
	#offset.x += 40
	
	visible = false  # Começa sem arma
	var gauge_node = gauge_scene.instantiate()
	add_child(gauge_node)
	anim_gauge = gauge_node.get_node("AnimatedSprite2D")
	anim_gauge.z_index = 10  # alterando o exio x para que a animação do gauge fique na frente
	anim_gauge.z_as_relative = false  # Importante para garantir que o z_index seja global e não relativo ao pai
	anim_gauge.position = Vector2(-20,40)
	anim_gauge.visible = false
	#atualizar_posicao()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		
	if Input.is_action_just_pressed("J02_ui_arma1"):
		equipar_arma("pistola")
	elif Input.is_action_just_pressed("J02_ui_arma2"):
		equipar_arma("kar")
	elif Input.is_action_just_pressed("J02_ui_arma3"):
		equipar_arma("awm")
	elif Input.is_action_just_pressed("J02_ui_soltar_arma"):
		soltar_arma()
	
	#atualizar_posicao() # Atualiza a posição da arma no processo (para que a arma sempre siga o personagem)
	
	if arma_atual != null:
		rotation = seta.rotation
		
	position = offset_pistola.rotated(rotation)
	
	#offset = (offset_pistola).rotated(rotation)
	rotation = seta.rotation
	if Input.is_action_just_pressed("J02_atirar"):
		print("atirou")
		carregando_forca = true
		seta.set_aiming_active(true)
		forca = 0.0
		anim_gauge.visible = true
		anim_gauge.play()  # Chama play só quando começa a carregar!
		
		
	if carregando_forca and Input.is_action_pressed("J02_atirar"):
		seta.visible = false
		forca += delta * incremento_forca_segundo
		forca = clamp(forca, 0.0, max_forca)
		posicao_inicial_projetil = global_position
		trajetoria.desenha_trajetoria(posicao_inicial_projetil, forca)

		# Se chegou no frame 5, para a animação para manter o frame travado
	if anim_gauge.frame >= 5:
		anim_gauge.frame = 5
		anim_gauge.stop()

	if carregando_forca and Input.is_action_just_released("J02_atirar"):
		disparar()
		trajetoria.visible = false
		trajetoria.clear_points()
		seta.set_aiming_active(false)
		carregando_forca = false
		anim_gauge.visible = false
		anim_gauge.stop()
		
	
func equipar_arma(nome: String):
	if nome in armas:
		texture = armas[nome]
		visible = true
		arma_atual = nome
		print("Arma equipada:", nome, " | Textura:", texture)

func soltar_arma():
	texture = null
	visible = false
	arma_atual = null
	print("Arma solta")

#func atualizar_posicao():
	#var direcao = 0
	#if personagem.velocity.x < 0:
		#direcao = -1
	#elif personagem.velocity.x > 0:
		#direcao = 1
	#else:
		#direcao = ultima_direcao
	#
	#ultima_direcao = direcao
	
	#abaixo, atualiza a posição do gauge para nao inverter junto da arma e se manter emabixo personagem
	#obs: como anim_gauge é um no filho de arma, ela inverte junto com o no pai, por isso tem que ajustar
	#if flip_h:
		#anim_gauge.position.x = 20  # o oposto de -20
	#else:
		#anim_gauge.position.x = -20
	
	
	# Ajuste do flip e do offset com base na arma atual
	#match arma_atual:
		#"pistola":
			#arma_offset.x = 30 * direcao
		#"kar":
			#arma_offset.x = 20 * direcao
		#"awm":
			#arma_offset.x = 20 * direcao
		#_:
			#arma_offset.x = 20 * direcao  # Padrão
#
	#flip_h = direcao == -1
	#arma_offset.y = 15
	#position.x += 100
	#global_position = personagem.global_position + arma_offset
	#offset+= Vector2(100, 0)

	
	
func disparar():
	if arma_atual == null:
		return
	carregando_forca = false
	print("Forca final: ", forca)
	var novo_projetil = ProjetilScene.instantiate()
	var direcao_mira = seta.get_aim_direction_vector()
	novo_projetil.direction = direcao_mira
	novo_projetil.global_position = global_position
	
	
	novo_projetil.forca = forca
	get_tree().current_scene.add_child(novo_projetil)
	print(novo_projetil.position.x)

			
		
		
