import Vapor
import ProviderSDK

struct WebSocketsManager {
    
    static var clients = [UUID: WebSocket]()
    
    static func configure(_ webSocketServer: NIOWebSocketServer) {
        
        webSocketServer.get("connect", Client.parameter) { webSocket, req in
            
            let _ = try req.parameters.next(Client.self).flatMap { client -> Future<Client> in
                
                clients[client.id!] = webSocket
                
                webSocket.onText { webSocket, text in
                    
                    print("ws received text: \(text)")
                }

                webSocket.onBinary { webSocket, data in
                    
                    print("ws received data: \(data)")
                    
                    Client.find(client.id!, on: req).do { client in
                        
                        guard let client = client else { return }
                        
                        do {
                            let clientToServerAction = try JSONDecoder().decode(ClientToServerAction.self, from: data)
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
                        } catch {
                            print(error)
                        }
                        
                        client.save(on: req)
                    }.catch { error in
                        print(error)
                    }
                }
                return client.save(on: req)
            }
        }
    }
}
