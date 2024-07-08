//
//  AutoScrollHeaderView.swift
//  autoScrollHeader
//
//  Created by Diego Henrick on 08/07/24.
//

import Foundation
import SwiftUI

struct MenuItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let description: String
}

public struct AutoScrollHeaderView: View {

        
    private let menuItems: [String: [MenuItem]] = [
        "Pizzas": [
            MenuItem(name: "Pizza Margherita", description: "Molho de tomate, mussarela de búfala, manjericão fresco e azeite extra virgem."),
            MenuItem(name: "Pizza Pepperoni", description: "Molho de tomate, mussarela e fatias de pepperoni."),
            MenuItem(name: "Pizza Quatro Queijos", description: "Molho de tomate, mussarela, gorgonzola, parmesão e provolone."),
            MenuItem(name: "Pizza Calabresa", description: "Molho de tomate, mussarela e fatias de calabresa."),
            MenuItem(name: "Pizza Portuguesa", description: "Molho de tomate, mussarela, presunto, cebola, ovos e azeitonas."),
            MenuItem(name: "Pizza Frango com Catupiry", description: "Molho de tomate, mussarela, frango desfiado e catupiry.")
        ],
        "Pizzas Veganas": [
            MenuItem(name: "Pizza Vegana de Legumes", description: "Molho de tomate, mussarela vegana, pimentão, cebola, cogumelos e azeitonas."),
            MenuItem(name: "Pizza Vegana de Margherita", description: "Molho de tomate, mussarela vegana, manjericão fresco e azeite extra virgem."),
            MenuItem(name: "Pizza Vegana de Brócolis", description: "Molho de tomate, mussarela vegana, brócolis e alho."),
            MenuItem(name: "Pizza Vegana de Abobrinha", description: "Molho de tomate, mussarela vegana, abobrinha grelhada e manjericão."),
            MenuItem(name: "Pizza Vegana de Alcachofra", description: "Molho de tomate, mussarela vegana, alcachofra e pimentão."),
            MenuItem(name: "Pizza Vegana de Espinafre", description: "Molho de tomate, mussarela vegana, espinafre e tomate seco.")
        ],
        "Combos": [
            MenuItem(name: "Combo Família", description: "Duas pizzas grandes, uma sobremesa e uma bebida à escolha."),
            MenuItem(name: "Combo Individual", description: "Uma pizza média e uma bebida à escolha."),
            MenuItem(name: "Combo Duplo", description: "Duas pizzas médias e duas bebidas à escolha."),
            MenuItem(name: "Combo Amigos", description: "Três pizzas grandes e três bebidas à escolha."),
            MenuItem(name: "Combo Festa", description: "Quatro pizzas grandes, duas sobremesas e quatro bebidas à escolha."),
            MenuItem(name: "Combo Executivo", description: "Uma pizza grande, uma sobremesa e uma bebida à escolha.")
        ],
        "Sobremesas": [
            MenuItem(name: "Brownie de Chocolate", description: "Brownie de chocolate quente servido com sorvete de baunilha."),
            MenuItem(name: "Tiramisu", description: "Tradicional sobremesa italiana feita com mascarpone, café e cacau."),
            MenuItem(name: "Cheesecake de Morango", description: "Cheesecake clássico com calda de morango."),
            MenuItem(name: "Pudim de Leite", description: "Pudim de leite condensado com calda de caramelo."),
            MenuItem(name: "Petit Gâteau", description: "Bolo de chocolate com recheio cremoso servido com sorvete de baunilha."),
            MenuItem(name: "Mousse de 6`", description: "Mousse leve e aerada de maracujá.")
        ],
        "Bebidas": [
            MenuItem(name: "Coca-Cola", description: "Lata de 350ml."),
            MenuItem(name: "Suco de Laranja", description: "Suco de laranja natural."),
            MenuItem(name: "Água Mineral", description: "Garrafa de 500ml."),
            MenuItem(name: "Chá Gelado de Limão", description: "Garrafa de 500ml."),
            MenuItem(name: "Cerveja Artesanal", description: "Garrafa de 500ml."),
            MenuItem(name: "Refrigerante Diet", description: "Lata de 350ml.")
        ]
    ]

    @State static var itemNames: [String] = [
        "Pizzas",
        "Pizzas Veganas",
        "Combos",
        "Sobremesas",
        "Bebidas"]
    
    @State private var activeSection: String = itemNames[0]
    @State private var animationProgress: CGFloat = 0
    @State private var scrollableTabOffset: CGFloat = 0
    @State private var initialOffset: CGFloat = 0
    
    private var coordinateSpaceName: String = "ContentView"
    
    public var body: some View {
        Rectangle()
            .fill(.white)
            .frame(maxHeight: 20)
        
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(AutoScrollHeaderView.itemNames, id: \.self) { section in
                    sectionView(section)
                        .offset(coordinateSpaceName) { rect in
                            updateActiveSectionOnScrollOffset(sectionName: section, sectionOffset: rect)
                        }
                }
                .offset(coordinateSpaceName) { rect in
                    scrollableTabOffset = rect.minY - initialOffset
                }
            }
            .offset(coordinateSpaceName) { rect in
                initialOffset = rect.minY
            }
            .safeAreaInset(edge: .top) {
                AutoScrollHeader(sections: AutoScrollHeaderView.itemNames,
                           animationProgress: $animationProgress,
                           activeTab: $activeSection,
                           proxy) { _ in }
                    .offset(y: scrollableTabOffset > 0 ? scrollableTabOffset : 0)
            }
        }
        .coordinateSpace(name: coordinateSpaceName)
    }
    
    private func updateActiveSectionOnScrollOffset(sectionName section: String, sectionOffset rect: CGRect) {
        let minY = rect.minY
        if (minY < 30 && -minY < (rect.midY / 2) && activeSection != section)
            && animationProgress == 0 {
            withAnimation(.easeInOut(duration: 0.3)) {
                activeSection = (minY < 30 && -minY < (rect.midY / 2) && activeSection != section)
                ? section
                : activeSection
            }
        }
    }
    
    @ViewBuilder
    func sectionView(_ sectionTitle: String) -> some View {

        VStack(alignment: .leading, spacing: 15) {
            Divider()
            Text(sectionTitle)
                .font(.title3)
                .fontWeight(.medium)
                .font(.body)
                .padding(.leading)


            
            ForEach(menuItems[sectionTitle]!, id: \.self) { item in
                Divider()
                Text(item.name)
                    .font(.body)
                Text(item.description)
                    .foregroundStyle(.gray)
            }
            
        }
        .padding(15)
        .id(sectionTitle)
    }
}

#Preview {
    AutoScrollHeaderView()
}


