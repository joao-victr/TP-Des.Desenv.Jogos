extends Node2D

@onready var anim_reliquia_magia := $Tiles_e_reliquias/reliquia_magia
@onready var anim_reliquia_tech := $Tiles_e_reliquias/reliquia_tech



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	anim_reliquia_magia.play("anim_relic_magia")
	anim_reliquia_tech.play("reliquia_tech_idle")
