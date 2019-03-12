import Foundation

public final class GameboyAdvance: Platform {
    public static var logo: Data = Data(bytes: [
        0x24, 0xFF, 0xAE, 0x51, 0x69, 0x9A, 0xA2, 0x21, 0x3D, 0x84, 0x82, 0x0A, 0x84, 0xE4, 0x09, 0xAD,
        0x11, 0x24, 0x8B, 0x98, 0xC0, 0x81, 0x7F, 0x21, 0xA3, 0x52, 0xBE, 0x19, 0x93, 0x09, 0xCE, 0x20,
        0x10, 0x46, 0x4A, 0x4A, 0xF8, 0x27, 0x31, 0xEC, 0x58, 0xC7, 0xE8, 0x33, 0x82, 0xE3, 0xCE, 0xBF,
        0x85, 0xF4, 0xDF, 0x94, 0xCE, 0x4B, 0x09, 0xC1, 0x94, 0x56, 0x8A, 0xC0, 0x13, 0x72, 0xA7, 0xFC,
        0x9F, 0x84, 0x4D, 0x73, 0xA3, 0xCA, 0x9A, 0x61, 0x58, 0x97, 0xA3, 0x27, 0xFC, 0x03, 0x98, 0x76,
        0x23, 0x1D, 0xC7, 0x61, 0x03, 0x04, 0xAE, 0x56, 0xBF, 0x38, 0x84, 0x00, 0x40, 0xA7, 0x0E, 0xFD,
        0xFF, 0x52, 0xFE, 0x03, 0x6F, 0x95, 0x30, 0xF1, 0x97, 0xFB, 0xC0, 0x85, 0x60, 0xD6, 0x80, 0x25,
        0xA9, 0x63, 0xBE, 0x03, 0x01, 0x4E, 0x38, 0xE2, 0xF9, 0xA2, 0x34, 0xFF, 0xBB, 0x3E, 0x03, 0x44,
        0x78, 0x00, 0x90, 0xCB, 0x88, 0x11, 0x3A, 0x94, 0x65, 0xC0, 0x7C, 0x63, 0x87, 0xF0, 0x3C, 0xAF,
        0xD6, 0x25, 0xE4, 0x8B, 0x38, 0x0A, 0xAC, 0x72, 0x21, 0xD4, 0xF8, 0x07
        ])
    
    public typealias AddressSpace = UInt32
    
    public static var headerRange: Range<AddressSpace> {
        return 0x0000..<0x00C0
    }
}

extension GameboyAdvance {
    public struct Cartridge: Gibby.Cartridge {
        public init(bytes: Data) {
            self.bytes = bytes
        }
        
        public typealias Platform = GameboyAdvance
        public typealias Index    = Int
        
        private let bytes: Data
        
        public subscript(position: Index) -> Data.Element {
            return bytes[Int(position)]
        }
        
        public var startIndex: Index {
            return Index(bytes.startIndex)
        }
        
        public var endIndex: Index {
            return Index(bytes.endIndex)
        }
        
        public func index(after i: Index) -> Index {
            return Index(bytes.index(after: Int(i)))
        }

        public var fileExtension: String {
            return "gba"
        }
        
        public func write(to url: URL, options: Data.WritingOptions = []) throws {
            try self.bytes.write(to: url, options: options)
        }
    }
}

extension GameboyAdvance.Cartridge {
    // https://problemkaputt.de/gbatek.htm#gbacartridgeheader
    public struct Header: Gibby.Header, PlatformMemory {
        public init(bytes: Data) {
            self.bytes = bytes
        }
        
        public typealias Platform = GameboyAdvance
        public typealias Index    = Platform.AddressSpace
        
        public subscript(position: Platform.AddressSpace) -> Data.Element {
            return bytes[Int(position)]
        }
        
        public var startIndex: Platform.AddressSpace {
            return Platform.AddressSpace(bytes.startIndex)
        }
        
        public var endIndex: Platform.AddressSpace {
            return Platform.AddressSpace(bytes.endIndex)
        }
        
        public func index(after i: Platform.AddressSpace) -> Platform.AddressSpace {
            return Platform.AddressSpace(bytes.index(after: Int(i)))
        }
        
        private let bytes: Data

        public var entryPoint: Data {
            return self[.boot]
        }

        public var logo: Data {
            return self[.logo]
        }
        
        public var title: String {
            return String(data: self[.title], encoding: .ascii) ?? ""
        }
        
        public let gameCode: String? = nil
        
        public let manufacturer: String = ""
        
        public let version: UInt8 = 0x00
        
        public let romBanks: Int = 0
        
        public let romBankSize: Int = 0
        
        public let ramBanks: Int = 0
        
        public let ramBankSize: Int = 0
        
        public let headerChecksum: UInt8 = 0

        public enum Section: GameboyAdvance.AddressSpace, HeaderSection {
            case boot
            case logo
            case title
            
            public var rawValue: RawValue {
                switch self {
                case .boot:             return 0x00
                case .logo:             return 0x04
                case .title:            return 0xA0
                }
            }

            public var size: Int {
                switch self {
                case .boot:             return 4
                case .logo:             return 156
                case .title:            return 12
                }
            }
            
            static var allSections: [Section] {
                return [
                    .boot
                    , .logo
                    , .title
                ]
            }
        }
    }
}

