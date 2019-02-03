public enum MemoryController: Codable, RawRepresentable, CustomDebugStringConvertible, Equatable {
    case rom(ram: Bool, battery: Bool)
    case one(ram: Bool, battery: Bool)
    case two(battery: Bool)
    case mmm1(ram: Bool, battery: Bool)
    case three(ram: Bool, battery: Bool, timer: Bool)
    case five(ram: Bool, battery: Bool, rumble: Bool)
    case six
    case seven
    case camera
    case tama5
    case huc1
    case huc3
    
    case unknown(value: UInt8)
    
    public init?(rawValue: UInt8) {
        switch rawValue {
        case 0x00: self = .rom(ram: false,  battery: false)
            
        case 0x01: self = .one(ram: false,  battery: false)
        case 0x02: self = .one(ram: true,   battery: false)
        case 0x03: self = .one(ram: true,   battery: true)
            
        case 0x05: self = .two(battery: false)
        case 0x06: self = .two(battery: true)
            
        case 0x08: self = .rom(ram: true, battery: false)
        case 0x09: self = .rom(ram: true, battery: true)
            
        case 0x0B: self = .mmm1(ram: false, battery: false)
        case 0x0C: self = .mmm1(ram: true, battery: false)
        case 0x0D: self = .mmm1(ram: true, battery: true)
            
        case 0x0F: self = .three(ram: false, battery: true, timer: true)
        case 0x10: self = .three(ram: true, battery: true, timer: true)
        case 0x11: self = .three(ram: false, battery: false, timer: false)
        case 0x12: self = .three(ram: true, battery: false, timer: false)
        case 0x13: self = .three(ram: true, battery: true, timer: false)
            
        case 0x19: self = .five(ram: false, battery: false, rumble: false)
        case 0x1A: self = .five(ram: true, battery: false, rumble: false)
        case 0x1B: self = .five(ram: true, battery: true, rumble: false)
        case 0x1C: self = .five(ram: false, battery: false, rumble: true)
        case 0x1D: self = .five(ram: true, battery: false, rumble: true)
        case 0x1E: self = .five(ram: true, battery: true, rumble: true)
            
        case 0x20: self = .six
        case 0x22: self = .seven
            
        case 0xFC: self = .camera
        case 0xFD: self = .tama5
        case 0xFE: self = .huc3
        case 0xFF: self = .huc1
            
        default:
            self = .unknown(value: rawValue)
        }
    }
    
    public var rawValue: UInt8 {
        switch self {
        case .rom(let ram, let battery):
            switch (ram, battery) {
            case (false, false): return 0x00
            case (true, false):  return 0x08
            case (true, true):   return 0x09
            default:             return MemoryController.badRawValues[typeDescription]!
            }
        case .one(let ram, let battery):
            switch (ram, battery) {
            case (false, false): return 0x01
            case (true, false):  return 0x02
            case (true, true):   return 0x03
            default:             return MemoryController.badRawValues[typeDescription]!
            }
        case .two(let battery):
            return battery ? 0x06 : 0x05
        case .mmm1(let ram, let battery):
            switch (ram, battery) {
            case (false, false): return 0x0B
            case (true, false):  return 0x0C
            case (true, true):   return 0x0D
            default:             return MemoryController.badRawValues[typeDescription]!
            }
        case .three(let ram, let battery, let timer):
            switch (ram, battery, timer) {
            case (false, true, true):   return 0x0F
            case (true, true, true):    return 0x10
            case (false, false, false): return 0x11
            case (true, false, false):  return 0x12
            case (true, true, false):   return 0x13
            default:                    return MemoryController.badRawValues[typeDescription]!
            }
            
        case .five(let ram, let battery, let rumble):
            switch (ram, battery, rumble) {
            case (false, false, false): return 0x19
            case (true, false, false):  return 0x1A
            case (true, true, false):   return 0x1B
            case (false, false, true):  return 0x1C
            case (true, false, true):   return 0x1D
            case (true, true, true):    return 0x1E
            default:                    return MemoryController.badRawValues[typeDescription]!
            }
        case .six:      return 0x20
        case .seven:    return 0x22
        case .camera:   return 0xFC
        case .tama5:    return 0xFD
        case .huc1:     return 0xFF
        case .huc3:     return 0xFE
        case .unknown(let value):
            return value
        }
    }
    
    public static let allControllers: [MemoryController] = (0x00...0xFF)
        .compactMap(MemoryController.init)
        .filter({ $0.isValid })
    
    private static let badRawValues: [String:UInt8] = [
        "ROM"  :0x0A
      , "MBC1" :0x04
      , "MMM1" :0x0E
      , "MBC3" :0x14
      , "MBC5" :0x1F
    ]

    public var isValid: Bool {
        if case .unknown = self {
            return false
        } else if MemoryController.badRawValues[typeDescription] == rawValue {
            return false
        } else {
            return true
        }
    }
    
    public var hardware: ExternalHardware {
        var hardware: ExternalHardware = []
        if hasRAM     { hardware.insert(.ram) }
        if hasBattery { hardware.insert(.battery) }
        if hasTimer   { hardware.insert(.timer) }
        if hasRumble  { hardware.insert(.rumble) }
        if hasSensor  { hardware.insert(.sensor) }
        if hasCamera  { hardware.insert(.camera) }
        
        return hardware
    }
    
    private var hasRAM: Bool {
        switch self {
        case .rom(true, _):
            return true
        case .one(true, _):
            return true
        case .two:
            return true
        case .mmm1(true, _):
            return true
        case .three(true, _, _):
            return true
        case .five(true, _, _):
            return true
        case .seven:
            return true
        case .huc1:
            return true
        default:
            return false
        }
    }
    
    private var hasBattery: Bool {
        switch self {
        case .rom(_, true):
            return true
        case .one(_, true):
            return true
        case .two(let battery):
            return battery
        case .mmm1(_, true):
            return true
        case .three(_, true, _):
            return true
        case .five(_, true, _):
            return true
        case .seven:
            return true
        case .huc1:
            return true
        default:
            return false
        }
    }
    
    private var hasTimer: Bool {
        guard case .three(_, _, true) = self else {
            return false
        }
        return true
    }
    
    private var hasRumble: Bool {
        switch self {
        case .five(_, _, true):
            return true
        case .seven:
            return true
        default:
            return false
        }
    }
    
    private var hasSensor: Bool {
        guard case .seven = self else {
            return false
        }
        return true
    }
    
    private var hasCamera: Bool {
        guard case .camera = self else {
            return false
        }
        return true
    }
    
    private var typeDescription: String {
        switch self {
        case .rom: return "ROM"
        case .one: return "MBC1"
        case .two: return "MBC2"
        case .mmm1: return "MMM1"
        case .three: return "MBC3"
        case .five: return "MBC5"
        case .six: return "MBC6"
        case .seven: return "MBC7"
        case .camera: return "POCKET"
        case .tama5: return "BANDAI TAMA5"
        case .huc3: return "HuC3"
        case .huc1: return "HuC1"
        default: return ""
        }
    }
    
    public var debugDescription: String {
        var type = typeDescription

        if hasCamera  { type += " \(ExternalHardware.camera.description)" }
        if hasSensor  { type += "+\(ExternalHardware.sensor.description)" }
        if hasRumble  { type += "+\(ExternalHardware.rumble.description)" }
        if hasTimer   { type += "+\(ExternalHardware.timer.description)" }
        if hasRAM && type != "MBC2"
                      { type += "+\(ExternalHardware.ram.description)" }
        if hasBattery { type += "+\(ExternalHardware.battery.description)" }
        
        return type
    }
}

extension MemoryController {
    public struct ExternalHardware: OptionSet, CustomStringConvertible {
        public let rawValue: Int
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let ram       = ExternalHardware(rawValue: 1 << 0)
        public static let battery   = ExternalHardware(rawValue: 1 << 1)
        public static let timer     = ExternalHardware(rawValue: 1 << 2)
        public static let rumble    = ExternalHardware(rawValue: 1 << 3)
        public static let sensor    = ExternalHardware(rawValue: 1 << 4)
        public static let camera    = ExternalHardware(rawValue: 1 << 5)
        
        public var description: String {
            switch self.rawValue {
            case ExternalHardware.ram.rawValue:     return "RAM"
            case ExternalHardware.battery.rawValue: return "BATTERY"
            case ExternalHardware.timer.rawValue:   return "TIMER"
            case ExternalHardware.rumble.rawValue:  return "RUMBLE"
            case ExternalHardware.sensor.rawValue:  return "SENSOR"
            case ExternalHardware.camera.rawValue:  return "CAMERA"
            default: return ""
            }
        }
    }
}
