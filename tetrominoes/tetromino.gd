class_name Tetromino extends Node2D

const validRotations : Array[int] = [0, 1, 2, 3]
const validTypes : Array[String] = ["T", "S", "Z", "J", "L", "I", "O"]
const CELL : int = 30

@export var currentType : String
@export var currentRotation : int = 0
@export var currentPosition : Vector2i
@export var currentTexture : CompressedTexture2D

var lastRotation : int = 0
var lastPosition : Vector2i = Vector2i(0, 0)

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var area2D : Area2D = $Area2D
@onready var sprite1 = $"Area2D/TetrominoSquare-1/Sprite-1"
@onready var sprite2 = $"Area2D/TetrominoSquare-2/Sprite-2"
@onready var sprite3 = $"Area2D/TetrominoSquare-3/Sprite-3"
@onready var sprite4 = $"Area2D/TetrominoSquare-4/Sprite-4"


func _ready():
	updateTexture()


func updateFrame(_type: String, _rotation: int) -> void:
	if not isValid(_type, _rotation):
		return
	
	if _type == "O":
		_rotation = 0
		
	animationPlayer.play(_type + "_" + str(_rotation))
	currentRotation = _rotation
	currentType = _type


func updatePosition(x: int, y: int) -> void:
	lastPosition = currentPosition
	
	position.x = x * CELL
	position.y = y * CELL
	
	currentPosition = Vector2i(x, y)


func rotateLeft() -> void:
	lastRotation = currentRotation
	
	if currentRotation == 0:
		currentRotation = 3
	else:
		currentRotation -= 1
		
	updateFrame(currentType, currentRotation)


func rotateRight() -> void:
	lastRotation = currentRotation
		
	if currentRotation == 3:
		currentRotation = 0
	else:
		currentRotation += 1
		
	updateFrame(currentType, currentRotation)


func rotate180() -> void:
	lastRotation = currentRotation
	
	if currentRotation > 1:
		currentRotation -= 2
	elif currentRotation < 2:
		currentRotation += 2
	
	updateFrame(currentType, currentRotation)


func isValid(_type: String, _rotation: int) -> bool:
	if _type in validTypes and _rotation in validRotations:
		return true
	return false


func updateTexture() -> void:
	sprite1.texture = currentTexture
	sprite2.texture = currentTexture
	sprite3.texture = currentTexture
	sprite4.texture = currentTexture


func _on_area_2d_body_entered(body):
	updateFrame(currentType, lastRotation)
	updatePosition(lastPosition.x, lastPosition.y)
	if body is Board:
		body.drawTetromino(currentType, currentRotation, currentPosition)
