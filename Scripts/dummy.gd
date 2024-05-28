extends Area2D

class_name dummy

@export var inArea:bool = false
var canBeHit:bool = false

func _on_sprite_animation_looped():
	$Sprite.stop() 

func _process(_delta):
	on_hit()

func _on_area_entered(area):
	if area.is_in_group("golpe") and canBeHit:
		$Sprite.stop()
		if global_position.x < area.global_position.x:
			$Sprite.frame = 2
		else:
			$Sprite.frame = 1
		$Sprite.play("dummy")
	if area.is_in_group("areaSprite"):
		inArea = true

func _on_area_exited(area):
	if area.is_in_group("areaSprite"):
		inArea = false
		GlobalStats.zindexPlayer = 2

func on_hit():
	if GlobalStats.positionPlayer.y >= global_position.y - 5 and GlobalStats.positionPlayer.y <= global_position.y + 4:
		canBeHit = true
	else:
		canBeHit = false
