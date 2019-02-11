public struct ArrayDataStore<Element>: DataStore {

    public weak var delegate: DataStoreDelegate?
    public private(set) var elements: [Element] = []

    public init(elements: [Element]) {
        self.elements = elements
    }

    public var numberOfSections: Int {
        return 1
    }

    public func numberOfElements(in section: Int) -> Int {
        return elements.count
    }

    public func element(at indexPath: IndexPath) -> Element {
        guard indexPath.section == 0 else {
            fatalError("Invalid section index: \(indexPath.section). Should always be 0")
        }

        return elements[indexPath.item]
    }

    public func indexPath(where predicate: @escaping (Any) -> Bool) -> IndexPath? {
        if let index = elements.index(where: predicate) {
            return IndexPath(item: index, section: 0)
        } else {
            return nil
        }
    }

    public mutating func setElements(_ elements: [Element], changeset: DataSourceChangeset? = nil) {
        guard let changeset = changeset else {
            self.elements = elements
            delegate?.dataStoreDidReload()
            return
        }

        let updates = changeset.updates

        delegate?.dataStore(performBatchUpdates: {
            self.elements = elements
            delegate?.dataStore(willPerform: updates)

            if !changeset.deletedSections.isEmpty {
                delegate?.dataStore(didDeleteSections: IndexSet(changeset.deletedSections))
            }

            if !changeset.insertedSections.isEmpty {
                delegate?.dataStore(didInsertSections: IndexSet(changeset.insertedSections))
            }

            if !changeset.updatedSections.isEmpty {
                delegate?.dataStore(didUpdateSections: IndexSet(changeset.updatedSections))
            }

            for (source, target) in changeset.movedSections {
                delegate?.dataStore(didMoveSection: source, to: target)
            }

            if !changeset.deletedIndexPaths.isEmpty {
                delegate?.dataStore(didDeleteIndexPaths: changeset.deletedIndexPaths)
            }

            if !changeset.insertedIndexPaths.isEmpty {
                delegate?.dataStore(didInsertIndexPaths: changeset.insertedIndexPaths)
            }

            if !changeset.updatedIndexPaths.isEmpty {
                delegate?.dataStore(didUpdateIndexPaths: changeset.updatedIndexPaths)
            }

            for (source, target) in changeset.movedIndexPaths {
                delegate?.dataStore(didMoveFromIndexPath: source, toIndexPath: target)
            }
        }, completion: { [weak delegate] _ in
            delegate?.dataStore(didPerform: updates)
        })
    }

}