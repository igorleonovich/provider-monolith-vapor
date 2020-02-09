import Foundation

enum ClientToServerActionType: String {
    case fullClientUpdate
    case statusUpdate
}

struct ClientToServerAction: Decodable {
    var type: String
    var data: Data
}
