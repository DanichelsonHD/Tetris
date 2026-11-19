class_name Tetromino extends Node2D

@export var currentType : String
@export var currentRotation : int = 0
@export var currentPosition : Vector2i
@export var currentTexture : CompressedTexture2D

@onready var stateMachine : StateMachine = $StateMachine
@onready var kickCases = $KickCases
@onready var sprite = $Sprite

signal pieceLocked

var board : Board

func Initialize(_board: Board):
	UpdateTexture()
	board = _board
	kickCases.Initialize(self, _board)
	stateMachine.Initialize(self, _board)


func UpdateFrame(_type: String, _rotation: int) -> void:
	sprite.UpdateFrame(_type, _rotation)


func UpdatePosition(x: int, y: int) -> void:
	position.x = x * sprite.CELL
	position.y = y * sprite.CELL
	
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
	return sprite.IsValid(_type, _rotation)


func IsOnFloor() -> bool:
	return not board.VerifyLocation(GetTetrominoesLocation(), Vector2i(0, 1))


func GetTetrominoesLocation() -> Array[Vector2i]:
	return sprite.GetTetrominoesLocation(currentPosition)


func UpdateTexture() -> void:
	sprite.currentTexture = currentTexture
	sprite.UpdateTexture()


func _on_area_2d_body_entered(body):
	if body is Board:
		stateMachine.ChangeState(stateMachine.get_child(1))
