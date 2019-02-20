public protocol Cartridge: PlatformMemory {
    associatedtype Header: PlatformHeader
    
    var header: Header { get }
}
