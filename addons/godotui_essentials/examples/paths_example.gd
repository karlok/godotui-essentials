extends Control

func _ready():
	# Example of creating UI components using GodotUIPaths
	create_components()

func create_components():
	# Create a vertical container for our components
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_CENTER)
	vbox.add_theme_constant_override("separation", 20)
	add_child(vbox)
	
	# Add a title
	var title = Label.new()
	title.text = "GodotUIPaths Example"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 24)
	vbox.add_child(title)
	
	# Add a description
	var description = Label.new()
	description.text = "This example demonstrates creating UI components\nusing the GodotUIPaths singleton."
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(description)
	
	# Create a button using GodotUIPaths
	var button = preload(GodotUIPaths.BUTTON_SCENE).instantiate()
	button.text = "Button created with GodotUIPaths"
	button.pressed.connect(func(): print("Button pressed!"))
	vbox.add_child(button)
	
	# Create a panel using GodotUIPaths
	var panel = preload(GodotUIPaths.PANEL_SCENE).instantiate()
	panel.custom_minimum_size = Vector2(300, 100)
	
	# Add a label to the panel
	var panel_label = Label.new()
	panel_label.text = "Panel created with GodotUIPaths"
	panel_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	panel_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.add_child(panel_label)
	
	vbox.add_child(panel)
	
	# Create a tooltip using GodotUIPaths and attach it to the panel
	var tooltip = preload(GodotUIPaths.TOOLTIP_SCENE).instantiate()
	tooltip.text = "This tooltip was created using GodotUIPaths"
	add_child(tooltip)
	tooltip.attach_to(panel)
	
	# Create a button that shows a dialog
	var dialog_button = preload(GodotUIPaths.BUTTON_SCENE).instantiate()
	dialog_button.text = "Show Dialog"
	dialog_button.pressed.connect(func(): show_dialog())
	vbox.add_child(dialog_button)

func show_dialog():
	# Create a dialog using GodotUIPaths
	var dialog = preload(GodotUIPaths.DIALOG_SCENE).instantiate()
	dialog.title = "Dialog created with GodotUIPaths"
	dialog.message = "This dialog was created using the GodotUIPaths singleton."
	dialog.add_button("Cool!", "ok")
	dialog.add_button("Cancel", "cancel")
	
	# Connect to the button_pressed signal
	dialog.button_pressed.connect(func(button_id):
		print("Dialog button pressed: ", button_id)
	)
	
	add_child(dialog)
	dialog.show_dialog() 