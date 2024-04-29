extends Node2D

#Fijarse lo del zindex (no es necesario, pero si hay 2 entidades solo revisa una de ellas y la otra se "caga") 
#Revisar el tema de donde hace daño, no deberia hacer daño de todos lados... o si, hay que veer como lo planteo
#Renombrar y verificar bien el codigo y los errores que saltan por el video de navegar entre escenas
#Seguir armando de una manera mas correcta y adaptada el codigo, ademas de cambiar nombres y ordenar un poco todo
#Utilizar mas variables globales para cosas como los contactos en general asi no hay quedeclararlas una vez en cada nivel
#Ver bien el planteo por niveles, que no pegue cuando presiono botones en el menu principal, separar las cosas, utilizar mas el ready


func _ready():
	var sombras = get_tree().get_nodes_in_group("sprites")
	for sprite in sombras:
		print(sprite)
		Sombra.crear_sombras(sprite)
		
	if NavigationManager.spawnDoorTag != null:
		level_spawn(NavigationManager.spawnDoorTag)

func _process(_delta):
	update_sombras()
	update_enemy()

func update_sombras():
	var sombras = get_tree().get_nodes_in_group("sprites")
	for sprite in sombras:
		Sombra.update_sombras(sprite)

func update_enemy():
	var enemigos = get_tree().get_nodes_in_group("enemigos")
	for enemy in enemigos:
		on_hit(enemy)
		render($PersonajePrincipal, enemy)

func level_spawn(destinationTag: String):
	var doorPath = "Area_" + destinationTag
	var door = get_node(doorPath) as cambioEscenas
	NavigationManager.trigger_player(door.spawn.global_position, door.direccionSpawn)

func render(sprite1, sprite2):
	if sprite1.position.y >= sprite2.position.y and sprite2.inSprite:
		sprite2.z_index = 1
		sprite1.z_index = 2
	elif sprite1.position.y <= sprite2.position.y and sprite2.inSprite:
		sprite1.z_index = 1
		sprite2.z_index = 2

func on_hit(enemy):
	if $PersonajePrincipal.position.y >= enemy.position.y - 5 and $PersonajePrincipal.position.y <= enemy.position.y + 4 and enemy.inArea:
		enemy.canBeHit = true
	else:
		enemy.canBeHit = false


