import Foundation

final class GameboyClassic: Platform {
    static var logo: Data = Data(bytes: [
        0xCE, 0xED, 0x66, 0x66, 0xCC, 0x0D, 0x00, 0x0B, 0x03, 0x73, 0x00, 0x83, 0x00, 0x0C, 0x00, 0x0D,
        0x00, 0x08, 0x11, 0x1F, 0x88, 0x89, 0x00, 0x0E, 0xDC, 0xCC, 0x6E, 0xE6, 0xDD, 0xDD, 0xD9, 0x99,
        0xBB, 0xBB, 0x67, 0x63, 0x6E, 0x0E, 0xEC, 0xCC, 0xDD, 0xDC, 0x99, 0x9F, 0xBB, 0xB9, 0x33, 0x3E
        ])
    
    typealias Cartridge     = Any
    typealias AddressSpace  = UInt16
}

extension GameboyClassic {
    enum ColorMode: RawRepresentable, Codable {
        init(rawValue: UInt8) {
            switch rawValue {
            case 0x80:
                self = .some
            case 0xC0:
                self = .exclusive
            default:
                self = .unknown(rawValue)
            }
        }
        
        case unknown(UInt8)
        case some
        case exclusive
        
        var rawValue: UInt8 {
            switch self {
            case .some:
                return 0x80
            case .exclusive:
                return 0xC0
            case .unknown(let value):
                return value
            }
        }
    }
}

extension GameboyClassic {
    public struct Header {
        private var bytes: Data
        
        public init(bytes: Data) {
            self.bytes = Data(bytes)
        }

        public var bootInstructions: Data {
            get {
                return bytes[0x0..<0x4]
            }
            set {
                guard newValue.count == 4 else {
                    return
                }
                bytes[0x0..<0x4] = newValue
            }
        }
        
        public var logo: Data {
            get {
                return bytes[0x4..<0x34]
            }
            set {
                bytes[0x4..<0x34] = GameboyClassic.logo
            }
        }
        
        public var title: String {
            var title = Data(bytes[0x34..<0x44])
            
            // Portions of 'title' got re-purposed by BigN post-GBC
            switch colorMode == .exclusive {
            case true:
                title = title[0..<11]
            default:
                if self.manufacturer.contains(" ") {
                    title = title[..<15]
                }
            }
            
            return String(data: title.filter { $0 != 0 }, encoding: .ascii)!
        }
        
        public var manufacturer: String {
            return bytes[0x3F..<0x43].map { String($0, radix: 16, uppercase: true)}.joined()
        }
    }
}
