class_name Falling extends State

const MAX_G : int = 20 #G representa quantas linhas o bloco cai por frame em 60 frames por segundo
const FPS : int = 60

var timer : float = 0
var floorTouched : bool
var softDropped : bool

func Process(_delta: float) -> State:
	if timer < CalculateG():
		timer += _delta
	elif not tetromino.IsOnFloor():
		tetromino.UpdatePosition(tetromino.currentPosition.x, tetromino.currentPosition.y + 1)
		timer = 0
	return null


func Physics(_delta: float) -> State:
	if tetromino.IsOnFloor():
		return locking
	return null


func CalculateG() -> float:
	if Globals.level >= MAX_G:
		return 1.0 / (MAX_G * FPS)
	
	const GRAVITY = 0.8
	const SPEED_INCREASE = 0.007
	var currentLevel = max(0, Globals.level - 1)
	
	var baseVelocity = GRAVITY - (SPEED_INCREASE * currentLevel)
	var currentG = pow(baseVelocity, currentLevel)
	
	return currentG / MAX_G if softDropped else currentG

func HandleInput(_event: InputEvent) -> State:
	DetectInput(_event)
	if _event.is_action_pressed("hardDrop"): 
		var hardDrop = tetromino.HardDrop()
		tetromino.UpdatePosition(hardDrop.x, hardDrop.y)
		return locked
	
	softDropped = true if Input.is_action_pressed("softDrop") else false
	
	return null


func Enter() -> void:
	softDropped = false


func Exit() -> void:
	pass
