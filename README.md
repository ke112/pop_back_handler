# pop_back_handler

[![pub package](https://img.shields.io/pub/v/pop_back_handler.svg)](https://pub.dev/packages/pop_back_handler)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A Flutter widget that provides unified handling for back navigation events, integrating `PopScope` with iOS swipe-back gesture detection.

一个 Flutter 小部件，提供统一的返回导航事件处理，并将 `PopScope` 与 iOS 的滑动返回手势检测功能集成。

## Features

- ✅ **Unified API** - Single callback for all back navigation events
- ✅ **Android Support** - Intercepts system back button via `PopScope`
- ✅ **iOS Support** - Detects edge swipe gestures when interception is enabled
- ✅ **RTL Support** - Fully supports both LTR and RTL layout directions
- ✅ **Configurable** - Customizable edge width and swipe threshold
- ✅ **Toggle-able** - Easy to enable/disable interception at runtime

## Problem Solved

When using Flutter's `PopScope` with `canPop: false`, iOS edge swipe gestures don't trigger the `onPopInvokedWithResult` callback. This package solves this by adding a `GestureDetector` layer that detects iOS edge swipes and triggers the same callback.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  pop_back_handler: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Usage

Wrap your page content with `PopBackHandler` and provide an `onPopRequested` callback:

```dart
import 'package:pop_back_handler/pop_back_handler.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopBackHandler(
      canPop: false, // Intercept back events
      onPopRequested: (didPop, result) async {
        // didPop = true: Page was already popped
        // didPop = false: Pop was intercepted, handle it here
        if (!didPop) {
          final shouldPop = await showConfirmDialog(context);
          if (shouldPop && context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('My Page')),
        body: YourContent(),
      ),
    );
  }
}
```

### With AppBar Back Button

Don't forget to also handle the AppBar's back button:

```dart
Future<void> _handleBack() async {
  final shouldPop = await showConfirmDialog(context);
  if (shouldPop && mounted) {
    Navigator.pop(context);
  }
}

PopBackHandler(
  canPop: false,
  onPopRequested: (didPop, result) {
    if (!didPop) {
      _handleBack();
    }
  },
  child: Scaffold(
    appBar: AppBar(
      title: Text('My Page'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: _handleBack,  // Use the same handler
      ),
    ),
    body: YourContent(),
  ),
);
```

### Allow Normal Back Navigation

You can allow normal back navigation by setting `canPop: true`:

```dart
PopBackHandler(
  canPop: true,  // System back gesture works normally (default)
  onPopRequested: (didPop, result) {
    // didPop will be true when page is popped normally
    debugPrint('Page popped: $didPop, result: $result');
  },
  child: YourContent(),
);
```

### Custom Sensitivity

Adjust the edge detection sensitivity:

```dart
PopBackHandler(
  canPop: false,
  edgeWidth: 30.0,        // Edge trigger zone width (default: 20.0)
  swipeThreshold: 80.0,   // Swipe distance to trigger (default: 100.0)
  onPopRequested: (didPop, result) {
    if (!didPop) {
      _handleBack();
    }
  },
  child: YourContent(),
);
```

## API Reference

### PopBackHandler\<T\>

| Property         | Type                                    | Default  | Description                                                              |
| ---------------- | --------------------------------------- | -------- | ------------------------------------------------------------------------ |
| `child`          | `Widget`                                | required | The widget below this widget in the tree                                 |
| `onPopRequested` | `void Function(bool didPop, T? result)` | required | Callback when back navigation is attempted                               |
| `canPop`         | `bool`                                  | `true`   | Whether the route can be popped. Set to `false` to intercept back events |
| `edgeWidth`      | `double`                                | `20.0`   | iOS edge trigger zone width (in logical pixels)                          |
| `swipeThreshold` | `double`                                | `100.0`  | iOS swipe distance threshold to trigger back (in logical pixels)         |

### Callback Parameters

- `didPop`: `true` if the page was already popped, `false` if the pop was intercepted
- `result`: The result value passed when popping (if any)

## Example

See the [example](example/) directory for a complete sample app.

```bash
cd example
flutter run
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

<img src="example/assets/images/Screenshot_0.png" width="300" />

<img src="example/assets/images/Screenshot_1.png" width="300" />
