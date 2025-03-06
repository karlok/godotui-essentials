# GodotUI Essentials Documentation

## Installation and Setup

### Installation

1. Download the latest release from the [releases page](https://github.com/yourusername/godotui-essentials/releases)
2. Extract the ZIP file
3. Copy the `addons/godotui_essentials` folder to your Godot project's `addons` folder
4. Enable the plugin in Godot: Project → Project Settings → Plugins → GodotUI Essentials

### Version Compatibility

GodotUI Essentials is designed for Godot 4.3+ and takes advantage of the latest features in the Godot engine.

| GodotUI Version | Compatible Godot Versions | Notes |
|-----------------|---------------------------|-------|
| 1.0.1           | 4.3+                     | Initial release |

#### Compatibility Notes:
- This add-on will **not** work with Godot 3.x
- Some features may not work correctly in Godot versions below 4.3
- Future updates will maintain compatibility with Godot 4.3+ while adding support for newer Godot versions

### Integration

Once the plugin is enabled, you can use GodotUI Essentials in your project in several ways:

1. **Using the Node Creation Dialog**:
   - Click the "+" button to add a new node
   - Search for "GUI" to find all GodotUI components (GUIButton, GUIPanel, GUIDialog, GUITooltip)
   - Add the desired component to your scene

2. **Instantiating Components via Code**:
   ```gdscript
   # Using GUIPaths singleton (recommended)
   var button = preload(GUIPaths.BUTTON_SCENE).instantiate()
   button.text = "Click Me"
   add_child(button)
   
   # Direct path (not recommended)
   var panel = preload("res://addons/godotui_essentials/components/gui_panel.tscn").instantiate()
   add_child(panel)
   ```

3. **Accessing Utility Classes**:
   The plugin registers several autoload singletons for convenience:
   - `GUIPaths`: Path references to all components and scripts
   - `GUIResponsive`: Responsive design utilities
   - `GUIFadeAnimation`: Fade animation utilities
   - `GUITypeOnEffect`: Type-on text effect utilities (instantiate as needed)

## Example Scenes

The add-on includes several example scenes that demonstrate key features:

### Responsive Design Example
- **Location**: `res://addons/godotui_essentials/examples/responsive_example.tscn`
- **Features**: Demonstrates how UI elements adapt to different screen sizes
- **Usage**: Open the scene and run it. Resize the window to see how elements adapt.

### Fade Animation Example
- **Location**: `res://addons/godotui_essentials/examples/fade_example.tscn`
- **Features**: Shows fade-in and fade-out animations for various components
- **Usage**: Open the scene and run it. Click buttons to trigger different fade animations.

### Type-On Effect Example
- **Location**: `res://addons/godotui_essentials/examples/type_on_example.tscn`
- **Features**: Demonstrates typewriter-style text animations
- **Usage**: Open the scene and run it. Click buttons to start different typing effects.

To use these examples as learning resources:
1. Open the example scenes in the Godot editor
2. Examine how they're structured
3. Run the scenes to see the features in action
4. Review the attached scripts to understand implementation details

## Components

### GUIButton

An enhanced button with hover effects and sound support.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `hover_sound` | AudioStream | Sound to play when the mouse hovers over the button |
| `click_sound` | AudioStream | Sound to play when the button is clicked |
| `use_sounds` | bool | Whether to use sound effects |
| `use_hover_effect` | bool | Whether to use hover visual effects |
| `hover_tint` | Color | Color tint to apply on hover |
| `hover_scale` | float | Scale factor to apply on hover |
| `transition_duration` | float | Duration of hover transition animations |

#### Methods

| Method | Parameters | Description |
|--------|------------|-------------|
| `set_sounds` | hover: AudioStream, click: AudioStream | Set both hover and click sounds at once |
| `disable_effects` | none | Disable all visual and sound effects |

#### Example

```gdscript
# Create a button programmatically
var button = preload("res://addons/godotui_essentials/components/gui_button.tscn").instantiate()
button.text = "Play Game"
button.hover_tint = Color(1.5, 1.2, 1.2)
button.hover_scale = 1.1
add_child(button)

# Connect to the pressed signal
button.pressed.connect(self._on_play_button_pressed)
```

### GUIPanel

A customizable panel with various border styles and appearance options.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `border_style` | BorderStyle enum | Style of the panel border (NONE, FLAT, BEVELED, ROUNDED) |
| `border_width` | int | Width of the panel border |
| `border_color` | Color | Color of the panel border |
| `background_color` | Color | Background color of the panel |
| `corner_radius` | int | Radius of rounded corners (when using ROUNDED style) |
| `use_shadow` | bool | Whether to display a shadow |
| `shadow_color` | Color | Color of the shadow |
| `shadow_offset` | Vector2 | Offset of the shadow |

#### Methods

| Method | Parameters | Description |
|--------|------------|-------------|
| `set_preset_style` | preset_name: String | Apply a preset style ("default", "flat", "beveled", "rounded_light") |

#### Example

```gdscript
# Create a panel programmatically
var panel = preload("res://addons/godotui_essentials/components/gui_panel.tscn").instantiate()
panel.set_preset_style("rounded_light")
panel.custom_minimum_size = Vector2(300, 200)
add_child(panel)

# Add content to the panel
var label = Label.new()
label.text = "Hello World!"
label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
label.size_flags_vertical = Control.SIZE_EXPAND_FILL
panel.add_child(label)
```

### GUIDialog

A customizable dialog box with title, message, and buttons.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `title` | String | Title of the dialog |
| `message` | String | Main message text |
| `message_alignment` | String enum | Text alignment ("center", "left", "right") |
| `auto_hide` | bool | Whether to hide the dialog when a button is pressed |
| `draggable` | bool | Whether the dialog can be dragged |
| `modal` | bool | Whether the dialog is modal (blocks input to other controls) |
| `use_close_button` | bool | Whether to show a close button in the title bar |
| `close_on_click_outside` | bool | Whether clicking outside the dialog closes it |
| `min_size` | Vector2 | Minimum size of the dialog |
| `title_color` | Color | Color of the title text |
| `message_color` | Color | Color of the message text |

#### Methods

| Method | Parameters | Description |
|--------|------------|-------------|
| `add_button` | text: String, button_id: String = "" | Add a button to the dialog |
| `remove_button` | button_id: String | Remove a button from the dialog |
| `clear_buttons` | none | Remove all buttons from the dialog |
| `show_dialog` | none | Show the dialog (centers it if not already visible) |
| `close` | none | Close the dialog |
| `set_panel_style` | style_name: String | Set the style of the panel |
| `get_button` | button_id: String | Get a button by its ID |
| `create_confirmation` (static) | parent: Node, title: String, message: String, ok_text: String = "OK", cancel_text: String = "Cancel" | Create a simple confirmation dialog |

#### Signals

| Signal | Parameters | Description |
|--------|------------|-------------|
| `button_pressed` | button_id: String | Emitted when a button is pressed |
| `closed` | none | Emitted when the dialog is closed |

#### Example

```gdscript
# Create a dialog programmatically
var dialog = preload("res://addons/godotui_essentials/components/gui_dialog.tscn").instantiate()
dialog.title = "Game Over"
dialog.message = "You scored 1000 points!"
dialog.add_button("Play Again", "play_again")
dialog.add_button("Quit", "quit")
add_child(dialog)
dialog.show_dialog()

# Connect to signals
dialog.button_pressed.connect(func(button_id):
    if button_id == "play_again":
        restart_game()
    elif button_id == "quit":
        quit_game()
)

# Create a confirmation dialog using the static method
var confirm = GUIDialog.create_confirmation(
    self,
    "Confirm Action",
    "Are you sure you want to delete this item?",
    "Yes, Delete",
    "Cancel"
)
confirm.button_pressed.connect(func(button_id):
    if button_id == "ok":
        delete_item()
)
```

### GUITooltip

A customizable tooltip that appears when hovering over a control.

#### Properties

| Property | Type | Description |
|----------|------|-------------|
| `text` | String | Text to display in the tooltip |
| `rich_text` | String | Rich text (BBCode) to display in the tooltip |
| `tooltip_mode` | String enum | Mode of the tooltip ("text", "rich_text") |
| `show_delay` | float | Delay before showing the tooltip (seconds) |
| `hide_delay` | float | Delay before hiding the tooltip (seconds) |
| `follow_mouse` | bool | Whether the tooltip follows the mouse cursor |
| `offset` | Vector2 | Offset from the mouse cursor position |
| `auto_size` | bool | Whether to automatically size the tooltip |
| `min_width` | int | Minimum width of the tooltip |
| `max_width` | int | Maximum width of the tooltip (0 for unlimited) |
| `background_color` | Color | Background color of the tooltip |
| `border_color` | Color | Border color of the tooltip |
| `text_color` | Color | Text color of the tooltip |

#### Methods

| Method | Parameters | Description |
|--------|------------|-------------|
| `attach_to` | target: Control | Attach the tooltip to a control |
| `detach` | none | Detach the tooltip from its target |
| `show_tooltip` | none | Show the tooltip immediately |
| `hide_tooltip` | none | Hide the tooltip immediately |
| `set_style` | bg_color: Color, border_col: Color, txt_color: Color | Set the tooltip style |
| `create_for_control` (static) | parent: Node, target: Control, tooltip_text: String | Create a tooltip and attach it to a control |

#### Example

```gdscript
# Create a tooltip programmatically
var tooltip = preload("res://addons/godotui_essentials/components/gui_tooltip.tscn").instantiate()
tooltip.text = "This is a tooltip"
tooltip.show_delay = 0.3
add_child(tooltip)
tooltip.attach_to($Button)

# Create a rich text tooltip
var rich_tooltip = preload("res://addons/godotui_essentials/components/gui_tooltip.tscn").instantiate()
rich_tooltip.tooltip_mode = "rich_text"
rich_tooltip.rich_text = "[b]Bold Title[/b]\nThis is [color=yellow]rich text[/color] with formatting."
add_child(rich_tooltip)
rich_tooltip.attach_to($Panel)

# Create a tooltip using the static method
var quick_tooltip = GUITooltip.create_for_control(
    self,
    $TextureRect,
    "This is a quick tooltip"
)
```

## Fade Animations

The add-on includes a fade animation system that allows UI elements to smoothly fade in and out. This is implemented through the `GUIFadeAnimation` singleton, which provides utilities for creating fade animations.

### Using Fade Animations

All components in the add-on (GUIButton, GUIPanel, GUIDialog, GUITooltip) have built-in fade animation capabilities. To enable fade animations:

```gdscript
# Enable fade animations on a component
button.use_fade_animations = true

# Customize fade durations
button.fade_in_duration = 0.3
button.fade_out_duration = 0.2

# Set the easing type
button.fade_easing = 2  # 0: Linear, 1: Ease In, 2: Ease Out, 3: Ease In Out
```

### Fade Animation Properties

Each component has the following fade animation properties:

- `use_fade_animations`: Enable/disable fade animations
- `fade_in_duration`: Duration of the fade-in animation in seconds
- `fade_out_duration`: Duration of the fade-out animation in seconds
- `fade_easing`: Easing type for the animation (Linear, Ease In, Ease Out, Ease In Out)

### Fade Animation Methods

Each component provides the following methods for controlling fade animations:

#### GUIButton, GUIPanel, GUITooltip
- `fade_in(duration: float = -1.0, delay: float = 0.0)`: Fade in the component
- `fade_out(duration: float = -1.0, delay: float = 0.0, hide_when_done: bool = true)`: Fade out the component
- `show_with_fade(duration: float = -1.0, delay: float = 0.0)`: Show the component with fade
- `hide_with_fade(duration: float = -1.0, delay: float = 0.0)`: Hide the component with fade

#### GUIDialog
- `fade_in(duration: float = -1.0, delay: float = 0.0)`: Fade in the dialog
- `fade_out(duration: float = -1.0, delay: float = 0.0)`: Fade out the dialog
- `show_dialog()`: Show the dialog with fade if enabled
- `close()`: Close the dialog with fade if enabled

### Using the GUIFadeAnimation Singleton

The `GUIFadeAnimation` singleton provides utilities for creating fade animations on any Control node:

```gdscript
# Fade in a control
GUIFadeAnimation.fade_in(my_control, 0.5, GUIFadeAnimation.EasingType.EASE_OUT, 0.1)

# Fade out a control
GUIFadeAnimation.fade_out(my_control, 0.3, GUIFadeAnimation.EasingType.EASE_IN)

# Create a custom fade-in animation
var tween = GUIFadeAnimation.create_fade_in_tween(my_control, 0.5)
# Add additional animations to the tween
tween.tween_property(my_control, "scale", Vector2(1.1, 1.1), 0.5)

# Create a custom fade-out animation
var tween = GUIFadeAnimation.create_fade_out_tween(my_control, 0.3)
# Add additional animations to the tween
tween.tween_property(my_control, "scale", Vector2(0.9, 0.9), 0.3)
```

### Example

See the `fade_example.tscn` in the examples folder for a complete demonstration of fade animation capabilities.

## Using GUIPaths for References

The add-on includes a global singleton called `GUIPaths` that provides easy access to component paths without hard-coding them. This makes your code more maintainable and less prone to errors when files are moved.

### Accessing Component Scenes

```gdscript
# Instead of hard-coding paths like this:
var button = preload("res://addons/godotui_essentials/components/gui_button.tscn").instantiate()

# Use GUIPaths like this:
var button = preload(GUIPaths.BUTTON_SCENE).instantiate()

# Or use the helper function:
var button = preload(GUIPaths.get_component_scene("Button")).instantiate()
```

### Accessing Component Scripts

```gdscript
# Instead of hard-coding paths like this:
var script = preload("res://addons/godotui_essentials/scripts/gui_button.gd")

# Use GUIPaths like this:
var script = preload(GUIPaths.BUTTON_SCRIPT)

# Or use the helper function:
var script = preload(GUIPaths.get_component_script("Button"))
```

### Accessing Art Assets

```gdscript
# Instead of hard-coding paths like this:
var icon = preload("res://addons/godotui_essentials/art/button_icon.svg")

# Use GUIPaths like this:
var icon = preload(GUIPaths.BUTTON_ICON)

# Or use the helper function:
var icon = preload(GUIPaths.get_component_icon("Button"))
```

### Available Constants

| Constant | Description |
|----------|-------------|
| `BASE_PATH` | Base path to the add-on |
| `COMPONENTS_PATH` | Path to component scenes |
| `SCRIPTS_PATH` | Path to component scripts |
| `ART_PATH` | Path to art assets |
| `EXAMPLES_PATH` | Path to example scenes |
| `BUTTON_SCENE` | Path to GUIButton scene |
| `PANEL_SCENE` | Path to GUIPanel scene |
| `DIALOG_SCENE` | Path to GUIDialog scene |
| `TOOLTIP_SCENE` | Path to GUITooltip scene |
| `BUTTON_SCRIPT` | Path to GUIButton script |
| `PANEL_SCRIPT` | Path to GUIPanel script |
| `DIALOG_SCRIPT` | Path to GUIDialog script |
| `TOOLTIP_SCRIPT` | Path to GUITooltip script |
| `BUTTON_ICON` | Path to button icon |
| `PANEL_ICON` | Path to panel icon |
| `DIALOG_ICON` | Path to dialog icon |
| `TOOLTIP_ICON` | Path to tooltip icon |

### Helper Functions

| Function | Parameters | Description |
|----------|------------|-------------|
| `get_component_scene` | component_name: String | Get the path to a component scene |
| `get_component_script` | component_name: String | Get the path to a component script |
| `get_component_icon` | component_name: String | Get the path to a component icon |

## Responsive Design

The add-on includes a responsive design system that automatically adapts UI elements to different screen sizes and viewport dimensions. This is implemented through the `GUIResponsive` singleton, which provides utilities for creating responsive UIs.

### Viewport-Based Responsive Design

Unlike traditional responsive systems that use fixed breakpoints, GodotUI Essentials uses a continuous scaling approach based on the actual viewport dimensions. This means UI elements will scale smoothly as the viewport changes, rather than jumping between predefined sizes.

The system works by:
1. Using a reference viewport size (1024×600) as a baseline
2. Calculating a scale factor based on the current viewport dimensions
3. Applying this scale factor to font sizes, margins, spacing, and component dimensions
4. Automatically adjusting layouts based on viewport orientation (portrait vs landscape)

### Using Responsive Components

All components in the add-on (GUIButton, GUIPanel, GUIDialog, GUITooltip) have built-in responsive capabilities. To enable responsive sizing:

```gdscript
# Enable responsive sizing on a component
button.use_responsive_sizing = true

# Set the font size category for text elements
button.font_size_category = "large"  # Options: "small", "normal", "large", "title"
```

### Responsive Properties

Each component has specific responsive properties:

#### GUIButton
- `use_responsive_sizing`: Enable/disable responsive sizing
- `font_size_category`: Text size category ("small", "normal", "large")

#### GUIPanel
- `use_responsive_sizing`: Enable/disable responsive sizing

#### GUIDialog
- `use_responsive_sizing`: Enable/disable responsive sizing
- `title_size_category`: Title text size category
- `message_size_category`: Message text size category
- `button_size_category`: Button text size category

#### GUITooltip
- `use_responsive_sizing`: Enable/disable responsive sizing
- `font_size_category`: Text size category

### Using the GUIResponsive Singleton

The `GUIResponsive` singleton provides utilities for creating responsive UIs:

```gdscript
# Get the scale factor based on viewport width
var scale = GUIResponsive.get_scale_factor()

# Get a balanced scale factor considering both width and height
var balanced_scale = GUIResponsive.get_balanced_scale_factor()

# Check if the viewport is in portrait orientation
var is_portrait = GUIResponsive.is_portrait_mode()

# Get font size for a specific category
var font_size = GUIResponsive.get_font_size("normal")

# Get spacing, margin, and padding values
var spacing = GUIResponsive.get_spacing()
var margin = GUIResponsive.get_margin()
var padding = GUIResponsive.get_padding()

# Get minimum size for a component
var button_size = GUIResponsive.get_min_size("button")

# Calculate sizes as percentages of viewport dimensions
var width = GUIResponsive.get_width_percent(50)  # 50% of viewport width
var height = GUIResponsive.get_height_percent(30)  # 30% of viewport height

# Apply responsive settings to UI elements
GUIResponsive.apply_font_size(my_label, "large")
GUIResponsive.apply_button_settings(my_button)
GUIResponsive.apply_container_settings(my_container)
```

### Creating a Responsive Container

You can create a container that automatically updates its children when the viewport changes:

```gdscript
# Create a responsive container
var container = GUIResponsive.create_responsive_container(parent_node)

# Add your UI elements to this container
var my_button = preload(GUIPaths.BUTTON_SCENE).instantiate()
container.add_child(my_button)
```

The responsive container will:
- Automatically update all child components when the viewport size changes
- Adjust layouts based on orientation (e.g., converting horizontal layouts to vertical in portrait mode)
- Ensure components stay within the visible area

### Responding to Viewport Changes

To update your UI when the viewport changes:

```gdscript
# Connect to the window resize signal
get_tree().root.size_changed.connect(func():
    # Update your UI based on the new viewport dimensions
    if GUIResponsive.is_portrait_mode():
        # Configure UI for portrait orientation
        pass
    else:
        # Configure UI for landscape orientation
        pass
        
    # You can also use the scale factor for custom scaling
    var scale = GUIResponsive.get_scale_factor()
    my_custom_element.scale = Vector2(scale, scale)
)
```

### Best Practices for Responsive Design

1. **Use Containers**: Rely on Godot's container nodes (VBoxContainer, HBoxContainer, MarginContainer) with appropriate size flags.

2. **Anchors and Size Flags**: Use anchors and size flags instead of absolute positioning:
   ```gdscript
   # Instead of:
   node.position = Vector2(100, 200)
   
   # Use:
   node.set_anchors_preset(Control.PRESET_CENTER)
   node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
   ```

3. **Percentage-Based Sizing**: Define sizes relative to the viewport:
   ```gdscript
   # Set width to 50% of viewport width
   node.custom_minimum_size.x = GUIResponsive.get_width_percent(50)
   ```

4. **Test on Multiple Resolutions**: Test your UI at various resolutions and orientations to ensure it scales properly.

5. **Consider Device Capabilities**: Remember that mobile devices may need larger touch targets and simpler layouts.

### Example

See the `responsive_example.tscn` in the examples folder for a complete demonstration of responsive design capabilities.

## Placeholder Art

The add-on includes several SVG files that can be used as placeholder art in your game:

### Basic UI Elements

- `button_icon.svg`: Simple button icon for the GUIButton component
- `panel_icon.svg`: Simple panel icon for the GUIPanel component
- `dialog_icon.svg`: Simple dialog icon for the GUIDialog component
- `tooltip_icon.svg`: Simple tooltip icon for the GUITooltip component
- `panel_background.svg`: Panel background with subtle highlights and shadows

### Character Assets

- `character_silhouette.svg`: Simple character silhouette that can be used as a placeholder for player or NPC characters

### Game Icons

The `game_icons.svg` file contains multiple icons that can be used for common game actions. You can use the region property of TextureRect to display specific icons:

| Icon | Region Rect |
|------|-------------|
| Play | Rect2(0, 0, 64, 64) |
| Pause | Rect2(64, 0, 64, 64) |
| Settings | Rect2(128, 0, 64, 64) |
| Exit | Rect2(192, 0, 64, 64) |

#### Example: Using a specific icon from game_icons.svg

```gdscript
var texture_rect = TextureRect.new()
texture_rect.texture = preload("res://addons/godotui_essentials/art/game_icons.svg")
texture_rect.region_enabled = true
texture_rect.region_rect = Rect2(0, 0, 64, 64)  # Play icon
add_child(texture_rect)
```

### Using Placeholder Art

To use these in your game, you can load them as textures:

```gdscript
# Load a texture
var texture = preload("res://addons/godotui_essentials/art/panel_background.svg")
$TextureRect.texture = texture

# Use as a background with tiling
$Background.texture = texture
$Background.stretch_mode = TextureRect.STRETCH_TILE
```

## Type-On Effects

The add-on includes a typewriter-style text animation system that can be applied to any Label or RichTextLabel node. This creates a typing effect where text appears character by character, enhancing the presentation of dialogue, instructions, or any text-based content.

### Using Type-On Effects

The type-on effect can be applied to both regular Labels and RichTextLabels (which support BBCode formatting):

```gdscript
# For a regular Label
var label = Label.new()
label.text = "This text will be typed out character by character."
add_child(label)

# Create and attach the type-on effect
var type_on_effect = GUITypeOnEffect.create_for_label(label)
type_on_effect.typing_speed = 0.05  # seconds per character
type_on_effect.start_typing()

# For a RichTextLabel with formatting
var rich_label = RichTextLabel.new()
rich_label.bbcode_enabled = true
rich_label.text = "[b]Formatted text[/b] with [color=yellow]colors[/color] and [wave]effects[/wave]."
add_child(rich_label)

# Create and attach the type-on effect
var type_on_effect = GUITypeOnEffect.create_for_rich_label(rich_label)
type_on_effect.start_typing()
```

### Type-On Effect Properties

The `GUITypeOnEffect` class provides several properties to customize the typing behavior:

- `typing_speed`: Time in seconds between each character (default: 0.05)
- `punctuation_pause`: Additional pause after punctuation characters (default: 0.2)
- `play_sound`: Whether to play a sound when typing (default: false)
- `typing_sound`: The AudioStream to use for typing sounds
- `sound_frequency`: How often to play the sound (every N characters, default: 3)
- `typing_style`: The style of typing animation:
  - Normal: Consistent typing speed
  - Random Variance: Slight random variations in typing speed
  - Accelerating: Gradually increases in speed
  - Decelerating: Gradually decreases in speed

### Type-On Effect Methods

The `GUITypeOnEffect` class provides the following methods:

- `start_typing(text: String = "")`: Start the typing effect with optional new text
- `stop_typing()`: Stop the typing effect and show the full text
- `skip_to_end()`: Skip to the end of the typing effect
- `is_typing()`: Check if the typing effect is currently active
- `set_typing_speed(speed: float)`: Change the typing speed
- `set_typing_sound(sound: AudioStream)`: Set the typing sound

### Type-On Effect Signals

The `GUITypeOnEffect` class emits the following signals:

- `typing_started`: Emitted when the typing effect starts
- `typing_completed`: Emitted when the typing effect completes
- `character_typed(character, index)`: Emitted when each character is typed

### Example Usage

```gdscript
# Create a dialog with typing effect
var dialog = preload(GUIPaths.DIALOG_SCENE).instantiate()
dialog.title = "Message"
dialog.message = "This important message will be typed out character by character."
add_child(dialog)

# Get the message label from the dialog
var message_label = dialog.get_node("MessageLabel")  # Adjust path as needed

# Create and configure the type-on effect
var type_on_effect = GUITypeOnEffect.create_for_label(message_label)
type_on_effect.typing_speed = 0.08
type_on_effect.play_sound = true
type_on_effect.typing_sound = preload("res://path/to/typing_sound.wav")
type_on_effect.typing_style = GUITypeOnEffect.TYPING_STYLE_RANDOM_VARIANCE

# Connect to signals if needed
type_on_effect.typing_completed.connect(func(): print("Typing completed"))

# Show the dialog and start typing
dialog.show_dialog()
type_on_effect.start_typing()
```

See the example scene `type_on_example.tscn` for a complete demonstration of the type-on effect capabilities.

## Tips and Best Practices

1. **Performance**: The hover effects on GUIButton use Tweens, which are efficient but can add up if you have many buttons. If you're experiencing performance issues, consider disabling hover effects for less important buttons.

2. **Sounds**: When using sound effects, make sure to:
   - Keep sound files small and compressed
   - Use the "UI" audio bus if available
   - Consider disabling sounds on mobile platforms

3. **Customization**: All components are designed to be easily customizable. Don't hesitate to modify the properties to match your game's style.

4. **Extending**: You can extend the provided components to add your own functionality:

```gdscript
extends GUIButton
class_name MyCustomButton

func _ready():
    super._ready()
    # Add your custom initialization here
```

5. **SVG Scaling**: The placeholder art is provided as SVG files, which means they can be scaled to any size without losing quality. This makes them ideal for responsive UIs.

6. **Dialog Management**: When using multiple dialogs, consider creating a dialog manager to handle showing and hiding dialogs, as well as managing dialog stacks for nested dialogs.

7. **Tooltips**: For performance reasons, consider creating tooltips only when needed rather than having many inactive tooltips in your scene.

## Troubleshooting and FAQ

### Common Issues

#### Components Not Appearing in the Add Node Dialog
- **Issue**: After installing the plugin, you don't see GUIButton, GUIPanel, etc. in the Add Node dialog.
- **Solution**: Make sure the plugin is enabled in Project Settings → Plugins. If it's enabled but still not working, try restarting the editor.

#### Path Errors When Using GUIPaths
- **Issue**: You get errors like "Invalid get index 'BUTTON_SCENE' on base 'GDScriptNativeClass'".
- **Solution**: Make sure you're accessing GUIPaths after the plugin is initialized. If you're using it in an autoload script, make sure your autoload has a higher priority than GUIPaths.

#### Responsive Design Not Working
- **Issue**: UI elements don't adapt to different screen sizes.
- **Solution**: Ensure you've set `use_responsive_sizing = true` on your components and that you're connecting to the window's `size_changed` signal to update your layout.

#### Type-On Effect Not Working
- **Issue**: Text appears all at once instead of character by character.
- **Solution**: Make sure you're calling `start_typing()` after adding the label to the scene tree. Also check that the label has text to display.

### Best Practices

1. **Use GUIPaths for References**:
   Always use the GUIPaths singleton to reference components and scripts instead of hard-coding paths.

2. **Responsive Design**:
   Connect to the window's `size_changed` signal to update your UI when the screen size changes.

3. **Fade Animations**:
   For the best performance, avoid having too many fade animations playing simultaneously.

4. **Type-On Effects**:
   Create a new GUITypeOnEffect instance for each text element that needs the effect.

### Getting Help

If you encounter issues not covered in this documentation:
1. Check the [GitHub repository](https://github.com/yourusername/godotui-essentials/issues) for known issues
2. Join our [Discord community](https://discord.gg/yourdiscord) for real-time help
3. Submit a detailed bug report if you've found a new issue 
