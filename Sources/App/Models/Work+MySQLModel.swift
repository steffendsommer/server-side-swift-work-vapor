import Fluent
import FluentMySQL
import MySQL
import ServerSideSwiftWorkShared
import Sugar
import Vapor

// MARK: ReflectionDecodable

extension Work.Framework: ReflectionDecodable {
    public static func reflectDecoded() throws -> (Work.Framework, Work.Framework) {
        return (.vapor, .perfect)
    }
}

extension Work.Kind: ReflectionDecodable {
    public static func reflectDecoded() throws -> (Work.Kind, Work.Kind) {
        return (.fullTime, .partTime)
    }
}

// MARK: MySQLModel

extension Work: MySQLModel {
    public static let createdAtKey: TimestampKey? = \.createdAt
    public static let updatedAtKey: TimestampKey? = \.updatedAt
    public static let deletedAtKey: TimestampKey? = \.deletedAt
}

extension Work: Migration {
    public static func prepare(on connection: MySQLConnection) -> Future<Void> {
        return MySQLDatabase.create(self, on: connection) { builder in
            try addProperties(to: builder, excluding: [
                Work.reflectProperty(forKey: \.description),
                Work.reflectProperty(forKey: \.kind),
                Work.reflectProperty(forKey: \.framework),
            ])

            builder.field(for: \.description, type: .text)
            builder.field(
                for: \.kind,
                type: .enum([
                    Work.Kind.fullTime.rawValue,
                    Work.Kind.partTime.rawValue,
                    Work.Kind.contract.rawValue
                ]))
            builder.field(
                for: \.framework,
                type: .enum([
                    Work.Framework.vapor.rawValue,
                    Work.Framework.perfect.rawValue,
                    Work.Framework.kitura.rawValue,
                    Work.Framework.other.rawValue
                ]))
        }
    }
}

extension Work: Content {}
extension Work: Parameter {}
