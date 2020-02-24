import Vapor
import ProviderSDK

struct WebSocketsManager {
    
    static var clients = [UUID: WebSocket]()
    
    static func configure(_ webSocketServer: NIOWebSocketServer) {
        
        webSocketServer.get("echo") { ws, req in
            ws.onText { (ws, text) in
                print("[echo] \(text)")
                ws.send("echo: \(text)")
            }
        }
        
        webSocketServer.get("connect", ProviderClient.parameter) { webSocket, req in
            
            print("[ws connected]")
            
            let _ = try req.parameters.next(ProviderClient.self).flatMap { client -> Future<ProviderClient> in
                
                clients[client.id!] = webSocket
                
                webSocket.onText { webSocket, text in
                    
                    print("[ws text] \(text)")
                }

                webSocket.onBinary { webSocket, data in
                    
                    // print("[ws data] \(data)")
                    
                    ProviderClient.find(client.id!, on: req).do { client in
                        
                        guard let client = client else { return }
                        
                        do {
                            let clientToServerAction = try JSONDecoder().decode(ClientToServerAction.self, from: data)
                            if let clientToServerActionType = ClientToServerActionType.init(rawValue: clientToServerAction.type) {

                                switch clientToServerActionType {

                                case .fullClientUpdate:
                                    
                                    print("\(Date()) [\(client.hostName)] [fullClientUpdate]")
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
                                        print("\(Date()) [\(client.hostName)] [state] \(updatedState)")
                                    }
                                    
                                    if let updatedCPUUsage = partiallyUpdatedClient.cpuUsage {
                                        client.cpuUsage = updatedCPUUsage
                                        print("\(Date()) [\(client.hostName)] [cpuUsage] \(updatedCPUUsage)")
                                    }
                                    
                                    if let updatedFreeRAM = partiallyUpdatedClient.freeRAM {
                                        client.freeRAM = updatedFreeRAM
                                        print("\(Date()) [\(client.hostName)] [freeRAM] \(updatedFreeRAM)")
                                    }
                                }
                            }
                        } catch {
                            print(error)
                        }
                        
                        let _ = client.save(on: req)
                    }.catch { error in
                        print(error)
                    }
                }
                
                webSocket.onCloseCode { wsErrorCode in
                    print("[ws closed] \(wsErrorCode)")
                    ProviderClientController.resetStats(on: req)
                }
                
                webSocket.onError { webSocket, error in
                    print("[ws error] \(error)")
                }
                
                return client.save(on: req)
            }
        }
    }
}
