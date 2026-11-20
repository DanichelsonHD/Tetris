class_name Locking extends State

var timer : float
var timeModifier : float = 0.25

func _ready() -> void:
	pass

func Process(_delta: float) -> State:
	if timer > 2:
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
	if _event.is_action_pressed("rotateLeft"): 
		tetromino.RotateLeft()
		timer -= timeModifier
	if _event.is_action_pressed("rotateRight"): 
		tetromino.RotateRight()
		timer -= timeModifier
	if _event.is_action_pressed("rotate180"): 
		tetromino.Rotate180()
		timer -= timeModifier
		
	if _event.is_action_pressed("moveLeft"): 
		tetromino.MoveLeft()
		timer -= timeModifier
	if _event.is_action_pressed("moveRight"): 
		tetromino.MoveRight()
		timer -= timeModifier
	return null

func Enter() -> void:
	timer = 0


func Exit() -> void:
	pass
