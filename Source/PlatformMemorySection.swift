import Foundation

protocol PlatformMemorySection: RawRepresentable where Self.RawValue == Platform.AddressSpace {
    associatedtype Platform: Gibby.Platform
    var size: Int { get }
}

extension PlatformMemorySection where RawValue: FixedWidthInteger {
    func range(offsetBy offset: Int = 0) -> Range<RawValue> {
        let lowerBound = rawValue.advanced(by: offset)
        let upperBound = lowerBound.advanced(by: self.size)
        return RawValue(lowerBound)..<RawValue(upperBound)
    }
}
