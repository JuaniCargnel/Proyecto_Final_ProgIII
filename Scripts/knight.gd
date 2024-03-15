extends CharacterBody2D

@export var inArea:bool = false
@export var canBeHit:bool = false
@export var inSprite:bool = false

var speed = 50 
var direccion = Vector2(1, 0) 
var derecha = true
var movimiento = true
var cambio = false

func _process(_delta):
	if $AreaKnight.global_position.x >= 600:
		if movimiento:
			$Timers/Idle.start()
			$Sprite.play("idle")
			$Sprite.set_flip_h(true)
			direccion.x = 0
			derecha = false
			movimiento = false
		elif cambio and !movimiento:
			cambio = false
			movimiento = true
			direccion.x = -1
			$Timers/Idle.stop()
	elif $AreaKnight.global_position.x <= 300:
		if movimiento:
			$Timers/Idle.start()
			$Sprite.play("idle")
			$Sprite.set_flip_h(false)
			direccion.x = 0
			derecha = true
			movimiento = false
		elif cambio and !movimiento:
			cambio = false
			movimiento = true
			direccion.x = 1
			$Timers/Idle.stop()
	else:
		$Sprite.play("run")

	#translate(direccion.normalized() * speed * delta)
	move_and_collide(direccion)

func _on_area_knight_area_entered(area):
	if area.is_in_group("areaSprite"):
		inSprite = true

func _on_area_knight_area_exited(area):
	if area.is_in_group("areaSprite"):
		inSprite = false

func _on_hitbox_cerca_body_entered(body):
	if body.is_in_group("player"):
		inArea = true

func _on_hitbox_cerca_body_exited(body):
	if body.is_in_group("player"):
		inArea = false
	
func _on_idle_timeout():
	cambio = true
	movimiento = false
