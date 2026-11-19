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

func Enter() -> void:
	pass

func Exit() -> void:
	pass
