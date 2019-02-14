import Foundation

public protocol PlatformHeader: PlatformMemory {
    var logo:    Data { get }
    var romSize: Int  { get }
    var ramSize: Int  { get }
}

extension PlatformHeader {
    public var isLogoValid: Bool {
        return Platform.validate(logo: logo)
    }
}
