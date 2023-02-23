import Foundation

@objc public class CapCoreML: NSObject {
    @objc public func echo(_ value: String) -> String {
        print(value)
        return value
    }
}
