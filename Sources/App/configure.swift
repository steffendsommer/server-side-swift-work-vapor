import Bootstrap
import Flash
import FluentMySQL
import Leaf
import ServerSideSwiftWorkShared
import Submissions
import Sugar
import Vapor

/// Called before your application initializes.
public func configure(
    _ config: inout Config,
    _ env: inout Environment,
    _ services: inout Services
) throws {
    try providers(&services, env)
    try routes(&services)
    try middlewares(&services)
    try databases(&services)
    try migrations(&services)

    config.prefer(MemoryKeyedCache.self, for: KeyedCache.self)
}

// MARK: Providers

private func providers(_ services: inout Services, _ environment: Environment) throws {
    try services.register(FluentMySQLProvider())
    try services.register(LeafProvider())
    try services.register(MutableLeafTagConfigProvider())
    try services.register(SubmissionsProvider())
    try services.register(FlashProvider())
    try services.register(BootstrapProvider())
}

// MARK: Databases

private func databases(_ services: inout Services) throws {
    guard let config = try MySQLDatabaseConfig(url: env(EnvironmentKey.MySQL.connection, "")) else {
        throw Abort(.internalServerError, reason: "Could not connect to MySQL")
    }

    let mysql = MySQLDatabase(config: config)
    var databases = DatabasesConfig()
    databases.add(database: mysql, as: .mysql)
    services.register(databases)
}

// MARK: Migrations

private func migrations(_ services: inout Services) throws {
    var config = MigrationConfig()
    config.add(model: Work.self, database: .mysql)
    services.register(config)
}

// MARK: Middlewares

private func middlewares(_ services: inout Services) throws {
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    middlewares.use(SessionsMiddleware.self)
    middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    middlewares.use(FlashMiddleware.self)
    services.register(middlewares)
}

// MARK: Routes

private func routes(_ services: inout Services) throws {
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
}
