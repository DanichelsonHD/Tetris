class_name Menu extends Control

@onready var options : Control = $Options
@onready var start : Control = $Start

var GAME = load("res://game.tscn")
var game : Game = null

func _ready() -> void:
	options.Initialize()
	options.Back.connect(ShowStart)
	options.Pause.connect(PauseGame)
	options.Menu.connect(GameBack)


func ShowOptions() -> void:
	if game != null:
		game.hide()
	start.hide()
	options.show()


func ShowStart() -> void:
	if game != null:
		game.hide()
	options.hide()
	start.show()


func ShowGame() -> void:
	if game != null:
		game.show()
	options.hide()
	start.hide()


func PauseGame(_paused: bool) -> void:
	if _paused:
		ShowOptions()
		return
	ShowGame()

func Sprint() -> void:
	if game != null:
		return
	CreateGame("SPRINT")


func Marathon() -> void:
	if game != null:
		return
	CreateGame("MARATHON")


func CreateGame(mode: String):
	start.hide()
	options.hide()
	game = GAME.instantiate()
	add_child(game)
	game.Initialize(mode)
	game.Back.connect(GameBack)
	game.Reset.connect(ResetGame)


func GameBack() -> void:
	if game != null:
		game.Back.disconnect(GameBack)
		game.queue_free()
	ShowStart()


func ResetGame(mode: String) -> void:
	GameBack()
	CreateGame(mode)


func Quit() -> void:
	get_tree().quit()
