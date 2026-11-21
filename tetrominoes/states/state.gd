class_name State extends Node2D

@onready var tetromino : Tetromino
@onready var board : Board

@onready var falling = $"../Falling"
@onready var locking = $"../Locking"
@onready var locked = $"../Locked"

func _ready() -> void:
	pass

func Process(_delta: float) -> State:
	
	return null

func Physics(_delta: float) -> State:
	
	return null

func HandleInput(_event: InputEvent) -> State:
	
	return null

func DetectInput(_event: InputEvent) -> void:
	if _event.is_action_pressed("rotateLeft"): 
		tetromino.RotateLeft()
	if _event.is_action_pressed("rotateRight"): 
		tetromino.RotateRight()
	if _event.is_action_pressed("rotate180"): 
		tetromino.Rotate180()
		
	if _event.is_action_pressed("moveLeft"): 
		tetromino.MoveLeft()
		tetromino.HandleMovement("Left")
	if _event.is_action_pressed("moveRight"): 
		tetromino.MoveRight()
		tetromino.HandleMovement("Right")
	
	if _event.is_action_released("moveLeft"):
		tetromino.DASTimer = 0
		tetromino.ARRTimer = 0
		tetromino.movementDirection = ""
	if _event.is_action_released("moveRight"):
		tetromino.DASTimer = 0
		tetromino.ARRTimer = 0
		tetromino.movementDirection = ""

func Enter() -> void:
	pass

func Exit() -> void:
	pass
