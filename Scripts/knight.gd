extends Area2D

class_name enemyClass

@export var inArea:bool = false
@export var canBeHit:bool = false
@export var inSprite:bool = false

var speed = 50 
var direccion = Vector2(1, 0) 
var posicionAnterior = Vector2()
var derecha = true
var movimiento = true
var cambio = false
var personaje = null

func _ready():
	posicionAnterior = position

func _process(delta):
	if $CollisionShape2D.global_position.x >= 600:
		if movimiento:
			$Timers/Idle.start()
			$Sprite.play("idle")
			$Sprite.set_flip_h(true)
			direccion = Vector2(0,0)
			derecha = false
			movimiento = false
		elif cambio and !movimiento:
			cambio = false
			movimiento = true
			direccion.x = -1
			$Timers/Idle.stop()
	elif $CollisionShape2D.global_position.x <= 300:
		if movimiento:
			$Timers/Idle.start()
			$Sprite.play("idle")
			$Sprite.set_flip_h(false)
			direccion = Vector2(0,0)
			derecha = true
			movimiento = false
		elif cambio and !movimiento:
			cambio = false
			movimiento = true
			direccion.x = 1
			$Timers/Idle.stop()
	elif personaje != null:
		direccion = position.direction_to(personaje.position) * speed
		if position.x > posicionAnterior.x:
			$Sprite.set_flip_h(false)
		elif position.x < posicionAnterior.x:
			$Sprite.set_flip_h(true)
			
		posicionAnterior = position
	else:
		$Sprite.play("run")
		
	translate(direccion.normalized() * speed * delta)
	#move_and_collide(direccion.normalized())

func _on_hitbox_cerca_body_entered(body):
	if body.is_in_group("player"):
		inArea = true
		personaje = body

func _on_hitbox_cerca_body_exited(body):
	if body.is_in_group("player"):
		inArea = false
		personaje = null
		
func _on_idle_timeout():
	cambio = true
	movimiento = false

func _on_area_entered(area):
	if area.is_in_group("areaSprite"):
		inSprite = true

func _on_area_exited(area):
	if area.is_in_group("areaSprite"):
		inSprite = false
