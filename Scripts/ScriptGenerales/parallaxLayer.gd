extends ParallaxBackground

# Gestiona las velocidades del parallax

func _process(delta):
	$ParallaxLayer.motion_offset.x += -50 * delta
	$ParallaxLayer2.motion_offset.x += -100 * delta
	$ParallaxLayer3.motion_offset.x += -150 * delta
	$ParallaxLayer4.motion_offset.x += -200 * delta
