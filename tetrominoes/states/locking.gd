class_name Locking extends State

var timer : float
var timeModifier : float = 0.5

func Process(_delta: float) -> State:
	if timer > 0.5:
		return locked
	if timer < 0:
		timer = 0
	timer += _delta
	return null


func Physics(_delta: float) -> State:
	if not tetromino.IsOnFloor():
		return falling
	return null


func HandleInput(_event: InputEvent) -> State:
	DetectInput(_event)
	if _event.is_action_pressed("hardDrop"): 
		tetromino.audioPlayer.PlayNow("DROP", -25)
		return locked
	return null


func ReduceTimer(reason: String) -> void:
	stateMachine.lastMovement = reason
	timer -= timeModifier


func Enter() -> void:
	timer = 0
	stateMachine.lastMovement = ""
	tetromino.pieceMoved.connect(ReduceTimer)


func Exit() -> void:
	tetromino.pieceMoved.disconnect(ReduceTimer)
