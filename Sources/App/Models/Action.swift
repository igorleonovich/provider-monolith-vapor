import Foundation

enum ClientToServerActionType: String {
    case fullClientUpdate
    case stateUpdate
}

struct ClientToServerAction: Decodable {
    var type: String
    var data: Data
}
