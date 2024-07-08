# Auto-Scrolling Header in SwiftUI

This repository demonstrates a custom SwiftUI implementation for an auto-scrolling header that smoothly transitions between sections as the user scrolls through the content.

## Features

- **Seamless Section Transitions:** The header dynamically highlights the active section based on the user's scroll position.
- **Smooth Animation:** Transitions between sections are animated for a visually pleasing experience.
- **ScrollView Integration:** Easily integrate the header with existing `ScrollView` content.

## Usage

1. **Add the `AutoScrollHeader` and `AutoScrollHeaderView` to your project.**
2. **Define the sections for your header.**
3. **Use the `AutoScrollHeader` in your view, passing the sections and active section binding.**
4. **Implement the `action` closure to handle section selection.**

## Example

```swift
struct ContentView: View {
    @State private var activeSection: String = "Pizzas"
    var sections: [String] = [
        "Pizzas",
        "Pizzas Veganas",
        "Combos",
        "Sobremesas",
        "Bebidas"
    ]

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(sections, id: \.self) { section in
                    SectionView(section: section)
                        .offset(coordinateSpaceName: "ContentView") { rect in
                            updateActiveSectionOnScrollOffset(sectionName: section, sectionOffset: rect)
                        }
                }
                .offset(coordinateSpaceName: "ContentView") { rect in
                    scrollableTabOffset = rect.minY - initialOffset
                }
            }
            .offset(coordinateSpaceName: "ContentView") { rect in
                initialOffset = rect.minY
            }
            .safeAreaInset(edge: .top) {
                AutoScrollHeader(sections: sections,
                           animationProgress: $animationProgress,
                           activeTab: $activeSection,
                           proxy) { _ in }
                    .offset(y: scrollableTabOffset > 0 ? scrollableTabOffset : 0)
            }
        }
        .coordinateSpace(name: "ContentView")
    }

    // ... other logic ...
}
License
This project is licensed under the MIT License - see the LICENSE file for details.

Contributing
Contributions are welcome! Please submit a pull request with a clear description of your changes.

Acknowledgements
This implementation draws inspiration from various existing auto-scrolling header solutions.

Demo Project
This repository includes a demo project to showcase the implementation in action. You can build and run the demo to see how the auto-scrolling header works. ```
