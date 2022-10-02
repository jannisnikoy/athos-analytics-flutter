# Athos Analytics
This package lets you integrate Athos Analytics into your Flutter-based project. Find more info about Athos Analytic on https://athos-analytics.io.

## Set up
Before integrating Athos Analytics, sign up for an account and create your new app on the dashboard. You will need the generated API Key to initialize
the library as followed:

```dart
AthosAnalytics.instance.initializeApp(const AthosConfiguration(apiKey: '{YOUR_API_KEY}'));
```

This should be done upon startup. If you're hosting your own API instance, add the `baseUrl` to the AthosConfiguration() constructor to override
which server to connect to.

## Sessions
When initializing the library, a new session is created. The payload for a session includes:

- Device name
- OS name
- OS version
- Locale
- App name
- App bundle identifier
- App version
- App build number
- Debug flag

## Sending events

### Generic events
The default method to send events to Athos Analytics is by using the `logEvent()` method. This takes a required parameter with your event name,
and an optional payload for any custom data you might want to add.

```dart
AthosAnalytics.instance.logEvent('EventName', payload: {'key': 'value'});
```

### Screen views
The `logScreenView()` method can be used to track screen views. Under the hood, this calls logEvent, but it standardizes the event name for screen views.
Additionally, this method takes an optional payload as well.

```dart
AthosAnalytics.instance.logScreenView('MainView');
```

### Button presses
Similar to `logScreenView()`, `logButtonPress()` can be used as a standardized method to track button presses. Payload is available here too.

```dart
AthosAnalytics.instance.logButtonPress('MainView');
```

## User ID
Sessions are not linked together. On creating a session, a prior session ID is used to determine whether a user is new or recurring, but this connection is not stored. If you want to have a persistent user ID between different app sessions, you can use the `setUserId()` method. This method takes a null value if you want to remove the stored userID (for example, when the user logs out).

```dart
AthosAnalytics.instance.setUserId('{YOUR_USER_ID}');
```

## Debug mode
By default, the `X-Athos-Debug-Mode` flag is set when running the app through your IDE. This allows you to filter events between debug and production instances.
Alternatively, you can disable event tracking in debug mode altogether using the following code:

```dart
AthosAnalytics.instance.setLoggingEnabled(!kDebugMode);
```