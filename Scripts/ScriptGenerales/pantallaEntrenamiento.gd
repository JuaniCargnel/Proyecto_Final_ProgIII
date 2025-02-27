extends Node2D

var player: PackedScene = preload("res://Escenas/Personajes/PersonajePrincipal.tscn")
var textScene: PackedScene = preload("res://Escenas/Globales/texto.tscn")
var text

func _ready():
	instance_player()
	text = textScene.instantiate()

func instance_player():
	add_child(player.instantiate())
