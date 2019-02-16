import Foundation

public protocol PlatformHeader: PlatformMemory {
    var entryPoint:         Data    { get set }
    var logo:               Data    { get set }
    var title:              String  { get set }
    var gameCode:           String? { get set }
    var manufacturer:       String  { get set }
    var version:            UInt8   { get set }
    var romSize:            Int     { get set }
    var ramSize:            Int     { get set }
    var headerChecksum:
        Platform.AddressSpace       { get }
}

extension PlatformHeader {
    public var isLogoValid: Bool {
        return Platform.validate(logo: logo)
    }
}
