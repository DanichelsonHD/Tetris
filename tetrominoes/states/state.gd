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
	
	if not Input.is_action_pressed("moveLeft") and tetromino.movementDirection == "Left":
		if Input.is_action_pressed("moveRight"):
			tetromino.movementDirection = "Right"
		else:
			tetromino.ARRTimer = 0
			tetromino.movementDirection = ""
		tetromino.DASTimer = 0
	
	if not Input.is_action_pressed("moveRight") and tetromino.movementDirection == "Right":
		if Input.is_action_pressed("moveLeft"):
			tetromino.movementDirection = "Left"
		else:
			tetromino.ARRTimer = 0
			tetromino.movementDirection = ""
		tetromino.DASTimer = 0

func Enter() -> void:
	pass

func Exit() -> void:
	pass
