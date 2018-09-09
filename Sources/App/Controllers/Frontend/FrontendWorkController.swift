import Flash
import Fluent
import FluentMySQL
import Leaf
import Submissions
import Vapor

internal final class FrontendWorkController {
    // MARK: List
    func renderList(_ req: Request) throws -> Future<View> {
        return Work.query(on: req).filter(\.approvedAt != nil).all()
            .flatMap(to: View.self) { work in
                return try req.privateContainer
                    .make(LeafRenderer.self)
                    .render("App/Frontend/Work/index", List(data: work))
        }
    }

    // MARK: Create

    func renderCreate(_ req: Request) throws -> Future<View> {
        try req.populateFields(Work.self)
        return try req.privateContainer
            .make(LeafRenderer.self)
            .render("App/Frontend/Work/create")
    }

    public func create(_ req: Request) throws -> Future<Response> {
        let submission = try req.content.decode(Work.Submission.self)

        return submission
            .createValid(on: req)
            .save(on: req)
            .map(to: Response.self) { _ in
                req
                    .redirect(to: "/")
                    .flash(.success, "Work has been submitted. It will be published after it has been approved.")
            }
            .catchFlatMap(handleValidationError(
                path: "App/Frontend/Work/create",
                on: req)
            )
    }
}

private extension FrontendWorkController {
    struct List: Codable {
        let data: [Work]
    }
}
