extends Area2D

func _process(_delta):
	z_index = round(global_position.y)

func _on_body_entered(body):
	if body.is_in_group("player"):
		var plusLife = GlobalStats.maxLife * 0.25
		if GlobalStats.playerLife < GlobalStats.maxLife:
			if GlobalStats.playerLife + plusLife > GlobalStats.maxLife:
				GlobalStats.playerLife = GlobalStats.maxLife
			else: 
				GlobalStats.playerLife += plusLife
			queue_free()
		else:
			queue_free()

