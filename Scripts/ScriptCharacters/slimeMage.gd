extends CharacterBody2D

@export var inArea:bool = false
@export var recibirDmg:bool = false
var fireBall: PackedScene = preload("res://Escenas/Globales/FireBall.tscn")

# Estadisticas y variables del Slime
var life: float = 3
var hitDmg: float = 1
var speed: int = 70 
var isDeath: bool = false
var estados: String = "idle"
var direccion: Vector2 = Vector2.ZERO

# Variables para generar el knockback y el movimiento aleatorio
var knockbackForce: Vector2 = Vector2.ZERO
var knockbackDuration: float = 0.2
var knockbackTimer: float = 0.0
var randomNumberX: int
var randomNumberY: int
var randomMovement: bool = false

func _ready(): # Seteo de variables al instanciar cada slime
	Sombra.crear_sombras($Sprite, $SombraMark)
	life *= GlobalStats.enemyLifeIncrement
	hitDmg *= GlobalStats.enemyDmgIncress
	$Sprite.material.set_shader_parameter("flicker_enabled", false)

func _process(delta): # Process del slime - Si el jugador esta vivo - Si el jugador esta muerto
	if !GlobalStats.alive:
		queue_free()
	else:
		actions(delta)
		Sombra.update_sombras()
		z_index = round(global_position.y)
		
		if $Timers/FireBall.get_time_left() <= 1.5 and $Timers/FireBall.get_time_left() > 0: # Activa un flickr cuando el slime esta por golpear (funciona regular)
			$Sprite.material.set_shader_parameter("flicker_enabled", true)

func actions(delta): # Arbol de acciones/estados del slime
	if life > 0:
		match estados:
			"movements": 
				movements(delta)
				recibir_dmg()
			"idle":
				$Sprite.play("idle")
				$Timers/IdleTimer.start()
				estados = "think"
			"think": # Estado de paso, no hace nada
				pass
	else: 
		if !isDeath:
			death()

func movements(delta): # Movimientos del slime (Gestion de la knockback y el movimiento random)
	if velocity.x <= 0:
		$Sprite.set_flip_h(true)
	else:
		$Sprite.set_flip_h(false)
	
	if knockbackTimer > 0.0:
		$Sprite.play("dmg")
		knockbackTimer -= delta
		velocity = knockbackForce
	elif randomMovement:
		$Sprite.play("idle")
		speed = 40
		velocity = velocity.lerp(Vector2(randomNumberX,randomNumberY).normalized() * speed, 7 * delta)
		
	move_and_slide()

func knockback(force: Vector2): # Crea el knockback
	knockbackForce = force
	knockbackTimer = knockbackDuration

func death(): # Funcion al morir (quita todo para no producir problemas)
	isDeath = true
	GlobalStats.enemyCounter += 1
	$Sprite.play("death")
	$Timers/DeathTimer.start()
	$DmgArea/CollisionShape2D.disabled = true
	$ShootingArea/CollisionShape2D.disabled = true

func recibir_dmg(): # Al recibir dmg ejecuta el knockback en la direccion contraria del jugador
	if recibirDmg:
		$Dmg.play()
		direccion = (global_position - GlobalStats.positionPlayer).normalized()
		var force = direccion * 75
		knockback(force)

########################################################################################
#################################  CONTROL DE NODOS ####################################
########################################################################################

func _on_death_timer_timeout(): # Se libera de la queue
	queue_free()

func _on_idle_timer_timeout(): # Se mueve aleatoriamente cada vez que termine el timer
	randomNumberX = randi_range(-1, 1) 
	randomNumberY = randi_range(-1, 1) 
	estados = "movements"
	randomMovement = true

func _on_dmg_area_area_entered(area): # Daño por contacto
	if area.is_in_group("playerDmg"):
		GlobalStats.playerLife -= 1
		GlobalStats.recibirDanio = true
		$Timers/DmgTimer.start()

func _on_dmg_area_area_exited(area): # Elimina el daño por contacto
	if area.is_in_group("playerDmg"):
		GlobalStats.recibirDanio = false
		$Timers/DmgTimer.stop()

func _on_dmg_timer_timeout(): # Continua haciendo daño cada vez que termina el timer si el jugador sigue ne la hitbox (Como si fueran Iframes pero mal)
	GlobalStats.recibirDanio = true
	GlobalStats.playerLife -= 1

func _on_shooting_area_body_entered(body): # Si el player entra en el area de disparo ejecuta el timerr
	if body.is_in_group("player"):
		$Timers/FireBall.start()

func _on_fire_ball_timeout(): # Dispara la fireball y apaga el flicker
	var fireBallInstance = fireBall.instantiate()
	get_parent().add_child(fireBallInstance)
	fireBallInstance.global_position = global_position
	fireBallInstance.direction = (GlobalStats.positionPlayer - fireBallInstance.global_position).normalized()
	$Sprite.material.set_shader_parameter("flicker_enabled", false)

func _on_shooting_area_body_exited(body): # Apaga el flicker y el disparo
	if body.is_in_group("player"):
		$Timers/FireBall.stop()
		$Sprite.material.set_shader_parameter("flicker_enabled", false)
