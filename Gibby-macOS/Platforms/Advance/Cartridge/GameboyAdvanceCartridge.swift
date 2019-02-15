import Foundation

extension GameboyAdvance {
    public struct Header: PlatformHeader {
        public typealias Platform = GameboyAdvance.Cartridge.Platform
        
        private let bytes: Data
        
        public init(bytes: Data) {
            self.bytes = bytes
        }
        
        public var logo: Data {
            return Platform.logo
        }
        
        public var romSize: Int {
            return 0
        }
        
        public var ramSize: Int {
            return 0
        }
    }
}
