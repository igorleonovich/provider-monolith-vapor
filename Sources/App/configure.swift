import Vapor
import FluentPostgreSQL
import ProviderSDK

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
//    try services.register(FluentSQLiteProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)
    
    try services.register(FluentPostgreSQLProvider())
    let pgSQL = PostgreSQLDatabaseConfig(hostname: "localhost", username: "c-ceo", database: "Provider")
    services.register(pgSQL)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: ProviderClient.self, database: .psql)
    migrations.add(model: ProviderManager.self, database: .psql)
    migrations.add(model: Deployment.self, database: .psql)
    services.register(migrations)
    
    // WebSockets
    let webSocketServer = NIOWebSocketServer.default()
    WebSocketsManager.configure(webSocketServer)
    services.register(webSocketServer, as: WebSocketServer.self)
}
