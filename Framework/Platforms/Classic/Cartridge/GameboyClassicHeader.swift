import Foundation

extension GameboyClassic {
    public struct Header: Gibby.Header {
       public typealias Platform = GameboyClassic.Cartridge.Platform
        
        private var bytes: Data
        
        public init(bytes: Data) {
            self.bytes = Data(bytes)
        }
        
        public var entryPoint: Data {
            get {
                return bytes[.boot]
            }
            set {
                guard newValue.count == 4 else {
                    return
                }
                bytes[.boot] = newValue
            }
        }
        
        public var logo: Data {
            get {
                return bytes[.logo]
            }
            set {
                bytes[.logo] = GameboyClassic.logo
            }
        }
        
        public var title: String {
            get {
                var title = Data(bytes[.title])
                var truncateSuffix = true
                
                // Portions of 'title' got re-purposed by Nintendo post-GBC
                if colorMode == .exclusive {
                    title = title[0..<11]
                }
                else if colorMode == .some {
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
            set {
                guard var title = String(newValue.prefix(16)).data(using: .ascii) else {
                    return
                }
                
                guard colorMode != .exclusive else {
                    bytes[0x34..<0x3F] = title[0..<11]
                    return
                }
                
                bytes[.title] = title
            }
        }
        
        public var gameCode: String? {
            get {
                return nil
            }
            set {
                
            }
        }
        
        public var manufacturer: String {
            get {
                return String(data: bytes[.manufacturer], encoding: .ascii) ?? ""
            }
            set {
                guard let value = newValue.data(using: .ascii), value.count == 4 else {
                    return
                }
                bytes[.manufacturer] = value
            }
        }
        
        public var colorMode: GameboyClassic.ColorMode {
            get {
                let byte = bytes[.colorFlag].first ?? 0x00
                return ColorMode(rawValue: byte)
            }
            set {
                bytes[.colorFlag] = Data([newValue.rawValue])
            }
        }
        
        public var licensee: String {
            return String(data: bytes[.licensee], encoding: .ascii) ?? ""
        }
        
        public var superGameboySupported: Bool {
            get {
                return bytes[.superGameboyFlag] == 0x03
            }
            set {
                guard newValue == true else {
                    bytes[.superGameboyFlag] = 0x00
                    return
                }
                bytes[.superGameboyFlag] = 0x03
            }
        }
        
        public var configuration: MemoryController.Configuration {
            get {
                return .init(rawValue: bytes[.memoryController])
            }
            set {
                if case .unknown = newValue {
                    return
                }
                bytes[.memoryController] = newValue.rawValue
            }
        }
        
        public var romSizeID: UInt8 {
            return bytes[.romSize]
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
        
        public var ramSizeID: UInt8 {
            return bytes[.ramSize]
        }
        
        public var ramSize: Int {
            get {
                return 0
            }
        }
        
        public var region: Region {
            get {
                return bytes[.region] != 0x00 ? "Non-Japanese" : "Japanese"
            }
            set {
                bytes[.region] = newValue.rawValue
            }
        }
        
        public var legacyLicensee: UInt8 {
            get {
                return bytes[.legacyLicensee]
            }
            set {
                bytes[.legacyLicensee] = newValue
            }
        }
        
        public var version: UInt8 {
            get {
                return bytes[.versionMask]
            }
            set {
                bytes[.versionMask] = newValue
            }
        }
        
        public var headerChecksum: GameboyClassic.AddressSpace {
            return UInt16(bytes[.headerChecksum])
        }
        
        public var romChecksum: UInt16 {
            return UInt16(bytes[.cartChecksum]
                .reversed()
                .reduce(0) { $0 | $1 }
            )
        }
    }
}