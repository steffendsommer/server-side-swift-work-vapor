import Validation

extension Validator where T == String {
    public static func `enum`<C>(_ type: C.Type) -> Validator<T> where C: RawRepresentable, C.RawValue == String {
        return EnumValidator<C>().validator()
    }
}

// MARK: Private

fileprivate struct EnumValidator<T>: ValidatorType where T: RawRepresentable, T.RawValue == String {
    typealias ValidationData = String

    /// See `ValidatorType`.
    public var validatorReadable: String {
        return "a valid enum"
    }

    /// Creates a new `EnumValidator`.
    public init() {}

    /// See `Validator`.
    func validate(_ data: String) throws {
        guard T.init(rawValue: data) != nil else {
            throw BasicValidationError("is not a valid enum case")
        }
    }
}
