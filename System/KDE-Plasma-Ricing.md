# KDE Plasma Ricing Configuration

## Color Scheme (Gruvbox Dark)
- **Wallpaper:** gruvbox-dark.jpg
- **Color Scheme:** Gruvbox Dark
  - Background: #282828
  - Foreground: #ebdbb2
  - Cursor: #fb4934
  - Selection: #504945

## Widget Configuration
### Panel (Bottom)
- Widgets in order:
  1. Application Menu
  2. Task Manager
  3. Separator
  4. System Tray
  5. Clock
  6. Network Management
  7. Audio Volume
  8. Battery
  9. Power Off

### Remove/unused widgets
- Remove: Digital Clock (integrated in Clock widget)
- Remove: Removable Media
- Remove: Keyboard Layout (if using default)

## Window Rules
- **Terminal:** floating by default, border size 2
- **Browser:** tiled on Desktop 2
- **IDE (code):** fullscreen on Desktop 3
- **File Manager:** tiled on Desktop 4

## Performance
- Compositor: OpenGL2 (if GPU supports)
- Reduce blur: Disable "Shadows" and "Animations" for lower GPU usage
- Frame rate limit: 60 FPS

## Startup Applications
- kitty (terminal)
- firefox (browser)
- code (IDE)
- thunar (file manager)
- discord (chat)
- spotify (music)