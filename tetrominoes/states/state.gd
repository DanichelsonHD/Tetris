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


const KickTable : Array[Array] = [
	[[-1,  0], [-1, -1], [ 0,  2], [-1,  2]], # 0->1 ou 2->1
	[[ 1,  0], [ 1,  1], [ 0, -2], [ 1, -2]], # 1->0 ou 1->2
	[[ 1,  0], [ 1, -1], [ 0,  2], [ 1,  2]], # 2->3 ou 0->3
	[[-1,  0], [-1, -1], [ 0, -2], [-1, -2]], # 3->2 ou 3->0
]
const KickTable180 : Array[Array] = [
	[0, +1], [+1, 0], [0, -1], [-1, 0]
]

func GetKickCase(current: int, next: int) -> Array[Array]:
	if current - next == 2 or current - next == -2:
		return KickTable180
		
	if current == 1:
		return KickTable[1]
	elif current == 3:
		return KickTable[3]
	
	if next == 1:
		return KickTable[0]
	elif next == 3:
		return KickTable[2]
	
	return [[0,0]]


func VerifyKickCase(kickTable: Array) -> Vector2i:
	for kick in [[0,0]] + kickTable:
		var vectorKick = Vector2i(kick[0], kick[1])
		if board.VerifyLocation(tetromino.GetTetrominoesLocation(), vectorKick):
			return vectorKick
	return Vector2i.ZERO


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
