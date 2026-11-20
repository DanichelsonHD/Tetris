extends Node

const validRotations : Array[int] = [0, 1, 2, 3]
const validTypes : Array[String] = ["T", "S", "Z", "J", "L", "I", "O"]
const CELL : int = 30
const lineClearedType : Dictionary[int, String] = {
	5: "T-SPIN",
	4: "TETRIS!!!!",
	3: "TRIPLE!!!",
	2: "DOUBLE!!",
	1: "SINGLE!",
	0: ""
}

var lastLineCleared : int = 0
var level : int = 0
var linesCleared : int = 0
var score : int = 0
var top : int

const SAVE_PATH = "user://tetrisScore.save"

func _ready() -> void:
	loadScore()


func LineCleared(lines: int) -> void:
	lastLineCleared = lines


func updateScore() -> void:
	if score > top:
		saveScore()


func saveScore() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_line(str(top))
		file.close()


func loadScore() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		top = 0
		saveScore()
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		top = int(file.get_line())
		file.close()
