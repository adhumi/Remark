import Foundation

struct APIResponse: Codable {
    struct Feed: Codable {
        struct Entry: Codable {
            struct LabelledString: Codable {
                let label: String
            }

            struct Author: Codable {
                let name: LabelledString
                let uri: LabelledString
            }

            let identifier: LabelledString
            let author: Author
            let version: LabelledString
            let rating: LabelledString
            let title: LabelledString
            let content: LabelledString

            enum CodingKeys : String, CodingKey {
                case author
                case version = "im:version"
                case rating = "im:rating"
                case identifier = "id"
                case title
                case content
            }
        }

        let entries: [Entry]

        enum CodingKeys : String, CodingKey {
            case entries = "entry"
        }
    }

    let feed: Feed
}
