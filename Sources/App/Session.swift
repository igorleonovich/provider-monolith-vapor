import Vapor

struct Session: Content, Hashable {
    let id: String
}

extension Session: Parameter {
    static func resolveParameter(_ parameter: String, on container: Container) throws -> Session {
        return .init(id: parameter)
    }
}
