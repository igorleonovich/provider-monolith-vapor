import FluentSQLite
import Vapor

enum ClientStatus: String {
    case down
    case busy
    case up
}

final class Client: SQLiteModel {
    
    var id: Int?
    var hostname: String
    var status: String
    
    init(id: Int? = nil, hostname: String) {
        self.id = id
        self.hostname = hostname
        self.status = ClientStatus.down.rawValue
    }
}

/// Allows `Client` to be used as a dynamic migration.
extension Client: Migration { }

/// Allows `Client` to be encoded to and decoded from HTTP messages.
extension Client: Content { }

/// Allows `Client` to be used as a dynamic parameter in route definitions.
extension Client: Parameter { }
