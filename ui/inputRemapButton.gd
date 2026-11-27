class_name InputRemapButton extends Button

@export var action : String
@export var actionEventIndex : int = 0

const CONTROLLER_LABELS: Dictionary = {
	JoyButton.JOY_BUTTON_A: "A",
	JoyButton.JOY_BUTTON_B: "B",
	JoyButton.JOY_BUTTON_X: "X",
	JoyButton.JOY_BUTTON_Y: "Y",
	JoyButton.JOY_BUTTON_LEFT_SHOULDER: "LB",
	JoyButton.JOY_BUTTON_RIGHT_SHOULDER: "RB",
	JoyButton.JOY_BUTTON_LEFT_STICK: "L3",
	JoyButton.JOY_BUTTON_RIGHT_STICK: "R3",
	JoyButton.JOY_BUTTON_DPAD_UP: "↑",
	JoyButton.JOY_BUTTON_DPAD_DOWN: "↓",
	JoyButton.JOY_BUTTON_DPAD_LEFT: "←",
	JoyButton.JOY_BUTTON_DPAD_RIGHT: "→",
	JoyButton.JOY_BUTTON_START: "Start",
	JoyButton.JOY_BUTTON_GUIDE: "Select"
}

func _ready():
	toggle_mode = true
	_toggled(false)


func _unhandled_input(event: InputEvent):
	if not InputMap.has_action(action) or not button_pressed:
		return
	
	if event.is_pressed() and (event is InputEventKey or event is InputEventJoypadButton):
		var actionEventsList = InputMap.action_get_events(action)
		if actionEventIndex < actionEventsList.size():
			InputMap.action_erase_event(action, actionEventsList[actionEventIndex])
		
		InputMap.action_add_event(action, event)
		actionEventIndex = InputMap.action_get_events(action).size() - 1
		button_pressed = false
		release_focus()
		
		get_viewport().set_input_as_handled()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		button_pressed = false
		release_focus()


func _toggled(toggled_on: bool) -> void:
	if not action or not InputMap.has_action(action):
		return
	
	if toggled_on:
		text = "Press any Input"
		return
	
	if actionEventIndex >= InputMap.action_get_events(action).size():
		text = "Unassigned"
		return
	
	var input = InputMap.action_get_events(action)[actionEventIndex]
	if input is InputEventJoypadButton:
		if CONTROLLER_LABELS.has(input.button_index):
			text = CONTROLLER_LABELS.get(input.button_index)
		else:
			text = "Button " + str(input.button_index)
	elif input is InputEventKey:
		if input.physical_keycode != 0:
			text = OS.get_keycode_string(input.physical_keycode)
		else:
			text = OS.get_keycode_string(input.keycode)
