# GodotUI Essentials

A collection of mobile-friendly UI components for Godot 4.3+, designed to make creating beautiful and functional user interfaces easier for mobile or desktop games.

## Features

- **Mobile-Friendly UI Components**: GUIButton, GUIPanel, and GUIDialog support touch input
- **Responsive Design**: Automatically adapt UI elements to different screen sizes and orientations
- **Fade Animations**: Built-in fade in/out animations for smooth transitions
- **Type-On Effect**: Text typing effect for dynamic text displays
- **Customizable Styles**: Easily customize the appearance of all components

## Installation

1. Download the latest release
2. Copy the `addons/godotui_essentials` folder to your Godot project's `addons` folder
3. Enable the plugin in Godot: Project → Project Settings → Plugins → GodotUI Essentials

## Components

### GUIButton

Mobile-friendly button with focus handling, sound support, and fade animations.

### GUIPanel

Customizable panel with borders, shadows, and fade animations.

### GUIDialog

Dialog box with title, message, customizable buttons, and fade animations.

## Utilities

- **GUIResponsive**: Utilities for responsive design
- **GUIFadeAnimation**: Utilities for fade animations
- **GUITypeOnEffect**: Text typing effect

## Test Scenes and Debugging

The addon includes test scenes and debugging tools in the `test_scenes` directory to help you understand how the components work together and diagnose any issues. See the [Test Scenes README](test_scenes/README.md) for more information.

## Documentation

For detailed documentation, see the [DOCUMENTATION.md](DOCUMENTATION.md) file.

## Version History

### v1.0.5 (Current)
- Removed tooltips and hover effects for better mobile support
- Simplified components for touch-based interfaces
- Improved focus handling for mobile devices
- Enhanced responsive design for different screen orientations

### v1.0.4
- Fixed serialization issues with dynamically created nodes
- Added test scenes and debugging tools
- Improved signal connection handling
- Added proper cleanup in notification handlers

### v1.0.3
- Previous release

### v1.0.1
- Initial release

## License

This addon is available under the MIT License. See the LICENSE file for more information. 