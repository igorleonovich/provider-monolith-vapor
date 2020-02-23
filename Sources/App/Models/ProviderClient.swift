import FluentSQLite
import Vapor
import ProviderSDK

final class ProviderClient: SQLiteUUIDModel {
    
    var id: UUID?
    var hostName: String
    var userName: String
    var osType: String
    var osVersion: String
    var kernelType: String
    var kernelVersion: String
    var state: String
    var cpuUsage: Double?
    var freeRAM: Int?
    
    init(id: UUID? = nil, hostName: String, userName: String, osType: String, osVersion: String, kernelType: String, kernelVersion: String, state: String = ProviderClientState.unknown.rawValue, cpuUsage: Double?, freeRAM: Int?) {
        self.id = id
        self.hostName = hostName
        self.userName = userName
        self.osType = osType
        self.osVersion = osVersion
        self.kernelType = kernelType
        self.kernelVersion = kernelVersion
        self.state = state
        self.cpuUsage = cpuUsage
        self.freeRAM = freeRAM
    }
}

/// Allows `ProviderClient` to be used as a dynamic migration.
extension ProviderClient: Migration { }

/// Allows `ProviderClient` to be encoded to and decoded from HTTP messages.
extension ProviderClient: Content { }

/// Allows `ProviderClient` to be used as a dynamic parameter in route definitions.
extension ProviderClient: Parameter { }
