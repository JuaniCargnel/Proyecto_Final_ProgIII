extends Node2D

func _process(_delta):
	z_index = round(global_position.y)

func _on_body_entered(body):
	if body.is_in_group("player"):
		$Pickup.play()
		$Timer.start()
		GlobalStats.activeSword = true

func _on_timer_timeout():
	queue_free()
