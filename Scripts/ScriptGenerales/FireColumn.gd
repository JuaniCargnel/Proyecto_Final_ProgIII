extends Area2D

var movimiento:int = 0

func _process(_delta):
	if $Fire != null:
		global_position.x += movimiento
	else:
		queue_free()
