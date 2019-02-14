import Foundation

public final class GameboyClassic: Platform {
    public static var logo: Data = Data(bytes: [
        0xCE, 0xED, 0x66, 0x66, 0xCC, 0x0D, 0x00, 0x0B, 0x03, 0x73, 0x00, 0x83, 0x00, 0x0C, 0x00, 0x0D,
        0x00, 0x08, 0x11, 0x1F, 0x88, 0x89, 0x00, 0x0E, 0xDC, 0xCC, 0x6E, 0xE6, 0xDD, 0xDD, 0xD9, 0x99,
        0xBB, 0xBB, 0x67, 0x63, 0x6E, 0x0E, 0xEC, 0xCC, 0xDD, 0xDC, 0x99, 0x9F, 0xBB, 0xB9, 0x33, 0x3E
        ])
    
    public typealias Cartridge     = Any
    public typealias AddressSpace  = UInt16
}

extension GameboyClassic {
    public enum Region: UInt8, ExpressibleByStringLiteral, CustomStringConvertible {
        case japanese    = 0x00
        case nonJapanese = 0x01
        
        public init(stringLiteral value: String) {
            if value.capitalized == "Japanese" {
                self = .japanese
            }
            else {
                self = .nonJapanese
            }
        }
        
        public var description: String {
            switch self {
            case .japanese: return "Japanese"
            case .nonJapanese: return "Non-Japanese"
            }
        }
    }
}

