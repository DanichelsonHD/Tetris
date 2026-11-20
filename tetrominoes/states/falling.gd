class_name Falling extends State

var timer : float = 0
var floorTouched : bool

func _ready() -> void:
	pass

func Process(_delta: float) -> State:
	if timer < 0.075:
		timer += _delta
	elif not tetromino.IsOnFloor():
		tetromino.UpdatePosition(tetromino.currentPosition.x, tetromino.currentPosition.y + 1)
		timer = 0
	return null


func Physics(_delta: float) -> State:
	if tetromino.IsOnFloor():
		return locking
	return null


func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("moveLeft"): tetromino.MoveLeft()
	if _event.is_action_pressed("moveRight"): tetromino.MoveRight()
	if _event.is_action_pressed("rotateLeft"): tetromino.RotateLeft()
	if _event.is_action_pressed("rotateRight"): tetromino.RotateRight()
	if _event.is_action_pressed("rotate180"): tetromino.Rotate180()
	return null


func Enter() -> void:
	pass


func Exit() -> void:
	pass
