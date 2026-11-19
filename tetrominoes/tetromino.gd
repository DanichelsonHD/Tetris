class_name Tetromino extends Node2D

const validRotations : Array[int] = [0, 1, 2, 3]
const validTypes : Array[String] = ["T", "S", "Z", "J", "L", "I", "O"]
const CELL : int = 30
const MARGIN : int = 15

@export var currentType : String
@export var currentRotation : int = 0
@export var currentPosition : Vector2i
@export var currentTexture : CompressedTexture2D

@onready var stateMachine : StateMachine = $StateMachine
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var kickCases = $KickCases
@onready var area2D : Area2D = $Area2D
@onready var tetrominoes : Array[CollisionShape2D] = [
	$"Area2D/TetrominoSquare-1", $"Area2D/TetrominoSquare-2", 
	$"Area2D/TetrominoSquare-3", $"Area2D/TetrominoSquare-4"
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
		
	animationPlayer.play(_type + "_" + str(_rotation))


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
			roundi((tetromino.position.x - MARGIN) / CELL), # Subtraí por causa de margem e 
			roundi((tetromino.position.y - MARGIN) / CELL)  # dividi pra virar posição de Vector2i
		)
		array.append(localPosition + currentPosition)
	return array


func UpdateTexture() -> void:
	for tetromino in tetrominoes:
		tetromino.get_child(0).texture = currentTexture


func _on_area_2d_body_entered(body):
	if body is Board:
		stateMachine.ChangeState(stateMachine.get_child(1))
