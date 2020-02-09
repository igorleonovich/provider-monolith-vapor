import Vapor

struct WebSockets {
    
    static func configure(_ webSocketServer: NIOWebSocketServer) {
        
        webSocketServer.get("connect", Client.parameter) { ws, req in
            ws.onText { ws, text in
                print("ws received text: \(text)")
//                if let newState = ClientState.init(rawValue: text) {
//                    do {
//                        let _ = try req.parameters.next(Client.self).flatMap { client -> Future<Client> in
//                            client.state = newState.rawValue
//                            return client.save(on: req)
//                        }
//                    } catch {
//                        print(error)
//                    }
//                }
            }
            
            ws.onBinary { ws, data in
                print("ws received data: \(data)")
                do {
                    let clientToServerAction = try JSONDecoder().decode(ClientToServerAction.self, from: data)
                    
                    let _ = try req.parameters.next(Client.self).flatMap { client -> Future<Client> in
                        
                        if let clientToServerActionType = ClientToServerActionType.init(rawValue: clientToServerAction.type) {
                            
                            switch clientToServerActionType {
                                
                            case .fullClientUpdate:
                                print("[fullClientUpdate]")
                                let newClient = try JSONDecoder().decode(Client.self, from: clientToServerAction.data)
                                client.hostName = newClient.hostName
                                client.userName = newClient.userName
                                client.osType = newClient.osType
                                client.osVersion = newClient.osVersion
                                client.kernelType = newClient.kernelType
                                client.kernelVersion = newClient.kernelVersion
                                client.state = newClient.state
                                return client.save(on: req)
                                
                            case .statusUpdate:
                                let newClientStateString = String(data: clientToServerAction.data, encoding: .utf8)
                                if let newClientState = ClientState.init(rawValue: newClientStateString) {
                                    client.state = newClientState
                                    print("[statusUpdate]")
                                }
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
