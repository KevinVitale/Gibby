import Foundation

public protocol Cartridge: PlatformMemory {
    associatedtype Header: PlatformHeader
    
    var header: Header { get }
    var fileExtension: String { get }
    
    func write(to: URL, options: Data.WritingOptions) throws
}
