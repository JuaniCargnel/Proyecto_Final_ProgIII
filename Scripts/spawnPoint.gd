extends Marker2D

var enemy_scene: PackedScene

func _ready():
	enemy_scene = preload("res://Escenas/Personajes/SlimeVerde.tscn")
	$Timer.set_wait_time(randi() % 7 + 4)
	$Timer.start()

func spawn_enemy():
	if GlobalStats.alive:
		var new_enemy = enemy_scene.instantiate()
		add_child(new_enemy)

func _on_timer_timeout():
	$Timer.set_wait_time(randi() % 7 + 4)
	spawn_enemy()
