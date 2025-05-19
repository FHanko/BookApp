
extension Array {
    public mutating func apply(predicate: (Element) -> Bool, update: (inout Element) -> Void) {
        self.indices.filter { predicate(self[$0]) }.forEach {
            update(&self[$0])
        }
    }
}
