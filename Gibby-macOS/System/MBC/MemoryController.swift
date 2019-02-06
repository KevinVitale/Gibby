public struct MemoryController {
    public init(configuration: Configuration = .rom(ram: false, battery: false), romSize: Any? = nil, ramSize: Any? = nil) {
        self.configuration = configuration
        self.romSize = romSize
        self.ramSize = ramSize
    }
    
    public let configuration: Configuration
    public let romSize: Any?
    public let ramSize: Any?
}
