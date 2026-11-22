class_name Locked extends State

var wasTSpin : bool

func Process(_delta: float) -> State:
	return falling

func Enter() -> void:
	board.DrawTetromino(tetromino.currentType, tetromino.GetTetrominoesLocation())
	var isTSpin : bool = tetromino.currentType == "T" and stateMachine.lastMovement == "Rotate"
	wasTSpin = tetromino.WasTSpin(isTSpin)

func Exit() -> void:
	tetromino.hold = false
	board.VerifyLines(wasTSpin)
	tetromino.pieceLocked.emit()
	tetromino.UpdatePosition(3, -2)
	tetromino.currentRotation = 0
	stateMachine.lastMovement = ""
