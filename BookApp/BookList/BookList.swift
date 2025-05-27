import SwiftUI
import SwiftData

struct BookList: View {
    @Query(sort: [SortDescriptor(\Book.id)]) var books: [Book]
    @State var showAddScreen = false
    @StateObject var vm: BookListViewModel = BookListViewModel()
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                List(books) { book in
                    BookCard(
                        book: book,
                        onToggle: { vm.send(.ToggleReadState(book)) }
                    ).onLongPressGesture {
                        context.delete(book)
                    }
                }
                
                Button {
                    showAddScreen = true
                } label: {
                    Image(systemName: "plus")
                        .font(.title.weight(.semibold))
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding()
                .navigationTitle("Books")
                .navigationDestination(isPresented: $showAddScreen) {
                    BookAdd()
                }
            }
        }
    }
}

#Preview {
    let preview = BookListPreview()
    preview.populate()
    return BookList(vm: BookListViewModel())
        .modelContainer(preview.modelContainer)
}
