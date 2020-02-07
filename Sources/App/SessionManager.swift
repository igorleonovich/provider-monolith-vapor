import Vapor

final class SessionManager {
    
    private(set) var sessions: LockedDictionary<Session, [WebSocket]> = [:]
    
    func createTrackingSession(for request: Request) -> Future<Session> {
        let session = Session(id: UUID().uuidString)
        guard self.sessions[session] == nil else {
            return self.createTrackingSession(for: request)
        }
        self.sessions[session] = []
        
        return Future.map(on: request) { session }
    }
}
