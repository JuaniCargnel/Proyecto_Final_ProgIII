extends Node2D

#Revisar el tema de donde hace daño, no deberia hacer daño de todos lados... o si, hay que veer como lo planteo
#Seguir armando de una manera mas correcta y adaptada el codigo, ademas de cambiar nombres y ordenar un poco todo

func _ready():
	get_window().set_content_scale_factor(1)
	var nodos = get_tree().get_nodes_in_group("nodo")
	for sprites in nodos:
		Sombra.crear_sombras(sprites)
		
	if NavigationManager.spawnDoorTag != null:
		level_spawn(NavigationManager.spawnDoorTag)

func _process(_delta):
	Sombra.update_sombras()
	GlobalManager.render()

func level_spawn(destinationTag: String):
	var doorPath = "Area_" + destinationTag
	var door = get_node(doorPath) as cambioEscenas
	NavigationManager.trigger_player(door.spawn.global_position, door.direccionSpawn)




