import Foundation
import Stenographer
import Logging
import os

var greeting = "Hello, playground"
var log = Log(category: "Cats")
log.debug("Meow")

public extension Log {
    static let analytics = Log(category: "📈 analytics")
    static let bootstrap = Log(category: "🥾 bootstrapping")
    static let endpoint = Log(category: "🔪 endpoint")
    static let home = Log(category: "🏡 home")
    static let keychain = Log(category: "🔐 keychain")
    static let lifecycle = Log(category: "🚴‍♀️ lifecycle")
    static let location = Log(category: "📍 location")
    static let onboarding = Log(category: "🏂 onboarding")
    static let user = Log(category: "🙋 user")
    static let notifications = Log(category: "🛎 notifications")
}
Log.analytics.debug("Stats and stuff")
