import Foundation

public struct GameboyClassicCartridge: Cartridge {
    public init(bytes: Data) {
        self.bytes = bytes
    }
    
    public typealias Platform = GameboyClassic
    public typealias Header = Platform.Header
    
    private let bytes: Data
    
    public var header: Header {
        let lowerBound = Int(Platform.headerRange.lowerBound)
        let upperBound = Int(Platform.headerRange.upperBound)
        return Header(bytes: self.bytes[lowerBound..<upperBound])
    }
    
    public var fileExtension: String {
        switch header.colorMode {
        case .unknown:
            return "gb"
        default:
            return "gbc"
        }
    }
    
    public func write(to url: URL, options: Data.WritingOptions = []) throws {
        try self.bytes.write(to: url, options: options)
    }
}
