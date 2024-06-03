extends Node2D
var player: PackedScene = preload("res://Escenas/Personajes/PersonajePrincipal.tscn")

func _ready():
	instance_player()

func _process(_delta):
	GlobalManager.render()

func instance_player():
	add_child(player.instantiate())

