import Vapor
import ProviderSDK

struct WebSocketsManager {
    
    static var clients = [UUID: WebSocket]()
    
    static func configure(_ webSocketServer: NIOWebSocketServer) {
        
        webSocketServer.get("echo") { ws, req in
            ws.onText { (ws, text) in
                print("\(Date()) [echo] \(text)")
                ws.send("echo: \(text)")
            }
        }
        
        webSocketServer.get("connect", ProviderClient.parameter) { webSocket, req in
            
            print("\(Date()) [ws] [client connected]")
            
            var clientID: UUID!
            
            let _ = try req.parameters.next(ProviderClient.self).flatMap { client -> Future<ProviderClient> in
                
                webSocket.send("clientID OK")
                
                clientID = client.id
                clients[clientID] = webSocket
                
                webSocket.onText { webSocket, text in
                    
                    print("\(Date()) [ws] [text from client] \(text)")
                }

                webSocket.onBinary { webSocket, data in
                    
//                     print("[ws] [data from client] \(data)")
                    
                    _ = ProviderClient.find(clientID, on: req).map { client in
                        
                        guard let client = client else { return }
                        
                        do {
                            let clientToServerAction = try JSONDecoder().decode(ClientToServerAction.self, from: data)
                            if let clientToServerActionType = ClientToServerActionType.init(rawValue: clientToServerAction.type) {

                                switch clientToServerActionType {

                                case .fullClientUpdate:
                                    
                                    print("\(Date()) [\(client.userName)@\(client.hostName)] [fullClientUpdate]")
                                    let newClient = try JSONDecoder().decode(ProviderLocalClient.self, from: clientToServerAction.data)

                                    client.hostName = newClient.hostName!
                                    client.userName = newClient.userName!
                                    client.osType = newClient.osType!
                                    client.osVersion = newClient.osVersion!
                                    client.kernelType = newClient.kernelType!
                                    client.kernelVersion = newClient.kernelVersion!
                                    client.state = newClient.state!
                                    client.cpuUsage = newClient.cpuUsage
                                    client.freeRAM = newClient.freeRAM

                                case .partialClientUpdate:
                                    
                                    let partiallyUpdatedClient = try JSONDecoder().decode(ProviderLocalClient.self, from: clientToServerAction.data)
                                    
                                    if let updatedState = partiallyUpdatedClient.state {
                                        client.state = updatedState
                                        print("\(Date()) [\(client.userName)@\(client.hostName)] [state] \(updatedState)")
                                    }
                                    
                                    if let updatedCPUUsage = partiallyUpdatedClient.cpuUsage {
                                        client.cpuUsage = updatedCPUUsage
                                        print("\(Date()) [\(client.userName)@\(client.hostName)] [cpuUsage] \(updatedCPUUsage)")
                                    }
                                    
                                    if let updatedFreeRAM = partiallyUpdatedClient.freeRAM {
                                        client.freeRAM = updatedFreeRAM
                                        print("\(Date()) [\(client.userName)@\(client.hostName)] [freeRAM] \(updatedFreeRAM)")
                                    }
                                }
                            }
                        } catch {
                            print(error)
                        }
                        
                        let _ = client.save(on: req)
                    }
                }
                
                _ = webSocket.onClose.map {
                    _ = ProviderClient.find(clientID, on: req).map { client in
                        guard let client = client else { return }
                        print("\(Date()) [ws] [closed] [\(client.userName)@\(client.hostName)]")
                        _ = ProviderClientController.resetStats(on: req, client: client)
                    }
                }
                
                webSocket.onError { webSocket, error in
                    _ = ProviderClient.find(clientID, on: req).map { client in
                        guard let client = client else { return }
                        print("\(Date()) [ws] [error] [\(client.userName)@\(client.hostName)] \(error)")
                    }
                }
                
                return client.save(on: req)
            }.catch { error in
                print(error)
                webSocket.send("clientID FAIL")
                webSocket.close()
                print("\(Date()) [ws] [closed]")
            }
        }
        
        print("\(Date()) [ws] [server configured]")
    }
}
