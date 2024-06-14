extends Node2D

# Pantalla de victoria similar a la pantalla de game over

func _ready():
	$AnimationPlayer.play("FadeIn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://Escenas/Menus/MenuPrincipal.tscn")

func _on_retry_pressed():
	$StartGame.play()
	$AnimationPlayer.play("FadeOut")

func _on_button_mouse_entered():
	$SFXButtons.play()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "FadeOut":
		get_tree().change_scene_to_file("res://Escenas/Niveles/Pantalla1A.tscn")
