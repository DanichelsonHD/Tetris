class_name Falling extends State

var timer : float = 0

func _ready() -> void:
	pass

func Process(_delta: float) -> State:
	if timer < 0.1:
		timer += _delta
	else:
		tetromino.UpdatePosition(tetromino.currentPosition.x, tetromino.currentPosition.y + 1)
		timer = 0
	return null

func Physics(_delta: float) -> State:
	
	return null

func HandleInput(_event: InputEvent) -> State:
	
	return null

func Enter() -> void:
	print("Entered Falling State")
	var kickCase = VerifyKickCase(GetKickCase(0, 1))
	if not kickCase == Vector2i.ZERO:
		pass
	pass

func Exit() -> void:
	
	pass
