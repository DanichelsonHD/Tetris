class_name Locked extends State

var wasTSpin : bool

func Process(_delta: float) -> State:
	return falling

func Enter() -> void:
	board.DrawTetromino(tetromino.currentType, tetromino.GetTetrominoesLocation())
	var isTSpin : bool = tetromino.currentType == "T" and stateMachine.lastMovement == "Rotate"
	wasTSpin = tetromino.WasTSpin(isTSpin)
	tetromino.pieceLocked.emit()
	tetromino.UpdatePosition(3, -2)

func Exit() -> void:
	tetromino.hold = false
	tetromino.currentRotation = 0
	board.VerifyLines(wasTSpin)
	stateMachine.lastMovement = ""
