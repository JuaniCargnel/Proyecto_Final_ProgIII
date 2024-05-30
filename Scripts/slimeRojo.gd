extends CharacterBody2D

@export var inArea:bool = false
@export var recibirDmg:bool = false
@onready var navigationAgent: NavigationAgent2D = $Navigation/NavigationAgent2D
var fuego: PackedScene = preload("res://Escenas/Globales/Fire.tscn")

var life: int = 5
var speed: int = 70 
var estados: String = "idle"
var direccion: Vector2 = Vector2.ZERO
var isDeath: bool = false
var randomMovement: bool = false

var knockbackForce: Vector2 = Vector2.ZERO
var knockbackDuration: float = 0.2
var knockbackTimer: float = 0.0
var randomNumberX: int
var randomNumberY: int

func _ready():
	Sombra.crear_sombras($Sprite, $SombraMark)
	$DeathArea/CollisionShape2D.disabled = true

func _process(delta):
	if !GlobalStats.alive:
		queue_free()
	else:
		actions(delta)
		Sombra.update_sombras()

func actions(delta):
	if life > 0:
		match estados:
			"movements": 
				movements(delta)
				recibir_dmg()
			"idle":
				$Sprite.play("idle")
				$Timers/IdleTimer.start()
				estados = "think"
			"think":
				pass
	else: 
		if !isDeath:
			death()

func movements(delta):
	if velocity.x <= 0:
		$Sprite.set_flip_h(true)
	else:
		$Sprite.set_flip_h(false)
	
	direccion = navigationAgent.get_next_path_position() - global_position
	
	if knockbackTimer > 0.0:
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

func knockback(force: Vector2):
	knockbackForce = force
	knockbackTimer = knockbackDuration

func death():
	isDeath = true
	$Sprite.play("death")
	$Timers/ExplosionTimer.start()
	$FollowArea/CollisionShape2D.disabled = true
	$DmgArea/CollisionShape2D.disabled = true

func _on_timer_timeout():
	navigationAgent.target_position = Vector2(GlobalStats.positionPlayer.x , GlobalStats.positionPlayer.y + 12)

func _on_follow_area_body_entered(body):
	if body.is_in_group("player"):
		estados = "movements"
		randomMovement = false
		inArea = true

func _on_follow_area_body_exited(body):
	if body.is_in_group("player"):
		estados = "idle"
		inArea = false

func recibir_dmg():
	if recibirDmg:
		direccion = (global_position - GlobalStats.positionPlayer).normalized()
		var force = direccion * 75
		knockback(force)

func _on_death_timer_timeout():
	queue_free()

func _on_idle_timer_timeout():
	randomNumberX = randi_range(-1, 1) 
	randomNumberY = randi_range(-1, 1) 
	var fuegoInstance = fuego.instantiate()
	fuegoInstance.global_position = global_position
	get_parent().add_child(fuegoInstance)
	estados = "movements"
	randomMovement = true

func _on_explosion_timer_timeout():
	if $Sprite.frame == 11:
		$Sprite.global_position = Vector2($Sprite.global_position.x, $Sprite.global_position.y - 12)
		$Sprite/AnimatedSprite2D.global_position = Vector2($Sprite/AnimatedSprite2D.global_position.x - 12, $Sprite/AnimatedSprite2D.global_position.y + 20)
		$DeathArea/CollisionShape2D.disabled = false
		$Timers/DeathTimer.start()

func _on_death_area_body_entered(body):
	if body.is_in_group("player"):
		GlobalStats.playerLife -= 5
		GlobalStats.recibirDaño = true
		$DeathArea/CollisionShape2D.call_deferred("set_disabled", true)

func _on_death_area_body_exited(body):
	if body.is_in_group("player"):
		GlobalStats.recibirDaño = false

func _on_dmg_area_body_entered(body):
	if body.is_in_group("player"):
		GlobalStats.playerLife -= 1
		GlobalStats.recibirDaño = true

func _on_dmg_area_body_exited(body):
	if body.is_in_group("player"):
		GlobalStats.recibirDaño = false