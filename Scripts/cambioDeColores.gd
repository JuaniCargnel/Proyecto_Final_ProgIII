extends Node2D

func _process(_delta):
	$PersonajePrincipal/Sprite.modulate = Color($R.value, $G.value, $B.value)
	
	GlobalStats.colorR = $R.value
	GlobalStats.colorG = $G.value
	GlobalStats.colorB = $B.value
