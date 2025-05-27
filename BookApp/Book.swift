import Foundation
import SwiftData

@Model
class Book: Identifiable {
    init(id: Int = 0, title: String = "", author: String = "", isbn: String = "", readState: ReadState = .Unread, cover: Data? = nil) {
        self.id = id
        self.title = title
        self.author = author
        self.isbn = isbn
        self.readState = readState
        self.cover = cover
    }
    
    @Attribute(.unique) var id: Int
    var title: String
    var author: String
    var isbn: String
    var readState: ReadState
    var cover: Data?

    func toggleReadState() {
        readState = readState.info.next
    }
}

enum ReadState: String, Codable {
    case Unread, Partial, Read

    var info: (text: String, icon: String, next: ReadState) {
        switch self {
            case .Unread: ("Not read", "book", .Partial)
            case .Partial: ("Reading", "bookmark", .Read)
            case .Read: ("Read", "book.fill", .Unread)
        }
    }
}
