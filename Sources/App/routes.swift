import Vapor

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    router.get { req in
        return "👋"
    }

    let clientController = ClientController()
    router.get("clients", use: clientController.index)
    router.post("clients", use: clientController.create)
    router.delete("clients", Client.parameter, use: clientController.delete)
    router.get("clients", "resetStats", use: clientController.resetStats)
    
    let deploymentController = DeploymentController()
    router.get("deployments", use: deploymentController.index)
    router.post("deployments", use: deploymentController.create)
    router.delete("deployments", Deployment.parameter, use: deploymentController.delete)
}
