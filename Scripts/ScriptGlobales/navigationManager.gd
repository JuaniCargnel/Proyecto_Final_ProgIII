extends Node

const sceneP1A = preload("res://Escenas/Pantalla1A.tscn")
const sceneP1B = preload("res://Escenas/Pantalla1B.tscn")

signal onTriggerPlayer

var spawnDoorTag

func destination_level(levelTag: String, destinationTag: String):
	var sceneToLoad
	
	match levelTag:
		"Pantalla1A":
			sceneToLoad = sceneP1A
		"Pantalla1B":
			sceneToLoad = sceneP1B
		
	if sceneToLoad != null:
		spawnDoorTag = destinationTag
		get_tree().call_deferred("change_scene_to_packed", sceneToLoad)

func trigger_player(position: Vector2, direction: String):
	onTriggerPlayer.emit(position, direction)
