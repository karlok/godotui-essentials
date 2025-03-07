@tool
extends EditorScript

func _run():
	# Get the editor interface
	var editor_interface = get_editor_interface()
	
	# Create a new scene
	var new_scene = Node2D.new()
	new_scene.name = "AllComponentsTestScene"
	
	# Create a GUIPanel
	var panel = Panel.new()
	panel.name = "GUIPanel"
	panel.position = Vector2(50, 50)
	panel.size = Vector2(500, 400)
	
	# Load the GUIPanel script
	var panel_script = load("res://addons/godotui_essentials/scripts/gui_panel.gd")
	panel.set_script(panel_script)
	
	# Create a stylebox for the panel
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0, 0, 0, 0.3)
	stylebox.corner_radius_top_left = 8
	stylebox.corner_radius_top_right = 8
	stylebox.corner_radius_bottom_right = 8
	stylebox.corner_radius_bottom_left = 8
	panel.add_theme_stylebox_override("panel", stylebox)
	
	# Add the panel to the scene
	new_scene.add_child(panel)
	panel.owner = new_scene
	
	# Create a GUIButton
	var button = Button.new()
	button.name = "GUIButton"
	button.position = Vector2(50, 50)
	button.size = Vector2(120, 40)
	button.text = "Test Button"
	
	# Load the GUIButton script
	var button_script = load("res://addons/godotui_essentials/scripts/gui_button.gd")
	button.set_script(button_script)
	
	# Add the button to the panel
	panel.add_child(button)
	button.owner = new_scene
	
	# Create a GUIDialog
	var dialog = Control.new()
	dialog.name = "GUIDialog"
	dialog.position = Vector2(200, 50)
	dialog.size = Vector2(300, 200)
	
	# Load the GUIDialog script
	var dialog_script = load("res://addons/godotui_essentials/scripts/gui_dialog.gd")
	dialog.set_script(dialog_script)
	dialog.title = "Test Dialog"
	dialog.message = "This is a test dialog to verify serialization."
	dialog.buttons = ["OK", "Cancel"]
	dialog.button_ids = [0, 1]
	
	# Add the dialog to the panel
	panel.add_child(dialog)
	dialog.owner = new_scene
	
	# Save the scene
	var packed_scene = PackedScene.new()
	var result = packed_scene.pack(new_scene)
	if result == OK:
		var error = ResourceSaver.save(packed_scene, "res://scenes/all_components_test_scene.tscn")
		if error == OK:
			print("Successfully saved all_components_test_scene.tscn")
		else:
			print("Error saving scene: ", error)
	else:
		print("Error packing scene: ", result)
	
	# Open the new scene
	editor_interface.open_scene_from_path("res://scenes/all_components_test_scene.tscn")
	
	print("All components test scene created successfully!") 