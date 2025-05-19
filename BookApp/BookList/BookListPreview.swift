import SwiftData

struct BookListPreview {
    let books:[Book] = [
        Book(id: 1, title: "1984", author: "George Orwell", isbn: "9780451524935", readState: .Read),
        Book(id: 2, title: "To Kill a Mockingbird", author: "Harper Lee", isbn: "9780061120084", readState: .Unread),
        Book(id: 3, title: "The Great Gatsby", author: "F. Scott Fitzgerald", isbn: "9780743273565", readState: .Read),
        Book(id: 4, title: "Sapiens: A Brief History of Humankind", author: "Yuval Noah Harari", isbn: "9780062316097", readState: .Partial),
        Book(id: 5, title: "The Catcher in the Rye", author: "J.D. Salinger", isbn: "9780316769488", readState: .Unread),
        //Book(id: 6, title: "Brave New World", author: "Aldous Huxley", isbn: "9780060850524", readState: .Unread),
        //Book(id: 7, title: "The Hobbit", author: "J.R.R. Tolkien", isbn: "9780547928227", readState: .Read),
        //Book(id: 8, title: "Fahrenheit 451", author: "Ray Bradbury", isbn: "9781451673319", readState: .Partial),
        //Book(id: 9, title: "The Road", author: "Cormac McCarthy", isbn: "9780307387899", readState: .Read),
        //Book(id: 10, title: "Thinking, Fast and Slow", author: "Daniel Kahneman", isbn: "9780374533557", readState: .Unread)
    ]
    
    var modelContainer: ModelContainer
        
    init() {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        do {
            modelContainer = try ModelContainer(for: Book.self, configurations: config)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    @MainActor
    func populate() {
        books.forEach { book in
            modelContainer.mainContext.insert(book)
        }
    }
}
