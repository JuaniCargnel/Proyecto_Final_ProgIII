extends CharacterBody2D

class_name enemyClass

# Arreglar para que se le pueda pegar y el knockback, y el ataque para que la hitbox haga daño desde el player 

@export var inArea:bool = false
@onready var navigationAgent: NavigationAgent2D = $Navigation/NavigationAgent2D

var canBeHit:bool = false
var life = 5
var speed = 70 
var direccion = Vector2(1, 0) 
var posicionAnterior = Vector2()
var isDeath = false
var iFrames = false
var canHit = true
var estados = "idle"
var knockbackFrames = 5
var knockbackDirection: Vector2
var knockbackFramesRemaining: int

func _ready():
	posicionAnterior = global_position

func _process(delta):
	actions(delta)

func actions(delta):
	if life > 0:
		match estados:
			"hit": 
				hitting()
			"follow": 
				following(delta)
			"damage":
				on_damage()
				knockback(delta)
			"idle":
				$Sprite.play("idle")
				speed = 0
	else: 
		if !isDeath:
			death()

func following(delta):
	speed = 70
	
	$Sprite.play("run")
	
	if position.x > posicionAnterior.x:
		$Sprite.set_flip_h(false)
	elif position.x < posicionAnterior.x:
		$Sprite.set_flip_h(true)
		
	posicionAnterior = global_position
	
	direccion = navigationAgent.get_next_path_position() - global_position
	direccion = direccion.normalized()
	
	if navigationAgent.is_target_reached():
		velocity = Vector2.ZERO
		estados = "hit"
	else: 
		velocity = velocity.lerp(direccion * speed, 7 * delta)
	
	move_and_slide()

func hitting():
	if GlobalStats.positionPlayer.y >= global_position.y - 5 and GlobalStats.positionPlayer.y <= global_position.y + 4 and navigationAgent.is_target_reached():
		if canHit:
			$HittingArea/HitboxHit.call_deferred("set_disabled", false)
			$Timers/AttackATimer.start()
			$Sprite.play("attack")
			canHit = false
			
			if $Sprite.is_flipped_h():
				$HittingArea/HitboxHit.position = Vector2(-20,-3)
			else:
				$HittingArea/HitboxHit.position = Vector2(20,-3)
	else: 
		estados = "follow"

func on_damage():
	if !iFrames:
		knockbackDirection = -direccion.normalized()
		knockbackFramesRemaining = knockbackFrames
		life -= 1
		iFrames = true
		$Timers/IFramesTimer.start()

func death():
	isDeath = true
	$Sprite.play("death")
	$Timers/DeathTimer.start()
	$Hitbox.disabled = true
	$FollowArea/HitboxFollow.disabled = true

func possible_damage():
	if GlobalStats.positionPlayer.y >= global_position.y - 5 and GlobalStats.positionPlayer.y <= global_position.y + 4:
		canBeHit = true
	else:
		canBeHit = false

func knockback(delta):
	if knockbackFramesRemaining > 0:
		position += knockbackDirection * (200 * delta)
		knockbackFramesRemaining -= 1

################################################################################################

#func _on_area_entered(area):
	#if area.is_in_group("golpe"):
		#estados = "damage"


func _on_follow_area_body_entered(body):
	if body.is_in_group("player"):
		estados = "follow"
		inArea = true

func _on_follow_area_body_exited(body):
	if body.is_in_group("player"):
		estados = "idle"
		inArea = false

################################################################################################

func _on_attack_a_timer_timeout():
	$HittingArea/HitboxHit.call_deferred("set_disabled", true)
	canHit = true

func _on_defense_timer_timeout():
	pass # Replace with function body.

func _on_i_frames_timer_timeout():
	iFrames = false
	estados = "follow"

func _on_death_timer_timeout():
	queue_free()

func _on_timer_timeout():
	var leftZone = get_tree().get_nodes_in_group("leftzone")
	var rightZone = get_tree().get_nodes_in_group("rightzone")
	
	if global_position < leftZone[0].global_position:
		navigationAgent.target_position = leftZone[0].global_position
	else: 
		navigationAgent.target_position = rightZone[0].global_position
