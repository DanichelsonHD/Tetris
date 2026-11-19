class_name Falling extends State

var timer : float = 0
var floorTouched : bool

func _ready() -> void:
	pass

func Process(_delta: float) -> State:
	if timer < 0.075:
		timer += _delta
	else:
		tetromino.UpdatePosition(tetromino.currentPosition.x, tetromino.currentPosition.y + 1)
		timer = 0
	return null

func Physics(_delta: float) -> State:
	if floorTouched:
		return locking
	return null

func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("moveLeft"): tetromino.MoveLeft()
	if _event.is_action_pressed("moveRight"): tetromino.MoveRight()
	return null

func Enter() -> void:
	print("Entered Falling State")
	floorTouched = false
	var kickCase = VerifyKickCase(GetKickCase(0, 1))
	if not kickCase == Vector2i.ZERO:
		pass


func Exit() -> void:
	floorTouched = false


func _on_area_2d_body_entered(body):
	floorTouched = true
