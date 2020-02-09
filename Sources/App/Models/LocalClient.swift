import Foundation

struct LocalClient: Decodable {
    var hostName: String
    var userName: String
    var osType: String
    var osVersion: String
    var kernelType: String
    var kernelVersion: String
    var state: String
}
