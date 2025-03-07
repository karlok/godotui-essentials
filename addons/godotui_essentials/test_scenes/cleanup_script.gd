@tool
extends EditorScript

func _run():
	# Get the currently edited scene
	var edited_scene = get_editor_interface().get_edited_scene_root()
	if not edited_scene:
		print("No scene is currently being edited.")
		return
	
	print("Scene name: ", edited_scene.name)
	
	# Find all visible nodes in the scene
	var all_nodes = []
	_find_all_nodes(edited_scene, all_nodes)
	
	print("Found ", all_nodes.size(), " nodes in total")
	
	# Check for orphaned buttons
	var orphaned_buttons = []
	for node in all_nodes:
		if node is Button and node.get_parent() and not _is_in_tree(node, edited_scene):
			orphaned_buttons.append(node)
			print("Found orphaned button: ", node.name, " at position ", node.position)
			
			# Remove the orphaned button
			node.get_parent().remove_child(node)
			node.queue_free()
			print("Removed orphaned button")
	
	if orphaned_buttons.size() == 0:
		print("No orphaned buttons found")
	
	# Save the scene
	get_editor_interface().save_scene()

# Helper function to find all nodes in the scene
func _find_all_nodes(node, result_array):
	result_array.append(node)
	for child in node.get_children():
		_find_all_nodes(child, result_array)

# Helper function to check if a node is properly in the scene tree
func _is_in_tree(node, root):
	var current = node
	while current and current != root:
		current = current.get_parent()
	return current == root 