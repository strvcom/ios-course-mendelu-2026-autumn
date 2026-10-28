import Foundation
import Helpers
import Playgrounds

// MARK: - DEMO 5a · What may cross an isolation boundary?

/// Value type: the receiver gets its own copy → Sendable.
struct Article {
    var title: String

    init(title: String) {
        self.title = title
    }
}

actor Newsroom {
    var published: [String] = []

    func publish(_ article: Article) {
        published.append(article.title)
    }
}

#Playground("5a · What may cross an isolation boundary?") {
    let newsroom = Newsroom()

    var article = Article(title: "MyTitle")
    await newsroom.publish(article) // ✅ the actor gets its own copy
    article.title = "EditedTitle" // ✅ we only change OUR copy

    print(await newsroom.published)
}
