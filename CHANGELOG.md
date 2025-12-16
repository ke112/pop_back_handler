# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1]

### Changed

- **BREAKING**: Renamed `enableInterceptBack` to `canPop` (with inverted semantics)
  - Old: `enableInterceptBack: true` = intercept back events
  - New: `canPop: false` = intercept back events
- **BREAKING**: Changed `onPopRequested` callback signature
  - Old: `VoidCallback` (no parameters)
  - New: `void Function(bool didPop, T? result)` with generic type support
- Added generic type parameter `<T>` to `PopBackHandler` for typed results

## [1.0.0]

### Added

- Initial release of `pop_back_handler`
- `PopBackHandler` widget with unified back event handling
- Android back button interception via `PopScope`
- iOS edge swipe gesture detection
- LTR and RTL layout direction support
- Configurable edge width and swipe threshold
