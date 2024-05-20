import SwiftUI
import OrderedCollections

public struct CollectionView<Section, Item, Cell, CollectionLayout>
    where Section: Sendable & Hashable, Item: Sendable & Hashable, Cell: UICollectionViewCell, CollectionLayout: UICollectionViewLayout {
    
    public typealias ItemCollection = OrderedDictionary<Section, [Item]>
    public typealias CellRegistration = UICollectionView.CellRegistration<Cell, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    private var singleSelection: Bool
    private var multipleSelection: Bool

    @Binding internal var data: ItemCollection

    @Binding internal var selection: Set<Item>

    internal var layout: CollectionLayout
    
    internal var cellRegistration: CellRegistration

    /// Creates a collection view that allows users to select multiple items.
    ///
    /// If you'd like to allow multiple selection, but don't need to keep track of the selections, use `.constant([])` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a set that represents selected items.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellType: A subclass of `UICollectionViewCell` that the collection view should use. It defaults to `UICollectionViewCell`.
    ///   - cellRegistrationHandler: A closure that handles the cell registration and configuration.
    public init(
        _ data: Binding<ItemCollection>,
        selection: Binding<Set<Item>>,
        layout: CollectionLayout,
        cellType: Cell.Type = UICollectionViewCell.self,
        cellRegistrationHandler: @escaping CellRegistration.Handler
    ) {
        self._data = data
        self._selection = selection
        self.singleSelection = true
        self.multipleSelection = true
        self.layout = layout
        self.cellRegistration = .init(handler: cellRegistrationHandler)
    }

    /// Creates a collection view that optionally allows users to select a single item.
    ///
    /// If you'd like to allow single selection, but don't need to keep track of the selection, use `.constant(nil)` as input for `selection`.
    /// - Parameters:
    ///   - data: The data for populating the list.
    ///   - selection: A binding to a selected value, if provided. Otherwise, no selection will be allowed.
    ///   - layout: The layout object to use for organizing items.
    ///   - cellType: A subclass of `UICollectionViewCell` that the collection view should use. It defaults to `UICollectionViewCell`.
    ///   - cellRegistrationHandler: A closure that handles the cell registration and configuration.
    public init(
        _ data: Binding<ItemCollection>,
        selection: Binding<Item?>? = nil,
        layout: CollectionLayout,
        cellType: Cell.Type = UICollectionViewCell.self,
        cellRegistrationHandler: @escaping CellRegistration.Handler
    ) {
        self._data = data
        
        if let selection {
            self._selection = .init(get: {
                if let item = selection.wrappedValue { [item] } else { [] }
            }, set: { selectedItems in
                selection.wrappedValue = selectedItems.first
            })
        } else {
            self._selection = .constant([])
        }
        
        self.singleSelection = selection != nil
        self.multipleSelection = false
        self.layout = layout
        self.cellRegistration = .init(handler: cellRegistrationHandler)
    }
    
    internal var collectionViewBackgroundColor: Color? = nil
    
    public typealias CollectionViewBoolCallback = (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Bool
    public typealias CollectionViewVoidCallback = (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void

    internal var didSelectItemHandler: CollectionViewVoidCallback? = nil
    internal var shouldSelectItemHandler: CollectionViewBoolCallback? = nil
    internal var shouldDeselectItemHandler: CollectionViewBoolCallback? = nil

    internal var shouldBeginMultipleSelectionInteractionHandler: CollectionViewBoolCallback? = nil
    internal var didBeginMultipleSelectionInteractionHandler: CollectionViewVoidCallback? = nil
    internal var didEndMultipleSelectionInteractionHandler: (() -> Void)? = nil

    internal var shouldHighlightItemHandler: CollectionViewBoolCallback? = nil
    internal var didHighlightItemHandler: CollectionViewVoidCallback? = nil
    internal var didUnhighlightItemHandler: CollectionViewVoidCallback? = nil

    internal var willDisplayCellHandler: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)? = nil
    internal var didEndDisplayingCellHandler: ((_ cell: UICollectionViewCell, _ indexPath: IndexPath) -> Void)? = nil

    internal var willDisplayContextMenu: ((_ configuration: UIContextMenuConfiguration, UIContextMenuInteractionAnimating?) -> Void)? = nil
    internal var willEndContextMenuInteraction: ((_ configuration: UIContextMenuConfiguration, UIContextMenuInteractionAnimating?) -> Void)? = nil
    internal var willPerformPreviewAction: ((_ configuration: UIContextMenuConfiguration, UIContextMenuInteractionAnimating?) -> Void)? = nil
    internal var contextMenuConfigHandler: ((_ indexPaths: [IndexPath], _ point: CGPoint) -> UIContextMenuConfiguration?)? = nil

    internal var prefetchItemsHandler: ((_ indexPaths: [IndexPath]) -> Void)? = nil
    internal var cancelPrefetchingHandler: ((_ indexPaths: [IndexPath]) -> Void)? = nil
}

extension CollectionView {
    private func uiColor(from color: Color?, in context: Context) -> UIColor? {
        guard let color else { return nil }
        if #available(iOS 17.0, *) {
            return UIColor(cgColor: color.resolve(in: context.environment).cgColor)
        } else {
            return if let cgColor = color.cgColor {
                UIColor(cgColor: cgColor)
            } else {
                nil
            }
        }
    }
}

extension CollectionView: UIViewRepresentable {
    public func makeUIView(context: Context) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        context.coordinator.setUpCollectionView(collectionView)
        
        collectionView.delegate = context.coordinator
        collectionView.prefetchDataSource = context.coordinator
        collectionView.allowsSelection = singleSelection
        collectionView.allowsMultipleSelection = multipleSelection
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {

        if uiView.backgroundColor != uiColor(from: collectionViewBackgroundColor, in: context) {
            uiView.backgroundColor = uiColor(from: collectionViewBackgroundColor, in: context)
        }

        updateDataSource(context.coordinator)

        if singleSelection || multipleSelection {
            let newSelectedIndexPaths = Set(selection
                .compactMap { context.coordinator.dataSource.indexPath(for: $0) })
            let currentlySelectedIndexPaths = Set(uiView.indexPathsForSelectedItems ?? [])
            
            if newSelectedIndexPaths != currentlySelectedIndexPaths {
                let removed = currentlySelectedIndexPaths.subtracting(newSelectedIndexPaths)
                removed.forEach {
                    uiView.deselectItem(at: $0, animated: true)
                }
                
                let added = newSelectedIndexPaths.subtracting(currentlySelectedIndexPaths)
                added.forEach {
                    uiView.selectItem(at: $0, animated: true, scrollPosition: .centeredVertically)
                }
            }
        }
    }
    
    private func updateDataSource(_ coordinator: Coordinator) {
        if let dataSource = coordinator.dataSource {
            var snapshot: DataSourceSnapshot = .init()
            
            snapshot.appendSections(Array(data.keys))
            for (section, items) in data {
                snapshot.appendItems(items, toSection: section)
            }

            dataSource.apply(snapshot, animatingDifferences: !dataSource.snapshot().itemIdentifiers.isEmpty)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}
