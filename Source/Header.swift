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

public enum HeaderError<Header: Gibby.Header>: Error {
    case invalid(Header)
}

extension Result where Success: Gibby.Header, Failure == Swift.Error {
    public func checkHeader() -> Result<Success,Failure> {
        flatMap { header in
            guard header.isLogoValid else {
                return .failure(HeaderError.invalid(header))
            }
            return .success(header)
        }
    }
}

extension Result where Success: Gibby.Cartridge, Failure == Swift.Error {
    public func checkHeader() -> Result<Success,Failure> {
        flatMap { cartridge in
            print(cartridge.header)
            guard cartridge.header.isLogoValid else {
                return .failure(HeaderError.invalid(cartridge.header))
            }
            return .success(cartridge)
        }
    }
}
