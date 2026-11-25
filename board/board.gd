class_name Board extends TileMapLayer

const colors : Dictionary[String, Vector2i] = {
	"T": Vector2i(5, 1), 
	"S": Vector2i(6, 0), 
	"Z": Vector2i(0, 0), 
	"J": Vector2i(2, 1), 
	"L": Vector2i(2, 0), 
	"I": Vector2i(0, 1), 
	"O": Vector2i(3, 0)
}

@onready var audioPlayer = $AudioStreamPlayer

func GameEnded() -> bool:
	for index in range(3, 6):
		if LocationOccupied(Vector2i(index, 0)):
			return true
	return false


func VerifyLines(isTSpin: bool) -> void:
	var clearedLines : Array[int] = []
	var squareEmpty : int = 0
	
	for line in range(0, 20):
		var occupied : int = 0
		for row in range(0, 10):
			if LocationOccupied(Vector2i(row, line)):
				occupied += 1
			else:
				squareEmpty += 1
		
		if occupied == 10:
			clearedLines.append(line)
			squareEmpty += 10
			for row in range(0, 10):
				erase_cell(Vector2i(row, line))
	
	MoveLinesDown(clearedLines, squareEmpty, isTSpin)


func MoveLinesDown(clearedLines : Array[int], squareEmpty: int, isTSpin: bool) -> void:
	for clearedLine in clearedLines:
		for line in range(clearedLine, -1, -1):
			for row in range(0, 10):
				var currentSquare : Vector2i = Vector2i(row, line)
				if LocationOccupied(currentSquare):
					set_cell(currentSquare + Vector2i(0, 1), 0, get_cell_atlas_coords(currentSquare))
					erase_cell(currentSquare)
	if isTSpin:
		var tSound : String = Globals.lineClearedType[5] + str(clearedLines)
		audioPlayer.PlayNow(tSound)
	else:
		audioPlayer.PlayNow(Globals.lineClearedType[clearedLines.size()], -5)
		
	var isAllCleared : bool = true if squareEmpty == 200 else false
	Globals.LineCleared(clearedLines.size(), isTSpin, isAllCleared)


func DrawTetromino(_type: String, _positions: Array[Vector2i]) -> void:
	for _position in _positions:
		set_cell(_position, 0, colors[_type])


func LocationOccupied(_position: Vector2i) -> bool:
	return get_cell_source_id(_position) != -1


func VerifyLocation(_positions: Array, kick: Vector2i) -> bool:
	for _position in _positions:
		var targetPosition : Vector2i = _position + kick
		if LocationOccupied(targetPosition):
			return false
	return true
