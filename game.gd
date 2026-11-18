class_name Game extends Node2D

@onready var board = $Board
@onready var tetromino = $Board/Tetromino
const BOARD = preload("uid://cgq83ky4undj")
var currentBag : Array[String]

func _ready():
	BOARD.get_source(0).texture = tetromino.currentTexture
	sortTetromino()


func _process(delta):
	pass

func _physics_process(delta):
	pass

func _unhandled_input(event):
	if event.is_action_pressed("rotateLeft"): tetromino.rotateLeft()
	if event.is_action_pressed("rotateRight"): tetromino.rotateRight()
	if event.is_action_pressed("rotate180"): tetromino.rotate180()
	if event.is_action_pressed("hardDrop"):
		sortTetromino()
	pass

func sortTetromino() -> void:
	if currentBag.is_empty():
		newBag()
	
	var sortedPiece = currentBag.pick_random()
	currentBag.erase(sortedPiece)
	tetromino.updateFrame(sortedPiece, 0)

func newBag() -> void:
	currentBag = tetromino.validTypes.duplicate()
	currentBag.shuffle()
