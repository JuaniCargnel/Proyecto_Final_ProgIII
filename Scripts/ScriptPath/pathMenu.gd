extends PathFollow2D

var speed:float = 0.095
var visibleSol: bool = true
var visibleLuna: bool = false

func _process(delta):
	progress_ratio += delta * speed
	
	if progress_ratio == 1 and visibleSol:
		progress_ratio = 0
		visibleLuna = true
		visibleSol = false
		$Sol.modulate = Color(0,0,0,0)
		$Luna.modulate = Color(1,1,1,1)
	if progress_ratio == 1 and visibleLuna:
		progress_ratio = 0
		visibleLuna = false
		visibleSol = true
		$Luna.modulate = Color(0,0,0,0)
		$Sol.modulate = Color(1,1,1,1)

