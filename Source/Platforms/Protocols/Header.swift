import Foundation

public protocol Header: PlatformMemory, CustomDebugStringConvertible {
    associatedtype Section: HeaderSection where Section.RawValue == Self.Platform.AddressSpace

    var entryPoint:         Data    { get }
    var logo:               Data    { get }
    var title:              String  { get }
    var gameCode:           String? { get }
    var manufacturer:       String  { get }
    var version:            UInt8   { get }
    var romSize:            Int     { get }
    var romBanks:           Int     { get }
    var ramBankSize:        Int     { get }
    var ramBanks:           Int     { get }
    var headerChecksum:     UInt8   { get }
}

extension Header {
    public var ramSize: Int {
        return ramBankSize * ramBanks
    }
}

extension Header where Self.Index == Platform.AddressSpace {
    public subscript(_ section: Section) -> Data {
        return Data(self[section.range(offsetBy: Int(self.startIndex))])
    }
}

extension Header {
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

extension Header {
    public var isLogoValid: Bool {
        return Platform.validate(logo: logo)
    }
}
