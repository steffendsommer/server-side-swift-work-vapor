import Fluent
import FluentMySQL
import Vapor

internal final class APIWorkController {
    // MARK: List

    func workList(_ req: Request) throws -> Future<[Work]> {
        return Work
            .query(on: req)
            .filter(\.approvedAt != nil)
            .sort(\.approvedAt, .descending)
            .all()
            .thenThrowing { items in
                guard items.count > 0 else {
                    throw WorkError.noWorkAvailable
                }
                return items
            }
    }

    // MARK: Single item

    func work(_ req: Request) throws -> Future<Work> {
        return try req.parameters.next(Work.self)
    }
}

extension WorkError: AbortError {
    var identifier: String {
        return "noWork"
    }

    var status: HTTPResponseStatus {
        return .custom(code: self.httpCode, reasonPhrase: "No work available")
    }

    var reason: String {
        return "Unfortunately, no work available at this moment."
    }
}
