import FluentSQLite
import Vapor
import ProviderSDK

extension ProviderClient: SQLiteUUIDModel {}

/// Allows `ProviderClient` to be used as a dynamic migration.
extension ProviderClient: Migration { }

/// Allows `ProviderClient` to be encoded to and decoded from HTTP messages.
extension ProviderClient: Content { }

/// Allows `ProviderClient` to be used as a dynamic parameter in route definitions.
extension ProviderClient: Parameter { }
