import UIKit

extension CollectionView {
    public class Coordinator: NSObject, UICollectionViewDelegate {

        var parent: CollectionView
        var dataSource: DataSource!
        
        init(_ parent: CollectionView) {
            self.parent = parent
        }
        
        internal func setUpCollectionView(_ collectionView: UICollectionView) {
            let cellRegistration = parent.cellRegistration
            self.dataSource = .init(collectionView: collectionView) { collectionView, indexPath, item in
                collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
            }
        }

        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            parent.didSelectItemHandler?(collectionView, indexPath)
        }
    }
}
