//
// Stenographer
//
// Created by Ryan Goodlett on 1/3/22

import OSLog
import Pulse
import Logging

public typealias OSLogger = os.Logger
public typealias SwiftLogger = Logging.Logger

public protocol Loggable {
    var osLogger: os.Logger { get }
    var swiftLogger: SwiftLogger { get }
    var category: String { get }
    func debug(_ message: String)
    func info(_ message: String)
    func notice(_ message: String)
    func error(_ message: String)
    func fault(_ message: String)
}

public struct Log: Loggable {
    public let osLogger: OSLogger
    public let swiftLogger: SwiftLogger
    public let category: String

    public init(category: String, level: Logging.Logger.Level = .trace, subsystem: String? = nil) {
        self.category = category
        let subsystem = subsystem ?? Bundle.main.bundleIdentifier ?? "UNKNOWN"
        osLogger = OSLogger(subsystem: subsystem, category: category)
        var logger = SwiftLogger(label: category)
        logger.logLevel = level
        self.swiftLogger = logger
    }
}

public extension Loggable {

    /// Log a message that is useful only during debugging
    /// - Parameter message: message to log
    ///
    /// Logged message is not persisted and is the most performant loging level
    func debug(_ message: String) {
        swiftLogger.debug(.init(stringLiteral: message))
        osLogIfAvailable(.debug, message)
    }

    /// Log a message that is helpful but not essential for troubleshooting
    /// - Parameter message: message to log
    ///
    /// Logged message is persisted only during `log collect`
    func info(_ message: String) {
        swiftLogger.info(.init(stringLiteral: message))
        osLogIfAvailable(.info, message)
    }

    /// Log a message essential for troubleshooting
    /// - Parameter message: message to log
    ///
    /// Logged message is persisted up to storage limit
    func notice(_ message: String) {
        swiftLogger.notice(.init(stringLiteral: message))
        osLogIfAvailable(.default, message)
    }

    /// Log a message representing an error seen during execution
    /// - Parameter message: message to log
    ///
    /// Logged message is persisted up to storage limit
    func error(_ message: String) {
        swiftLogger.error(.init(stringLiteral: message))
        osLogIfAvailable(.error, message)
    }

    /// Log a serious message that will always be logged
    /// - Parameter message: message to log
    ///
    /// Logged message is persisted up to storage limit
    func fault(_ message: String) {
        swiftLogger.critical(.init(stringLiteral: message))
        osLogIfAvailable(.fault, message)
    }

    private func osLogIfAvailable(_ type: OSLogType, _ message: String) {
        if #available(iOS 14.0, *) {
            switch type {
            case .debug:
                osLogger.debug("\(message)")
            case .info:
                osLogger.info("\(message)")
            case .error:
                osLogger.error("\(message)")
            case .fault:
                osLogger.fault("\(message)")
            default:
                osLogger.debug("\(message)")
            }
        }
    }
}
