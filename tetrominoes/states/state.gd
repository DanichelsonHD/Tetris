class_name State extends Node2D

@onready var animationPlayer : AnimationPlayer = $"../../AnimationPlayer"
@onready var tetromino : Tetromino
@onready var board : Board

@onready var tetromino_1 = $"../../Area2D/TetrominoSquare-1"
@onready var tetromino_2 = $"../../Area2D/TetrominoSquare-2"
@onready var tetromino_3 = $"../../Area2D/TetrominoSquare-3"
@onready var tetromino_4 = $"../../Area2D/TetrominoSquare-4"

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

func Enter() -> void:
	pass

func Exit() -> void:
	pass
