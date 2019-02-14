import Foundation

public protocol Platform {
    associatedtype Cartridge
    associatedtype AddressSpace: FixedWidthInteger
    
    static var logo: Data { get }
}

extension Platform {
    public static func validate(logo: Data) -> Bool {
        return logo == Self.logo
    }
}
