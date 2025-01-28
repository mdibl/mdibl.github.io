# Bioinformatics Bit 2: Command Line Fundamentals
> Updated: Jan 28, 2025

## Introduction

The command line interface (CLI) is a text-based way to interact with your computer. While it might seem intimidating at first, it's an essential tool in bioinformatics that offers powerful ways to handle data and automate tasks.

## Getting Started

### Mac/Unix

- Open Terminal (Mac: Press Cmd + Space, type "Terminal")
- Terminal comes pre-installed on all Mac/Unix systems

### Windows
You have several options:

#### WSL (Windows Subsystem for Linux) - RECOMMENDED
   - Provides a full Linux environment on Windows
   - Uses EXACTLY the same commands as Mac/Unix
   - Install through Windows Store (Ubuntu recommended)
   - Most compatible with bioinformatics tools
   
#### Git Bash
   - Download [here](https://git-scm.com/download/win)
   - Provides a Unix-like environment
   - Uses same commands as Mac/Unix
   - Good alternative if you can't install WSL

#### PowerShell via Windows Terminal
   - Install Windows Terminal from Microsoft Store
   - Different command syntax
   - Not recommended for bioinformatics work

## Basic Navigation
Purpose: Moving around your file system

!!! Note ""

    === "Mac/Unix/WSL/Git Bash"

        | Command | Description |
        |---------|-------------|
        | `pwd` | Show current directory |
        | `cd myDir` | Change directory to myDir |
        | `cd ..` | Go up one directory |
        | `ls` | List files and folders |
        | `cd ~` | Go to home directory |

    === "PowerShell"
        | Command  | Description |
        |---------|-------------|
        | `pwd` or `Get-Location` | Show current directory |
        | `ls` or `Get-ChildItem` | List files and folders |
        | `cd myDir` | Change directory to myDir |
        | `cd ..` | Go up one directory |
        | `cd ~` | Go to home directory |

## Working with Files and Directories

Purpose: Creating, moving, and manipulating files

!!! Note ""

    === "Mac/Unix/WSL/Git Bash"

        | Command | Description |
        |---------|-------------|
        | `mkdir my_project` | Create new directory |
        | `touch file.txt` | Create empty file |
        | `cp file.txt backup.txt` | Copy file |
        | `mv file.txt newname.txt` | Rename/move file |
        | `rm file.txt` | Delete file |
        | `rm -r directory` | Delete directory |

    === "PowerShell"
        | Command | Description |
        |---------|-------------|
        | `mkdir my_project` or `New-Item -ItemType Directory -Name my_project` | Create new directory |
        | `New-Item file.txt` | Create empty file |
        | `Copy-Item file.txt backup.txt` | Copy file |
        | `Move-Item file.txt newname.txt` | Rename/move file |
        | `Remove-Item file.txt` | Delete file |
        | `Remove-Item directory -Recurse` | Delete directory |


## Viewing File Contents

Purpose: Reading and examining files

!!! Note ""

    === "Mac/Unix/WSL/Git Bash"

        | Command | Description |
        |---------|-------------|
        | `cat file.txt` | Display entire file |
        | `less file.txt` | View file page by page |
        | `head -n 10 file.txt` | View first 10 lines |
        | `tail -n 10 file.txt` | View last 10 lines |

    === "PowerShell"
        | Command | Description |
        |---------|-------------|
        | `Get-Content file.txt` or `cat file.txt` | Display entire file |
        | `Get-Content file.txt | more` | View file page by page |
        | `Get-Content file.txt -Head 10` | View first 10 lines |
        | `Get-Content file.txt -Tail 10` | View last 10 lines |


## Basic Text Manipulation

Purpose: Finding and filtering content

!!! Note ""

    === "Mac/Unix/WSL/Git Bash"
        | Command | Description |
        |---------|-------------|
        | `grep "sequence" file.txt` | Search for "sequence" in file |
        | `wc -l file.txt` | Count lines in file |
        | `sort file.txt` | Sort file contents |
        | `uniq file.txt` | Show unique lines |

    === "PowerShell"
        | Command | Description |
        |---------|-------------|
        | `Select-String "sequence" file.txt` | Search for "sequence" in file |
        | `(Get-Content file.txt | Measure-Object -Line).Lines` | Count lines in file |
        | `Get-Content file.txt | Sort-Object` | Sort file contents |
        | `Get-Content file.txt | Sort-Object | Get-Unique` | Show unique lines |


## Practical Tips

1. Use Tab for auto-completion (works in all shells)
2. Use up/down arrows to cycle through command history
3. Use ```clear``` (```cls``` in PowerShell) to clear the screen
4. Use ```ctrl + c``` to stop a running command
5. Use ```man``` (Mac/Unix/WSL/Git Bash) or ```Get-Help``` (PowerShell) for documentation

## Common Mistakes to Avoid

1. Mind the case - commands are case-sensitive (except in PowerShell)
2. Watch for spaces in file names (and try to avoid them)
3. Be careful with delete commands
4. Always verify your current directory before operations
