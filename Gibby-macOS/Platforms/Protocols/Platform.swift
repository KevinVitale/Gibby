import Foundation

public protocol Platform {
    associatedtype Cartridge: Gibby.Cartridge
    associatedtype AddressSpace: FixedWidthInteger
    
    static var logo: Data { get }
    
    static var headerOffset:   AddressSpace { get }
    static var headerSize:     AddressSpace { get }
}

extension Platform {
    public static func validate(logo: Data) -> Bool {
        return logo == Self.logo
    }
}
