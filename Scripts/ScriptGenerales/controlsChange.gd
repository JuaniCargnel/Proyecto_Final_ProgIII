extends Control

var awaiting_input = false
var current_action = ""

func _ready():
	update_labels()

func _process(_delta):
	if !visible:
		awaiting_input = false
		update_labels()

func _input(event):
	if awaiting_input and event is InputEventKey and event.pressed:
		InputMap.action_erase_event(current_action, InputMap.action_get_events(current_action)[0])
		InputMap.action_add_event(current_action, event)
		awaiting_input = false
		update_labels()

func update_labels():
	$MoveUp/CenterContainer/Label.text = InputMap.action_get_events("Up")[0].as_text()
	$MoveDown/CenterContainer/Label.text = InputMap.action_get_events("Down")[0].as_text()
	$MoveLeft/CenterContainer/Label.text = InputMap.action_get_events("Left")[0].as_text()
	$MoveRight/CenterContainer/Label.text = InputMap.action_get_events("Right")[0].as_text()
	$Run/CenterContainer/Label.text = InputMap.action_get_events("Correr")[0].as_text()
	$HitA/CenterContainer/Label.text = InputMap.action_get_events("GolpeA")[0].as_text()
	$HitB/CenterContainer/Label.text = InputMap.action_get_events("GolpeB")[0].as_text()
	$Roll/CenterContainer/Label.text = InputMap.action_get_events("Roll")[0].as_text()

func _on_move_up_pressed():
	if !awaiting_input:
		awaiting_input = true
		current_action = "Up"
		$MoveUp/CenterContainer/Label.text = "..."

func _on_move_down_pressed():
	if !awaiting_input:
		awaiting_input = true
		current_action = "Down"
		$MoveDown/CenterContainer/Label.text = "..."

func _on_move_left_pressed():
	if !awaiting_input:
		awaiting_input = true
		current_action = "Left"
		$MoveLeft/CenterContainer/Label.text = "..."

func _on_move_right_pressed():
	if !awaiting_input:
		awaiting_input = true
		current_action = "Right"
		$MoveRight/CenterContainer/Label.text = "..."

func _on_hit_a_pressed():
	if !awaiting_input:
		awaiting_input = true
		current_action = "GolpeA"
		$HitA/CenterContainer/Label.text = "..."

func _on_hit_b_pressed():
	if !awaiting_input:
		awaiting_input = true
		current_action = "GolpeB"
		$HitB/CenterContainer/Label.text = "..."

func _on_roll_pressed():
	if !awaiting_input:
		awaiting_input = true
		current_action = "Roll"
		$Roll/CenterContainer/Label.text = "..."

func _on_run_pressed():
	if !awaiting_input:
		awaiting_input = true
		current_action = "Correr"
		$Run/CenterContainer/Label.text = "..."
