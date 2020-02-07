import Vapor

struct WebSockets {
    
    static func configure(_ websockets: NIOWebSocketServer) {
        websockets.get("connect", Client.parameter) { ws, req in
            let client = try req.parameters.next(Client.self)
            print("ws connected with params: ")
            print(req.parameters.values)
            ws.onText { ws, text in
                print("ws received: \(text)")
                ws.send(text)
            }
//            if let clientID = client.id?.uuidString {
//                ClientManager.connectedClients[clientID] = ws
//                print("connected client: ID: \(clientID)")
//            }
        }
    }
}
