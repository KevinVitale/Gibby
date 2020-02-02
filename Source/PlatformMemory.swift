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

import CryptoKit
extension Data {
    @available(OSX 10.15, *)
    public var md5: Data? {
        var md5Hash = Insecure.MD5()
        md5Hash.update(data: Data(self[0..<self.endIndex]))
        return md5Hash
            .finalize()
            .withUnsafeBytes({ unsafeBytes -> Data? in
                guard let baseAddress = unsafeBytes.baseAddress else {
                    return nil
                }
                return Data(bytes: baseAddress, count: Insecure.MD5.byteCount)
            })
    }
}

extension PlatformMemory {
    @available(OSX 10.15, *)
    public var md5: Data? {
        Data(self[0..<self.endIndex]).md5
    }
}
