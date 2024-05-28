extends CharacterBody2D

@export var inArea:bool = false
@onready var navigationAgent: NavigationAgent2D = $Navigation/NavigationAgent2D

var life = 5
var speed = 70 
var isDeath = false
var estados = "idle"
var direccion = Vector2.ZERO

var knockback_force: Vector2 = Vector2.ZERO
var knockback_duration: float = 0.2
var knockback_timer: float = 0.0

func _process(delta):
	actions(delta)

func actions(delta):
	if life > 0:
		match estados:
			"follow": 
				movements(delta)
			"idle":
				$Sprite.play("idle")
				speed = 0
	else: 
		if !isDeath:
			death()

func movements(delta):
	speed = 70
	
	$Sprite.play("run")
	
	if global_position.x > GlobalStats.positionPlayer.x:
		$Sprite.set_flip_h(true)
	elif global_position.x < GlobalStats.positionPlayer.x:
		$Sprite.set_flip_h(false)
	
	direccion = navigationAgent.get_next_path_position() - global_position
	
	if knockback_timer > 0.0:
		knockback_timer -= delta
		velocity = knockback_force
	else:
		knockback_force = Vector2.ZERO
		velocity = velocity.lerp(direccion.normalized() * speed, 7 * delta)
	
	move_and_slide()

func knockback(force: Vector2):
	knockback_force = force
	knockback_timer = knockback_duration

func death():
	isDeath = true
	$Sprite.play("death")
	$Timers/DeathTimer.start()
	$Hitbox.disabled = true
	$FollowArea/CollisionShape2D.disabled = true

func _on_timer_timeout():
	navigationAgent.target_position = Vector2(GlobalStats.positionPlayer.x - 8, GlobalStats.positionPlayer.y + 12)

func _on_follow_area_body_entered(body):
	if body.is_in_group("player"):
		estados = "follow"
		inArea = true

func _on_follow_area_body_exited(body):
	if body.is_in_group("player"):
		estados = "idle"
		inArea = false

func _on_dmg_area_area_entered(area):
	if area.is_in_group("golpe"):
		direccion = (global_position - GlobalStats.positionPlayer).normalized()
		var force = direccion * 75
		knockback(force)
		life -= 1

func _on_death_timer_timeout():
	queue_free()
