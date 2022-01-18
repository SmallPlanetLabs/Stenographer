/*
 MIT License

 Copyright (c) 2021 Shaps Benkau

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation
import CoreGraphics

public struct Message: ExpressibleByStringInterpolation, ExpressibleByStringLiteral, CustomStringConvertible {
    public var interpolation: LogInterpolation

    public init(stringLiteral value: String) {
        interpolation = LogInterpolation()
        interpolation.appendLiteral(value)
    }

    public init(stringInterpolation: LogInterpolation) {
        interpolation = stringInterpolation
    }

    public var description: String {
        var message = ""

        for value in interpolation.storage {
            switch value {
            case let .literal(value):
                message.append(value)
            case let .bool(value, format, privacy):
                switch format {
                case .answer:
                    message.append(privacy.value(for: value() ? "yes" : "no"))
                case .truth:
                    message.append(privacy.value(for: value() ? "true" : "false"))
                }
            case let .convertible(value, _, privacy):
                message.append(privacy.value(for: value().description))
            case let .double(value, format, _, privacy):
                switch format.format {
                case let .fixed(precision, explicitPositiveSign):
                    let value = value()
                    let string = String(format: "\(explicitPositiveSign ? "+" : "")%.0\(precision())f", value)
                    message.append(privacy.value(for: string))
                }
            case let .float(value, format, _, privacy):
                switch format.format {
                case let .fixed(precision, explicitPositiveSign):
                    let value = value()
                    let string = String(format: "\(explicitPositiveSign ? "+" : "")%.0\(precision())f", value)
                    message.append(privacy.value(for: string))
                }
            case let .cgfloat(value, format, _, privacy):
                switch format.format {
                case let .fixed(precision, explicitPositiveSign):
                    let value = value()
                    let string = String(format: "\(explicitPositiveSign ? "+" : "")%.0\(precision())f", value)
                    message.append(privacy.value(for: string))
                }
            case let .signedInt(value, format, _, privacy):
                switch format.format {
                case let .decimal(minDigits, explicitPositiveSign):
                    let value = value()
                    let string = String(format: "\(explicitPositiveSign ? "+" : "")%0\(minDigits())ld", value)
                    message.append(privacy.value(for: string))
                }
            case let .unsignedInt(value, format, _, privacy):
                switch format.format {
                case let .decimal(minDigits, explicitPositiveSign):
                    let value = String(format: "\(explicitPositiveSign ? "+" : "")%0\(minDigits())lu", value())
                    message.append(privacy.value(for: value))
                }
            case let .meta(value, _, privacy):
                message.append(privacy.value(for: String(describing: value())))
            case let .object(value, privacy):
                message.append(privacy.value(for: value()))
            case let .string(value, _, privacy):
                message.append(privacy.value(for: value()))
            }
        }

        return message
    }

}
