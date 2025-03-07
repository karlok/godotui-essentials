extends Control

func _ready():
	# Create a UI to demonstrate fade animations
	create_fade_example_ui()

func create_fade_example_ui():
	# Create a center container
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	
	# Create a VBox for our content
	var vbox = VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 20)
	center.add_child(vbox)
	
	# Add a title
	var title = Label.new()
	title.text = "Fade Animation Examples"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)
	
	# Add a description
	var description = Label.new()
	description.text = "Click the buttons below to see fade-in and fade-out animations"
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(description)
	
	# Add a separator
	var separator = HSeparator.new()
	vbox.add_child(separator)
	
	# Create a grid for our components
	var grid = GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 30)
	grid.add_theme_constant_override("v_separation", 20)
	vbox.add_child(grid)
	
	# Add examples for each component
	add_button_example(grid)
	add_panel_example(grid)
	add_dialog_example(grid)

func add_button_example(parent):
	# Add a label
	var label = Label.new()
	label.text = "GUIButton:"
	parent.add_child(label)
	
	# Create a container for the buttons
	var container = HBoxContainer.new()
	container.add_theme_constant_override("separation", 10)
	parent.add_child(container)
	
	# Create a button with fade animations
	var button = preload(GUIPaths.BUTTON_SCENE).instantiate()
	button.text = "Fade Button"
	button.use_fade_animations = true
	button.fade_in_duration = 0.5
	button.fade_out_duration = 0.3
	button.modulate.a = 0.0  # Start invisible
	container.add_child(button)
	
	# Create control buttons
	var fade_in_button = Button.new()
	fade_in_button.text = "Fade In"
	fade_in_button.pressed.connect(func(): button.fade_in())
	container.add_child(fade_in_button)
	
	var fade_out_button = Button.new()
	fade_out_button.text = "Fade Out"
	fade_out_button.pressed.connect(func(): button.fade_out())
	container.add_child(fade_out_button)

func add_panel_example(parent):
	# Add a label
	var label = Label.new()
	label.text = "GUIPanel:"
	parent.add_child(label)
	
	# Create a container for the panel and controls
	var container = VBoxContainer.new()
	container.add_theme_constant_override("separation", 10)
	parent.add_child(container)
	
	# Create a panel with fade animations
	var panel = preload(GUIPaths.PANEL_SCENE).instantiate()
	panel.custom_minimum_size = Vector2(200, 100)
	panel.use_fade_animations = true
	panel.fade_in_duration = 0.5
	panel.fade_out_duration = 0.3
	panel.modulate.a = 0.0  # Start invisible
	container.add_child(panel)
	
	# Add content to the panel
	var panel_label = Label.new()
	panel_label.text = "Fade Panel"
	panel_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	panel_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.add_child(panel_label)
	
	# Create control buttons
	var button_container = HBoxContainer.new()
	button_container.add_theme_constant_override("separation", 10)
	container.add_child(button_container)
	
	var fade_in_button = Button.new()
	fade_in_button.text = "Fade In"
	fade_in_button.pressed.connect(func(): panel.fade_in())
	button_container.add_child(fade_in_button)
	
	var fade_out_button = Button.new()
	fade_out_button.text = "Fade Out"
	fade_out_button.pressed.connect(func(): panel.fade_out())
	button_container.add_child(fade_out_button)

func add_dialog_example(parent):
	# Add a label
	var label = Label.new()
	label.text = "GUIDialog:"
	parent.add_child(label)
	
	# Create a container for the controls
	var container = VBoxContainer.new()
	container.add_theme_constant_override("separation", 10)
	parent.add_child(container)
	
	# Create a button to show the dialog
	var show_dialog_button = Button.new()
	show_dialog_button.text = "Show Dialog with Fade"
	container.add_child(show_dialog_button)
	
	# Create the dialog
	var dialog = preload(GUIPaths.DIALOG_SCENE).instantiate()
	dialog.title = "Fade Dialog Example"
	dialog.message = "This dialog uses fade-in and fade-out animations."
	dialog.use_fade_animations = true
	dialog.fade_in_duration = 0.5
	dialog.fade_out_duration = 0.3
	dialog.add_button("Close")
	add_child(dialog)
	
	# Connect the button to show the dialog
	show_dialog_button.pressed.connect(func(): dialog.show_dialog()) 