import SwiftUI

struct DividerShadowModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var opacity: CGFloat = 0.03
    let radius: CGFloat
    let yOffset: CGFloat
    
    init(opacity: CGFloat = 0.03, radius: CGFloat, yOffset: CGFloat) {
        self.opacity = opacity
        self.radius = radius
        self.yOffset = yOffset
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(Double(colorScheme == .light ? opacity : opacity + 0.4)),
                    radius: radius,
                    x: 0,
                    y: yOffset)
    }
}

struct FloatShadowModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    var opacity: CGFloat = 0.2
    let radius: CGFloat
    let yOffset: CGFloat
    
    init(opacity: CGFloat = 0.2, radius: CGFloat, yOffset: CGFloat) {
        self.opacity = opacity
        self.radius = radius
        self.yOffset = yOffset
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.theme.shadowColor.opacity(Double(colorScheme == .light ? opacity : opacity + 0.4)),
                    radius: radius,
                    x: 0,
                    y: yOffset)
    }
}

extension View {
    func dividerShadow(opacity: CGFloat = 0.03, radius: CGFloat = 1, yOffset: CGFloat = 2) -> some View {
        self.modifier(DividerShadowModifier(opacity: opacity, radius: radius, yOffset: yOffset))
    }
    
    func floatShadow(opacity: CGFloat = 0.2, radius: CGFloat = 20, yOffset: CGFloat = 10) -> some View {
        self.modifier(FloatShadowModifier(opacity: opacity, radius: radius, yOffset: yOffset))
    }
}
