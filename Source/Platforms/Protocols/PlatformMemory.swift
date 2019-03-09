import Foundation

public protocol PlatformMemory: Collection where Self.Element == Data.Element, Self.Index: FixedWidthInteger {
    associatedtype Platform: Gibby.Platform

    init(bytes: Data)
}
