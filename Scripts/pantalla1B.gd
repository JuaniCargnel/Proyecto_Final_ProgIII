extends Node2D

func _ready():
	var nodos = get_tree().get_nodes_in_group("nodo")
	for sprites in nodos:
		Sombra.crear_sombras(sprites)
		
	if NavigationManager.spawnDoorTag != null:
		level_spawn(NavigationManager.spawnDoorTag)

func _process(_delta):
	Sombra.update_sombras()

func level_spawn(destinationTag: String):
	var doorPath = "Area_" + destinationTag
	var door = get_node(doorPath) as cambioEscenas
	NavigationManager.trigger_player(door.spawn.global_position, door.direccionSpawn)

