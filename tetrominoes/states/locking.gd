class_name Locking extends State

var timer : float

func _ready() -> void:
	pass

func Process(_delta: float) -> State:
	if timer > 2:
		return locked
	timer += _delta
	print(timer)
	return null

func Physics(_delta: float) -> State:
	
	return null

func HandleInput(_event: InputEvent) -> State:
	if _event.is_action_pressed("RotateLeft"):
		timer -= 1
	if _event.is_action_pressed("RotateRight"):
		timer -= 1
	if _event.is_action_pressed("Rotate180"):
		timer -= 1
	return null

func Enter() -> void:
	print("Entered Locking State")
	timer = 0
	pass

func Exit() -> void:
	
	pass
