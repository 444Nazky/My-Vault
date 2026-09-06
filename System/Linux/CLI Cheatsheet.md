# Linux CLI Cheatsheet

Quick reference for common Linux command-line operations.

## Navigation

### Basic Movement
| Command | Description |
|---------|-------------|
| `pwd` | Print working directory |
| `cd <dir>` | Change directory |
| `cd ~` or `cd` | Go to home |
| `cd ..` | Go to parent |
| `cd -` | Go to previous |

### File Listing
| Command | Description |
|---------|-------------|
| `ls` | List files |
| `ls -la` | List with details |
| `ls -lh` | Human-readable sizes |
| `ls -lt` | Sort by time |
| `ls -S` | Sort by size |

## Files

### View Files
| Command | Description |
|---------|-------------|
| `cat <file>` | View entire file |
| `less <file>` | View with scrolling |
| `head <file>` | View first lines |
| `tail <file>` | View last lines |
| `tail -f` | Follow file changes |

### File Operations
| Command | Description |
|---------|-------------|
| `cp <src> <dest>` | Copy file |
| `mv <src> <dest>` | Move/rename |
| `rm <file>` | Delete file |
| `mkdir <dir>` | Create directory |
| `rmdir <dir>` | Remove empty dir |

### Search Files
| Command | Description |
|---------|-------------|
| `find <path> -name "<pattern>"` | Find by name |
| `find . -type f -name "*.md"` | Find all .md files |
| `which <cmd>` | Find command path |
| `whereis <cmd>` | Find binary/source |

## Text Processing

### Search in Files
| Command | Description |
|---------|-------------|
| `grep "<text>" <file>` | Search in file |
| `grep -r "<text>" <dir>` | Recursive search |
| `grep -i "<text>"` | Case insensitive |
| `grep -n "<text>"` | Show line numbers |

### Modify Text
| Command | Description |
|---------|-------------|
| `sed 's/old/new/g'` | Replace text |
| `awk '{print $1}'` | Print first column |
| `sort <file>` | Sort lines |
| `uniq <file>` | Remove duplicates |

## System Info

### Hardware
| Command | Description |
|---------|-------------|
| `lspci` | List PCI devices |
| `lsusb` | List USB devices |
| `free -h` | Memory usage |
| `df -h` | Disk space |
| `top` or `htop` | Process monitor |

### System
| Command | Description |
|---------|-------------|
| `uname -a` | System information |
| `uptime` | System uptime |
| `whoami` | Current user |
| `hostname` | Hostname |

## Package Management (Arch)

### Pacman
| Command | Description |
|---------|-------------|
| `pacman -S <pkg>` | Install package |
| `pacman -R <pkg>` | Remove package |
| `pacman -Ss <text>` | Search packages |
| `pacman -Syu` | Update all |
| `pacman -Q` | List installed |

### AUR (yay/paru)
| Command | Description |
|---------|-------------|
| `yay -S <pkg>` | Install AUR package |
| `yay -Ss <text>` | Search AUR |

## Permissions

| Command | Description |
|---------|-------------|
| `chmod +x <file>` | Make executable |
| `chmod 755 <file>` | Set permissions |
| `chown user:group <file>` | Change owner |

## Processes

| Command | Description |
|---------|-------------|
| `ps aux` | List all processes |
| `kill <pid>` | Kill process |
| `killall <name>` | Kill by name |
| `pkill <pattern>` | Kill by pattern |

## Networking

| Command | Description |
|---------|-------------|
| `ip addr` | Show IP addresses |
| `ping <host>` | Test connectivity |
| `curl <url>` | Fetch URL |
| `wget <url>` | Download file |

## Useful Shortcuts

### Bash Shortcuts
| Shortcut | Description |
|----------|-------------|
| `Ctrl+C` | Cancel current |
| `Ctrl+Z` | Suspend to background |
| `Ctrl+D` | Exit shell |
| `Ctrl+L` | Clear screen |
| `Ctrl+A` | Start of line |
| `Ctrl+E` | End of line |

### History
| Shortcut | Description |
|----------|-------------|
| `!!` | Last command |
| `!$` | Last argument |
| `Ctrl+R` | Search history |
| `history` | Show history |

## Environment

### Variables
| Command | Description |
|---------|-------------|
| `echo $VAR` | Show variable |
| `export VAR=value` | Set variable |
| `env` | Show all vars |
| `printenv` | Print env vars |

### Paths
| Command | Description |
|---------|-------------|
| `$PATH` | Path variable |
| `which <cmd>` | Find command |
| `type <cmd>` | Command type |

## Pipes and Redirects

| Syntax | Description |
|--------|-------------|
| `cmd1 \| cmd2` | Pipe output |
| `cmd > file` | Redirect output |
| `cmd >> file` | Append output |
| `cmd 2> file` | Redirect errors |

## Archive Commands

### tar
| Command | Description |
|---------|-------------|
| `tar -cvf archive.tar files` | Create |
| `tar -xvf archive.tar` | Extract |
| `tar -czvf archive.tar.gz` | Create gzip |
| `tar -xzvf archive.tar.gz` | Extract gzip |

---

Tags: #linux #cli #cheatsheet #commands
