import Foundation

class OpenLibraryApi {
    static private let host = "openlibrary.org"
    static private let path = "/search.json"
    
    static func getUrl(_ query: String, _ fields: [String], _ limit: Int) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: String(limit))
        ]
        return components.url
    }
    
    static func queryBooks(_ query: String) async throws -> [ApiBook] {
        guard let url = getUrl(query, ["key", "title", "author_name"], 10) else {
            return []
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(Response.self, from: data)
        return response.docs.sorted { $0.key > $1.key }
    }
}

struct Response: Decodable {
    var docs = [ApiBook]()
}

struct ApiBook: Decodable, Identifiable {
    var key = ""
    var title = ""
    var author_name = [String]()
    
    var id: String { key }
}
