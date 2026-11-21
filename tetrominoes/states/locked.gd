class_name Locked extends State


func Process(_delta: float) -> State:
	return falling

func Enter() -> void:
	board.DrawTetromino(tetromino.currentType, tetromino.GetTetrominoesLocation())
	tetromino.pieceLocked.emit()
	tetromino.UpdatePosition(3, -2)

func Exit() -> void:
	tetromino.hold = false
	tetromino.currentRotation = 0
	board.VerifyLines()
