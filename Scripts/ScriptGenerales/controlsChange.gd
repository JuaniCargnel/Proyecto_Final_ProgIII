extends Control

var awaitingInput = false
var currentAction = ""

func _ready(): # Al comenzar updatea los labels a las teclas que el player haya decidido
	update_labels()

func _process(_delta): # Si no esta visible actualiza los labels y deja de esperar una tecla
	if !visible: 
		awaitingInput = false
		update_labels()

func _input(event): # Obtiene la tecla presionada al cumplirse las condiciones y la cambia en el mapeo
	if awaitingInput and event is InputEventKey and event.pressed:
		InputMap.action_erase_event(currentAction, InputMap.action_get_events(currentAction)[0])
		InputMap.action_add_event(currentAction, event)
		awaitingInput = false
		update_labels()

func update_labels(): # Updatea los labels de las teclas a la tecla que este en el mapeo
	$MoveUp/CenterContainer/Label.text = InputMap.action_get_events("Up")[0].as_text()
	$MoveDown/CenterContainer/Label.text = InputMap.action_get_events("Down")[0].as_text()
	$MoveLeft/CenterContainer/Label.text = InputMap.action_get_events("Left")[0].as_text()
	$MoveRight/CenterContainer/Label.text = InputMap.action_get_events("Right")[0].as_text()
	$Run/CenterContainer/Label.text = InputMap.action_get_events("Correr")[0].as_text()
	$HitA/CenterContainer/Label.text = InputMap.action_get_events("GolpeA")[0].as_text()
	$HitB/CenterContainer/Label.text = InputMap.action_get_events("GolpeB")[0].as_text()
	$Roll/CenterContainer/Label.text = InputMap.action_get_events("Roll")[0].as_text()

# Al presionar el boton indicado, espera un nuevo input para mapear la tecla
func _on_move_up_pressed():
	if !awaitingInput:
		awaitingInput = true
		currentAction = "Up"
		$MoveUp/CenterContainer/Label.text = "..."

func _on_move_down_pressed():
	if !awaitingInput:
		awaitingInput = true
		currentAction = "Down"
		$MoveDown/CenterContainer/Label.text = "..."

func _on_move_left_pressed():
	if !awaitingInput:
		awaitingInput = true
		currentAction = "Left"
		$MoveLeft/CenterContainer/Label.text = "..."

func _on_move_right_pressed():
	if !awaitingInput:
		awaitingInput = true
		currentAction = "Right"
		$MoveRight/CenterContainer/Label.text = "..."

func _on_hit_a_pressed():
	if !awaitingInput:
		awaitingInput = true
		currentAction = "GolpeA"
		$HitA/CenterContainer/Label.text = "..."

func _on_hit_b_pressed():
	if !awaitingInput:
		awaitingInput = true
		currentAction = "GolpeB"
		$HitB/CenterContainer/Label.text = "..."

func _on_roll_pressed():
	if !awaitingInput:
		awaitingInput = true
		currentAction = "Roll"
		$Roll/CenterContainer/Label.text = "..."

func _on_run_pressed():
	if !awaitingInput:
		awaitingInput = true
		currentAction = "Correr"
		$Run/CenterContainer/Label.text = "..."
