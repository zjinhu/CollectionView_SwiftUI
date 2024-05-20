import SwiftUI

extension CollectionView {

    public func backgroundColor(
        _ color: UIColor
    ) -> CollectionView {
        var new = self
        new.collectionViewBackgroundColor = if #available(iOS 15.0, *) {
            Color(uiColor: color)
        } else {
            Color(color)
        }
        return new
    }

    public func backgroundColor(
        _ color: Color?
    ) -> CollectionView {
        var new = self
        new.collectionViewBackgroundColor = color
        return new
    }

    @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
    public func backgroundStyle<S>(
        _ style: S
    ) -> some View where S: ShapeStyle {
        self.backgroundView {
            Rectangle().fill(BackgroundStyle.background)
        }
    }

    @available(iOS 15.0, macOS 12.0, macCatalyst 15.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
    public func backgroundView<V>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> V
    ) -> some View where V: View {
        var new = self
        new.collectionViewBackgroundColor = nil
        return new.background(alignment: alignment, content: content)
    }

    public func onSelect(
        _ handler: CollectionViewVoidCallback?
    ) -> CollectionView {
        var new = self
        new.didSelectItemHandler = handler
        return new
    }
}
