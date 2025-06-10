extends Node2D

@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play()  # Toca a animação
	if not anim.animation_finished.is_connected(_on_animation_finished):
		anim.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	queue_free()  # Remove a explosão após a animação terminar
