import Foundation

public protocol Platform {
    associatedtype AddressSpace: FixedWidthInteger
    associatedtype HeaderSection: Gibby.HeaderSection where HeaderSection.Platform == Self
    
    static var logo: Data { get }
    static var headerRange: Range<AddressSpace> { get }
}

extension Platform {
    static func validate(logo: Data) -> Bool {
        return logo == Self.logo
    }
}
