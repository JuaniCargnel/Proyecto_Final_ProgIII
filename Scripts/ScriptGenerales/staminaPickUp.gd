extends Area2D

# PickUp de Stamina. Funciona igual al de health 

func _process(_delta):
	z_index = round(global_position.y)
	if !GlobalStats.alive:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		var plusStamina = GlobalStats.maxStamina * 0.35
		$Pickup.play()
		$Timer.start()
		if GlobalStats.playerStamina < GlobalStats.maxStamina:
			if GlobalStats.playerStamina + plusStamina > GlobalStats.maxStamina:
				GlobalStats.playerStamina = GlobalStats.maxStamina
			else:
				GlobalStats.playerStamina += plusStamina

func _on_timer_timeout():
	GlobalStats.maxPickUpsScreen.erase(self)
	queue_free()
