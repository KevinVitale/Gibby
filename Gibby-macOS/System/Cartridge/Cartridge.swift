import Foundation

public struct Cartridge {
    public let system: GameBoy
    private var bytes: Data

    public init(system: GameBoy = .original) {
        self.system = system
        self.bytes = .init(count: 0xFFFF)
        self[.logo] = system.logo
    }
    
    public init(contentsOf url: URL, options: Data.ReadingOptions = []) throws {
        let bytes = try Data(contentsOf: url, options: options)
        
        self.system = .original
        self.bytes = bytes
    }
    
    public func write(to url: URL, options: Data.WritingOptions = []) throws {
        try self[.rom(system)].write(to: url, options: options)
    }
}

extension Cartridge {
    enum Section {
        case header(GameBoy)
        case rom(GameBoy)
        
        private var lowerBound: Int {
            switch self {
            case .header(let system):
                switch system {
                case .original: fallthrough
                case    .color: return 0x100
                case  .advance:
                    fatalError("Game Boy Advance not yet implemented.")
                }
            case .rom(let system):
                switch system {
                case .original: fallthrough
                case    .color: return 0x0
                case  .advance:
                    fatalError("Game Boy Advance not yet implemented.")
                }
            }
        }
        
        private var upperBound: Int {
            return lowerBound.advanced(by: size)
        }
        
        private var size: Int {
            switch self {
            case .header(let system):
                switch system {
                case .original: fallthrough
                case    .color: return 0x50
                case  .advance: return 0xC0
                }
            case .rom(let system):
                switch system {
                case .original: fallthrough
                case    .color: return 0x8000
                case  .advance:
                    fatalError("Game Boy Advance not yet implemented.")
                }
            }
        }

        fileprivate var range: Range<Int> {
            return lowerBound..<upperBound
        }
        
        static var original: [Section] {
            return [ .header(.original) ]
        }
        
        static var color: [Section] {
            return [ .header(.color) ]
        }
        
        static var advance: [Section] {
            return [ .header(.advance) ]
        }
    }
}

extension Cartridge {
    subscript(section: Cartridge.Section) -> Data {
        get {
            guard self.bytes.indices.overlaps(section.range) else {
                return .init()
            }
            return self.bytes[section.range]
        }
        set {
            guard self.bytes.indices.overlaps(section.range) else {
                return
            }
            self.bytes.replaceSubrange(section.range, with: newValue)
        }
    }
}

extension Cartridge {
    subscript(header: Cartridge.Header.Section) -> Data {
        get {
            let offsetRange = header.range(offsetBy: self.system.headerOffset)
            guard self.bytes.indices.overlaps(offsetRange) else {
                return .init()
            }
            return self.bytes[offsetRange]
        }
        set {
            let offsetRange = header.range(offsetBy: self.system.headerOffset)
            guard self.bytes.indices.overlaps(offsetRange) else {
                return
            }
            self.bytes.replaceSubrange(offsetRange, with: newValue)
        }
    }
}

