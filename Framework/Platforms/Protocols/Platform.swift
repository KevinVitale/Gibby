import Foundation

public protocol Platform {
    associatedtype AddressSpace: FixedWidthInteger
    
    static var logo: Data { get }
    static var headerRange: Range<AddressSpace> { get }
}

extension Platform {
    public static func validate(logo: Data) -> Bool {
        return logo == Self.logo
    }
}
