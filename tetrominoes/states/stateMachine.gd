class_name StateMachine extends Node2D

var states : Array[State]
var prevState : State
var currentState : State

func _ready():
	process_mode = Node.PROCESS_MODE_DISABLED 

func _process(delta):
	ChangeState(currentState.Process(delta))

func _physics_process(delta):
	ChangeState(currentState.Physics(delta))

func _unhandled_input(event):
	ChangeState(currentState.HandleInput(event))


func Initialize(_tetromino: Tetromino, _board: Board) -> void:
	states = []
	
	for child in get_children():
		if child is State:
			child.tetromino = _tetromino
			child.board = _board
			states.append(child)
	
	if states.size() > 0:
		ChangeState(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT


func ChangeState(newState: State) -> void:
	if newState == null || newState == currentState:
		return
	
	if currentState:
		currentState.Exit()
	
	prevState = currentState
	currentState = newState
	
	currentState.Enter()
