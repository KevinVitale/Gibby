public protocol Cartridge: PlatformMemory {
    associatedtype Header: PlatformHeader
}
