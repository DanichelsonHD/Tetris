class_name Game extends Node2D

@onready var board = $Board
@onready var tetromino = $Board/Tetromino
const BOARD = preload("uid://cgq83ky4undj")
var currentBag : Array[String]

func _ready():
	tetromino.Initialize(board)
	BOARD.get_source(0).texture = tetromino.currentTexture
	SortTetromino()
	tetromino.pieceLocked.connect(SortTetromino)


func _process(delta):
	if board.GameEnded():
		get_tree().reload_current_scene()

func _physics_process(delta):
	pass

#func _unhandled_input(event):
	#if event.is_action_pressed("RotateLeft"): tetromino.RotateLeft()
	#if event.is_action_pressed("RotateRight"): tetromino.RotateRight()
	#if event.is_action_pressed("Rotate180"): tetromino.Rotate180()
	#if event.is_action_pressed("hardDrop"): SortTetromino()
	#if event.is_action_pressed("softDrop"): tetromino.UpdatePosition(tetromino.currentPosition.x, tetromino.currentPosition.y + 1)
	#pass

func SortTetromino() -> void:
	if currentBag.is_empty():
		NewBag()
	
	var sortedPiece = currentBag.pick_random()
	currentBag.erase(sortedPiece)
	tetromino.currentType = sortedPiece
	tetromino.UpdateFrame(sortedPiece, 0)

func NewBag() -> void:
	currentBag = tetromino.validTypes.duplicate()
	currentBag.shuffle()
