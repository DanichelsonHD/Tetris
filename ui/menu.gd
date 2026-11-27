class_name Menu extends Control

@onready var options : Control = $Options
@onready var start : Control = $Start

const BOARD = preload("uid://cgq83ky4undj")

var GAME = load("res://game.tscn")
var game : Game = null

func _ready() -> void:
	options.Initialize()
	options.Back.connect(ShowStart)
	options.Pause.connect(PauseGame)
	options.Menu.connect(GameBack)
	options.ChangeTexture.connect(ChangeTexture)


func ShowOptions() -> void:
	if game != null:
		game.hide()
	start.hide()
	options.show()


func ShowStart() -> void:
	if game != null:
		game.hide()
		game.queue_free()
		game = null
	options.hide()
	start.show()


func ShowGame() -> void:
	if game != null:
		game.show()
	options.hide()
	start.hide()


func ChangeTexture() -> void:
	if game != null:
		game.UpdateTexture()
	BOARD.get_source(0).texture = Globals.texture


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
	ChangeTexture()
	game.Back.connect(GameBack)
	game.Reset.connect(ResetGame)


func GameBack() -> void:
	if game != null:
		game.Back.disconnect(GameBack)
		game.queue_free()
		game = null
	ShowStart()


func ResetGame(mode: String) -> void:
	GameBack()
	CreateGame(mode)


func Quit() -> void:
	get_tree().quit()
