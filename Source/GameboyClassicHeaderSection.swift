enum GameboyClassicHeaderSection: UInt16, PlatformMemorySection {
    typealias Platform = GameboyClassic
    
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

    var rawValue: UInt16 {
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

    var size: Int {
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

    static var allSections: [GameboyClassicHeaderSection] {
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

