//
//  UnitTestSettings.swift
//  UnitTestSettings
//
//  Created by Prafull Kumar Soni on 12/15/19.
//

import Foundation

import Logging

let env = ProcessInfo.processInfo.environment

public let TEST_INDEX_PREFIX: String = {
    let prefix = env["TEST_INDEX_PREFIX"]
    return prefix ?? "es_test_index"
}()

public let loggerLevel: Logger.Level = {
    let logLevel = env["LOG_LEVEL"]
    if let value = logLevel, let level = Logger.Level(rawValue: value.lowercased()) {
        return level
    } else {
        return .debug
    }
}()

public let logFactory: ((String) -> LogHandler) = { label -> LogHandler in
    var handler = StreamLogHandler.standardOutput(label: label)
    handler.logLevel = loggerLevel
    return handler
}

public let isLoggingConfigured: Bool = {
    LoggingSystem.bootstrap(logFactory)
    return true
}()

public let esConnection: ESConnection = {
    var url = URL(string: "http://localhost:9200")!
    let urlString = env["ES_URL"]
    if let esString = urlString, let esUrl = URL(string: esString) {
        url = esUrl
    }
    let uname = env["ES_UNAME"] ?? "elastic"
    let passwd = env["ES_PASSWD"] ?? "elastic"
    let isProtected = Bool(env["IS_PROTECTED"] ?? "") ?? true
    let isSecure = Bool(env["IS_SECURE"] ?? "") ?? false
    let caCert = env["CA_CERT"]
    let cert = env["SSL_CERT"]
    let privateKey = env["SSL_KEY"]

    return ESConnection(host: url, uname: uname, passwd: passwd, isProtected: isProtected, isSecure: isSecure, certPath: cert, privateKey: privateKey, caCert: caCert)
}()

public struct ESConnection {
    public let host: URL
    public let uname: String
    public let passwd: String
    public let isProtected: Bool
    public let isSecure: Bool
    public let certPath: String?
    public let privateKey: String?
    public let caCert: String?
}

/// Copy of `Logging.StdioOutputStream`
/// [Look here for more details](https://github.com/apple/swift-log/blob/master/Sources/Logging/Logging.swift)
/// A wrapper to facilitate `print`-ing to stderr and stdio that
/// ensures access to the underlying `FILE` is locked to prevent
/// cross-thread interleaving of output.
internal struct StdioOutputStream: TextOutputStream {
    internal let file: UnsafeMutablePointer<FILE>
    internal let flushMode: FlushMode

    internal func write(_ string: String) {
        string.withCString { ptr in
            flockfile(self.file)
            defer {
                funlockfile(self.file)
            }
            _ = fputs(ptr, self.file)
            if case .always = self.flushMode {
                self.flush()
            }
        }
    }

    /// Flush the underlying stream.
    /// This has no effect when using the `.always` flush mode, which is the default
    internal func flush() {
        _ = fflush(file)
    }

    internal static let stderr = StdioOutputStream(file: systemStderr, flushMode: .always)
    internal static let stdout = StdioOutputStream(file: systemStdout, flushMode: .always)

    /// Defines the flushing strategy for the underlying stream.
    internal enum FlushMode {
        case undefined
        case always
    }
}

// Prevent name clashes
#if os(macOS) || os(tvOS) || os(iOS) || os(watchOS)
    let systemStderr = Darwin.stderr
    let systemStdout = Darwin.stdout
#else
    let systemStderr = Glibc.stderr!
    let systemStdout = Glibc.stdout!
#endif

/// Copy of `Logging.StreamLogHandler` with modifications to include label in log output
///
/// [Look here for more details](https://github.com/apple/swift-log/blob/master/Sources/Logging/Logging.swift)
public struct StreamLogHandler: LogHandler {
    /// Factory that makes a `StreamLogHandler` to directs its output to `stdout`
    public static func standardOutput(label: String) -> StreamLogHandler {
        return StreamLogHandler(label: label, stream: StdioOutputStream.stdout)
    }

    /// Factory that makes a `StreamLogHandler` to directs its output to `stderr`
    public static func standardError(label: String) -> StreamLogHandler {
        return StreamLogHandler(label: label, stream: StdioOutputStream.stderr)
    }

    private let stream: TextOutputStream
    private let label: String

    public var logLevel: Logger.Level = .info

    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            prettyMetadata = prettify(metadata)
        }
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return metadata[metadataKey]
        }
        set {
            metadata[metadataKey] = newValue
        }
    }

    // internal for testing only
    internal init(label: String, stream: TextOutputStream) {
        self.label = label
        self.stream = stream
    }

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    file _: String, function _: String, line _: UInt)
    {
        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))

        var stream = self.stream
        stream.write("\(timestamp()) \(level) \(label) :\(prettyMetadata.map { " \($0)" } ?? "") \(message)\n")
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }

    private func timestamp() -> String {
        var buffer = [Int8](repeating: 0, count: 255)
        var timestamp = time(nil)
        let localTime = localtime(&timestamp)
        strftime(&buffer, buffer.count, "%Y-%m-%dT%H:%M:%S%z", localTime)
        return buffer.withUnsafeBufferPointer {
            $0.withMemoryRebound(to: CChar.self) {
                String(cString: $0.baseAddress!)
            }
        }
    }
}
