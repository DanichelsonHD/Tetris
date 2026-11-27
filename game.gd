class_name Game extends Node2D

@onready var board : Board = $Board
@onready var hold : Hold = $Hold
@onready var ghost = $Board/Ghost
@onready var tetromino : Tetromino = $Board/Tetromino
@onready var title = $Title
@onready var subtitle = $Subtitle
@onready var lineCleared = $LineCleared
@onready var musicPlayer = $MusicPlayer
@onready var audioPlayer = $AudioPlayer

@onready var nextPieces : Array[Hold] = [$Next_1, $Next_2, $Next_3, $Next_4, $Next_5, $Next_6]

var currentBag : Array[String]
var nextBag : Array[String]

signal Back
signal Reset

func _ready():
	Initialize("MARATHON")


func Initialize(_mode: String) -> void:
	Globals.mode = _mode
	Globals.Initialize()
	tetromino.Initialize(board)
	
	currentBag = NewBag(currentBag)
	SortTetromino()
	tetromino.pieceLocked.connect(SortTetromino)
	
	musicPlayer.PlayNow("1980", -Globals.musicVolume)


func UpdateTexture() -> void:
	UpdateTetrominoTexture(tetromino)
	UpdateTetrominoTexture(hold)
	UpdateTetrominoTexture(ghost)
	for nextPiece in nextPieces:
		UpdateTetrominoTexture(nextPiece)


func UpdateTetrominoTexture(_tetromino) -> void:
	_tetromino.currentTexture = Globals.texture
	_tetromino.UpdateTexture()


func _process(delta):
	Globals.gameEnded = board.GameEnded()
	musicPlayer.Volume(Globals.musicVolume)
	audioPlayer.Volume(Globals.sfxVolume)
	if Globals.gameEnded:
		GameEnded()
	else:
		Globals.timer += delta
	for index in nextPieces.size():
		NextSprite(nextPieces[index], index, 487.5, 7.5)


func _physics_process(delta):
	UpdateTexts()
	tetromino.UpdateTimers(delta)
	HandleGhost()


func UpdateTexts() -> void:
	subtitle.text = FormatInt(Globals.level, 2) + "   " + FormatInt(Globals.linesCleared, 3) + "  "
	if Globals.mode == "SPRINT":
		title.text = "LVL   LINES    TIME         TOP"
		subtitle.text += "  " + Globals.FormatTimerGame(Globals.timer) + "   " + Globals.FormatTimerGame(Globals.bestTime)
		
	elif Globals.mode == "MARATHON":
		title.text = "LVL   LINES   SCORE        TOP"
		subtitle.text += FormatInt(Globals.score, 6) + "  " + FormatInt(Globals.top, 6)
	
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
	if event.is_action_pressed("resetKey"): ResetGame()
	if event.is_action_pressed("menuKey"): GameBack()


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
		
		audioPlayer.PlayNow("HOLD", Globals.sfxVolume)


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


func GameEnded() -> void:
	tetromino.pieceLocked.disconnect(SortTetromino)
	Globals.UpdateScore()
	Globals.inGame = false
	tetromino.stateMachine.Stop()
	musicPlayer.stop()
	if Globals.newTop:
		musicPlayer.PlayNow("TOP", Globals.musicVolume)
		Globals.newTop = false


func GameBack() -> void:
	Globals.UpdateScore()
	Globals.inGame = false
	Back.emit()


func ResetGame() -> void:
	Globals.UpdateScore()
	Reset.emit(Globals.mode)
