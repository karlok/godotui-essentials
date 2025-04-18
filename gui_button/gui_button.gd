extends Button

const BUTTON_SOUND := preload("res://addons/gui_essentials/sfx/button_sound.wav")
var sound := AudioStreamPlayer.new()

func _ready():
	self.focus_mode = Control.FOCUS_NONE # remove button border when focused
	
	sound.stream = BUTTON_SOUND
	sound.volume_db = -10
	add_child(sound)
	
	pressed.connect(func(): _play_click_sound())

func _play_click_sound():
	if not is_inside_tree():
		print("button or sound not inside tree")
		return

	await get_tree().process_frame

	if is_instance_valid(sound) and sound.is_inside_tree():
		sound.play()
	else:
		print("sound is not valid or sound is not inside tree")
