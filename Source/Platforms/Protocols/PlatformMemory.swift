import Foundation

public protocol PlatformMemory: Collection {
    associatedtype Platform: Gibby.Platform where Self.Element == Data.Element, Self.Index: FixedWidthInteger

    init(bytes: Data)
}
