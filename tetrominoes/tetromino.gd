class_name Tetromino extends Node2D

const ARR : float = 0.033
const DAS : float = 0.133
const fourCorners : Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(2, 0),
	Vector2i(0, 2),
	Vector2i(2, 2)
]

@export var currentType : String
@export var currentRotation : int = 0
@export var currentPosition : Vector2i
@export var currentTexture : CompressedTexture2D
@onready var audioPlayer = $AudioStreamPlayer
@onready var stateMachine : StateMachine = $StateMachine
@onready var kickCases = $KickCases
@onready var sprite = $Sprite

signal pieceLocked
signal pieceMoved

var board : Board
var hold : bool
var DASTimer : float
var ARRTimer : float
var movementDirection : String

func Initialize(_board: Board):
	UpdateTexture()
	board = _board
	hold = false
	DASTimer = 0
	ARRTimer = 0
	kickCases.Initialize(self, _board)
	stateMachine.Initialize(self, _board)


func UpdateFrame(_type: String, _rotation: int) -> void:
	sprite.UpdateFrame(_type, _rotation)
	currentRotation = _rotation
	currentType = _type


func UpdatePosition(x: int, y: int) -> void:
	position.x = x * Globals.CELL
	position.y = y * Globals.CELL
	
	currentPosition = Vector2i(x, y)


func HandleMovement(_direction: String) -> void:
	if DASTimer <= 0:
		DASTimer = DAS
	
	movementDirection = _direction


func UpdateTimers(_delta: float) -> void:
	if DASTimer > 0:
		DASTimer -= _delta
	if DASTimer <= 0:
		if ARRTimer <= 0:
			ARRTimer = ARR
			if movementDirection == "Left":
				MoveLeft()
			elif movementDirection == "Right":
				MoveRight()
		if ARRTimer > 0:
			ARRTimer -= _delta


func MoveLeft() -> void:
	var left : Vector2i = Vector2i(-1, 0)
	if board.VerifyLocation(GetTetrominoesLocation(), left):
		UpdatePosition(currentPosition.x + left.x, currentPosition.y)
		pieceMoved.emit("MoveLeft")


func MoveRight() -> void:
	var right : Vector2i = Vector2i(1, 0)
	if board.VerifyLocation(GetTetrominoesLocation(), right):
		UpdatePosition(currentPosition.x + right.x, currentPosition.y)
		pieceMoved.emit("MoveRight")


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
	
	if kickCase != Vector2i(-5, -5) and kickTable != [[0, 0]]:
		pieceMoved.emit("Rotate")
		currentRotation = testRotation
		currentPosition += kickCase
		
		audioPlayer.PlayNow("ROTATE", -30)
		
		UpdateFrame(currentType, currentRotation)
		UpdatePosition(currentPosition.x, currentPosition.y)


func HardDrop() -> Vector2i:
	var hardDrop : Vector2i = currentPosition
	while board.VerifyLocation(sprite.GetTetrominoesLocation(hardDrop), Vector2i(0, 1)):
		hardDrop.y += 1
	
	return hardDrop


func WasTSpin(isTSpin: bool) -> bool:
	var occupiedCorners : int = 4
	for position in fourCorners:
		if not board.LocationOccupied(position + currentPosition):
			occupiedCorners -= 1
	
	return occupiedCorners >= 3 and isTSpin


func IsValid(_type: String, _rotation: int) -> bool:
	return sprite.IsValid(_type, _rotation)


func IsOnFloor() -> bool:
	return not board.VerifyLocation(GetTetrominoesLocation(), Vector2i(0, 1))


func GetTetrominoesLocation() -> Array[Vector2i]:
	return sprite.GetTetrominoesLocation(currentPosition)


func UpdateTexture() -> void:
	sprite.currentTexture = currentTexture
	sprite.UpdateTexture()
