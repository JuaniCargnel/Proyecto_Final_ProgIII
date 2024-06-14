extends Area2D

@export var inArea:bool = false

var fireOff = false

func _ready(): # Setea la animacion y crea las sombras
	$Sprite.play("fireStart")
	Sombra.crear_sombras($Sprite, $SombraMark)

func _process(_delta): # Apaga el fuego si el personaje esta muerto, si se termino el tiempo. Mientras este visible tiene sombra y actualiza el Zindex
	if !GlobalStats.alive:
		queue_free()
	elif fireOff:
		queue_free()
	else:
		Sombra.update_sombras()
		z_index = round(global_position.y)

func _on_render_area_body_entered(body): # Devuelve si el jugador esta dentro del area 
	if body.is_in_group("player"):
		inArea = true

func _on_render_area_body_exited(body): # Devuelve si el jugador esta fuera del area
	if body.is_in_group("player"):
		inArea = false

func _on_fire_down_timeout(): # Hace la animacion de apagar el fuego
	$Sprite.play("fireDown")
	$Timers/FireOff.start()

func _on_fire_start_timeout(): # Ejecuta el loop del fuego
	$Sprite.play("fireLoop")

func _on_fire_off_timeout(): # Apaga el fuego completamente
	fireOff = true

func _on_area_entered(area): # Le hace daño al jugador 
	if area.is_in_group("playerDmg"):
		GlobalStats.playerLife -= 1
		GlobalStats.recibirDanio = true
		$Timers/DmgTimer.start()

func _on_area_exited(area):
	if area.is_in_group("playerDmg"):
		$Timers/DmgTimer.stop()
		GlobalStats.recibirDanio = false

func _on_dmg_timer_timeout(): # Loopea el daño
	GlobalStats.playerLife -= 1
