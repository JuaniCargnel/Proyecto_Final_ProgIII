extends Marker2D

# Un Marker2D que se utiliza como spawner de enemigos. 

var enemyScenes: Array = [] # Array que contiene las escenas de los enemigos
var spawnIntervalRange: Vector2 = Vector2(7, 14) # Rango de spawn entre cada enemigo
# Crea un diccionario con las caracteristicas de los enemigos (su nombre y su respectivo maximo de enemigos en pantalla)
var maxEnemies: Dictionary = {"SlimeVerde": GlobalStats.maxSlimeVerde, "SlimeRojo": GlobalStats.maxSlimeRojo, "SlimeMage": GlobalStats.maxSlimeMage} 

func _ready(): # Instancia las escenas de los enemigos
	enemyScenes.append({"name": "SlimeVerde", "scene": preload("res://Escenas/Personajes/SlimeVerde.tscn")})
	enemyScenes.append({"name": "SlimeRojo", "scene": preload("res://Escenas/Personajes/SlimeRojo.tscn")})
	enemyScenes.append({"name": "SlimeMage", "scene": preload("res://Escenas/Personajes/SlimeMage.tscn")})
	$Timer.set_wait_time(spawnIntervalRange.x + randf() * (spawnIntervalRange.y - spawnIntervalRange.x))
	$Timer.start()

func spawn_enemy(): #  Spawnea enemigos si el jugador esta vivo
	if GlobalStats.alive:
		var enemyInfo = enemyScenes[randi() % enemyScenes.size()] # Informacion del enemigo
		if get_tree().get_nodes_in_group(enemyInfo["name"]).size() < maxEnemies[enemyInfo["name"]]: # Instancia el enemigo si hay menos enemigos en pantalla
			var newEnemy = enemyInfo["scene"].instantiate()
			newEnemy.add_to_group(enemyInfo["name"])
			add_child(newEnemy)

func _on_timer_timeout():
	spawn_enemy()
	
	$Timer.set_wait_time(spawnIntervalRange.x + randf() * (spawnIntervalRange.y - spawnIntervalRange.x)) # Cambia el wait time del spawner y lo vuelve a iniciar
	$Timer.start()
