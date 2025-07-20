# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Podlive is a macOS podcast streaming client written in Objective-C. It connects to live streaming podcasts via Ultraschall/Studio Link On Air, with a Parse-Server backend for metadata, push notifications, and user favorites.

## Development Setup

### Dependencies
- **Carthage**: Used for dependency management
- **Dependencies**: Parse SDK, Bolts, Facebook SDK (via Carthage)

### Build Commands
```bash
cd App
carthage update --no-use-binaries --platform macOS
git submodule init
git submodule update
```

### Project Structure
- **App/Podlive.xcodeproj**: Main Xcode project
- **App/Podlive/**: Source code organized by feature
- **App/Carthage/**: External dependencies
- **App/Submodules/**: Git submodules (libextobjc, configuration)

## Code Architecture

### Key Components
- **Application Layer**: `CCNApplicationDelegate`, `CCNApplicationViewController` - Main app coordination
- **Authentication**: Parse-based user authentication with Facebook SDK integration
- **Channel Management**: `CCNChannelManager`, `CCNUserManager` - Data layer for channels and users
- **Channel Grid**: Collection view-based grid for displaying podcast channels
- **Player**: `CCNPlayer`, `CCNPlayerViewController` - Audio streaming and controls
- **Preferences**: Multi-pane preferences window system
- **Search**: Channel search functionality

### Data Model
- **CCNChannel**: Core podcast channel model with Parse backend
- **Parse Integration**: Backend API for user data, channels, and real-time updates

### Key Dependencies
- **Parse SDK**: Backend communication and data persistence
- **libextobjc**: Weak/strong reference handling in blocks
- **Carthage frameworks**: Bolts, Facebook SDK for authentication

## Coding Conventions

### Objective-C Style (from Developer-Notes.md)
- **Type Inference**: Use `var` and `let` macros instead of explicit types when possible
  ```objc
  let defaults = NSUserDefaults.standardUserDefaults;
  ```
- **Dot Notation**: Always prefer dot notation over bracket notation
- **Indentation**: 4 spaces
- **No Interface Builder**: UI is programmatically created (minimal XIB usage for preferences)

### Prefix and Macros
- **Class Prefix**: `CCN` for all custom classes
- **Logging**: `CCNLog`, `CCNLogInfo`, `CCNLogError` macros (Debug only)
- **Constants**: Use `NSSTRING_CONSTANT` and `NSSTRING_CONTEXT` macros

### Parse Configuration
- Configuration handled through `Parse.plist` and `CCNConstants`
- Test/production server switching via `TESTSERVER` flag
- Real-time notifications and data syncing

## Common Tasks

### Building
- Open `App/Podlive.xcodeproj` in Xcode
- Ensure Carthage dependencies are up to date
- Build for macOS target

### Adding Features
- Follow MVC pattern with manager classes for data coordination
- Use Parse SDK for backend communication
- Apply consistent naming with `CCN` prefix
- Follow dot notation and type inference conventions

### Dependencies
- Carthage for external frameworks
- Git submodules for internal utilities (libextobjc)
- Parse SDK handles most backend operations