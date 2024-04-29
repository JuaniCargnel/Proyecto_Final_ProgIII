extends Node2D

func _ready():
	Sombra.crear_sombras($PersonajePrincipal)
	
	if NavigationManager.spawnDoorTag != null:
		level_spawn(NavigationManager.spawnDoorTag)

func level_spawn(destinationTag):
	var doorPath = "Area_" + destinationTag
	var door = get_node(doorPath) as cambioEscenas
	NavigationManager.trigger_player(door.spawn.global_position, door.direccionSpawn)
