extends Button

const BUTTON_SOUND := preload("res://addons/gui_essentials/sfx/button_sound.wav")
var sound := AudioStreamPlayer.new()

func _ready():
	self.focus_mode = Control.FOCUS_NONE # remove button border when focused
	
	sound.stream = BUTTON_SOUND
	sound.volume_db = -10
	add_child(sound)
	
	pressed.connect(func(): sound.play())
