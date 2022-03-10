//
// Stenographer
//
// Created by Ryan Goodlett on 1/3/22

import OSLog
import Pulse
import Logging

internal typealias OSLogger = os.Logger
internal typealias SwiftLogger = Logging.Logger

internal protocol Loggable {
    var osLogger: os.Logger { get }
    var swiftLogger: SwiftLogger { get }
    var category: String { get }
    func debug(_ message: @autoclosure () -> Message, metadata: @autoclosure () -> Logging.Logger.Metadata?, file: String, function: String, line: UInt)
    func info(_ message: @autoclosure () -> Message, metadata: @autoclosure () -> Logging.Logger.Metadata?, file: String, function: String, line: UInt)
    func notice(_ message: @autoclosure () -> Message, metadata: @autoclosure () -> Logging.Logger.Metadata?, file: String, function: String, line: UInt)
    func error(_ message: @autoclosure () -> Message, metadata: @autoclosure () -> Logging.Logger.Metadata?, file: String, function: String, line: UInt)
    func fault(_ message: @autoclosure () -> Message, metadata: @autoclosure () -> Logging.Logger.Metadata?, file: String, function: String, line: UInt)
}

/// An object for writing interpolated string messages to the unified logging system & Pulse.
public struct Log: Loggable {
    let osLogger: OSLogger
    let swiftLogger: SwiftLogger
    let category: String
    
    /// Creates a custom logger for logging to a specific subsystem and category.
    /// - Parameters:
    ///   - category: A category within the specified subsystem. The system uses this value to categorize and filter related log messages, and to group related logging settings within the subsystem. A category’s logging settings override those of the containing subsystem.
    ///   - level: The log level the message was logged at.
    ///   - subsystem: An identifier string, in reverse DNS notation, that represents the app subsystem that’s logging information, such as *com.your_company.your_subsystem_name*. The universal logging system uses this information to categorize and filter related log messages, and to group related logging settings. **Defaults to the Bundle ID or `UNKNOWN` if Bundle ID cannot be determined** .
    public init(category: String, level: Logging.Logger.Level = .trace, subsystem: String? = nil) {
        self.category = category
        let subsystem = subsystem ?? Bundle.main.bundleIdentifier ?? "UNKNOWN"
        osLogger = OSLogger(subsystem: subsystem, category: category)
        var logger = SwiftLogger(label: category)
        logger.logLevel = level
        self.swiftLogger = logger
    }

    /// Log a message that is useful only during debugging
    /// - Parameters:
    ///    - message: Message to log.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#file`).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    ///
    /// Logged message is not persisted and is the most performant loging level
    public func debug(_ message: @autoclosure () -> Message,
                      metadata: @autoclosure () -> Logging.Logger.Metadata? = nil,
                      file: String = #file,
                      function: String = #function,
                      line: UInt = #line) {
        swiftLogger.debug(.init(stringLiteral: message().description),
                          metadata: metadata(),
                          file: file,
                          function: function,
                          line: line)
        osLogIfAvailable(.debug, message().description)
    }

    /// Log a message that is helpful but not essential for troubleshooting
    /// - Parameters:
    ///    - message: Message to log.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#file`).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    ///
    /// Logged message is persisted only during `log collect`
    public func info(_ message: @autoclosure () -> Message,
                     metadata: @autoclosure () -> Logging.Logger.Metadata? = nil,
                     file: String = #file,
                     function: String = #function,
                     line: UInt = #line) {
        swiftLogger.info(.init(stringLiteral: message().description),
                         metadata: metadata(),
                         file: file,
                         function: function,
                         line: line)
        osLogIfAvailable(.info,  message().description)
    }

    /// Log a message essential for troubleshooting
    /// - Parameters:
    ///    - message: Message to log.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#file`).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    ///
    /// Logged message is persisted up to storage limit
    public func notice(_ message: @autoclosure () -> Message,
                       metadata: @autoclosure () -> Logging.Logger.Metadata? = nil,
                       file: String = #file,
                       function: String = #function,
                       line: UInt = #line) {
        swiftLogger.notice(.init(stringLiteral:  message().description),
                           metadata: metadata(),
                           file: file,
                           function: function,
                           line: line)
        osLogIfAvailable(.default,  message().description)
    }

    /// Log a message representing an error seen during execution
    /// - Parameters:
    ///    - message: Message to log.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#file`).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    ///
    /// Logged message is persisted up to storage limit
    public func error(_ message: @autoclosure () -> Message,
                      metadata: @autoclosure () -> Logging.Logger.Metadata? = nil,
                      file: String = #file,
                      function: String = #function,
                      line: UInt = #line) {
        swiftLogger.error(.init(stringLiteral:  message().description),
                          metadata: metadata(),
                          file: file,
                          function: function,
                          line: line)
        osLogIfAvailable(.error,  message().description)
    }

    /// Log a serious message that will always be logged
    /// - Parameters:
    ///    - message: Message to log.
    ///    - metadata: One-off metadata to attach to this log message.
    ///    - file: The file this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#file`).
    ///    - function: The function this log message originates from (there's usually no need to pass it explicitly as
    ///                it defaults to `#function`).
    ///    - line: The line this log message originates from (there's usually no need to pass it explicitly as it
    ///            defaults to `#line`).
    ///
    /// Logged message is persisted up to storage limit
    public func fault(_ message: @autoclosure () -> Message,
                      metadata: @autoclosure () -> Logging.Logger.Metadata? = nil,
                      file: String = #file,
                      function: String = #function,
                      line: UInt = #line) {
        swiftLogger.critical(.init(stringLiteral:  message().description),
                             metadata: metadata(),
                             file: file,
                             function: function,
                             line: line)
        osLogIfAvailable(.fault,  message().description)
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
