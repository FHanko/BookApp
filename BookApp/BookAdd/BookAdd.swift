import Foundation
import SwiftUI

struct BookAdd: View {
    @StateObject private var vm = BookAddViewModel()
    @FocusState private var titleIsFocused: Bool
    
    var body: some View {
        VStack {
            if (vm.isLoading) {
                ProgressView()
            } else if (vm.books.isEmpty) {
                Text("No books found.")
            } else {
                List(vm.books) { book in
                    Button {
                        vm.loadCover(book)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(book.title)
                            Text(book.author_name.first ?? "").font(.footnote)
                        }
                    }
                }
            }
        }
        .searchable(text: $vm.search, prompt: "Search").font(.title3)
        .navigationTitle("Add Book")
    }
}
