class_name Game extends Node2D

@onready var board : Board = $Board
@onready var hold : Hold = $Hold
@onready var ghost = $Board/Ghost
@onready var tetromino : Tetromino = $Board/Tetromino
@onready var subtitle = $Subtitle
@onready var lineCleared = $LineCleared
@onready var musicPlayer = $MusicPlayer
@onready var audioPlayer = $AudioPlayer

@onready var nextPieces : Array[Hold] = [$Next_1, $Next_2, $Next_3, $Next_4, $Next_5, $Next_6]

const BOARD = preload("uid://cgq83ky4undj")
var currentBag : Array[String]
var nextBag : Array[String]

func _ready():
	Globals.mode = "MARATHON"
	Globals.Initialize()
	tetromino.Initialize(board)
	BOARD.get_source(0).texture = tetromino.currentTexture
	
	UpdateTexture(hold)
	UpdateTexture(ghost)
	for nextPiece in nextPieces:
		UpdateTexture(nextPiece)
	
	currentBag = NewBag(currentBag)
	SortTetromino()
	tetromino.pieceLocked.connect(SortTetromino)
	
	musicPlayer.PlayNow("1980", -12.5)


func UpdateTexture(_hold: Hold) -> void:
	_hold.currentTexture = tetromino.currentTexture
	_hold.UpdateTexture()


func _process(delta):
	if board.GameEnded():
		Globals.UpdateScore()
		tetromino.stateMachine.Stop()
		if Globals.newTop:
			musicPlayer.stop()
			musicPlayer.PlayNow("TOP", -15)
			Globals.newTop = false
		#Reset()
	else:
		Globals.timer += delta
	for index in nextPieces.size():
		NextSprite(nextPieces[index], index, 487.5, 7.5)


func _physics_process(delta):
	UpdateTexts()
	tetromino.UpdateTimers(delta)
	HandleGhost()


func UpdateTexts() -> void:
	subtitle.text = FormatInt(Globals.level, 2) + "   " + FormatInt(Globals.linesCleared, 3) + "  " + FormatInt(Globals.score, 6) + "  " + FormatInt(Globals.top, 6)
	lineCleared.text = Globals.lineClearedType[Globals.lastLineCleared]


func FormatInt(integer: int, zeros: int) -> String:
	return str(integer).pad_zeros(zeros)


func HandleGhost() -> void:
	ghost.UpdateFrame(tetromino.currentType, tetromino.currentRotation)
	ghost.UpdatePosition(tetromino.HardDrop())


func NextSprite(_hold: Hold, _index: int, _position: float, _margin: float) -> void:
	var _type = currentBag[_index]
	ChangeSprite(_hold, _type, _position, _margin)


func ChangeSprite(_hold: Hold, _type: String, _position: float, _margin: float) -> void:
	_hold.UpdateFrame(_type, 0)
	if _type == "I" or _type == "O":
		_hold.position.x = _position - _margin
	else: _hold.position.x = _position


func _unhandled_input(event):
	if event.is_action_pressed("holdPiece"): SwapHold()
	if event.is_action_pressed("resetKey"): Reset()


func Reset() -> void:
	Globals.Initialize()
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
		tetromino.currentRotation = 0
		ChangeSprite(hold, hold.type, 480, 10)
		tetromino.hold = true
		
		audioPlayer.PlayNow("HOLD", -10)


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


func _notification(notification: int) -> void:
	if notification == NOTIFICATION_WM_CLOSE_REQUEST:
		print("Ending game")
		Globals.UpdateScore()
		get_tree().quit()
