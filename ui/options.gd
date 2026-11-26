class_name Options extends Control

@onready var audio : Control = $Audio
@onready var keybinds : Control = $Keybinds
@onready var video : Control = $Video
@onready var currentOption : Control = video
@onready var options : Array[Control] = [ audio, keybinds, video ]

signal Back

func Initialize():
	for option in options:
		option.hide()
	ChangeOption(currentOption)


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
	Back.emit()
