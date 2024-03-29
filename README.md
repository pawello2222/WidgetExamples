<p align="center">
  <img src="./.resources/Assets/logo.png" alt="Widget Examples logo" height=150>
</p>
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

<details>
  <summary>
    <b>Table of Contents</b>
  </summary>

  1. [Gallery](#gallery)
  2. [Installation](#installation)
  3. [License](#license)

</details>

## Gallery <a name="gallery"></a>

<table>
  <tr>
    <th align="center" width="25%">
      <a href="./Widgets/AppGroupWidget">App&nbsp;Group</a>
    </th>
    <th align="center" width="25%">
      <a href="./Widgets/CoreDataWidget">Core&nbsp;Data</a>
    </th>
    <th align="center" width="25%">
      <a href="./Widgets/CountdownWidget">Countdown</a>
    </th>
    <th align="center" width="25%">
      <a href="./Widgets/DeepLinkWidget">Deep&nbsp;Link</a>
    </th>
  </tr>
  <tr>
    <td align="center">
      <a href="./Widgets/AppGroupWidget">
        <img src="./.resources/Screenshots/AppGroupWidget.png" alt="App Group Widget">
      </a>
    </td>
    <td align="center">
      <a href="./Widgets/CoreDataWidget">
        <img src="./.resources/Screenshots/CoreDataWidget.png" alt="Core Data Widget">
      </a>
    </td>
    <td align="center">
      <a href="./Widgets/CountdownWidget">
        <img src="./.resources/Screenshots/CountdownWidget.png" alt="Countdown Widget">
      </a>
    </td>
    <td align="center">
      <a href="./Widgets/DeepLinkWidget">
        <img src="./.resources/Screenshots/DeepLinkWidget.png" alt="Deep Link Widget">
      </a>
    </td>
  </tr>
  <tr>
    <th align="center">
      <a href="./Widgets/DigitalClockWidget">Digital&nbsp;Clock</a>
    </th>
    <th align="center">
      <a href="./Widgets/DynamicIntentWidget">Dynamic&nbsp;Intent</a>
    </th>
    <th align="center">
      <a href="./Widgets/EnvironmentWidget">Environment</a>
    </th>
    <th align="center">
      <a href="./Widgets/IntentWidget">Intent</a>
    </th>
  </tr>
  <tr>
    <td align="center">
      <a href="./Widgets/DigitalClockWidget">
        <img src="./.resources/Screenshots/DigitalClockWidget.png" alt="Digital Clock Widget">
      </a>
    </td>
    <td align="center">
      <a href="./Widgets/DynamicIntentWidget">
        <img src="./.resources/Screenshots/DynamicIntentWidget.png" alt="Dynamic Intent Widget">
      </a>
    </td>
    <td align="center">
      <a href="./Widgets/EnvironmentWidget">
        <img src="./.resources/Screenshots/EnvironmentWidget.png" alt="Environment Widget">
      </a>
    </td>
    <td align="center">
      <a href="./Widgets/IntentWidget">
        <img src="./.resources/Screenshots/IntentWidget.png" alt="Intent Widget">
      </a>
    </td>
  </tr>
  <tr>
    <th align="center">
      <a href="./Widgets/InteractiveWidget">Interactive</a>
    </th>
    <th align="center" colspan="2">
      <a href="./Widgets/LiveActivityWidget">Live&nbsp;Activity</a>
    </th>
    <th align="center">
      <a href="./Widgets/LockScreenWidget">Lock&nbsp;Screen</a>
    </th>
  </tr>
  <tr>
    <td align="center">
      <a href="./Widgets/InteractiveWidget">
        <img src="./.resources/Screenshots/InteractiveWidget.png" alt="Interactive Widget">
      </a>
    </td>
    <td align="center" colspan="2">
      <a href="./Widgets/LiveActivityWidget">
        <img src="./.resources/Screenshots/LiveActivityWidget.png" alt="Live Activity Widget">
      </a>
    </td>
    <td align="center">
      <a href="./Widgets/LockScreenWidget">
        <img src="./.resources/Screenshots/LockScreenWidget.png" alt="Lock Screen Widget">
      </a>
    </td>
  </tr>
    <tr>
    <th align="center">
      <a href="./Widgets/NetworkWidget">Network</a>
    </th>
    <th align="center">
      <a href="./Widgets/SharedViewWidget">Shared&nbsp;View</a>
    </th>
    <th align="center">
      <a href="./Widgets/SwiftDataWidget">SwiftData</a>
    </th>
    <th align="center">
      <a href="./Widgets/URLImageWidget">URL&nbsp;Image</a>
    </th>
  </tr>
  <tr>
    <td align="center">
      <a href="./Widgets/NetworkWidget">
        <img src="./.resources/Screenshots/NetworkWidget.png" alt="Network Widget">
      </a>
    </td>
    <td align="center">
      <a href="./Widgets/SharedViewWidget">
        <img src="./.resources/Screenshots/SharedViewWidget.png" alt="Shared View Widget">
      </a>
    </td>
    <td align="center">
      <a href="./Widgets/SwiftDataWidget">
        <img src="./.resources/Screenshots/SwiftDataWidget.png" alt="SwiftData Widget">
      </a>
    </td>
    <td align="center">
      <a href="./Widgets/URLImageWidget">
        <img src="./.resources/Screenshots/URLImageWidget.png" alt="URL Image Widget">
      </a>
    </td>
  </tr>
</table>

## Installation <a name="installation"></a>

It is recommended to download the whole project to keep the configuration intact as some widgets depend on the App Group capability or integrate with the main App.


### Versions

This project requires iOS 17.

You can also download releases for previous deployment targets:
- [v0.6.2](https://github.com/pawello2222/WidgetExamples/releases/tag/0.6.2) (iOS 16.1+)
- [v0.6.0](https://github.com/pawello2222/WidgetExamples/releases/tag/0.6.0) (iOS 16.0+)
- [v0.5.0](https://github.com/pawello2222/WidgetExamples/releases/tag/0.5.0) (iOS 14.0+)

## License <a name="license"></a>

Widget Examples project is available under the MIT license. See the [LICENSE](./LICENSE.md) file for more info.
