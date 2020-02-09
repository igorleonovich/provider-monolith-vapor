import Vapor

struct WebSockets {
    
    static func configure(_ webSocketServer: NIOWebSocketServer) {
        
        webSocketServer.get("connect", Client.parameter) { webSocket, req in

            webSocket.onText { webSocket, text in
                
                print("ws received text: \(text)")
            }

            webSocket.onBinary { webSocket, data in
                
                print("ws received data: \(data)")
                
                do {
                    let clientToServerAction = try JSONDecoder().decode(ClientToServerAction.self, from: data)

                    let _ = try req.parameters.next(Client.self).flatMap { client -> Future<Client> in

                        if let clientToServerActionType = ClientToServerActionType.init(rawValue: clientToServerAction.type) {

                            switch clientToServerActionType {

                            case .fullClientUpdate:
                                print("[fullClientUpdate]")
                                let newClient = try JSONDecoder().decode(LocalClient.self, from: clientToServerAction.data)

                                client.hostName = newClient.hostName
                                client.userName = newClient.userName
                                client.osType = newClient.osType
                                client.osVersion = newClient.osVersion
                                client.kernelType = newClient.kernelType
                                client.kernelVersion = newClient.kernelVersion
                                client.state = newClient.state

                            case .stateUpdate:
                                if let newClientStateString = String(data: clientToServerAction.data, encoding: .utf8),
                                    let newClientState = ClientState.init(rawValue: newClientStateString) {

                                    client.state = newClientState.rawValue
                                    print("[stateUpdate] \(newClientState)")
                                }
                            }
                        }

                        return client.save(on: req)
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
}
