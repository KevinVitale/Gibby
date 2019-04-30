import Foundation

public protocol Header: PlatformMemory, CustomDebugStringConvertible where Self.Index == Self.Platform.AddressSpace {
    var logo:        Data    { get }
    var title:       String  { get }
    var romBanks:    Int     { get }
    var romBankSize: Int     { get }
    var ramBanks:    Int     { get }
    var ramBankSize: Int     { get }
}

extension Header {
    public var romSize: Int {
        return romBankSize * romBanks
    }
    
    public var ramSize: Int {
        return ramBankSize * ramBanks
    }
}

extension Header {
    public subscript(_ section: Platform.HeaderSection) -> Data  {
        guard self.isEmpty == false else {
            return Data()
        }
        return Data(self[section.range(offsetBy: Int(self.startIndex))])
    }
}

extension Header {
    public var isLogoValid: Bool {
        return Platform.validate(logo: logo)
    }
}

