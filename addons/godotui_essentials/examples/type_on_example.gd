extends Control

# Variables for our UI elements
var _regular_label: Label
var _rich_label: RichTextLabel
var _type_on_effect_regular: GUITypeOnEffect
var _type_on_effect_rich: GUITypeOnEffect
var _speed_slider: HSlider
var _style_option: OptionButton
var _sound_checkbox: CheckBox
var _punctuation_checkbox: CheckBox

func _ready():
	# Create a UI to demonstrate type-on effects
	create_type_on_example_ui()

func create_type_on_example_ui():
	# Create a center container
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	
	# Create a panel for our content
	var panel = preload(GUIPaths.PANEL_SCENE).instantiate()
	panel.custom_minimum_size = Vector2(600, 500)
	center.add_child(panel)
	
	# Create a VBox for our content
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 20)
	vbox.add_theme_constant_override("margin_left", 20)
	vbox.add_theme_constant_override("margin_right", 20)
	vbox.add_theme_constant_override("margin_top", 20)
	vbox.add_theme_constant_override("margin_bottom", 20)
	panel.add_child(vbox)
	
	# Add a title
	var title = Label.new()
	title.text = "Type-On Effect Examples"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)
	
	# Add a description
	var description = Label.new()
	description.text = "Demonstrates typewriter-style text animations"
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(description)
	
	# Add a separator
	var separator = HSeparator.new()
	vbox.add_child(separator)
	
	# Create controls section
	var controls_hbox = HBoxContainer.new()
	controls_hbox.add_theme_constant_override("separation", 20)
	vbox.add_child(controls_hbox)
	
	# Speed control
	var speed_vbox = VBoxContainer.new()
	controls_hbox.add_child(speed_vbox)
	speed_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var speed_label = Label.new()
	speed_label.text = "Typing Speed:"
	speed_vbox.add_child(speed_label)
	
	_speed_slider = HSlider.new()
	_speed_slider.min_value = 0.01
	_speed_slider.max_value = 0.2
	_speed_slider.step = 0.01
	_speed_slider.value = 0.05
	_speed_slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	speed_vbox.add_child(_speed_slider)
	
	# Style control
	var style_vbox = VBoxContainer.new()
	controls_hbox.add_child(style_vbox)
	style_vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var style_label = Label.new()
	style_label.text = "Typing Style:"
	style_vbox.add_child(style_label)
	
	_style_option = OptionButton.new()
	_style_option.add_item("Normal", 0)
	_style_option.add_item("Random Variance", 1)
	_style_option.add_item("Accelerating", 2)
	_style_option.add_item("Decelerating", 3)
	_style_option.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	style_vbox.add_child(_style_option)
	
	# Checkboxes
	var checkbox_vbox = VBoxContainer.new()
	controls_hbox.add_child(checkbox_vbox)
	
	_sound_checkbox = CheckBox.new()
	_sound_checkbox.text = "Play Sound"
	checkbox_vbox.add_child(_sound_checkbox)
	
	_punctuation_checkbox = CheckBox.new()
	_punctuation_checkbox.text = "Pause at Punctuation"
	checkbox_vbox.add_child(_punctuation_checkbox)
	
	# Add another separator
	var separator2 = HSeparator.new()
	vbox.add_child(separator2)
	
	# Regular Label Example
	var regular_label_section = VBoxContainer.new()
	vbox.add_child(regular_label_section)
	
	var regular_label_title = Label.new()
	regular_label_title.text = "Regular Label:"
	regular_label_section.add_child(regular_label_title)
	
	_regular_label = Label.new()
	_regular_label.text = "This is a regular label with a type-on effect. It will display text character by character, like a typewriter. You can adjust the speed and style using the controls above."
	_regular_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_regular_label.custom_minimum_size.y = 80
	regular_label_section.add_child(_regular_label)
	
	var regular_buttons = HBoxContainer.new()
	regular_buttons.add_theme_constant_override("separation", 10)
	regular_label_section.add_child(regular_buttons)
	
	var start_regular_button = Button.new()
	start_regular_button.text = "Start Typing"
	start_regular_button.pressed.connect(_on_start_regular_pressed)
	regular_buttons.add_child(start_regular_button)
	
	var skip_regular_button = Button.new()
	skip_regular_button.text = "Skip to End"
	skip_regular_button.pressed.connect(_on_skip_regular_pressed)
	regular_buttons.add_child(skip_regular_button)
	
	# Rich Text Label Example
	var rich_label_section = VBoxContainer.new()
	vbox.add_child(rich_label_section)
	
	var rich_label_title = Label.new()
	rich_label_title.text = "Rich Text Label:"
	rich_label_section.add_child(rich_label_title)
	
	_rich_label = RichTextLabel.new()
	_rich_label.bbcode_enabled = true
	_rich_label.text = "[b]This is a rich text label[/b] with a type-on effect. It supports [color=yellow]colors[/color], [i]italics[/i], and other [wave]BBCode[/wave] formatting while still showing the typewriter effect."
	_rich_label.fit_content = true
	_rich_label.custom_minimum_size = Vector2(0, 80)
	_rich_label.scroll_active = false
	rich_label_section.add_child(_rich_label)
	
	var rich_buttons = HBoxContainer.new()
	rich_buttons.add_theme_constant_override("separation", 10)
	rich_label_section.add_child(rich_buttons)
	
	var start_rich_button = Button.new()
	start_rich_button.text = "Start Typing"
	start_rich_button.pressed.connect(_on_start_rich_pressed)
	rich_buttons.add_child(start_rich_button)
	
	var skip_rich_button = Button.new()
	skip_rich_button.text = "Skip to End"
	skip_rich_button.pressed.connect(_on_skip_rich_pressed)
	rich_buttons.add_child(skip_rich_button)
	
	# Create the type-on effects
	_type_on_effect_regular = GUITypeOnEffect.create_for_label(_regular_label)
	_type_on_effect_regular.typing_completed.connect(_on_regular_typing_completed)
	
	_type_on_effect_rich = GUITypeOnEffect.create_for_rich_label(_rich_label)
	_type_on_effect_rich.typing_completed.connect(_on_rich_typing_completed)
	
	# Load a typing sound
	var typing_sound = preload("res://addons/godotui_essentials/examples/typing_sound.wav") if ResourceLoader.exists("res://addons/godotui_essentials/examples/typing_sound.wav") else null
	if typing_sound:
		_type_on_effect_regular.typing_sound = typing_sound
		_type_on_effect_rich.typing_sound = typing_sound

func _on_start_regular_pressed():
	# Apply current settings
	_apply_current_settings(_type_on_effect_regular)
	
	# Start typing
	_type_on_effect_regular.start_typing()

func _on_skip_regular_pressed():
	if _type_on_effect_regular.is_typing():
		_type_on_effect_regular.skip_to_end()

func _on_start_rich_pressed():
	# Apply current settings
	_apply_current_settings(_type_on_effect_rich)
	
	# Start typing
	_type_on_effect_rich.start_typing()

func _on_skip_rich_pressed():
	if _type_on_effect_rich.is_typing():
		_type_on_effect_rich.skip_to_end()

func _apply_current_settings(effect: GUITypeOnEffect):
	# Apply speed
	effect.typing_speed = _speed_slider.value
	
	# Apply style
	effect.typing_style = _style_option.selected
	
	# Apply sound
	effect.play_sound = _sound_checkbox.button_pressed
	
	# Apply punctuation pause
	effect.punctuation_pause = 0.2 if _punctuation_checkbox.button_pressed else 0.0

func _on_regular_typing_completed():
	print("Regular label typing completed")

func _on_rich_typing_completed():
	print("Rich label typing completed") 
