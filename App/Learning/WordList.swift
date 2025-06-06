import Foundation

struct WordList {
    static func load() -> [String] {
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let words = try? JSONDecoder().decode([String].self, from: data) else {
            return []
        }
        return words
    }
}
