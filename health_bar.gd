extends TextureProgressBar

@onready var player: CharacterBody2D = $".."

func update(new_health: int):
	value = new_health * 100 / player.max_health
	
func _ready() -> void:
	position.y -= 30
	player.health_changed.connect(update)
