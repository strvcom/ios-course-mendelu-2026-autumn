
import SwiftUI

struct AStack<Content: View>: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        if dynamicTypeSize.isAccessibilitySize {
            VStack(alignment: .leading) {
                content
            }
        } else {
            HStack { content }
        }
    }

}
