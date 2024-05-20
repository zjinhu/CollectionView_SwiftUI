import UIKit

extension CollectionView {
    public class Coordinator: NSObject, UICollectionViewDelegate, UICollectionViewDataSourcePrefetching {
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

        public func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
            parent.shouldSelectItemHandler?(collectionView, indexPath) ?? true
        }
        
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            parent.didSelectItemHandler?(collectionView, indexPath)
            guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
            parent.selection.insert(item)
        }
        
        public func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
            parent.shouldDeselectItemHandler?(collectionView, indexPath) ?? true
        }
        
        public func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
            guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
            parent.selection.remove(item)
        }
        
        public func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
            parent.shouldBeginMultipleSelectionInteractionHandler?(collectionView, indexPath) ?? false
        }
        
        public func collectionView(_ collectionView: UICollectionView, didBeginMultipleSelectionInteractionAt indexPath: IndexPath) {
            parent.didBeginMultipleSelectionInteractionHandler?(collectionView, indexPath)
        }
        
        public func collectionViewDidEndMultipleSelectionInteraction(_ collectionView: UICollectionView) {
            parent.didEndMultipleSelectionInteractionHandler?()
        }

        public func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
            parent.shouldHighlightItemHandler?(collectionView, indexPath) ?? true
        }
        
        public func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
            parent.didHighlightItemHandler?(collectionView, indexPath)
        }
        
        public func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
            parent.didUnhighlightItemHandler?(collectionView, indexPath)
        }
        
        public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            parent.willDisplayCellHandler?(cell, indexPath)
        }

        public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            parent.didEndDisplayingCellHandler?(cell, indexPath)
        }

        public func collectionView(_ collectionView: UICollectionView, willDisplayContextMenu configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
            parent.willDisplayContextMenu?(configuration, animator)
        }
        
        public func collectionView(_ collectionView: UICollectionView, willEndContextMenuInteraction configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
            parent.willEndContextMenuInteraction?(configuration, animator)
        }
        
        public func collectionView(_ collectionView: UICollectionView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
            parent.willPerformPreviewAction?(configuration, animator)
        }
        
        public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
            parent.contextMenuConfigHandler?(indexPaths, point)
        }

        public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
            parent.prefetchItemsHandler?(indexPaths)
        }
        
        public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
            parent.cancelPrefetchingHandler?(indexPaths)
        }
    }
}
