extends Area2D

func _process(_delta):
	z_index = round(global_position.y)

func _on_body_entered(body):
	if body.is_in_group("player"):
		var plusStamina = GlobalStats.maxStamina * 0.25
		if GlobalStats.playerStamina < GlobalStats.maxStamina:
			if GlobalStats.playerStamina + plusStamina > GlobalStats.maxStamina:
				GlobalStats.playerStamina = GlobalStats.maxStamina
			else: 
				GlobalStats.playerStamina += plusStamina
			queue_free()
		else:
			queue_free()

