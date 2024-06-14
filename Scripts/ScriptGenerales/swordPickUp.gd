extends Node2D

# Funciona similar al health pickup

func _process(_delta):
	z_index = round(global_position.y)
	if !GlobalStats.alive:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		$Pickup.play()
		$Timer.start()
		GlobalStats.activeSword = true
		if GlobalStats.activeSword: # setea el time a 0 para poder reiniciar el timer de la espada
			GlobalStats.swordTime = 0

func _on_timer_timeout():
	GlobalStats.maxPickUpsScreen.erase(self)
	queue_free()
