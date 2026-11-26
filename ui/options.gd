class_name Options extends Control

@onready var audio : Control = $Audio
@onready var keybinds : Control = $Keybinds
@onready var video : Control = $Video
@onready var currentOption : Control = video
@onready var options : Array[Control] = [ audio, keybinds, video ]
@onready var menu : Button = $Buttons/Menu

var _paused : bool

signal Back
signal Pause
signal Menu

func _unhandled_input(event):
	if event.is_action_pressed("returnKey"):
		if _paused:
			UnpauseGame()
		elif Globals.inGame:
			PauseGame()
		else:
			Back.emit()


func Initialize() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	for option in options:
		option.hide()
	ChangeOption(currentOption)
	_paused = false
	menu.hide()


func PauseGame() -> void:
	get_tree().paused = true
	_paused = true
	menu.show()
	Pause.emit(_paused)


func UnpauseGame() -> void:
	get_tree().paused = false
	_paused = false
	menu.hide()
	Pause.emit(_paused)


func ChangeOption(option: Control) -> void:
	currentOption.hide()
	currentOption = option
	currentOption.show()


func PreviousOption() -> void:
	var index : int = options.find(currentOption)
	index = options.size() - 1 if index == 0 else index - 1
	ChangeOption(options[index])


func NextOption() -> void:
	var index : int = options.find(currentOption)
	index = 0 if index == options.size() - 1 else index + 1
	ChangeOption(options[index])


func OptionsBack() -> void:
	UnpauseGame()
	if Globals.inGame:
		Pause.emit(_paused)
		return
	
	Back.emit()


func ExitToMenu() -> void:
	UnpauseGame()
	Menu.emit()
