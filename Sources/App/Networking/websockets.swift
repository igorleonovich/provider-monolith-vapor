import Vapor
import ProviderSDK

struct WebSockets {
    
    static var clientID: UUID? = nil
    
    static func configure(_ webSocketServer: NIOWebSocketServer) {
        
        webSocketServer.get("connect", Client.parameter) { webSocket, req in
            
            let _ = try req.parameters.next(Client.self).flatMap { client -> Future<Client> in
                clientID = client.id
                return client.save(on: req)
            }

            webSocket.onText { webSocket, text in
                
                print("ws received text: \(text)")
            }

            webSocket.onBinary { webSocket, data in
                
                print("ws received data: \(data)")
                
                Client.find(clientID!, on: req).do { client in
                    
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
        }
    }
}
