# VSCode Performance Guide

## Overview
Optimization guide for Visual Studio Code (VSCodium) on Linux.

## Startup Optimization

### Disable Extensions
```bash
# Start without extensions
code --disable-extensions

# Disable specific extension
code --disable-extension extension.id
```

### Settings to Improve Startup
```json
{
  "workbench.startupEditor": "welcomePage",
  "editor.cursorBlinking": "smooth",
  "editor.mouseWheelZoom": false,
  "window.restoreFullscreen": false
}
```

## Editor Performance

### Disable Heavy Features
```json
{
  "editor.minimap.enabled": false,
  "editor.renderWhitespace": "none",
  "editor.guides.bracketPairs": false,
  "editor.bracketPairColorization.enabled": false,
  "editor.inlineSuggest.enabled": false
}
```

### Font Optimization
```json
{
  "editor.fontLigatures": false,
  "editor.fontSize": 14
}
```

## Telemetry & Background Tasks

### Disable Telemetry
```json
{
  "telemetry.telemetryLevel": "off",
  "update.showReleaseNotes": false
}
```

### Reduce Background Work
```json
{
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "workbench.activityBar.visible": false
}
```

## Extensions Recommendations

### Lightweight Alternatives
- ESLint (heavy) -> Consider disable on large projects
- Prettier (heavy) -> Disable if not needed
- GitLens (very heavy) -> Disable on large repos

### Recommended Light Extensions
```bash
# Install
code --install-extension ms-python.python
code --install-extension golang.go
```

## Large File Handling

### Exclude Large Folders
```json
{
  "files.exclude": {
    "**/.git": true,
    "**/node_modules": true,
    "**/dist": true,
    "**/build": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/dist": true
  }
}
```

### Language Server Optimization
```json
{
  "python.analysis.autoSearchPaths": false,
  "python.analysis.diagnosticMode": "openFilesOnly",
  "typescript.preferences.includePackageJsonAutoImport": "off"
}
```

## Memory Management

### Limit Resource Usage
```json
{
  "editor.inlayHints.maxLength": 50,
  "remote.SSH.showLoginTerminal": true
}
```

### Disable Unused Features
```json
{
  "notebook.cellOutputScrollLimit": 10,
  "notebook.diff.enablePreview": false
}
```

## Terminal Performance

### Terminal Settings
```json
{
  "terminal.integrated.fontSize": 12,
  "terminal.integrated.scrollback": 1000,
  "terminal.integrated.cursorBlinking": true
}
```

## Tags
#vscode #vscodium #performance #optimization #editor
