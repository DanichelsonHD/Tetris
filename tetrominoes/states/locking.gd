class_name Locking extends State

var timer : float
var timeModifier : float = 0.5

func _ready() -> void:
	pass

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
	return null


func ReduceTimer(reason: String) -> void:
	print(reason)
	timer -= timeModifier

func Enter() -> void:
	timer = 0
	tetromino.pieceMoved.connect(ReduceTimer)

func Exit() -> void:
	tetromino.pieceMoved.disconnect(ReduceTimer)
