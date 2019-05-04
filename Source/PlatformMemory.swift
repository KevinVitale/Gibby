import Foundation.NSData

public protocol PlatformMemory: Collection where Self.Element == Data.Element, Self.Index: FixedWidthInteger {
    associatedtype Platform: Gibby.Platform

    init(bytes: Data)
}

extension PlatformMemory {
    fileprivate func contains(_ range: Range<Self.Index>) -> Bool {
        return (self.startIndex..<self.endIndex).overlaps(range)
    }
}

extension PlatformMemory where Self: Header, Self.Platform == GameboyClassic {
    subscript(_ section: GameboyClassicHeaderSection) -> Data {
        let range = section.range(offsetBy: Int(self.startIndex))
        assert(self.contains(range))
        return Data(self[range])
    }
}

extension PlatformMemory where Self: Header, Self.Platform == GameboyAdvance {
    subscript(_ section: GameboyAdvanceHeaderSection) -> Data {
        let range = section.range(offsetBy: Int(self.startIndex))
        assert(self.contains(range))
        return Data(self[range])
    }
}

extension PlatformMemory {
    public func write(to url: URL, options: Data.WritingOptions = []) throws {
        let bytes = self.startIndex..<self.endIndex
        try Data(self[bytes]).write(to: url, options: options)
    }
}
