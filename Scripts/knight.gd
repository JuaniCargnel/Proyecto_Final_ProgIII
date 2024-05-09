extends Area2D

class_name enemyClass

@export var inArea:bool = false
@export var canBeHit:bool = false

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
	if personaje != null:
		direccion = position.direction_to(personaje.position) * speed
		if position.x > posicionAnterior.x:
			$Sprite.set_flip_h(false)
		elif position.x < posicionAnterior.x:
			$Sprite.set_flip_h(true)
		posicionAnterior = position
		$Sprite.play("run")
		translate(direccion.normalized() * speed * delta)
	else:
		$Sprite.play("idle")
		translate(direccion.normalized() * 0)

func _on_hitbox_cerca_body_entered(body):
	if body.is_in_group("player"):
		personaje = body

func _on_hitbox_cerca_body_exited(body):
	if body.is_in_group("player"):
		personaje = null

func _on_area_entered(area):
	if area.is_in_group("areaSprite"):
		inArea = true

func _on_area_exited(area):
	if area.is_in_group("areaSprite"):
		inArea = false

func _on_defense_timer_timeout():
	pass # Replace with function body.
