import UIKit

public protocol EditHandling {
    var isEditing: Bool { get }
    func setEditing(_ editing: Bool, animated: Bool)
}

public protocol EditHandlingDataSource: DataSource, EditHandling {
    func supportsEditing(for indexPath: IndexPath) -> Bool
}

public protocol SelectionHandlingDataSource: DataSource {
    var allowsMultipleSelection: Bool { get }
    var selectedIndexPaths: [IndexPath] { get }
    func selectionHandler(forElementAt indexPath: IndexPath) -> (() -> Void)?
    func deselectionHandler(forElementAt indexPath: IndexPath) -> (() -> Void)?
    func selectElement(at indexPath: IndexPath)
    func deselectElement(at indexPath: IndexPath)
}

extension SelectionHandlingDataSource where Self: CollectionUIProvidingDataSource {
    public var selectedIndexPaths: [IndexPath] {
        guard let collectionView = collectionView else { return [] }
        let indexPaths = collectionView.indexPathsForSelectedItems ?? []
        return collectionView.localIndexPaths(for: indexPaths, globalDataSource: rootDataSource, localDataSource: self).map { $0.local }
    }

    public func selectElement(at indexPath: IndexPath) {
        let section = updateDelegate?.dataSource(self, sectionFor: indexPath.section).globalSection ?? indexPath.section
        collectionView?.selectItem(at: IndexPath(item: indexPath.item, section: section), animated: true, scrollPosition: [])
    }

    public func deselectElement(at indexPath: IndexPath) {
        let section = updateDelegate?.dataSource(self, sectionFor: indexPath.section).globalSection ?? indexPath.section
        collectionView?.deselectItem(at: IndexPath(item: indexPath.item, section: section), animated: true)
    }
}

extension SelectionHandlingDataSource where Self: CollectionUIProvidingDataSource & CollectionDataSource {
    public var selectedElements: [Store.Element] {
        return selectedIndexPaths.map { element(at: $0) }
    }
}

public extension SelectionHandlingDataSource {
    func deselectionHandler(forElementAt indexPath: IndexPath) -> (() -> Void)? { return nil }
}

internal struct SelectionContext {
    var localDataSource: SelectionHandlingDataSource
    var localIndexPath: IndexPath
    var handler: () -> Void
}

extension UICollectionView {

    internal func localIndexPaths(for indexPaths: [IndexPath], globalDataSource: DataSource, localDataSource: DataSource) -> [(local: IndexPath, global: IndexPath)] {
        let grouped = Dictionary(grouping: indexPaths, by: { $0.section })

        let mapped: [[(local: IndexPath, global: IndexPath)]] = grouped.compactMap { info in
            let local = globalDataSource.localSection(for: info.key)
            return local.dataSource === localDataSource
                ? info.value.map { (IndexPath(item: $0.item, section: local.localSection), $0) }
                : nil
        }

        return mapped.flatMap { $0 }
    }

}
