import FluentSQLite
import Vapor

enum ClientState: String {
    case unknown
    case ready
    case progress
    case running
}

final class Client: SQLiteUUIDModel {
    
    var id: UUID?
    var hostName: String
    var userName: String
    var osType: String
    var osRelease: String
    var state: String
    
    init(id: UUID? = nil, hostName: String, userName: String, osType: String, osRelease: String, state: String = ClientState.unknown.rawValue) {
        self.id = id
        self.hostName = hostName
        self.userName = userName
        self.osType = osType
        self.osRelease = osRelease
        self.state = state
    }
}

/// Allows `Client` to be used as a dynamic migration.
extension Client: Migration { }

/// Allows `Client` to be encoded to and decoded from HTTP messages.
extension Client: Content { }

/// Allows `Client` to be used as a dynamic parameter in route definitions.
extension Client: Parameter { }
