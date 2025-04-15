extends Label

@onready var _timer := Timer.new()
@onready var _audio := AudioStreamPlayer.new()

enum TypeOnMode { CHAR, WORD }
const DEFAULT_SOUND := preload("res://addons/gui_essentials/sfx/typing_sound.wav")

func _ready():
	add_child(_timer)
	add_child(_audio)
	_timer.timeout.connect(_on_type_next)
	_audio.stream = DEFAULT_SOUND
	_audio.volume_db = -10

# --- Properties for type-on effect
var _target_text := ""
var _typing_mode: TypeOnMode = TypeOnMode.CHAR
var _char_index := 0
var _word_list := []
var _word_index := 0

# --- Public function to start the effect
func type_on(text: String, speed := 0.05, mode: TypeOnMode = TypeOnMode.CHAR):
	_typing_mode = mode
	_target_text = text
	_char_index = 0
	_word_index = 0

	if _typing_mode == TypeOnMode.CHAR:
		self.text = text
		visible_characters = 0
	else:
		self.text = ""
		_word_list = text.split(" ", false)

	_timer.wait_time = speed
	_timer.start()

# --- Timer step
func _on_type_next():
	if _typing_mode == TypeOnMode.CHAR:
		if _char_index < _target_text.length():
			_char_index += 1
			visible_characters = _char_index
			_play_type_sound()
		else:
			_timer.stop()
	elif _typing_mode == TypeOnMode.WORD:
		if _word_index < _word_list.size():
			if _word_index == 0:
				self.text = _word_list[0]
			else:
				self.text += " " + _word_list[_word_index]
			_word_index += 1
			_play_type_sound()

			# Force redraw just in case
			self.queue_redraw()
		else:
			_timer.stop()
		
func _play_type_sound():
	if _audio.stream:
		_audio.stop()
		_audio.play()
