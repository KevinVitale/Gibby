import Foundation.NSData

public protocol PlatformMemory: Collection where Self.Element == Data.Element, Self.Index: FixedWidthInteger {
    associatedtype Platform: Gibby.Platform

    init(bytes: Data)
}

extension PlatformMemory {
    public func write(to url: URL, options: Data.WritingOptions = []) throws {
        let bytes = self.startIndex..<self.endIndex
        try Data(self[bytes]).write(to: url, options: options)
    }
}
