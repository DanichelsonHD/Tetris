class_name Tetromino extends Node2D

const validRotations : Array[int] = [0, 1, 2, 3]
const validTypes : Array[String] = ["T", "S", "Z", "J", "L", "I", "O"]
const CELL : int = 30
const MARGIN : int = 15

@export var currentType : String
@export var currentRotation : int = 0
@export var currentPosition : Vector2i
@export var currentTexture : CompressedTexture2D

var lastRotation : int = 0
var lastPosition : Vector2i = Vector2i(0, 0)

@onready var StateMachine : StateMachine = $StateMachine
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var area2D : Area2D = $Area2D
@onready var tetrominoes : Array[CollisionShape2D] = [
	$"Area2D/TetrominoSquare-1", $"Area2D/TetrominoSquare-2", 
	$"Area2D/TetrominoSquare-3", $"Area2D/TetrominoSquare-4"
]

func Initialize(_board: Board):
	UpdateTexture()
	StateMachine.Initialize(self, _board)


func UpdateFrame(_type: String, _rotation: int) -> void:
	if not IsValid(_type, _rotation):
		return
	
	if _type == "O":
		_rotation = 0
		
	animationPlayer.play(_type + "_" + str(_rotation))


func UpdatePosition(x: int, y: int) -> void:
	lastPosition = currentPosition
	
	position.x = x * CELL
	position.y = y * CELL
	
	currentPosition = Vector2i(x, y)


func RotateLeft() -> void:
	lastRotation = currentRotation
	
	if currentRotation == 0:
		currentRotation = 3
	else:
		currentRotation -= 1
		
	UpdateFrame(currentType, currentRotation)


func RotateRight() -> void:
	lastRotation = currentRotation
		
	if currentRotation == 3:
		currentRotation = 0
	else:
		currentRotation += 1
		
	UpdateFrame(currentType, currentRotation)


func Rotate180() -> void:
	lastRotation = currentRotation
	
	if currentRotation > 1:
		currentRotation -= 2
	elif currentRotation < 2:
		currentRotation += 2
	
	UpdateFrame(currentType, currentRotation)


func IsValid(_type: String, _rotation: int) -> bool:
	if _type in validTypes and _rotation in validRotations:
		return true
	return false


func GetTetrominoesLocation() -> Array[Vector2i]:
	var array = []
	for tetromino in tetrominoes:
		array.append(Vector2i(
			(tetromino.position.x - MARGIN) / CELL, # Subtraí por causa de margem e 
			(tetromino.position.y - MARGIN) / CELL  # dividi pra virar posição de Vector2i
		))
	return array

func UpdateTexture() -> void:
	for tetromino in tetrominoes:
		tetromino.get_child(0).texture = currentTexture


func _on_area_2d_body_entered(body):
	UpdateFrame(currentType, lastRotation)
	UpdatePosition(lastPosition.x, lastPosition.y)
	if body is Board:
		body.DrawTetromino(currentType, currentRotation, currentPosition)
