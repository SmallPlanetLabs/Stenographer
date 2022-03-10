# Stenographer

## A Logging Utility

Note this is prerelease software subject to robust changes.

### Background

The goal of this package is to provide an easy to use and universal method to log information to the Console via OSLog and using SwiftLog via Pulse.

### Installation

Add Stenographer to your project through Xcode by adding a project with the repository's url.

### Usage

#### Adding Pulse UI

In order to use the prebuilt Pulse Logging view there are 2 steps.

1. Import Pulse UI by adding the following to the `View` that will display the Pulse UI.

```swift
import PulseUI
```

2. Add the `MainView` to your `View`. This can be done however you prefer. For this example we will use a `NavigationLink`.

```swift
NavigationLink("Logs", destination: MainView())
```

#### Adding Custom Log Categories

Adding custom log categories is easy and can be managed via an extension to `Logging.Logger`.

1. Create a `.swift` file to handle your extension code.

2. Import Stenographer and Logging by adding the following to your extension file.

```swift
import Stenographer
import Logging
```

3. Extend `Logging.Logger`.

```swift
extension Logging.Logger {
	// This is were your category code will go
}
```

4. Add your custom categories inside your extension.

```swift
extension Logging.Logger {
	static let analytics = Log(category: "📈 analytics")
	static let bootstrap = Log(category: "🥾 bootstrapping")
	static let keychain = Log(category: "🔐 keychain")
	static let lifecycle = Log(category: "🚴‍♀️ lifecycle")
}
```

#### Logging with your custom categories.

1. Import `Logging` to the file where you want to log.

```swift
import Logging
```

2. Then log with the according log level.

```swift
Logger.bootstrap.info("App initialized")
Logger.analytics.error("Analytics server returned error \(error)")
// etc
```

## License

Stenographer is free software distributed under the terms of the MIT license, reproduced below. Stenographer may be used for any purpose, including commercial purposes, at absolutely no cost. No paperwork, no royalties, no GNU-like "copyleft" restrictions. Just download and enjoy.

Copyright (c) 2022 [Small Planet Digital, LLC](http://smallplanet.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## About Small Planet

Small Planet is a mobile agency in Brooklyn, NY that creates lovely experiences for smartphones and tablets. Stenographer has made our lives a lot easier and we hope it does the same for you. You can find us at [smallplanet.com](http://smallplanet.com).
