extends PathFollow2D

var speed = 0.09

func _process(delta):
	progress_ratio += delta * speed

	if progress_ratio >= 0.90 and progress_ratio <= 1.18:
		if $Sol.modulate == Color(1,1,1,1):
			$Luna.modulate = Color(1,1,1,1)
			$Sol.modulate = Color(0,0,0,0)
		else: 
			$Luna.modulate = Color(0,0,0,0)
			$Sol.modulate = Color(1,1,1,1)
