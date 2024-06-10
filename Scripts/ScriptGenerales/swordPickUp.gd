extends Node2D

func _process(_delta):
	z_index = round(global_position.y)

func _on_body_entered(body):
	if body.is_in_group("player"):
		GlobalStats.activeSword = true
		queue_free()
