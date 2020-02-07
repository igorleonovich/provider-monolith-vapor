import FluentSQLite
import Vapor

/// A single entry of a Client list.
final class Client: SQLiteModel {
    /// The unique identifier for this `Client`.
    var id: Int?

    /// A title describing what this `Client` entails.
    var hostname: String

    /// Creates a new `Client`.
    init(id: Int? = nil, hostname: String) {
        self.id = id
        self.hostname = hostname
    }
}

/// Allows `Client` to be used as a dynamic migration.
extension Client: Migration { }

/// Allows `Client` to be encoded to and decoded from HTTP messages.
extension Client: Content { }

/// Allows `Client` to be used as a dynamic parameter in route definitions.
extension Client: Parameter { }
