import FluentSQLite
import Vapor

final class Deployment: SQLiteUUIDModel {
    
    var id: UUID?
    var state: String
    
    init(id: UUID? = nil, state: String) {
        self.id = id
        self.state = state
    }
}

extension Deployment: Migration { }

extension Deployment: Content { }

extension Deployment: Parameter { }

enum DeploymentState: String {
    case transporting
    case deploying
    case running
    case stopped
}
