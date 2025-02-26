extends CharacterBody2D

@export var inArea:bool = false
@export var recibirDmg:bool = false
@onready var navigationAgent: NavigationAgent2D = $Navigation/NavigationAgent2D
var fuego: PackedScene = preload("res://Escenas/Globales/Fire.tscn")

# Estadisticas y variables del Slime
var life: float = 6
var hitDmg: float = 1
var speed: int = 70 
var estados: String = "idle"
var direccion: Vector2 = Vector2.ZERO
var isDeath: bool = false

# Variables para generar el knockback y el movimiento aleatorio
var randomMovement: bool = false
var knockbackForce: Vector2 = Vector2.ZERO
var knockbackDuration: float = 0.2
var knockbackTimer: float = 0.0
var randomNumberX: int
var randomNumberY: int

func _ready(): # Seteo de variables al instanciar cada slime
	Sombra.crear_sombras($Sprite, $SombraMark)
	$DeathArea/CollisionShape2D.disabled = true
	life *= GlobalStats.enemyLifeIncrement
	hitDmg *= GlobalStats.enemyDmgIncress

func _process(delta): # Process del slime - Si el jugador esta vivo - Si el jugador esta muerto
	if !GlobalStats.alive:
		queue_free()
	else:
		actions(delta)
		Sombra.update_sombras()
		z_index = round(global_position.y)

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
		
	direccion = navigationAgent.get_next_path_position() - global_position  # Sigue al jugador
	
	if knockbackTimer > 0.0: # Varia entre el estado de follow, knockback y random mov
		$Sprite.play("dmg")
		knockbackTimer -= delta
		velocity = knockbackForce
	elif randomMovement:
		speed = 40
		velocity = velocity.lerp(Vector2(randomNumberX,randomNumberY).normalized() * speed, 7 * delta)
	else:
		speed = 70
		$Timers/IdleTimer.stop()
		$Sprite.play("run")
		knockbackForce = Vector2.ZERO
		velocity = velocity.lerp(direccion.normalized() * speed, 7 * delta)
		
	move_and_slide()

func knockback(force: Vector2): # Crea el knockback
	knockbackForce = force
	knockbackTimer = knockbackDuration

func death(): # Funcion al morir (quita todo para no producir problemas)
	isDeath = true
	GlobalStats.enemyCounter += 1
	$Sprite.play("death")
	$Timers/ExplosionTimer.start()
	$FollowArea/CollisionShape2D.disabled = true
	$DmgArea/CollisionShape2D.disabled = true
	$Hitbox.disabled = true

func recibir_dmg(): # Al recibir dmg ejecuta el knockback en la direccion contraria del jugador
	if recibirDmg: 
		$Dmg.play()
		direccion = (global_position - GlobalStats.positionPlayer).normalized()
		var force = direccion * 75
		knockback(force)

########################################################################################
#################################  CONTROL DE NODOS ####################################
########################################################################################

func _on_timer_timeout(): # Sigue la posicion de los pies del jugador
	navigationAgent.target_position = Vector2(GlobalStats.positionPlayer.x , GlobalStats.positionPlayer.y)

func _on_follow_area_body_entered(body): # Sigue al jugador y deja de estar en random
	if body.is_in_group("player"):
		estados = "movements"
		randomMovement = false
		inArea = true

func _on_follow_area_body_exited(body): # Entra en idle 
	if body.is_in_group("player"):
		estados = "idle"
		inArea = false

func _on_death_timer_timeout(): # Se libera de la queue
	queue_free()

func _on_idle_timer_timeout(): # Se mueve aleatoriamente cada vez que termine el timer
	randomNumberX = randi_range(-1, 1) 
	randomNumberY = randi_range(-1, 1) 
	var fuegoInstance = fuego.instantiate() # Instancia y genera un fuego que se crea al estar en idle
	fuegoInstance.global_position = position
	get_parent().add_child(fuegoInstance)
	estados = "movements"
	randomMovement = true

func _on_explosion_timer_timeout(): # Al morir, explota y hace daño
	if $Sprite.frame == 11:
		$Sprite.global_position = Vector2($Sprite.global_position.x, $Sprite.global_position.y - 12)
		$Sprite/AnimatedSprite2D.global_position = Vector2($Sprite/AnimatedSprite2D.global_position.x - 12, $Sprite/AnimatedSprite2D.global_position.y + 20)
		$DeathArea/CollisionShape2D.disabled = false
		$Timers/DeathTimer.start()

func _on_dmg_area_area_entered(area): # Daño por contacto
	if area.is_in_group("playerDmg"):
		GlobalStats.playerLife -= hitDmg
		GlobalStats.recibirDanio = true
		$Timers/DmgTimer.start()

func _on_dmg_area_area_exited(area): # Elimina el daño por contacto
	if area.is_in_group("playerDmg"):
		GlobalStats.recibirDanio = false
		$Timers/DmgTimer.stop()

func _on_death_area_area_entered(area): # Daño de la explosion
	if area.is_in_group("playerDmg"):
		GlobalStats.playerLife -= 3 * GlobalStats.enemyDmgIncress
		GlobalStats.recibirDanio = true
		$DeathArea/CollisionShape2D.call_deferred("set_disabled", true)

func _on_death_area_area_exited(area): # Elimina el daño por explosion
	if area.is_in_group("playerDmg"):
		GlobalStats.recibirDanio = false
		
func _on_dmg_timer_timeout(): # Continua haciendo daño cada vez que termina el timer si el jugador sigue ne la hitbox (Como si fueran Iframes pero mal)
		GlobalStats.recibirDanio = true
		GlobalStats.playerLife -= 1
