open class BasicDataSource<Store>: CollectionDataSource where Store: DataStore {

    private let store: Store
    public weak var updateDelegate: DataSourceUpdateDelegate?

    public var isEmpty: Bool {
        return store.isEmpty
    }

    public init(store: Store) {
        self.store = store
    }

    public var numberOfSections: Int {
        return store.numberOfSections
    }

    public func numberOfElements(in section: Int) -> Int {
        return store.numberOfElements(in: section)
    }

    public func indexPath(where predicate: @escaping (Any) -> Bool) -> IndexPath? {
        return store.indexPath(where: predicate)
    }

    public func element(at indexPath: IndexPath) -> Store.Element {
        return store.element(at: indexPath)
    }

    public func dataSourceFor(global section: Int) -> (dataSource: DataSource, localSection: Int) {
        return (self, section)
    }

    public func dataSourceFor(global indexPath: IndexPath) -> (dataSource: DataSource, localIndexPath: IndexPath) {
        return (self, indexPath)
    }

    open func didBecomeActive() { /* do nothing by default */ }
    open func willResignActive() { /* do nothing by default */ }

}

public typealias ArrayDataSource<Element> = BasicDataSource<ArrayDataStore<Element>>

public extension BasicDataSource {

    convenience init<Element>(array elements: [Element]) where Store == ArrayDataStore<Element> {
        self.init(store: ArrayDataStore(elements: elements))
    }

    convenience init<Element>(array elements: Element...) where Store == ArrayDataStore<Element> {
        self.init(store: ArrayDataStore(elements: elements))
    }

}
