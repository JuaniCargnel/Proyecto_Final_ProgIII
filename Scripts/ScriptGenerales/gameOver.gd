extends Node2D

# Pantalla de gameover. Al comenzar ejecuta un FadeIn a una pantalla en negro

func _ready():
	$AnimationPlayer.play("FadeIn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_menu_pressed(): # Vuelve al menu principal
	get_tree().change_scene_to_file("res://Escenas/Menus/MenuPrincipal.tscn")

func _on_retry_pressed(): # Ejecuta animacion de FadeOut
	$StartGame.play()
	$AnimationPlayer.play("FadeOut")

func _on_button_mouse_entered(): # Los botones hacen ruido 
	$SFXButtons.play()

func _on_animation_player_animation_finished(anim_name): # Al terminar la animacion de FadeOut vuelve a comenzar la partida
	if anim_name == "FadeOut":
		get_tree().change_scene_to_file("res://Escenas/Niveles/Pantalla1A.tscn")
