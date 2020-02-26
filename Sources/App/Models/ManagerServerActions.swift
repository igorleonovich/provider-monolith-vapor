import Foundation

public enum ManagerToServerActionType: String {
    case deployConfig
}

public struct ManagerToServerAction: Codable {
    public var type: String
    public var data: Data
    
    public init(type: String, data: Data) {
        self.type = type
        self.data = data
    }
}
