extends AudioStreamPlayer

var names : Dictionary[String, AudioStreamOggVorbis] = {
	"TOP": load("res://sounds/achievement.ogg") as AudioStreamOggVorbis,
	"1980": load("res://sounds/music_1980s.ogg") as AudioStreamOggVorbis,
	
	"DROP": load("res://sounds/drop.ogg") as AudioStreamOggVorbis,
	"ROTATE": load("res://sounds/rotate.ogg") as AudioStreamOggVorbis,
	"HOLD": load("res://sounds/hold.ogg") as AudioStreamOggVorbis,
	"MOVE": load("res://virtualkey.png") as AudioStreamOggVorbis,
	
	"LOCK": load("res://sounds/lock.ogg") as AudioStreamOggVorbis,
	
	"ALL CLEAR!!!!": load("res://sounds/pc.ogg") as AudioStreamOggVorbis,
	
	"T-SPIN0": load("res://sounds/spin_0.ogg") as AudioStreamOggVorbis,
	"T-SPIN1": load("res://sounds/spin_1.ogg") as AudioStreamOggVorbis,
	"T-SPIN2": load("res://sounds/spin_2.ogg") as AudioStreamOggVorbis,
	"T-SPIN3": load("res://sounds/spin_3.ogg") as AudioStreamOggVorbis,
	
	"TETRIS!!!!": load("res://sounds/clear_4.ogg") as AudioStreamOggVorbis,
	"TRIPLE!!!": load("res://sounds/clear_3.ogg") as AudioStreamOggVorbis,
	"DOUBLE!!": load("res://sounds/clear_2.ogg") as AudioStreamOggVorbis,
	"SINGLE!": load("res://sounds/clear_1.ogg") as AudioStreamOggVorbis,
	
	"": null
}

func PlayNow(name: String, _volume: float) -> void:
	stream = names[name]
	volume_db = _volume
	play()
