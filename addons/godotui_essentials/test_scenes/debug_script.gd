@tool
extends EditorScript

func _run():
	# Get the currently edited scene
	var edited_scene = get_editor_interface().get_edited_scene_root()
	if not edited_scene:
		print("No scene is currently being edited.")
		return
	
	print("Scene name: ", edited_scene.name)
	
	# Find all GUIPanel nodes
	var panels = []
	_find_nodes_of_type(edited_scene, "GUIPanel", panels)
	
	print("Found ", panels.size(), " GUIPanel nodes")
	
	# Examine each panel
	for panel in panels:
		print("Panel name: ", panel.name)
		print("Panel script: ", panel.get_script())
		print("Panel children count: ", panel.get_child_count())
		
		# Print details about each child
		for i in range(panel.get_child_count()):
			var child = panel.get_child(i)
			print("  Child ", i, ": ", child.name, " (", child.get_class(), ")")
			print("  Child script: ", child.get_script())
			
			# If it's a GUIButton, print more details
			if child.get_script() and child.get_script().resource_path.find("gui_button.gd") != -1:
				print("  Button text: ", child.text)
				print("  Button position: ", child.position)
				print("  Button size: ", child.size)
				print("  Button visible: ", child.visible)
	
	# Now let's add a new GUIButton to each panel for testing
	for panel in panels:
		var new_button = Button.new()
		new_button.name = "NewGUIButton"
		new_button.text = "New Button"
		new_button.position = Vector2(50, 50)
		new_button.size = Vector2(100, 50)
		
		# Load the GUIButton script
		var script = load("res://addons/godotui_essentials/scripts/gui_button.gd")
		new_button.set_script(script)
		
		panel.add_child(new_button)
		new_button.owner = edited_scene  # This is crucial for the node to be saved with the scene
		
		print("Added new GUIButton to panel: ", panel.name)
	
	# Save the scene
	get_editor_interface().save_scene()

# Helper function to find nodes of a specific type
func _find_nodes_of_type(node, type_name, result_array):
	if node.get_class() == type_name or (node.get_script() and node.get_script().resource_path.find(type_name.to_lower() + ".gd") != -1):
		result_array.append(node)
	
	for child in node.get_children():
		_find_nodes_of_type(child, type_name, result_array) 