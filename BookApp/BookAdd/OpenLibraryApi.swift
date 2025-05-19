import Foundation

class OpenLibraryApi {
    static private let host = "openlibrary.org"
    
    enum ApiError: Error {
        case urlError(String), isbnError(String)
    }
    
    enum CoverSize: String { case S, M, L }
    static func getCoverUrl(_ isbn: String, _ size: CoverSize) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "covers.\(host)"
        components.path = "/b/isbn/\(isbn)-\(size).jpg"
        return components.url
    }
    
    static func getQueryUrl(_ query: String, _ fields: [String], _ limit: Int) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = "/search.json"
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: String(limit)),
            URLQueryItem(name: "fields", value: fields.joined(separator: ","))
        ]
        return components.url
    }
    
    static func queryBooks(_ query: String) async throws -> [ApiBook] {
        guard let url = getQueryUrl(query, ["key", "title", "author_name", "isbn"], 10) else {
            throw ApiError.urlError("URL Error.")
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(QueryResponse.self, from: data)
        
        return response.docs
            .sorted { $0.key > $1.key }
    }
    
    static func loadCover(_ book: ApiBook) async throws -> Data {
        guard let isbn = book.isbn.first else { throw ApiError.isbnError("ISBN not found.") }
        guard let url = getCoverUrl(isbn, .M) else { throw ApiError.urlError("URL Error.") }
        
        print(url)
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
}

struct QueryResponse: Decodable {
    var docs = [ApiBook]()
}

struct ApiBook: Decodable, Identifiable {
    var key = ""
    var title = ""
    var author_name = [String]()
    var isbn = [String]()
    var cover: Data?
    var coverLoading: Bool? = false
    
    var id: String { key }
    var model: Book {
        Book(title: title, author: author_name[0], isbn: isbn[0])
    }
}
