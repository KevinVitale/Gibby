import Foundation

/**
 Encompases the original (`DMG`) and color (`GBC`) Gameboy hardware platforms.
 */
public final class GameboyClassic: Platform {
    /// The __Nintendo__ logo displayed on boot-up.
    public static var logo: Data = Data([
        0xCE, 0xED, 0x66, 0x66, 0xCC, 0x0D, 0x00, 0x0B, 0x03, 0x73, 0x00, 0x83, 0x00, 0x0C, 0x00, 0x0D,
        0x00, 0x08, 0x11, 0x1F, 0x88, 0x89, 0x00, 0x0E, 0xDC, 0xCC, 0x6E, 0xE6, 0xDD, 0xDD, 0xD9, 0x99,
        0xBB, 0xBB, 0x67, 0x63, 0x6E, 0x0E, 0xEC, 0xCC, 0xDD, 0xDC, 0x99, 0x9F, 0xBB, 0xB9, 0x33, 0x3E
        ])
    
    /// The platform's address range, defining address between: `0..<65535`.
    public typealias AddressSpace  = UInt16
    public typealias Header = Cartridge.Header
    
    /// The memory range which defines the platform's cartridge header.
    ///
    ///  [Cartridge Header]: http://gbdev.gg8.se/wiki/articles/The_Cartridge_Header
    ///  Memory layout is shown here: [Cartridge Header].
    public static var headerRange: Range<AddressSpace> {
        return 0x100..<0x150
    }
}
