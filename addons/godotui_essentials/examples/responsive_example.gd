extends Control

func _ready():
	# Create a responsive UI example
	create_responsive_ui()
	
	# Add a label to show the current viewport information
	var info_panel = Panel.new()
	info_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	info_panel.position = Vector2(-250, 10)
	info_panel.size = Vector2(240, 100)
	add_child(info_panel)
	
	var info_container = VBoxContainer.new()
	info_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	info_container.add_theme_constant_override("margin_left", 10)
	info_container.add_theme_constant_override("margin_right", 10)
	info_container.add_theme_constant_override("margin_top", 10)
	info_container.add_theme_constant_override("margin_bottom", 10)
	info_panel.add_child(info_container)
	
	var size_label = Label.new()
	size_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_container.add_child(size_label)
	
	var scale_label = Label.new()
	scale_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_container.add_child(scale_label)
	
	var orientation_label = Label.new()
	orientation_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	info_container.add_child(orientation_label)
	
	# Update the info labels when the window size changes
	get_tree().root.size_changed.connect(func():
		var viewport_size = GUIResponsive.get_viewport_dimensions()
		var scale_factor = GUIResponsive.get_scale_factor()
		var is_portrait = GUIResponsive.is_portrait_mode()
		
		size_label.text = "Viewport: " + str(int(viewport_size.x)) + "×" + str(int(viewport_size.y))
		scale_label.text = "Scale Factor: " + str(scale_factor).substr(0, 4)
		orientation_label.text = "Orientation: " + ("Portrait" if is_portrait else "Landscape")
	)
	
	# Trigger the initial update
	get_tree().root.size_changed.emit()

func create_responsive_ui():
	# Create a responsive container
	var container = GUIResponsive.create_responsive_container(self)
	
	# Create a center container
	var center = CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	container.add_child(center)
	
	# Create a VBox for our content
	var vbox = VBoxContainer.new()
	GUIResponsive.apply_container_settings(vbox)
	center.add_child(vbox)
	
	# Add a title
	var title = Label.new()
	title.text = "Viewport-Based Responsive Design"
	GUIResponsive.apply_font_size(title, "title")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	# Add a description
	var description = Label.new()
	description.text = "This example demonstrates continuous scaling based on viewport dimensions.\nResize the window to see how UI elements adapt smoothly."
	description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	GUIResponsive.apply_font_size(description, "normal")
	vbox.add_child(description)
	
	# Add a separator
	var separator = HSeparator.new()
	vbox.add_child(separator)
	
	# Create a grid for our components
	var grid = GridContainer.new()
	grid.columns = 2
	GUIResponsive.apply_container_settings(grid)
	vbox.add_child(grid)
	
	# Add buttons with different sizes
	add_component_row(grid, "Small Button", "small")
	add_component_row(grid, "Normal Button", "normal")
	add_component_row(grid, "Large Button", "large")
	
	# Add a section to demonstrate orientation changes
	var orientation_section = VBoxContainer.new()
	GUIResponsive.apply_container_settings(orientation_section)
	vbox.add_child(orientation_section)
	
	var orientation_label = Label.new()
	orientation_label.text = "Orientation-Aware Layout"
	orientation_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	GUIResponsive.apply_font_size(orientation_label, "large")
	orientation_section.add_child(orientation_label)
	
	var orientation_description = Label.new()
	orientation_description.text = "This layout will change based on orientation.\nTry resizing the window to be taller than wide."
	orientation_description.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	GUIResponsive.apply_font_size(orientation_description, "normal")
	orientation_section.add_child(orientation_description)
	
	# Create a container that will change based on orientation
	var adaptive_container = HBoxContainer.new()
	GUIResponsive.apply_container_settings(adaptive_container)
	orientation_section.add_child(adaptive_container)
	
	# Add some panels to the adaptive container
	for i in range(4):
		var panel_container = VBoxContainer.new()
		panel_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		adaptive_container.add_child(panel_container)
		
		var panel_label = Label.new()
		panel_label.text = "Panel " + str(i+1)
		panel_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		GUIResponsive.apply_font_size(panel_label, "normal")
		panel_container.add_child(panel_label)
		
		var panel = preload(GUIPaths.PANEL_SCENE).instantiate()
		panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
		panel.custom_minimum_size = Vector2(100, 80)
		panel_container.add_child(panel)
		
		var panel_content = Label.new()
		panel_content.text = str(i+1)
		panel_content.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		panel_content.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		panel_content.set_anchors_preset(Control.PRESET_FULL_RECT)
		GUIResponsive.apply_font_size(panel_content, "title")
		panel.add_child(panel_content)
	
	# Add a section to demonstrate percentage-based sizing
	var percentage_section = VBoxContainer.new()
	GUIResponsive.apply_container_settings(percentage_section)
	vbox.add_child(percentage_section)
	
	var percentage_label = Label.new()
	percentage_label.text = "Percentage-Based Sizing"
	percentage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	GUIResponsive.apply_font_size(percentage_label, "large")
	percentage_section.add_child(percentage_label)
	
	var percentage_container = HBoxContainer.new()
	percentage_container.alignment = BoxContainer.ALIGNMENT_CENTER
	GUIResponsive.apply_container_settings(percentage_container)
	percentage_section.add_child(percentage_container)
	
	# Add panels with percentage-based widths
	var percentages = [25, 50, 75]
	for percent in percentages:
		var panel_container = VBoxContainer.new()
		panel_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		percentage_container.add_child(panel_container)
		
		var panel_label = Label.new()
		panel_label.text = str(percent) + "% Width"
		panel_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		GUIResponsive.apply_font_size(panel_label, "normal")
		panel_container.add_child(panel_label)
		
		var panel = preload(GUIPaths.PANEL_SCENE).instantiate()
		panel.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		panel.custom_minimum_size = Vector2(GUIResponsive.get_width_percent(percent) * 0.8, 80)
		panel_container.add_child(panel)
	
	# Add a button to show a dialog
	var dialog_button = preload(GUIPaths.BUTTON_SCENE).instantiate()
	dialog_button.text = "Show Responsive Dialog"
	dialog_button.pressed.connect(func(): show_responsive_dialog())
	vbox.add_child(dialog_button)

func add_component_row(grid, button_text, size_category):
	# Add a label
	var label = Label.new()
	label.text = button_text + ":"
	GUIResponsive.apply_font_size(label, size_category)
	grid.add_child(label)
	
	# Add a button
	var button = preload(GUIPaths.BUTTON_SCENE).instantiate()
	button.text = button_text
	button.font_size_category = size_category
	
	# Add a tooltip to the button
	var tooltip = preload(GUIPaths.TOOLTIP_SCENE).instantiate()
	tooltip.text = "This is a " + size_category + " tooltip"
	tooltip.font_size_category = size_category
	add_child(tooltip)
	tooltip.attach_to(button)
	
	grid.add_child(button)

func show_responsive_dialog():
	var dialog = preload(GUIPaths.DIALOG_SCENE).instantiate()
	dialog.title = "Viewport-Based Responsive Dialog"
	dialog.message = "This dialog adapts smoothly to the viewport dimensions.\nTry resizing the window to see how it changes continuously."
	dialog.title_size_category = "large"
	dialog.message_size_category = "normal"
	dialog.button_size_category = "normal"
	
	dialog.add_button("OK", "ok")
	dialog.add_button("Cancel", "cancel")
	
	add_child(dialog)
	dialog.show_dialog() 