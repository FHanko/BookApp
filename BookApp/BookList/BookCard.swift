import SwiftUI
import Foundation

struct BookCard:View {
    let coverWidth = 70.0
    var coverHeight: Double { coverWidth * sqrt(2.0) }
    var book: Book
    var onToggle: () -> Void

    var body: some View {
        HStack {
            if let cover = book.cover {
                Image(uiImage: UIImage(data: cover)!)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: coverWidth, height: coverHeight, alignment: .topTrailing)
            } else {
                Rectangle()
                    .frame(width: coverWidth, height: coverHeight)
            }
            
            VStack(alignment: .leading) {
                Text(book.title)
                    .font(.headline)
                Text(book.author)
                Spacer()
                Text(book.isbn)
                    .font(.footnote)
            }
            Spacer()
            ReadStateToggle(book: book, onToggle: onToggle)
        }
        .frame(maxHeight: coverHeight)
    }
}

struct ReadStateToggle: View {
    var book: Book
    var onToggle: () -> Void

    var body: some View {
        VStack {
            Button {
                onToggle()
            } label: {
                Image(systemName: "\(book.readState.info.icon)")
                    .font(.title)
                Text("\(book.readState.info.text)")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .frame(width: 60)
            }
        }
    }
}

#Preview {
    BookCard(
        book: Book(id: 1, title: "1984", author: "George Orwell", isbn: "9780451524935", readState: .Read)) {
            
        }
}
