extension GameboyClassic.Cartridge {
    public struct ExternalHardware: OptionSet, CustomStringConvertible {
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public let rawValue: Int
        
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
