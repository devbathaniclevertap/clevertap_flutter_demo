# Flutter CleverTap Demo

A Flutter application demonstrating CleverTap SDK integration with various engagement features.

## Features

### Native Display

To trigger Native Display:

1. Create a Native Display campaign in CleverTap Dashboard
2. Set up a carousel template with images
3. Add custom key-value pairs if needed
4. Use the following event to trigger:

```dart
CleverTapPlugin.recordEvent("Native Display", {});
```

### App Inbox Message

To trigger App Inbox:

1. Create an App Inbox campaign in CleverTap Dashboard
2. Configure message template and content
3. Initialize inbox in your app:

```dart
CleverTapPlugin.initializeInbox();
```

4. Trigger using:

```dart
CleverTapPlugin.recordEvent("App Inbox Message", {});
```

### In App Message

To trigger In-App Messages:

1. Create an In-App campaign in CleverTap Dashboard
2. Set up trigger rules and targeting
3. Use this event to show the message:

```dart
CleverTapPlugin.recordEvent("In App Message", {});
```

## Setup

1. Add CleverTap credentials in:

   - Android: `android/app/src/main/AndroidManifest.xml`
   - iOS: `ios/Runner/Info.plist`

2. Required dependencies:

```yaml
dependencies:
  clevertap_plugin: ^5.2.0
  carousel_slider: ^4.2.1
```

3. Initialize CleverTap in your app:

```dart
CleverTapPlugin.setDebugLevel(3);
CleverTapPlugin.createNotificationChannel(
  "YourChannel",
  "Channel Name",
  "Channel Description",
  5,
  true
);
```

## Push Notifications

### Android Setup

1. Add Firebase configuration
2. Update AndroidManifest.xml with required permissions
3. Initialize Firebase messaging

### iOS Setup

1. Add notification capabilities in Xcode
2. Configure notification service extension
3. Update Info.plist with required permissions

## Contributing

Feel free to submit issues and enhancement requests.

## License

This project is licensed under the MIT License - see the LICENSE file for details
