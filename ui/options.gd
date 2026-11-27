class_name Options extends Control

@onready var audio : Control = $Audio
@onready var volumeGeneral = $Audio/General
@onready var volumeMusic = $Audio/Music
@onready var volumeSfx = $Audio/SFX

@onready var keybinds : Control = $Keybinds

@onready var video : Control = $Video
@onready var texture = $Video/Texture

@onready var currentOption : Control = video
@onready var options : Array[Control] = [ audio, keybinds, video ]
@onready var menu : Button = $Buttons/Menu

var _paused : bool
var sprites: Array[Dictionary] = [
	{ "name": "Brick", "texture": preload("res://tetrominoes/sprites/brick.png") as CompressedTexture2D },
	{ "name": "Cardboard", "texture": preload("res://tetrominoes/sprites/cardboard.png") as CompressedTexture2D },
	{ "name": "ColoredBone", "texture": preload("res://tetrominoes/sprites/coloredbone.png") as CompressedTexture2D },
	{ "name": "Jelly", "texture": preload("res://tetrominoes/sprites/jelly.png") as CompressedTexture2D },
	{ "name": "Minoes", "texture": preload("res://tetrominoes/sprites/minoes.png") as CompressedTexture2D },
	{ "name": "Pastel", "texture": preload("res://tetrominoes/sprites/pastel.png") as CompressedTexture2D },
	{ "name": "Pure", "texture": preload("res://tetrominoes/sprites/pure.png") as CompressedTexture2D },
	{ "name": "Shiny", "texture": preload("res://tetrominoes/sprites/shiny.png") as CompressedTexture2D },
	{ "name": "Smooth", "texture": preload("res://tetrominoes/sprites/smooth.png") as CompressedTexture2D }
]
var spriteIndex : int

signal Back
signal Pause
signal Menu
signal ChangeTexture

func Initialize() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	spriteIndex = 4
	UpdateTexture()
	for option in options:
		option.hide()
	ChangeOption(currentOption)
	_paused = false
	menu.hide()


func _unhandled_input(event):
	if event.is_action_pressed("returnKey"):
		if _paused:
			UnpauseGame()
		elif Globals.inGame:
			PauseGame()
		else:
			Back.emit()


func UpdateTexture() -> void:
	Globals.texture = sprites[spriteIndex]["texture"]
	texture.text = sprites[spriteIndex]["name"].to_upper()
	ChangeTexture.emit()


func UpdateVolume(_unused: bool) -> void:
	Globals.musicVolume = volumeMusic.value + volumeGeneral.value
	Globals.sfxVolume = volumeSfx.value + volumeGeneral.value


func PreviousTexture() -> void:
	spriteIndex = sprites.size() - 1 if spriteIndex == 0 else spriteIndex - 1
	UpdateTexture()


func NextTexture() -> void:
	spriteIndex = 0 if spriteIndex == sprites.size() - 1 else spriteIndex + 1
	UpdateTexture()


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


func Fullscreen(toggle: bool) -> void:
	var windowMode = DisplayServer.WINDOW_MODE_FULLSCREEN if toggle else DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(windowMode)

func ExitToMenu() -> void:
	UnpauseGame()
	Globals.inGame = false
	Menu.emit()
