extends Area2D


func _process(_delta):
	if $Fire != null:
		global_position.x += 1
	else:
		queue_free()
