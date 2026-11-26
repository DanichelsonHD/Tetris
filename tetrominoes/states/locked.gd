class_name Locked extends State

var wasTSpin : bool

func Process(_delta: float) -> State:
	return falling

func Enter() -> void:
	board.DrawTetromino(tetromino.currentType, tetromino.GetTetrominoesLocation())
	tetromino.audioPlayer.PlayNow("LOCK", Globals.sfxVolume)
	var isTSpin : bool = tetromino.currentType == "T" and stateMachine.lastMovement == "Rotate"
	wasTSpin = tetromino.WasTSpin(isTSpin)

func Exit() -> void:
	board.VerifyLines(wasTSpin)
	
	tetromino.hold = false
	tetromino.pieceLocked.emit()
	tetromino.UpdatePosition(3, -2)
	tetromino.currentRotation = 0
	tetromino.lockingResets = 0
	
	stateMachine.lastMovement = ""
