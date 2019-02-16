import Foundation

public protocol PlatformHeader: PlatformMemory, CustomDebugStringConvertible {
    var entryPoint:         Data    { get set }
    var logo:               Data    { get set }
    var title:              String  { get set }
    var gameCode:           String? { get set }
    var manufacturer:       String  { get set }
    var version:            UInt8   { get set }
    var romSize:            Int     { get     }
    var headerChecksum:
        Platform.AddressSpace       { get }
}

extension PlatformHeader {
    public var debugDescription: String {
        return """
        |-------------------------------------|
        |\t ENTRY POINT: \(entryPoint) (\(entryPoint.map { String($0, radix: 16, uppercase: true) }.joined(separator: " ")))
        |\t  LOGO VALID: \(isLogoValid)
        |\t       TITLE: \(title)
        |\t   GAME CODE: \(gameCode ?? "")
        |\tMANUFACTURER: \(manufacturer)
        |\t     VERSION: \(version)
        |\t    ROM SIZE: \(romSize)
        |\t    RAM SIZE: \(ramSize)
        |\tHDR CHECKSUM: \(headerChecksum)
        |-------------------------------------|
        """
    }
}

extension PlatformHeader {
    public var isLogoValid: Bool {
        return Platform.validate(logo: logo)
    }
}
