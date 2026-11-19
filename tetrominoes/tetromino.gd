class_name Tetromino extends Node2D

const validRotations : Array[int] = [0, 1, 2, 3]
const validTypes : Array[String] = ["T", "S", "Z", "J", "L", "I", "O"]
const CELL : int = 30

@export var currentType : String
@export var currentRotation : int = 0
@export var currentPosition : Vector2i
@export var currentTexture : CompressedTexture2D

@onready var stateMachine : StateMachine = $StateMachine
@onready var kickCases = $KickCases
@onready var rotations = $Rotations
@onready var tetrominoes : Array[Sprite2D] = [
	$"Rotations/Sprite-1", $"Rotations/Sprite-2", 
	$"Rotations/Sprite-3", $"Rotations/Sprite-4"
]

signal pieceLocked

var board : Board

func Initialize(_board: Board):
	UpdateTexture()
	board = _board
	kickCases.Initialize(self, _board)
	stateMachine.Initialize(self, _board)


func UpdateFrame(_type: String, _rotation: int) -> void:
	if not IsValid(_type, _rotation):
		return
	
	if _type == "O":
		_rotation = 0
	
	for mino in tetrominoes:
		var animation : Array = rotations.rotations[_type + "_" + str(_rotation)]
		mino.position = Vector2(
			animation[mino.z_index][0] * 30,
			animation[mino.z_index][1] * 30
		)
		mino.frame = animation[0][0]


func UpdatePosition(x: int, y: int) -> void:
	position.x = x * CELL
	position.y = y * CELL
	
	currentPosition = Vector2i(x, y)


func MoveLeft() -> void:
	var left : Vector2i = Vector2i(-1, 0)
	if board.VerifyLocation(GetTetrominoesLocation(), left):
		UpdatePosition(currentPosition.x + left.x, currentPosition.y)


func MoveRight() -> void:
	var right : Vector2i = Vector2i(1, 0)
	if board.VerifyLocation(GetTetrominoesLocation(), right):
		UpdatePosition(currentPosition.x + right.x, currentPosition.y)


func RotateLeft() -> void:
	var testRotation : int
	if currentRotation == 0:
		testRotation = 3
	else:
		testRotation = currentRotation - 1
	
	if true: pass
	UpdateFrame(currentType, currentRotation)

#func RotateRight() -> void:
	#lastRotation = currentRotation
		#
	#if currentRotation == 3:
		#currentRotation = 0
	#else:
		#currentRotation += 1
		#
	#UpdateFrame(currentType, currentRotation)

#func Rotate180() -> void:
	#lastRotation = currentRotation
	#
	#if currentRotation > 1:
		#currentRotation -= 2
	#elif currentRotation < 2:
		#currentRotation += 2
	#
	#UpdateFrame(currentType, currentRotation)

func IsValid(_type: String, _rotation: int) -> bool:
	if _type in validTypes and _rotation in validRotations:
		return true
	return false


func IsOnFloor() -> bool:
	return not board.VerifyLocation(GetTetrominoesLocation(), Vector2i(0, 1))


func GetTetrominoesLocation() -> Array[Vector2i]:
	var array : Array[Vector2i] = []
	for tetromino in tetrominoes:
		var localPosition = Vector2i(
			roundi((tetromino.position.x) / CELL),
			roundi((tetromino.position.y) / CELL)
		)
		array.append(localPosition + currentPosition)
	return array


func UpdateTexture() -> void:
	for tetromino in tetrominoes:
		tetromino.texture = currentTexture


func _on_area_2d_body_entered(body):
	if body is Board:
		stateMachine.ChangeState(stateMachine.get_child(1))
