import Vapor

let sessionManager = SessionManager()

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    router.get { req in
        return "/"
    }
    
    router.post("create", use: sessionManager.createTrackingSession)

    // Example of configuring a controller
    let clientController = ClientController()
    router.get("clients", use: clientController.index)
    router.post("clients", use: clientController.create)
    router.delete("clients", Client.parameter, use: clientController.delete)
}
