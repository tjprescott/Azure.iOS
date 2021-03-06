# Release History

## 1.0.0-beta.5 (2020-11-18)

### New Features
- Added Cocoapods specs for AzureCore, AzureCommunication, AzureCommunicationChat, and AzureCommunicationCalling
  libraries.

### Breaking Changes
- Azure Communication Chat Service
  - The `baseUrl` parameter has been renamed to `endpoint` in the `AzureCommunicationChatClient` initializers.

- Azure Communication Calling Service
  - Swift applications will not see the `ACS` prefix for classes and enums. For example, `ACSCallAgent` is now
    `CallAgent` when the library is imported in a Swift application.
  - Parameter labels are now mandatory for all API calls from Swift applications.
  - Except for the first parameter, parameter labels are now mandatory for all other parameters to delegate methods in
    Swift applications.
  - And exception is now thrown if an application tries to render video/camera twice.

### Key Bug Fixes
- Azure Communication Calling Service
  - Fixed a deadlock when deleting an `ACSCallAgent` object.
  - The `Call.hangup()` method will return only after all necessary events are delivered to the app.
    [#85](https://github.com/Azure/Communication/issues/85)
  - The `Call.hangup()` method now terminates a call if the call is in the `Connecting` or `Ringing` state.
    [#96](https://github.com/Azure/Communication/issues/96)
  - The library was raising a `RemoteVideoStream Removed` event when app stopped rendering a stream. The library now
    also raises a follow-up `RemoteVideoStream Added` event once the stream is ready to be rendered again.
    [#95](https://github.com/Azure/Communication/issues/95)

## 1.0.0-beta.2 (2020-10-05)

Version 1.0.0-beta.2 adds the Azure Communication Services Chat to the SDK.

### Added Libraries

- Azure Communication Services Chat ([AzureCommunicationChat](https://github.com/Azure/azure-sdk-for-ios/tree/master/sdk/communication/AzureCommunicationChat))

## 1.0.0-beta.1 (2020-09-21):

Version 1.0.0-beta.1 is a beta of our efforts in creating a client library that is developer-friendly, idiomatic to
the iOS ecosystem, and as consistent across different languages and platforms as possible. The principles that guide
our efforts can be found in the
[Azure SDK Design Guidelines for iOS](https://azure.github.io/azure-sdk/ios_introduction.html).

### Added Libraries

- Azure SDK for iOS core ([AzureCore](https://github.com/Azure/azure-sdk-for-ios/tree/master/sdk/core/AzureCore))
- Azure Communication Services common ([AzureCommunication](https://github.com/Azure/azure-sdk-for-ios/tree/master/sdk/communication/AzureCommunication))
  - This library is used by other libraries in this SDK, as well as by libraries in the [Azure Communication SDKs](https://github.com/Azure/Communication).
