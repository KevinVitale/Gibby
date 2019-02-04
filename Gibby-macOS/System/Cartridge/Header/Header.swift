import Foundation

extension Cartridge {
    /* leave blank; used for namespacing. */
    struct Header { private init() { } }
}

extension Cartridge {
    public var header: Data {
        get {
            return self[.header(system)]
        }
        set {
            self[.header(system)] = newValue
        }
    }
}

extension Cartridge {
    ///
    public var entryPoint: Data {
        get {
            return self[.boot]
        }
        set {
            self[.boot] = newValue
        }
    }
    
    ///
    public var isLogoValid: Bool {
        return self[.logo] == system.logo
    }
    
    ///
    public var title: String {
        get {
            var title = Data(self[.title])
            switch self.colorMode {
            case .none:
                ()
            case .some:
                if self.manufacturer.contains(" ") {
                    title = title[..<15]
                }
            case .exclusive:
                title = title[..<11]
            case .unknown:
                ()
            }

            return String(data: title.filter { $0 != 0 }, encoding: .ascii)!
        }
        set {
            guard var data = newValue.uppercased().data(using: .ascii) else {
                return
            }
            defer {
                self[.title] = data
            }
            
            switch self.colorMode {
            case .exclusive: data = data[..<11]
            case      .some: data = data[..<15]
            case      .none: return
            default: ()
            }
        }
    }
    
    ///
    public var manufacturer: String {
        guard self.colorMode != .none else {
            return ""
        }
        return String(data: self[.manufacturer], encoding: .ascii)!
    }
    
    ///
    public var colorMode: Cartridge.ColorMode {
        get {
            guard let value = self[.colorFlag].first else {
                return .unknown(0x00)
            }
            return Cartridge.ColorMode(rawValue: Int(value))
        }
        set {
            self[.colorFlag] = Data([UInt8(newValue.rawValue)])
        }
    }
    
    ///
    public var licensee: String {
        let value = self[.licensee]
            .reversed()
            .reduce(into: UInt8()) { result, next in
                guard result != 0 else {
                    result = next
                    return
                }
                result -= next
        }
        
        return String(value, radix: 10, uppercase: true)
    }
    
    ///
    public var legacyLicensee: Cartridge.LegacyLicensee {
        return Cartridge.LegacyLicensee(rawValue: Int(self[.legacyLicensee].first ?? 0x00))
    }
    
    ///
    public var superGameboySupported: Bool {
        return (self[.superGameboyFlag].first ?? 0x00) == 0x03
    }
    
    ///
    public var memoryController: MemoryController {
        guard let value = self[.memoryController].first
            , case let memoryController = MemoryController(rawValue: value) else {
                return .unknown(value: 0x00)
        }
        return memoryController
    }
    
    ///
    public var romSize: String {
        return self[.romSize].map { String($0, radix: 16, uppercase: true) }.joined()
    }
    
    ///
    public var ramSize: String {
        return self[.ramSize].map { String($0, radix: 16, uppercase: true) }.joined()
    }
    
    ///
    public var region: String {
        return ((self[.region].first ?? 0x00) == 0x01) ? "Non-Japanese" : "Japanese"
    }
    
    ///
    public var version: String {
        return self[.versionMask].map { String($0, radix: 16, uppercase: true) }.joined()
    }
    
    ///
    public var headerChecksum: String {
        return self[.headerChecksum].map { String($0, radix: 16, uppercase: true) }.joined()
    }
    
    ///
    public var cartChecksum: String {
        return self[.cartChecksum].map { String($0, radix: 16, uppercase: true) }.joined()
    }
}
