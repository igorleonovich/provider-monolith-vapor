import FluentSQLite
import Vapor

enum ClientState: String {
    case unknown
    case down
    case busy
    case up
}

final class Client: SQLiteUUIDModel {
    
    var id: UUID?
    var hostname: String
    var state: String
    
    init(id: UUID? = nil, hostname: String, state: String = ClientState.unknown.rawValue) {
        self.id = id
        self.hostname = hostname
        self.state = state
    }
}

/// Allows `Client` to be used as a dynamic migration.
extension Client: Migration { }

/// Allows `Client` to be encoded to and decoded from HTTP messages.
extension Client: Content { }

/// Allows `Client` to be used as a dynamic parameter in route definitions.
extension Client: Parameter { }
