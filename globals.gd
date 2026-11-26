extends Node

const SAVE_PATH = "user://tetrisScore.save"
const validRotations : Array[int] = [0, 1, 2, 3]
const validTypes : Array[String] = ["T", "S", "Z", "J", "L", "I", "O"]
const CELL : int = 30
const lineClearedType : Dictionary[int, String] = {
	10: "ALL CLEAR!!!!",
	5: "T-SPIN",
	4: "TETRIS!!!!",
	3: "TRIPLE!!!",
	2: "DOUBLE!!",
	1: "SINGLE!",
	0: ""
}
const lineClearedScore : Dictionary[int, int] = {
	10: 1600,
	5: 1200,
	4: 800,
	3: 500,
	2: 300,
	1: 100,
	0: 0
}

var lastLineCleared : int
var level : int
var linesCleared : int
var sprintLines : int
var score : int
var top : int
var backToBack : int
var newTop : bool
var timer : float
var bestTime : float
var gameEnded : bool
var mode : String
var scores : Dictionary = {
	"MARATHON": {
		"score": 0,
		"level": 0,
		"lines": 0,
		"time": 0.0
	},
	"SPRINT": {
		"score": 0,
		"level": 0,
		"lines": 0,
		"time": 0.0
	}
}

var musicVolume : float
var sfxVolume : float

func Initialize() -> void:
	UpdateScore()
	LoadScore()
	lastLineCleared = 0
	level = 0
	linesCleared = 0
	score = 0
	backToBack = 0
	timer = 0
	sprintLines = 40
	musicVolume = -12
	sfxVolume = -6
	bestTime = scores[mode]["time"]
	top = scores[mode]["score"]
	newTop = false
	gameEnded = false

func LineCleared(lines: int, isTSpin: bool, isAllCleared) -> void:
	if isAllCleared:
		lastLineCleared = 10
	elif isTSpin:
		lastLineCleared =  5
	else:
		lastLineCleared = lines
	linesCleared += lines
	level = linesCleared / 10
	
	backToBack = backToBack + 1 if (lines >= 4 or isTSpin) else 0
	
	UpdateScore()
	
	if mode == "SPRINT":
		if linesCleared >= sprintLines:
			gameEnded = true


func UpdateScore() -> void:
	var multiplier : int = 15 if backToBack > 1 else 10
	score += lineClearedScore[lastLineCleared] * (level + 1) * multiplier / 10
	
	if mode == "MARATHON":
		if score <= top:
			return
	if mode == "SPRINT":
		if timer >= bestTime or linesCleared < sprintLines:
			return
	
	top = score
	bestTime = timer
	newTop = true
	SaveScore()


func SaveScore() -> void:
	var currentMode : Dictionary = scores[mode]
	
	currentMode["score"] = top
	currentMode["level"] = level
	currentMode["lines"] = linesCleared
	currentMode["time"] = bestTime
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	
	if file:
		for _mode in ["MARATHON", "SPRINT"]:
			var data : Dictionary = scores[_mode]
			
			file.store_line(_mode)
			file.store_line("Score: " + str(data["score"]))
			file.store_line("Level: " + str(data["level"]))
			file.store_line("Lines: " + str(data["lines"]))
			file.store_line("Time: " + FormatTimer(data["time"]))
			file.store_line("")
		
		file.close()


func LoadScore() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		SaveScore()
		return
	
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	
	if file:
		for _mode in ["MARATHON", "SPRINT"]:
			file.get_line() # nome do modo
			
			var data: Dictionary = scores[_mode]
			
			data["score"] = int(file.get_line().replace("Score: ", ""))
			data["level"] = int(file.get_line().replace("Level: ", ""))
			data["lines"] = int(file.get_line().replace("Lines: ", ""))
			
			var timeString: String = file.get_line().replace("Time: ", "")
			data["time"] = FormatToTimer(timeString)
			
			file.get_line()
		
		file.close()
	print(scores)


func FormatTimer(_timer: float) -> String:
	var minutes : int = int(_timer / 60)
	var seconds : float = fmod(_timer, 60)
	var timerStr : String = "%02d:%06.3f" % [minutes, seconds]
	return timerStr


func FormatTimerGame(_timer: float) -> String:
	var minutes : int = int(_timer / 60)
	var seconds : float = fmod(_timer, 60)
	var timerStr : String = "%02d:%02.0f" % [minutes, seconds]
	return timerStr


func FormatToTimer(timerStr: String) -> float:
	var floats : Array = timerStr.split_floats(":") as Array[float]
	var _timer : float = floats[0] * 60 + floats[1]
	return _timer
