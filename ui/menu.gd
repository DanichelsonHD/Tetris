class_name Menu extends Control

@onready var options : Control = $Options
@onready var start : Control = $Start

var GAME = load("res://game.tscn")
var game : Game = null

func _ready() -> void:
	options.Initialize()
	options.Back.connect(ShowStart)


func ShowOptions() -> void:
	start.hide()
	options.show()


func ShowStart() -> void:
	options.hide()
	start.show()


func Quit() -> void:
	get_tree().quit()


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
