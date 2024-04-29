extends Area2D

class_name cambioEscenas

@export var TagNivelDeDestino: String
@export var TagPuerta: String
@export var direccionSpawn = "up"

@onready var spawn = $Spawn

func _on_body_entered(body):
	if body.is_in_group("player"):
		NavigationManager.destination_level(TagNivelDeDestino, TagPuerta)
