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

func _ready():
	pass


func GameEnded() -> bool:
	for index in range(3, 7):
		if LocationOccupied(Vector2i(index, 0)):
			return true
	return false


func DrawTetromino(_type: String, _positions: Array[Vector2i]) -> void:
	for _position in _positions:
		print(_position)
		set_cell(_position, 0, colors[_type])


func LocationOccupied(_position: Vector2i) -> bool:
	return get_cell_source_id(_position) != -1


func VerifyLocation(_positions: Array, kick: Vector2i) -> bool:
	for _position in _positions:
		var targetPosition : Vector2i = _position + kick
		if LocationOccupied(targetPosition):
			return false
	return true
