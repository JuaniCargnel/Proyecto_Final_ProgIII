extends Node2D
var player: PackedScene = preload("res://Escenas/Personajes/PersonajePrincipal.tscn")

func _ready():
	if NavigationManager.spawnDoorTag != null:
		level_spawn(NavigationManager.spawnDoorTag)
		
	instance_player()

func _process(_delta):
	GlobalManager.render()

func instance_player():
	add_child(player.instantiate())

func level_spawn(destinationTag: String):
	var doorPath = "Area_" + destinationTag
	var door = get_node(doorPath) as cambioEscenas
	NavigationManager.trigger_player(door.spawn.global_position, door.direccionSpawn)
