import Foundation
import SwiftUI
import SwiftData

enum BookListIntent {
    case ToggleReadState(Book)
}

final class BookListViewModel: ObservableObject {
    func send(_ intent: BookListIntent) {
        switch intent {
            case .ToggleReadState(let book):
                toggleReadState(book)
        }
    }

    private func toggleReadState(_ book: Book) {
        book.toggleReadState()
    }
}
