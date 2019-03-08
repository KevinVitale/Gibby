import Foundation

extension GameboyAdvance {
    public struct Header: PlatformHeader {
        public typealias Platform = GameboyAdvance.Cartridge.Platform
        
        private var bytes: Data
        
        public init(bytes: Data) {
            self.bytes = bytes
        }
        
        public var entryPoint: Data {
            get {
                return bytes[0x00..<0x04]
            }
            set {
                bytes[0x00..<0x04] = newValue
            }
        }

        public var logo: Data {
            get {
                return bytes[0x04..<0xA0]
            }
            set {
                bytes[0x04..<0xA0] = GameboyAdvance.logo
            }
        }

        public var title: String {
            get {
                return String(data: bytes[0xA0..<0xAC], encoding: .ascii) ?? ""
            }
            set {
                bytes[0xA0..<0xAC] = String(newValue.prefix(12)).data(using: .ascii)!
            }
        }

        public var debugEnabled: Bool {
            return false
        }
        
        public var cartridgeKey: Int {
            return 0
        }

        public var gameCode: String? = nil
        
        public var manufacturer: String = ""
        
        public var version: UInt8 = 0
        
        public var romBanks: Int = 0
        
        public var romSize: Int = 0
        
        public var ramSize: Int = 0
        
        public var headerChecksum: UInt32 = 0
    }
}
