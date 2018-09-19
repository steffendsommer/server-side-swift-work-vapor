import Fluent
import ServerSideSwiftWorkShared
import Submissions
import Sugar
import Validation
import Vapor

extension Work: Submittable {
    public struct Submission: SubmissionType {
        let company: String?
        let companyLogoUrl: String?
        let location: String?
        let kind: String?
        let framework: String?
        let remoteAllowed: Bool?
        let title: String?
        let description: String?
        let externalUrl: String?
        let contactEmail: String?

        public init(_ work: Work?) {
            company = work?.company
            companyLogoUrl = work?.companyLogoUrl
            location = work?.location
            kind = work?.kind.rawValue
            framework = work?.framework.rawValue
            remoteAllowed = work?.remoteAllowed
            title = work?.title
            description = work?.description
            externalUrl = work?.externalUrl
            contactEmail = work?.contactEmail
        }

        public func fieldEntries() throws -> [FieldEntry<Work>] {
            return try [
                makeFieldEntry(
                    keyPath: \.company,
                    label: "Company",
                    validators: [.count(2...191)]
                ),
                makeFieldEntry(
                    keyPath: \.companyLogoUrl,
                    label: "Company logo URL",
                    validators: [.count(2...191)]
                ),
                makeFieldEntry(
                    keyPath: \.location,
                    label: "Location",
                    validators: [.count(2...191)]
                ),
                makeFieldEntry(
                    keyPath: \.kind,
                    label: "Kind",
                    validators: [.enum(Kind.self)]
                ),
                makeFieldEntry(
                    keyPath: \.framework,
                    label: "Framework",
                    validators: [.enum(Framework.self)]
                ),
                makeFieldEntry(
                    keyPath: \.remoteAllowed,
                    label: "Remote allowed"
                ),
                makeFieldEntry(
                    keyPath: \.title,
                    label: "Title",
                    validators: [.count(2...191)]
                ),
                makeFieldEntry(
                    keyPath: \.description,
                    label: "Description",
                    validators: [.count(2...500)]
                ),
                makeFieldEntry(
                    keyPath: \.externalUrl,
                    label: "External URL (for the work)",
                    validators: [.count(2...191)]
                ),
                makeFieldEntry(
                    keyPath: \.contactEmail,
                    label: "Your email",
                    validators: [.email]
                )
            ]
        }
    }

    public struct Create: Decodable {
        let company: String
        let companyLogoUrl: String
        let location: String
        let kind: Kind
        let framework: Framework
        let remoteAllowed: Bool
        let title: String
        let description: String
        let externalUrl: String
        let contactEmail: String
    }

    public convenience init(_ create: Create) throws {
        self.init(
            company: create.company,
            companyLogoUrl: create.companyLogoUrl,
            location: create.location,
            kind: create.kind,
            framework: create.framework,
            remoteAllowed: create.remoteAllowed,
            title: create.title,
            description: create.description,
            externalUrl: create.externalUrl,
            contactEmail: create.contactEmail
        )
    }

    public func update(_ submission: Submission) throws {
        if let company = submission.company, !company.isEmpty {
            self.company = company
        }

        if let companyLogoUrl = submission.companyLogoUrl, !companyLogoUrl.isEmpty {
            self.companyLogoUrl = companyLogoUrl
        }

        if let location = submission.location, !location.isEmpty {
            self.location = location
        }

        if let kindRaw = submission.kind, let kind = Kind(rawValue: kindRaw) {
            self.kind = kind
        }

        if
            let frameworkRaw = submission.framework,
            let framework = Framework(rawValue: frameworkRaw)
        {
            self.framework = framework
        }

        if let remoteAllowed = submission.remoteAllowed {
            self.remoteAllowed = remoteAllowed
        }

        if let title = submission.title, !title.isEmpty {
            self.title = title
        }

        if let description = submission.description, !description.isEmpty {
            self.description = description
        }

        if let externalUrl = submission.externalUrl, !externalUrl.isEmpty {
            self.externalUrl = externalUrl
        }

        if let contactEmail = submission.contactEmail, !contactEmail.isEmpty {
            self.contactEmail = contactEmail
        }
    }
}
