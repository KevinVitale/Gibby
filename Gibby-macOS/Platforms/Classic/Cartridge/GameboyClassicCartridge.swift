import Foundation

public struct GameboyClassicCartridge: Cartridge {
    public init(bytes: Data) {
        self.bytes = bytes
    }
    
    public typealias Platform = GameboyClassic
    public typealias Header = Platform.Header
    
    private let bytes: Data
    
    public var header: Header {
        return Header(bytes: self.bytes[Platform.headerRange])
    }
    
}
