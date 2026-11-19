class_name Locked extends State


func Process(_delta: float) -> State:
	
	return falling

func Enter() -> void:
	print("Entered Locked State")
	tetromino.pieceLocked.emit()
	tetromino.UpdatePosition(3, -3)
	board.DrawTetromino(tetromino.currentType, tetromino.GetTetrominoesLocation())
	pass

func Exit() -> void:
	pass
