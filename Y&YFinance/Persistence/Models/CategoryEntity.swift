import Foundation
import SwiftData

@Model
final class CategoryEntity {
    @Attribute(.unique) var id: Int
    var name: String
    var emoji: String
    var directionRaw: String       // "income"/"outcome"

    init(id: Int,
         name: String,
         emoji: String,
         directionRaw: String) {
        self.id  = id
        self.name = name
        self.emoji = emoji
        self.directionRaw = directionRaw
    }
}
