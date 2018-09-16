import Fluent
import FluentMySQL
import Vapor

internal final class APIWorkController {
    // MARK: List

    func workList(_ req: Request) throws -> Future<[Work]> {
        return Work.query(on: req).filter(\.approvedAt != nil).sort(\.approvedAt, .descending).all()
    }

    // MARK: Single item

    func work(_ req: Request) throws -> Future<Work> {
        return try req.parameters.next(Work.self)
    }
}
