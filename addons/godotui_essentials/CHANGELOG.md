# Changelog

All notable changes to the GodotUI Essentials addon will be documented in this file.

## [1.0.4] - 2023-03-07

### Fixed
- **Critical Bug Fix**: Fixed serialization issues with dynamically created nodes
  - Added proper owner assignment for all dynamically created child nodes
  - Fixed issue where GUIButton would disappear from scene hierarchy after reopening the project
  - Ensured all components properly save their children when the scene is saved

### Added
- **Test Scenes Directory**: Added a new `test_scenes` directory with tools for testing and debugging
  - `test_all_components.gd`: Creates a test scene with all components
  - `debug_script.gd`: Helps diagnose issues with component hierarchies
  - `cleanup_script.gd`: Identifies and removes orphaned nodes
  - Added documentation for test scenes

### Improved
- **Signal Handling**: Added checks to prevent connecting signals multiple times
- **Resource Management**: Added proper cleanup in notification handlers
- **Singleton References**: Updated all references to use the correct singleton names
- **Documentation**: Updated documentation to explain serialization issues and how to avoid them

## [1.0.3] - 2023-03-01

### Changes
- Various improvements and bug fixes

## [1.0.1] - 2023-02-15

### Initial Release
- GUIButton component with hover effects, sound support, and fade animations
- GUIPanel component with customizable borders, shadows, and fade animations
- GUIDialog component with title, message, buttons, and fade animations
- GUITooltip component with text, rich text support, and fade animations
- Responsive design utilities
- Fade animation utilities
- Type-on effect for text
- Example scenes demonstrating component usage 