class_name KickCases extends Node2D

var board : Board
var tetromino : Tetromino

const KickTable : Array[Array] = [
	[[-1,  0], [-1, -1], [ 0,  2], [-1,  2]], # 0->1 ou 2->1
	[[ 1,  0], [ 1,  1], [ 0, -2], [ 1, -2]], # 1->0 ou 1->2
	[[ 1,  0], [ 1, -1], [ 0,  2], [ 1,  2]], # 2->3 ou 0->3
	[[-1,  0], [-1, -1], [ 0, -2], [-1, -2]], # 3->2 ou 3->0
]
const IKickTable : Array[Array] = [
	[[-2,  0], [ 1,  0], [-2,  1], [ 1, -2]], # 0->1 ou 3->2
	[[ 2,  0], [-1,  0], [ 2, -1], [-1,  2]], # 1->0 ou 2->3
	[[-1,  0], [ 2,  0], [-1, -2], [ 2,  1]], # 1->2 ou 0->3
	[[ 1,  0], [-2,  0], [ 1,  2], [-2, -1]]  # 2->1 ou 3->0
]
const KickTable180 : Array[Array] = [
	[0, +1], [+1, 0], [0, -1], [-1, 0]
]

func GetKickCase(current: int, next: int) -> Array[Array]:
	if tetromino.currentType == "I":
		return GetIKickCase(current, next)
	
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
	
	return [[0, 0]]


func GetIKickCase(current: int, next: int) -> Array[Array]:
	if (current == 0 and next == 1) or (current == 3 and next == 2):
		return IKickTable[0]
	if (current == 1 and next == 0) or (current == 2 and next == 3):
		return IKickTable[1]
		
	if (current == 1 and next == 2) or (current == 0 and next == 3):
		return IKickTable[2]
	if (current == 2 and next == 1) or (current == 3 and next == 0):
		return IKickTable[3]
		
	return [[0, 0]]


func VerifyKickCase(kickTable: Array, desiredRotation: Array[Vector2i]) -> Vector2i:
	for kick in [[0,0]] + kickTable:
		var vectorKick = Vector2i(kick[0], kick[1])
		if board.VerifyLocation(desiredRotation, vectorKick):
			return vectorKick
	return Vector2i(-5, -5)

func Initialize(_tetromino: Tetromino, _board: Board) -> void:
	board = _board
	tetromino = _tetromino

func _ready():
	pass
