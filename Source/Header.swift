import Foundation

public protocol Header: PlatformMemory, CustomDebugStringConvertible where Self.Index == Self.Platform.AddressSpace {
    var logo:        Data    { get }
    var title:       String  { get }
}

extension Header {
    public var isLogoValid: Bool {
        return Platform.validate(logo: logo)
    }
}

