class_name S extends State


func _ready() -> void:
	pass

func Process(_delta: float) -> State:
	
	return null

func Physics(_delta: float) -> State:
	
	return null

func HandleInput(_event: InputEvent) -> State:
	
	return null

func Enter() -> void:
	print("Entered S State")
	animationPlayer.play("S_" + str(tetromino.currentRotation))
	pass

func Exit() -> void:
	pass
