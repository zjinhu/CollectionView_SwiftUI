import SwiftUI

extension CollectionView where Cell == UICollectionViewCell {
    
    public init<Content>(
        _ data: Binding<ItemCollection>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, _ item: Item) -> Content,
        cellConfig: ((Cell, IndexPath, _ item: Item) -> Void)? = nil
    ) where Content: View {
        self.init(data, layout: layout) { cell, indexPath, item in
            cell.contentConfiguration = UIHostingConfigurationBackport {
                cellContent(indexPath, item)
            }
            cellConfig?(cell, indexPath, item)
        }
    }
    
    public init<Content, Background>(
        _ data: Binding<ItemCollection>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, _ item: Item) -> Content,
        @ViewBuilder cellBackground: @escaping (IndexPath, _ item: Item) -> Background,
        cellConfig: ((Cell, IndexPath, _ item: Item) -> Void)? = nil
    ) where Content: View, Background: View {
        self.init(data, layout: layout) { cell, indexPath, item in
            cell.contentConfiguration = UIHostingConfigurationBackport {
                cellContent(indexPath, item)
            }
            .background {
                cellBackground(indexPath, item)
            }
            cellConfig?(cell, indexPath, item)
        }
    }
    
    public init<Content, S>(
        _ data: Binding<ItemCollection>,
        layout: CollectionLayout,
        cellBackground: S,
        @ViewBuilder cellContent: @escaping (IndexPath, _ item: Item) -> Content,
        cellConfig: ((Cell, IndexPath, _ item: Item) -> Void)? = nil
    ) where Content: View, S: ShapeStyle {
        self.init(data, layout: layout) { cell, indexPath, item in
            cell.contentConfiguration = UIHostingConfigurationBackport {
                cellContent(indexPath, item)
            }
            .background(cellBackground)
            cellConfig?(cell, indexPath, item)
        }
    }
}

@available(iOS 16, macCatalyst 16, tvOS 16, visionOS 1, *)
extension CollectionView where Cell == UICollectionViewCell {
    
    public init<Content>(
        _ data: Binding<ItemCollection>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Content,
        cellConfigurationHandler: ((Cell, IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Void)? = nil
    ) where Content: View {
        self.init(data, layout: layout) { cell, indexPath, item in
            cell.configurationUpdateHandler = { cell, state in
                cell.contentConfiguration = UIHostingConfiguration {
                    cellContent(indexPath, state, item)
                }
                cellConfigurationHandler?(cell, indexPath, state, item)
            }
        }
    }
    
    public init<Content, Background>(
        _ data: Binding<ItemCollection>,
        layout: CollectionLayout,
        @ViewBuilder cellContent: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Content,
        @ViewBuilder cellBackground: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Background,
        cellConfigurationHandler: ((Cell, IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Void)? = nil
    ) where Content: View, Background: View {
        self.init(data, layout: layout) { cell, indexPath, item in
            cell.configurationUpdateHandler = { cell, state in
                cell.contentConfiguration = UIHostingConfiguration {
                    cellContent(indexPath, state, item)
                }
                .background {
                    cellBackground(indexPath, state, item)
                }
                cellConfigurationHandler?(cell, indexPath, state, item)
            }
        }
    }
    
    public init<Content, S>(
        _ data: Binding<ItemCollection>,
        layout: CollectionLayout,
        cellBackground: S,
        @ViewBuilder cellContent: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Content,
        cellConfigurationHandler: ((Cell, IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Void)? = nil
    ) where Content: View, S: ShapeStyle {
        self.init(data, layout: layout) { cell, indexPath, item in
            cell.configurationUpdateHandler = { cell, state in
                cell.contentConfiguration = UIHostingConfiguration {
                    cellContent(indexPath, state, item)
                }
                .background(cellBackground)
                cellConfigurationHandler?(cell, indexPath, state, item)
            }
        }
    }
}

extension CollectionView where CollectionLayout == UICollectionViewCompositionalLayout, Cell == UICollectionViewListCell {
    
    public init(
        _ data: Binding<ItemCollection>,
        listAppearance: UICollectionLayoutListConfiguration.Appearance,
        contentConfiguration: @escaping (IndexPath, _ state: UICellConfigurationState, _ item: Item) -> UIListContentConfiguration,
        backgroundConfiguration: ((IndexPath, _ state: UICellConfigurationState, _ item: Item) -> UIBackgroundConfiguration)?,
        cellConfigurationHandler: ((Cell, IndexPath, _ state: UICellConfigurationState, _ item: Item) -> Void)? = nil,
        listConfigurationHandler: ((_ config: inout UICollectionLayoutListConfiguration) -> Void)? = nil
    ) {
        var listConfig = UICollectionLayoutListConfiguration(appearance: listAppearance)
        listConfig.backgroundColor = .clear
        listConfigurationHandler?(&listConfig)
        
        self.init(data, layout: UICollectionViewCompositionalLayout.list(using: listConfig)) { cell, indexPath, item in
            if #available(iOS 15.0, *) {
                cell.configurationUpdateHandler = { cell, state in
                    cell.contentConfiguration = contentConfiguration(indexPath, state, item)
                    cell.backgroundConfiguration = backgroundConfiguration?(indexPath, state, item)
                    cellConfigurationHandler?(cell as! Cell, indexPath, state, item)
                }
            } else {
                cell.contentConfiguration = contentConfiguration(indexPath, .init(traitCollection: .current), item)
                cell.backgroundConfiguration = backgroundConfiguration?(indexPath, .init(traitCollection: .current), item)
                cellConfigurationHandler?(cell, indexPath, .init(traitCollection: .current), item)
            }
        }
        
        self.collectionViewBackgroundColor = if #available(iOS 15.0, *) {
            Color(uiColor: listAppearance.defaultBackgroundColor)
        } else {
            Color(listAppearance.defaultBackgroundColor)
        }
    }
}

extension UICollectionLayoutListConfiguration.Appearance {
    var defaultBackgroundColor: UIColor {
        switch self {
        case .plain, .sidebarPlain:
                .systemBackground
        case .grouped, .insetGrouped, .sidebar:
                .systemGroupedBackground
        @unknown default:
                .systemBackground
        }
    }
}
