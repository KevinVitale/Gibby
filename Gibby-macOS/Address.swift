public protocol Addressable {
    associatedtype RawAddress: Comparable
    var address: Address<Self> { get }
    
    func range(offsetBy offset: RawAddress) -> Range<RawAddress>
}

public struct Address<Subject: Addressable>: RawRepresentable {
    public init(rawValue: RawValue) {
        self.rawValue = rawValue
    }
    
    public typealias RawValue = Subject.RawAddress
    
    public var rawValue: RawValue
}

extension Cartridge.Header.Section: Addressable {
    var address: Address<Cartridge.Header.Section> {
        return Address(rawValue: self.rawValue)
    }
    
    typealias RawAddress = RawValue
}
