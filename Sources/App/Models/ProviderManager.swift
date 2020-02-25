import FluentPostgreSQL
import Vapor
import ProviderSDK

public final class ProviderManager: Codable {
    
    public var id: UUID?
    
    init(id: UUID?) {
        self.id = id
    }
}

extension ProviderManager: PostgreSQLUUIDModel {}

/// Allows `ProviderManager` to be used as a dynamic migration.
extension ProviderManager: Migration { }

/// Allows `ProviderManager` to be encoded to and decoded from HTTP messages.
extension ProviderManager: Content { }

/// Allows `ProviderManager` to be used as a dynamic parameter in route definitions.
extension ProviderManager: Parameter { }
