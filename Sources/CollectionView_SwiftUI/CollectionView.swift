import SwiftUI
import OrderedCollections

public struct CollectionView<Section, Item, Cell, CollectionLayout>
where Section: Sendable & Hashable, Item: Sendable & Hashable, Cell: UICollectionViewCell, CollectionLayout: UICollectionViewLayout {
    
    public typealias ItemCollection = OrderedDictionary<Section, [Item]>
    public typealias CellRegistration = UICollectionView.CellRegistration<Cell, Item>
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, Item>
    
    @Binding internal var data: ItemCollection
    
    internal var layout: CollectionLayout
    internal var cellRegistration: CellRegistration
    
    public init(_ data: Binding<ItemCollection>,
                layout: CollectionLayout,
                cellRegistrationHandler: @escaping CellRegistration.Handler) {
        self._data = data
        self.layout = layout
        self.cellRegistration = .init(handler: cellRegistrationHandler)
    }
    
    internal var collectionViewBackgroundColor: Color? = nil

    public typealias CollectionViewVoidCallback = (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> Void
    
    internal var didSelectItemHandler: CollectionViewVoidCallback? = nil
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
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }
    
    public func updateUIView(_ uiView: UICollectionView, context: Context) {
        
        if uiView.backgroundColor != uiColor(from: collectionViewBackgroundColor, in: context) {
            uiView.backgroundColor = uiColor(from: collectionViewBackgroundColor, in: context)
        }
        
        updateDataSource(context.coordinator)
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
