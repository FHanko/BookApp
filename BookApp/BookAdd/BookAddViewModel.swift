import Foundation
import Combine

final class BookAddViewModel: ObservableObject {
    @Published var search = ""
    @Published var books = [ApiBook]()
    @Published var isLoading = false
    var cancellables = [AnyCancellable]()
    var apiTask: Task<Void, Never>? = nil
    
    init() {
        $search
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            //.throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
            .sink { value in
                if (value.count >= 3) {
                    self.isLoading = true
                    self.apiTask?.cancel()
                    self.apiTask = Task {
                        await self.searchBook(query: value)
                    }
                } else {
                    self.books = []
                    self.isLoading = false
                }
            }.store(in: &cancellables)
    }
    
    @MainActor
    func loadCover(_ book: ApiBook) {
        guard let index = books.firstIndex(where: { $0.key == book.key }) else { return }
        
        Task {
            do {
                books[index].coverLoading = true
                let cover = try await OpenLibraryApi.loadCover(book)
                books[index].cover = cover
            } catch let error as OpenLibraryApi.ApiError {
                switch error {
                case .isbnError(let message), .urlError(let message):
                    print(message)
                }
            } catch {
                print(error)
            }
            books[index].coverLoading = false
        }
    }
    
    @MainActor
    private func searchBook(query: String) async {
        do {
            books = try await OpenLibraryApi.queryBooks(query)
        } catch let error as URLError {
            if (error.code == URLError.cancelled) {
                return
            }
            print("URL Error \(error)")
        } catch {
            print("Search error \(type(of: error)) \(error)")
        }
        self.isLoading = false
    }
    
    private func convertBook() {
        
    }
}

