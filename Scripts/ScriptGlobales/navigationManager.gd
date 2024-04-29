extends Node

const scenePrueba = preload("res://Escenas/PantallaPrueba.tscn")
const sceneP1 = preload("res://Escenas/Pantalla1.tscn")

signal onTriggerPlayer

var spawnDoorTag

func destination_level(levelTag, destinationTag):
	var sceneToLoad
	
	match levelTag:
		"PantallaPrueba":
			sceneToLoad = scenePrueba
		"Pantalla1":
			sceneToLoad = sceneP1
		
	if sceneToLoad != null:
		spawnDoorTag = destinationTag
		get_tree().change_scene_to_packed(sceneToLoad)

func trigger_player(position, direction):
	onTriggerPlayer.emit(position, direction)
