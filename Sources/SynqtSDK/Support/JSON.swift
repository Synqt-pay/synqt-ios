import Foundation

/**
 A JSON value, read loosely: a missing, null or empty value reads as nil
 rather than failing the whole response. Numbers stay `Decimal`, so amounts are never rounded through a Double.
 Add-ons read and build SYNQT's JSON with it.
 */
@_spi(SynqtAddon)
public enum JSON: Codable, Equatable, Sendable {
    case string(String), number(Decimal), bool(Bool), object([String: JSON]), array([JSON]), null

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() { self = .null }
        else if let string = try? container.decode(String.self) { self = .string(string) }
        else if let boolean = try? container.decode(Bool.self) { self = .bool(boolean) }
        else if let number = try? container.decode(Decimal.self) { self = .number(number) }
        else if let object = try? container.decode([String: JSON].self) { self = .object(object) }
        else { self = .array(try container.decode([JSON].self)) }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let string): try container.encode(string)
        case .number(let number): try container.encode(number)
        case .bool(let boolean): try container.encode(boolean)
        case .object(let object): try container.encode(object)
        case .array(let array): try container.encode(array)
        case .null: try container.encodeNil()
        }
    }

    public static func parse(_ data: Data) throws -> JSON { try JSONDecoder().decode(JSON.self, from: data) }

    public subscript(key: String) -> JSON? {
        if case .object(let object) = self { return object[key] }
        return nil
    }

    /// The value as text, or nil when it is missing, null, empty or not a scalar.
    public var text: String? {
        switch self {
        case .string(let string): return string.isEmpty ? nil : string
        case .number(let number): return "\(number)"
        case .bool(let boolean): return boolean ? "true" : "false"
        default: return nil
        }
    }

    var bool: Bool { self == .bool(true) || text == "true" }

    var fields: [String: JSON] {
        if case .object(let object) = self { return object }
        return [:]
    }

    /// The array's objects; anything else in it is skipped.
    var objects: [JSON] {
        guard case .array(let array) = self else { return [] }
        return array.filter { if case .object = $0 { return true } else { return false } }
    }

    /// This value as a typed model, or nil if it does not fit.
    func decode<T: Decodable>(_ type: T.Type) -> T? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
