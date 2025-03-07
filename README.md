# GodotUI Essentials

A work-in-progress, simple, lightweight add-on for Godot 4.3+ that provides ready-to-use UI components and placeholder art for 2D game development. (Briefly tested with Godot 4.4, and it seems to work; made some changes to eliminate some warnings, etc. Documentation is updated accordingly.)

***Note:*** I am seeing warnings in the console when adding nodes from this addon. I am still working to address this issue:
```bash
  WARNING: scene/gui/control.cpp:1443 - Nodes with non-equal opposite anchors will have their size overridden after _ready(). 
  WARNING: If you want to set size, change the anchors or consider using set_deferred().
```

## Features

- **Basic UI Components**: Pre-configured buttons, panels, dialogs, menus, and tooltips
- **Placeholder Art**: Simple, clean placeholder graphics for prototyping
- **Viewport-Based Responsive Design**: UI elements that adapt smoothly to any screen size or orientation
- **Fade Animations**: Smooth fade-in and fade-out transitions for all UI components
- **Type-On Text Effects**: Typewriter-style text animations for labels and dialogue
- **Minimal Setup**: Drag-and-drop components with sensible defaults
- **Path Management**: Global singleton for referencing components without hard-coded paths

## Installation

1. Clone the repo, as it is too early for a release :)
3. Copy the `addons/godotui_essentials` folder to your Godot project's `addons` folder
4. Enable the plugin in Godot: Project → Project Settings → Plugins → GodotUI Essentials

## Quick Start

1. After enabling the plugin, you'll find new nodes in the "Add Node" dialog under "GodotUI Essentials"
2. Drag and drop UI components into your scene
3. Customize properties through the Inspector panel
4. Access placeholder art through the FileSystem panel in `addons/godotui_essentials/art`

## Components

### UI Elements
- **GUIButton**: Enhanced buttons with hover effects and sound support
- **GUIPanel**: Configurable panels with various border styles
- **GUIDialog**: Simple dialog boxes with customizable layouts
- **GUITooltip**: Tooltips that appear on hover

### Responsive Design
All components include built-in responsive capabilities that:
- Scale smoothly based on viewport dimensions
- Adapt to different screen orientations
- Support percentage-based sizing
- Automatically adjust layouts for optimal viewing

### Placeholder Art
- Basic shapes (circles, squares, etc.)
- UI frames and backgrounds
- Simple character silhouettes
- Generic icons for common game actions

## Usage Examples

```gdscript
# Example: Creating a dialog programmatically using GUIPaths
var dialog = preload(GUIPaths.DIALOG_SCENE).instantiate()
dialog.title = "Game Over"
dialog.message = "Try again?"
dialog.add_button("Restart", "restart_game")
dialog.add_button("Quit", "quit_game")
add_child(dialog)

# Example: Creating a responsive tooltip
var tooltip = preload(GUIPaths.TOOLTIP_SCENE).instantiate()
tooltip.text = "This tooltip scales with the viewport"
tooltip.use_responsive_sizing = true
tooltip.font_size_category = "normal"
add_child(tooltip)
tooltip.attach_to($MyButton)

# Example: Using fade animations
var button = preload(GUIPaths.BUTTON_SCENE).instantiate()
button.text = "Fade Button"
button.use_fade_animations = true
button.fade_in_duration = 0.5
add_child(button)
button.fade_in()  # Smoothly fade in the button

# Example: Using type-on text effects
var label = Label.new()
label.text = "This text will appear character by character."
add_child(label)

var type_on_effect = GUITypeOnEffect.create_for_label(label)
type_on_effect.typing_speed = 0.05
type_on_effect.play_sound = true
type_on_effect.start_typing()

# Example: Using viewport-based sizing
func _ready():
    # Create a panel that's 50% of viewport width
    var panel = preload(GUIPaths.PANEL_SCENE).instantiate()
    panel.custom_minimum_size.x = GUIResponsive.get_width_percent(50)
    add_child(panel)
    
    # Connect to window resize to update UI
    get_tree().root.size_changed.connect(func():
        # Update panel size when viewport changes
        panel.custom_minimum_size.x = GUIResponsive.get_width_percent(50)
        
        # Adjust layout based on orientation
        if GUIResponsive.is_portrait_mode():
            $MyContainer.vertical = true
        else:
            $MyContainer.vertical = false
    )
```

## Path Management

The add-on includes a global singleton called `GUIPaths` that provides easy access to component paths without hard-coding them:

```gdscript
# Instead of hard-coding paths:
var button = preload("res://addons/godotui_essentials/components/gui_button.tscn").instantiate()

# Use GUIPaths:
var button = preload(GUIPaths.BUTTON_SCENE).instantiate()
```

See the documentation for more details on using the `GUIPaths` singleton.

## Customization

All components can be customized through the Inspector. Common properties include:
- Colors and appearances
- Fonts and text properties
- Margins and padding
- Animation speeds
- Sound effects

## Requirements

- Godot 4.3 or higher

## License

This add-on is available under the MIT License. See the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Support

If you encounter any issues or have questions, please file an issue on the GitHub repository.

---

Made with ♥ for the Godot community 
