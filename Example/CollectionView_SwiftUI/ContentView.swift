//
//  ContentView.swift
//  Example
//
//  Created by FunWidget on 2024/4/22.
//

import SwiftUI
import OrderedCollections
import CollectionView_SwiftUI
struct ContentView: View {
    @State
    var items: OrderedDictionary<Testing.Sections, [Testing.Item]> = .gridData // .dummyData()
    @State var selection: Testing.Item? = nil
    
    var body: some View {
        
        CollectionView($items,
                       selection: $selection,
                       layout: gridLayout(), // compositionalLayout()
                       cellBackground: Color.gray) { indexPath, item in
            VStack {
                Image(systemName: item.systemImageName)
                Text(item.title)
                Text(item.subtitle)
            }
        }
                       .padding(.horizontal, 10)
        
    }

    func gridLayout()->UICollectionViewLayout{
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        
        layout.itemSize = CGSize(width: 88, height: 88)
        return layout
    }
    
    func compositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let leadingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                                   heightDimension: .fractionalHeight(1.0)))
            leadingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            let trailingItem = NSCollectionLayoutItem(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.3)))
            trailingItem.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            let trailingGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                                   heightDimension: .fractionalHeight(1.0)),
                subitem: trailingItem, count: 2)
            
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .fractionalHeight(0.4)),
                subitems: [leadingItem, trailingGroup])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            section.orthogonalScrollingBehavior = .continuous
            return section
            
        }
        return layout
    }
    
    
    func listLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout.list(using: .init(appearance: .insetGrouped))
    }
    
}

#Preview {
    ContentView()
}

enum Testing {
    enum Sections: String, Hashable {
        case section1
        case section2
    }
    
    struct Item: Hashable {
        var title: String
        var subtitle: String
        var systemImageName: String
    }
}

extension OrderedDictionary where Key == Testing.Sections, Value == [Testing.Item] {
    internal static var dummyData: Self {
        [
            .section1: [
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill")
            ],
            .section2: [
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "books.vertical.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
            ]
        ]
    }
    
    internal static var gridData: Self {
        [
            .section1: [
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "books.vertical.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "books.vertical.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "books.vertical.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "books.vertical.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "books.vertical.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "books.vertical.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "books.vertical.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "books.vertical.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
                Testing.Item(title: String(UUID().uuidString.prefix(8)), subtitle: String(UUID().uuidString.prefix(8)), systemImageName: "trash.fill"),
            ],
 
        ]
    }
}
