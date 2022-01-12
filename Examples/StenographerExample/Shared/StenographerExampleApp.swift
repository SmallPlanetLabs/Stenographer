//
//  StenographerExampleApp.swift
//  Shared
//
//  Created by Ryan Goodlett on 1/12/22.
//

import SwiftUI
import Stenographer
import Pulse
import PulseUI
import Logging

@main
struct StenographerExampleApp: App {

    init() {
        LoggingSystem.bootstrap(PersistentLogHandler.init)
    }

    var body: some Scene {
        WindowGroup {
            MainView()
                .onAppear {
                    let log = Log(category: "⚠️ Test")
                    let world = "world"
                    log.debug("Hello \(world, privacy: .private)!")
                }
        }
    }
}
