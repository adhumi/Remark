import Foundation

public struct Author {
    public let name: String
    public let uri: URL?

    init(author: APIResponse.Feed.Entry.Author) {
        name = author.name.label
        uri = URL(string: author.uri.label)
    }
}

public struct Review: CustomDebugStringConvertible {
    public let identifier: String
    public let author: Author
    public let version: String
    public let rating: Int
    public let title: String
    public let content: String

    init(entry: APIResponse.Feed.Entry) {
        identifier = entry.identifier.label
        author = Author(author: entry.author)
        version = entry.version.label
        rating = Int(entry.rating.label) ?? 0
        title = entry.title.label
        content = entry.content.label
    }

    public var debugDescription: String {
        return "\(title) (\(author.name))\n\(content)"
    }
}
