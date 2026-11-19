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
var hold : bool

func Initialize(_board: Board):
	UpdateTexture()
	board = _board
	hold = false
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
	
	ApplyRotation(testRotation)

func RotateRight() -> void:
	var testRotation : int
	if currentRotation == 3:
		testRotation = 0
	else:
		testRotation = currentRotation + 1
		
	ApplyRotation(testRotation)

func Rotate180() -> void:
	var testRotation : int
	if currentRotation > 1:
		testRotation = currentRotation - 2
	elif currentRotation < 2:
		testRotation = currentRotation + 2
	
	ApplyRotation(testRotation)


func ApplyRotation(testRotation: int) -> void:
	var kickTable : Array = kickCases.GetKickCase(currentRotation, testRotation)
	
	if currentType == "O":
		testRotation = 0
	
	var desiredRotation : Array = sprite.rotations.rotations[currentType + "_" + str(testRotation)]
	var vectorRotation : Array[Vector2i] = []
	
	for index in range(1, 5):
		var tetromino = Vector2i(desiredRotation[index][0], desiredRotation[index][1])
		vectorRotation.append(tetromino + currentPosition)
	
	var kickCase : Vector2i = kickCases.VerifyKickCase(kickTable, vectorRotation)
	
	if kickCase != Vector2i(-5, -5) or kickTable != [[0, 0]]:
		currentRotation = testRotation
		currentPosition += kickCase
		
		UpdateFrame(currentType, currentRotation)
		UpdatePosition(currentPosition.x, currentPosition.y)


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
