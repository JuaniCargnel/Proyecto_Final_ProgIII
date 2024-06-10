extends Marker2D

var enemy_scenes: Array = []
var spawn_interval_range: Vector2 = Vector2(7, 14)
var max_enemies: Dictionary = {"SlimeVerde": 20, "SlimeRojo": 10}

func _ready():
	# Preload the enemy scenes
	enemy_scenes.append({"name": "SlimeVerde", "scene": preload("res://Escenas/Personajes/SlimeVerde.tscn")})
	enemy_scenes.append({"name": "SlimeRojo", "scene": preload("res://Escenas/Personajes/SlimeRojo.tscn")})
	
	# Start the timer with a random interval
	$Timer.set_wait_time(spawn_interval_range.x + randf() * (spawn_interval_range.y - spawn_interval_range.x))
	$Timer.start()

func spawn_enemy():
	if GlobalStats.alive:
		# Choose a random enemy scene
		var enemy_info = enemy_scenes[randi() % enemy_scenes.size()]
		
		# Check if we have reached the maximum number of this enemy type
		if get_tree().get_nodes_in_group(enemy_info["name"]).size() < max_enemies[enemy_info["name"]]:
			# Instantiate the enemy and add it to the scene
			var new_enemy = enemy_info["scene"].instantiate()
			new_enemy.add_to_group(enemy_info["name"])
			add_child(new_enemy)

func _on_timer_timeout():
	# Spawn an enemy
	spawn_enemy()
	
	# Reset the timer with a new random interval
	$Timer.set_wait_time(spawn_interval_range.x + randf() * (spawn_interval_range.y - spawn_interval_range.x))
	$Timer.start()
