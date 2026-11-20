class_name Game extends Node2D

@onready var board : Board = $Board
@onready var hold : Hold = $Hold
@onready var tetromino : Tetromino = $Board/Tetromino
@onready var subtitle = $Subtitle
@onready var lineCleared = $LineCleared

@onready var nextPieces : Array[Hold] = [$Next_1, $Next_2, $Next_3, $Next_4, $Next_5, $Next_6]

const BOARD = preload("uid://cgq83ky4undj")
var currentBag : Array[String]
var nextBag : Array[String]

func _ready():
	tetromino.Initialize(board)
	BOARD.get_source(0).texture = tetromino.currentTexture
	
	for nextPiece in nextPieces:
		nextPiece.currentTexture = tetromino.currentTexture
		nextPiece.UpdateTexture()
		
	hold.currentTexture = tetromino.currentTexture
	hold.UpdateTexture()
	
	currentBag = NewBag(currentBag)
	SortTetromino()
	tetromino.pieceLocked.connect(SortTetromino)


func _process(delta):
	if board.GameEnded():
		Globals.UpdateScore(true)
		Reset()
	for index in nextPieces.size():
		NextSprite(nextPieces[index], index, 487.5, 7.5)


func _physics_process(delta):
	UpdateTexts()


func UpdateTexts() -> void:
	subtitle.text = str(Globals.level).pad_zeros(2) + "   " + str(Globals.linesCleared).pad_zeros(3) + "  " + str(Globals.score).pad_zeros(6) + "  " + str(Globals.top).pad_zeros(6)
	lineCleared.text = Globals.lineClearedType[Globals.lastLineCleared]


func NextSprite(_hold: Hold, _index: int, _position: float, _margin: float) -> void:
	var _type = currentBag[_index]
	ChangeSprite(_hold, _type, _position, _margin)


func ChangeSprite(_hold: Hold, _type: String, _position: float, _margin: float) -> void:
	_hold.UpdateFrame(_type, 0)
	if _type == "I" or _type == "O":
		_hold.position.x = _position - _margin
	else: _hold.position.x = _position


func _unhandled_input(event):
	#if event.is_action_pressed("hardDrop"): SortTetromino()
	#if event.is_action_pressed("softDrop"): tetromino.UpdatePosition(tetromino.currentPosition.x, tetromino.currentPosition.y + 1)
	if event.is_action_pressed("holdPiece"): SwapHold()
	if event.is_action_pressed("resetKey"): Reset()
	pass


func Reset() -> void:
	get_tree().reload_current_scene()


func SwapHold() -> void:
	if not tetromino.hold:
		var _type : String = tetromino.currentType
		if hold.type.is_empty():
			hold.type = _type
			tetromino.currentType = currentBag[0]
			tetromino.UpdateFrame(tetromino.currentType, 0)
			currentBag.pop_front()
		else:
			var _holdType : String = hold.type
			hold.type = _type
			tetromino.currentType = _holdType
			tetromino.UpdateFrame(_holdType, 0)
		tetromino.UpdatePosition(3, 0)
		ChangeSprite(hold, hold.type, 480, 10)
		tetromino.hold = true


func SortTetromino() -> void:
	if nextBag.is_empty():
		nextBag = NewBag(nextBag)
	
	var sortedPiece = currentBag.pop_front()
	currentBag.append(nextBag.pop_back())
	tetromino.currentType = sortedPiece
	tetromino.UpdateFrame(sortedPiece, 0)


func NewBag(tempBag: Array[String]) -> Array[String]:
	tempBag = Globals.validTypes.duplicate()
	tempBag.shuffle()
	return tempBag
