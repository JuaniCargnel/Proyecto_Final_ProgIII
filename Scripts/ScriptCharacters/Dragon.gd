extends Node2D


func _ready():
	Sombra.crear_sombras($Sprite, $SombraMark)

func _process(_delta):
	Sombra.update_sombras()




