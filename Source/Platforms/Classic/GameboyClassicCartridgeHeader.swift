extension GameboyClassic.Cartridge {
    public struct Header: Gibby.Header, PlatformMemory {
        public init(bytes: Data) {
            self.bytes = bytes
        }
        
        public typealias Platform = GameboyClassic
        public typealias Index    = Platform.AddressSpace
        
        private let bytes: Data
        
        public subscript(position: Index) -> Data.Element {
            return bytes[Int(position)]
        }
        
        public var startIndex: Index {
            return Index(bytes.startIndex)
        }
        
        public var endIndex: Platform.AddressSpace {
            return Index(bytes.endIndex)
        }
        
        public func index(after i: Index) -> Index {
            return Index(bytes.index(after: Int(i)))
        }
        
        public var entryPoint: Data {
            return self[.boot]
        }
        
        public var logo: Data {
            return self[.logo]
        }
        
        public var title: String {
            var title = self[.title]
            var truncateSuffix = true
            
            // Portions of 'title' got re-purposed by Nintendo post-GBC
            if self.colorMode == .exclusive {
                title = title[0..<11]
            }
            else if self.colorMode == .some {
                title = title[0..<15]
            }
            else {
                truncateSuffix = false
            }
            
            let characterSet = CharacterSet.alphanumerics.union(.whitespaces).union(.punctuationCharacters)
            var titleString  = String(String(data: title, encoding: .ascii)!.unicodeScalars.filter { characterSet.contains($0) })
            let suffix       = String(self.manufacturer.unicodeScalars.filter { characterSet.contains($0) })
            
            if truncateSuffix && titleString.hasSuffix(suffix) {
                titleString = String(titleString.dropLast(suffix.count))
            }
            
            return titleString
        }
        
        public var gameCode: String? {
            return nil
        }
        
        public var manufacturer: String {
            return String(data: self[.manufacturer], encoding: .ascii) ?? ""
        }
        
        public var licensee: String {
            return String(data: self[.licensee], encoding: .ascii) ?? ""
        }
        
        public var superGameboySupported: Bool {
            return (self[.superGameboyFlag].first ?? 0x00) == 0x03
        }
        
        public var configuration: Configuration {
            guard let value = self[.memoryController].first else {
                return .unknown(value: 0x0A)
            }
            return .init(rawValue: value)
        }
        
        public var romSizeID: UInt8 {
            return self[.romSize].first ?? 0x00
        }
        
        public var romBanks: Int {
            var romBanks = 2
            switch romSizeID {
            case 0...8:
                romBanks = 2 << romSizeID
            case 0x52, 0x82:
                romBanks = 72
            case 0x53, 0x83:
                romBanks = 80
            case 0x54, 0x84:
                romBanks = 96
            default: ()
            }
            
            if case .one = configuration {
                if romSizeID == 5 {
                    romBanks -= 1
                }
                else if romSizeID == 6 {
                    romBanks -= 3
                }
            }
            return romBanks
        }
        
        public var romSize: Int {
            return 0x4000 * romBanks
        }
        
        private var ramSizeID: UInt8 {
            return self[.ramSize].first ?? 0xFF
        }

        public var ramBanks: Int {
            if case .two = configuration {
                return 1
            }
            switch ramSizeID {
            case 0x00:
                return 0
            case 0x01:
                return 1
            case 0x02:
                return 1
            case 0x03:
                return 4
            case 0x04:
                return 16
            case 0x05:
                return 8
            default:
                return 0
            }
        }
        
        public var ramBankSize: Int {
            if case .two = configuration {
                return 0x200
            }
            switch ramSizeID {
            case 0x00:
                return 0
            case 0x01:
                return 0x0800
            case 0x02...0x05:
                return 0x2000
            default:
                return 0
            }
        }
        
        public var region: Region {
            return (self[.region].first ?? 0x00) != 0x00 ? "Non-Japanese" : "Japanese"
        }
        
        public var legacyLicensee: UInt8 {
            return self[.legacyLicensee].first ?? 0x00
        }
        
        public var version: UInt8 {
            return self[.versionMask].first ?? 0x00
        }
        
        public var headerChecksum: UInt8 {
            return self[.headerChecksum].first ?? 0xFF
        }
        
        public var romChecksum: UInt16 {
            return UInt16(self[.cartChecksum]
                .reversed()
                .reduce(0) { $0 | $1 }
            )
        }
        
        public var colorMode: ColorMode {
            let byte = self[.colorFlag].first ?? 0
            return ColorMode(rawValue: byte)
        }
    }
}
