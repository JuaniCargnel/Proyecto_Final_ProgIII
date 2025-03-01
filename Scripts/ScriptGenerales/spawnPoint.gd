extends Marker2D

# Un Marker2D que se utiliza como spawner de enemigos. 

var enemyScenes: Array = [] # Array que contiene las escenas de los enemigos
# Crea un diccionario con las caracteristicas de los enemigos (su nombre y su respectivo maximo de enemigos en pantalla)
var maxEnemies: Dictionary = {"SlimeVerde": GlobalStats.maxSlimeVerde, "SlimeRojo": GlobalStats.maxSlimeRojo, "SlimeMage": GlobalStats.maxSlimeMage} 
	
func _ready(): # Instancia las escenas de los enemigos
	enemyScenes.append({"name": "SlimeVerde", "scene": preload("res://Escenas/Personajes/SlimeVerde.tscn")})
	enemyScenes.append({"name": "SlimeRojo", "scene": preload("res://Escenas/Personajes/SlimeRojo.tscn")})
	enemyScenes.append({"name": "SlimeMage", "scene": preload("res://Escenas/Personajes/SlimeMage.tscn")})
	#$Timer.set_wait_time(spawnIntervalRange.x + randf() * (spawnIntervalRange.y - spawnIntervalRange.x))

func spawn_enemy(): #  Spawnea enemigos si el jugador esta vivo
	if GlobalStats.alive:
		var enemyInfo = enemyScenes[randi() % enemyScenes.size()] # Informacion del enemigo
		if get_tree().get_nodes_in_group(enemyInfo["name"]).size() < maxEnemies[enemyInfo["name"]]: # Instancia el enemigo si hay menos enemigos en pantalla
			$AnimatedSprite2D.show()
			var newEnemy = enemyInfo["scene"].instantiate()
			newEnemy.add_to_group(enemyInfo["name"])
			get_parent().add_child(newEnemy)
			newEnemy.global_position = Vector2(global_position.x, global_position.y -10)
		else: 
			print("hola")
			$AnimatedSprite2D.hide()
			$AnimatedSprite2D2.hide()


func _on_animated_sprite_2d_animation_looped():
	$AnimatedSprite2D.stop()
	$AnimatedSprite2D.hide()
	$AnimatedSprite2D2.show()
	$AnimatedSprite2D2.play()

func _on_animated_sprite_2d_2_animation_looped():
	spawn_enemy()
	$Timer.start()

func _on_timer_timeout():
	queue_free()
