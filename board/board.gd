class_name Board extends TileMapLayer


func _ready():
	pass


func DrawTetromino(_type: String, _rotation: int, _position: Vector2i) -> void:
	print(_type, _rotation, _position)
