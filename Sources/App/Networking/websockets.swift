import Vapor

struct WebSockets {
    
    static func configure(_ webSocketServer: NIOWebSocketServer) {
        
        webSocketServer.get("connect", Client.parameter) { ws, req in
            ws.onText { ws, text in
                print("ws received: \(text)")
                ws.send(text)
                do {
                    let _ = try req.parameters.next(Client.self).flatMap { client -> Future<Client> in
                        client.hostname = "new-hostname"
                        return client.save(on: req)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
