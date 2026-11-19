class_name Hold extends Node2D

const validRotations : Array[int] = [0, 1, 2, 3]
const validTypes : Array[String] = ["T", "S", "Z", "J", "L", "I", "O"]
const CELL : int = 30

@export var currentTexture : CompressedTexture2D

@onready var rotations = $Rotations
@onready var tetrominoes : Array[Sprite2D] = [
	$"Rotations/Sprite-1", $"Rotations/Sprite-2", 
	$"Rotations/Sprite-3", $"Rotations/Sprite-4"
]

var type : String

func UpdateFrame(_type: String, _rotation: int) -> void:
	if not IsValid(_type, _rotation):
		return
	
	type = _type
	
	if _type == "O":
		_rotation = 0
	
	for mino in tetrominoes:
		var animation : Array = rotations.rotations[_type + "_" + str(_rotation)]
		mino.position = Vector2(
			animation[mino.z_index][0] * 30,
			animation[mino.z_index][1] * 30
		)
		mino.frame = animation[0][0]


func IsValid(_type: String, _rotation: int) -> bool:
	if _type in validTypes and _rotation in validRotations:
		return true
	return false


func GetTetrominoesLocation(_position: Vector2i) -> Array[Vector2i]:
	var array : Array[Vector2i] = []
	for tetromino in tetrominoes:
		var localPosition = Vector2i(
			roundi((tetromino.position.x) / CELL),
			roundi((tetromino.position.y) / CELL)
		)
		array.append(localPosition + _position)
	return array

func UpdateTexture() -> void:
	for tetromino in tetrominoes:
		tetromino.texture = currentTexture
