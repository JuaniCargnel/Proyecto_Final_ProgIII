extends Area2D

@export var inArea:bool = false

var fireOff = false

func _ready():
	$Sprite.play("fireStart")
	Sombra.crear_sombras($Sprite, $SombraMark)

func _process(_delta):
	if !GlobalStats.alive:
		queue_free()
	elif fireOff:
		queue_free()
	else:
		Sombra.update_sombras()

func _on_render_area_body_entered(body):
	if body.is_in_group("player"):
		inArea = true

func _on_render_area_body_exited(body):
	if body.is_in_group("player"):
		inArea = false

func _on_fire_down_timeout():
	$Sprite.play("fireDown")
	$Timers/FireOff.start()

func _on_fire_start_timeout():
	$Sprite.play("fireLoop")

func _on_fire_off_timeout():
	fireOff = true

func _on_body_entered(body):
	if body.is_in_group("player"):
		GlobalStats.playerLife -= 1
		GlobalStats.recibirDaño = true
		$Timers/DmgTimer.start()

func _on_body_exited(body):
	if body.is_in_group("player"):
		$Timers/DmgTimer.stop()
		GlobalStats.recibirDaño = false

func _on_dmg_timer_timeout():
	GlobalStats.playerLife -= 1


