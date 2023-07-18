<p align="center">
  <a href="https://github.com/pawello2222/WidgetExamples/actions?query=branch%3Amain">
    <img src="https://img.shields.io/github/actions/workflow/status/pawello2222/WidgetExamples/ci.yml?logo=github" alt="Build">
  </a>
  <a href="https://github.com/pawello2222/WidgetExamples">
    <img src="https://img.shields.io/badge/language-swift-orange.svg" alt="Language">
  </a>
  <a href="https://github.com/pawello2222/WidgetExamples/releases">
    <img src="https://img.shields.io/github/v/release/pawello2222/WidgetExamples" alt="Release version">
  </a>
  <a href="https://github.com/pawello2222/WidgetExamples/blob/main/LICENSE.md">
    <img src="https://img.shields.io/github/license/pawello2222/WidgetExamples" alt="License">
  </a>
</p>

# Widget Examples

A demo project showing different types of Widgets created with SwiftUI and WidgetKit.

## Requirements

This project has been updated for iOS 17.

You can always access earlier versions for different deployment targets:
- [v0.6.2](https://github.com/pawello2222/WidgetExamples/releases/tag/0.6.2) (iOS 16.1)
- [v0.6.0](https://github.com/pawello2222/WidgetExamples/releases/tag/0.6.0) (iOS 16.0)
- [v0.5.0](https://github.com/pawello2222/WidgetExamples/releases/tag/0.5.0) (iOS 14)

## Widgets

### [App Group](./Widgets/AppGroupWidget)

Use an App Group to share data between the App and the Widget.

### [Core Data](./Widgets/CoreDataWidget)

Use Core Data to share data between the App and the Widget.

### [Countdown](./Widgets/CountdownWidget)

Display the remaining time in seconds and change color when the end date is approaching.

### [Deep Link](./Widgets/DeepLinkWidget)

Use Deep Links to pass information from the Widget when opening the parent App.

### [Digital Clock](./Widgets/DigitalClockWidget)

Display a digital clock that shows time in various formats.

### [Dynamic Intent](./Widgets/DynamicIntentWidget)

Configure the Widget with data that can be changed dynamically.

### [Environment](./Widgets/EnvironmentWidget)

Customize the Widget view depending on Environment variables.

### [Intent](./Widgets/IntentWidget)

Configure the Widget by changing its background type and color.

### [Interactive](./Widgets/InteractiveWidget)

Interact with elements of the Widget.

### [Lock Screen](./Widgets/LockScreenWidget)

Display the Widget on both the lock screen and the home screen.

### [Network](./Widgets/NetworkWidget)

Load data into the Widget from a network request.

### [Shared View](./Widgets/SharedViewWidget)

Display the Widget view directly in the parent App.

### [SwiftData](./Widgets/SwiftDataWidget)

Use SwiftData to share data between the App and the Widget.

### [URL Image](./Widgets/URLImageWidget)

Display an image downloaded from an external URL and cache it.

## Notes

Some widgets depend on the App Group capability (e.g., [App Group Widget](./Widgets/AppGroupWidget)) or integrate with the main App (e.g., [Shared View Widget](./Widgets/SharedViewWidget)), so it's recommended to download the whole project to keep the configuration intact.

## License

Widget Examples project is available under the MIT license. See the [LICENSE](./LICENSE.md) file for more info.
