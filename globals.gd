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
const lineClearedScore : Dictionary[int, int] = {
	5: 800,
	4: 800,
	3: 500,
	2: 300,
	1: 100,
	0: 0
}

var lastLineCleared : int = 0
var level : int = 0
var linesCleared : int = 0
var score : int = 0
var top : int
var backToBack : int = 0

const SAVE_PATH = "user://tetrisScore.save"

func _ready() -> void:
	LoadScore()


func LineCleared(lines: int, isTSpin: bool) -> void:
	backToBack = backToBack + 1 if lines != 0 else 0
	
	lastLineCleared = lines if not isTSpin else 5
	linesCleared += lines
	level = linesCleared / 10
	
	UpdateScore(false)


func UpdateScore(gameEnded: bool) -> void:
	if gameEnded:
		if score > top:
			SaveScore()
		return
	
	var multiplier : int = 15 if backToBack > 1 else 10
	score += lineClearedScore[lastLineCleared] * (level + 1) * multiplier / 10


func SaveScore() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_line(str(top))
		file.close()


func LoadScore() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		top = 0
		SaveScore()
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		top = int(file.get_line())
		file.close()
