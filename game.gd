class_name Game extends Node2D

@onready var board : Board = $Board
@onready var hold : Hold = $Hold
@onready var tetromino : Tetromino = $Board/Tetromino

@onready var nextPieces : Array[Hold] = [$Next_1, $Next_2, $Next_3, $Next_4, $Next_5, $Next_6]

const BOARD = preload("uid://cgq83ky4undj")
var currentBag : Array[String]
var nextBag : Array[String]

func _ready():
	tetromino.Initialize(board)
	BOARD.get_source(0).texture = tetromino.currentTexture
	currentBag = NewBag(currentBag)
	SortTetromino()
	tetromino.pieceLocked.connect(SortTetromino)


func _process(delta):
	if board.GameEnded():
		get_tree().reload_current_scene()
	for index in nextPieces.size():
		NextSprite(nextPieces[index], index, 487.5)

func _physics_process(delta):
	pass

func NextSprite(_hold: Hold, _index: int, _position: float) -> void:
	var _type = currentBag[_index]
	ChangeSprite(_hold, _type, _position)

func ChangeSprite(_hold: Hold, _type: String, _position: float) -> void:
	_hold.UpdateFrame(_type, 0)
	if _type == "I" or _type == "O":
		_hold.position.x = _position - 7.5
	else: _hold.position.x = _position

func _unhandled_input(event):
	#if event.is_action_pressed("RotateLeft"): tetromino.RotateLeft()
	#if event.is_action_pressed("RotateRight"): tetromino.RotateRight()
	#if event.is_action_pressed("Rotate180"): tetromino.Rotate180()
	#if event.is_action_pressed("hardDrop"): SortTetromino()
	#if event.is_action_pressed("softDrop"): tetromino.UpdatePosition(tetromino.currentPosition.x, tetromino.currentPosition.y + 1)
	if event.is_action_pressed("holdPiece"): 
		var _type : String = tetromino.currentType
		if hold.type == null:
			tetromino.currentType = currentBag.pop_front()
			tetromino.UpdateFrame(tetromino.currentType, 0)
		else:
			tetromino.currentType = hold.type
			tetromino.UpdateFrame(hold.type, 0)
		tetromino.UpdatePosition(3, 0)
		ChangeSprite(hold, _type, 217.5)
		
	pass

func SortTetromino() -> void:
	if nextBag.is_empty():
		nextBag = NewBag(nextBag)
	
	var sortedPiece = currentBag.pop_front()
	currentBag.append(nextBag.pop_back())
	tetromino.currentType = sortedPiece
	tetromino.UpdateFrame(sortedPiece, 0)

func NewBag(tempBag: Array[String]) -> Array[String]:
	tempBag = tetromino.sprite.validTypes.duplicate()
	tempBag.shuffle()
	return tempBag
