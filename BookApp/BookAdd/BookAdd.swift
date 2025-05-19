import Foundation
import SwiftUI

struct BookAdd: View {
    let coverWidth = 120.0
    var coverHeight: Double { coverWidth * sqrt(2.0) }
    @StateObject private var vm = BookAddViewModel()
    @FocusState private var titleIsFocused: Bool
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            if (vm.isLoading) {
                ProgressView()
            } else if (vm.books.isEmpty) {
                Text("No books found.")
            } else {
                List(vm.books) { book in
                    if (book.cover != nil) {
                        HStack {
                            VStack {
                                BookText(book: book)
                                Spacer()
                                Button {
                                    context.insert(book.model)
                                    dismiss()
                                } label: {
                                    Text("Add")
                                }.zIndex(5)
                            }.padding(.trailing, 38)
                            Spacer()
                            VStack(alignment: .trailing) {
                                let image = UIImage(data: book.cover!)
                                Image(uiImage: image!)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: coverWidth, height: coverHeight, alignment: .topTrailing)
                            }
                        }
                    } else {
                        HStack {
                            BookText(book: book)
                            if (book.coverLoading == true) {
                                ProgressView()
                            }
                        }.onTapGesture {
                            vm.loadCover(book)
                        }
                    }
                }
            }
        }
        .searchable(text: $vm.search, prompt: "Search").font(.title3)
        .navigationTitle("Add Book")
    }
}

struct BookText: View {
    var book: ApiBook
    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title)
            Text(book.author_name.first ?? "").font(.footnote)
            Spacer()
        }
    }
}
