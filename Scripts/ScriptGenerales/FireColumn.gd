extends Area2D

var movimiento:int = 0

func _process(_delta):
	if $Fire == null:
		queue_free()
	else:
		global_position.x += movimiento
