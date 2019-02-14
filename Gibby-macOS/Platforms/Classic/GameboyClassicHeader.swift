import Foundation

extension GameboyClassic {
    public struct Header {
        private var bytes: Data
        
        public init(bytes: Data) {
            self.bytes = Data(bytes)
        }
        
        public var bootInstructions: Data {
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
                
                // Portions of 'title' got re-purposed by BigN post-GBC
                if colorMode == .exclusive {
                    title = title[0..<11]
                }
                
                return String(data: title.filter { $0 != 0 }, encoding: .ascii)!
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
        
        public var ramSizeID: UInt8 {
            return bytes[.ramSize]
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
        
        public var headerChecksum: UInt8 {
            return bytes[.headerChecksum]
        }
        
        public var romChecksum: UInt16 {
            return UInt16(bytes[.cartChecksum]
                .reversed()
                .reduce(0) { $0 | $1 }
            )
        }
    }
}

extension GameboyClassic.Header {
    enum Section: Int {
        case boot
        case logo
        case title
        case manufacturer
        case colorFlag
        case licensee
        case superGameboyFlag
        case memoryController
        case romSize
        case ramSize
        case region
        case legacyLicensee
        case versionMask
        case headerChecksum
        case cartChecksum
        
        private var size: Int {
            switch self {
            case .boot:             return 4
            case .logo:             return 48
            case .title:            return 16
            case .manufacturer:     return 4
            case .colorFlag:        return 1
            case .licensee:         return 2
            case .superGameboyFlag: return 1
            case .memoryController: return 1
            case .romSize:          return 1
            case .ramSize:          return 1
            case .region:           return 1
            case .legacyLicensee:   return 1
            case .versionMask:      return 1
            case .headerChecksum:   return 1
            case .cartChecksum:     return 2
            }
        }
        
        func range(offsetBy offset: Int = 0) -> Range<Int> {
            let lowerBound = rawValue.advanced(by: offset)
            let upperBound = lowerBound.advanced(by: size)
            return lowerBound..<upperBound
        }
        
        var rawValue: Int {
            switch self {
            case .boot:             return 0x00
            case .logo:             return 0x04
            case .title:            return 0x34
            case .manufacturer:     return 0x3F
            case .colorFlag:        return 0x43
            case .licensee:         return 0x44
            case .superGameboyFlag: return 0x46
            case .memoryController: return 0x47
            case .romSize:          return 0x48
            case .ramSize:          return 0x49
            case .region:           return 0x4A
            case .legacyLicensee:   return 0x4B
            case .versionMask:      return 0x4C
            case .headerChecksum:   return 0x4D
            case .cartChecksum:     return 0x4E
            }
        }
        
        init?(rawValue: Int) {
            guard let section = Section.allSections.filter({ $0.rawValue == rawValue }).first else {
                return nil
            }
            self = section
        }
        
        static var allSections: [Section] {
            return [
                .boot
                , .logo
                , .title
                , .manufacturer
                , .colorFlag
                , .licensee
                , .superGameboyFlag
                , .memoryController
                , .romSize
                , .ramSize
                , .region
                , .legacyLicensee
                , .versionMask
                , .headerChecksum
                , .cartChecksum
            ]
        }
    }
}

extension Data {
    fileprivate subscript(section: GameboyClassic.Header.Section) -> Data {
        get {
            return self[section.range(offsetBy: startIndex)]
        }
        set {
            self[section.range(offsetBy: startIndex)] = newValue
        }
    }
    
    fileprivate subscript(section: GameboyClassic.Header.Section) -> UInt8 {
        get {
            return self[section].first ?? 0x00
        }
        set {
            self[section.range(offsetBy: startIndex).startIndex] = newValue
        }
    }
}
