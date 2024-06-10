extends Node2D
var player: PackedScene = preload("res://Escenas/Personajes/PersonajePrincipal.tscn")
var placeHolder = 0

func _ready():
	$MusicGameplay.play()
	$AnimationPlayer.play("FadeIn")
	instance_player()

func _process(_delta):
	var fadePlayer = get_tree().get_nodes_in_group("player")
	for player1 in fadePlayer:
		player1.modulate = Color(1,1,1,placeHolder)
		if player1.modulate != Color(1,1,1,1):
			placeHolder += 0.005
			player1.modulate = Color(1,1,1,placeHolder)
		else: 
			pass

func instance_player():
	add_child(player.instantiate())
