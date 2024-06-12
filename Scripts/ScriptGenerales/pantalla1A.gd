extends Node2D

var player: PackedScene = preload("res://Escenas/Personajes/PersonajePrincipal.tscn")
var colorPlayer = 0

func _ready():
	$MusicGameplay.play()
	$AnimationPlayer.play("FadeIn")
	instance_player()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _process(_delta):
	var fadePlayer = get_tree().get_nodes_in_group("player")
	for player1 in fadePlayer:
		player1.modulate = Color(1,1,1,colorPlayer)
		if player1.modulate != Color(1,1,1,1) and GlobalStats.alive:
			colorPlayer += 0.005
			player1.modulate = Color(1,1,1,colorPlayer)
		elif !GlobalStats.alive: 
			colorPlayer -= 0.005
			player1.modulate = Color(colorPlayer,colorPlayer,colorPlayer,colorPlayer)
			
	player_death()

func instance_player():
	add_child(player.instantiate())

func player_death():
	if !GlobalStats.alive:
		$MusicGameplay.stop()
		$AnimationPlayer.play("FadeOut")
		$HUD.visible = false
