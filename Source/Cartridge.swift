import Foundation

public protocol Cartridge: PlatformMemory {
    var fileExtension: String { get }
}

extension Cartridge {
    public init(filePath: String) throws {
        let bytes = try Data(contentsOf: URL(fileURLWithPath: filePath), options: [])
        self.init(bytes: bytes)
    }
    
    public init(url: URL) throws {
        let bytes = try Data(contentsOf: url, options: [])
        self.init(bytes: bytes)
    }
}

extension Cartridge where Platform == GameboyClassic {
    public var fileExtension: String {
        switch header.colorMode {
        case .unknown:
            return "gb"
        default:
            return "gbc"
        }
    }
}

extension Cartridge where Platform == GameboyAdvance {
    public var fileExtension: String {
        return "gba"
    }
}

extension Cartridge {
    public var header: Platform.Header {
        let lowerBound = Self.Index(Platform.headerRange.lowerBound)
        let upperBound = Self.Index(Platform.headerRange.upperBound)
        
        let headerRange = lowerBound..<upperBound
        var headerData  = Data(count: headerRange.count)

        guard self.isEmpty == false else {
            return Platform.Header(bytes: headerData)
        }
        
        headerData = Data(self[headerRange])
        return Platform.Header(bytes: headerData)
    }
}
