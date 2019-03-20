import UIKit
import Composed

struct Person {
    var name: String
    var age: Int
}

final class PeopleDataSource: SectionedDataSource<Person>, CollectionUIProvidingDataSource {

    var title: String?

    func sizingStrategy() -> CollectionUISizingStrategy {
        return ColumnSizingStrategy(columnCount: 2, sizingMode: .automatic(isUniform: true))
    }

    func metrics(for section: Int) -> CollectionUISectionMetrics {
        return CollectionUISectionMetrics(insets: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20), horizontalSpacing: 8, verticalSpacing: 8)
    }

    func cellConfiguration(for indexPath: IndexPath) -> DataSourceUIConfiguration {
        return DataSourceUIConfiguration(prototype: PersonCell.fromNib, dequeueSource: .nib) { cell, indexPath, _ in
            cell.prepare(person: self.element(at: indexPath))
        }
    }

    func footerConfiguration(for section: Int) -> DataSourceUIConfiguration? {
        return DataSourceUIConfiguration(prototype: FooterView.fromNib, dequeueSource: .nib) { view, indexPath, _ in
            view.prepare(title: "\(self.numberOfElements(in: section)) items")
        }
    }

    func headerConfiguration(for section: Int) -> DataSourceUIConfiguration? {
        return title.map { title in
            DataSourceUIConfiguration(prototype: HeaderView.fromNib, dequeueSource: .nib) { view, indexPath, _ in
                view.prepare(title: title)
            }
        }
    }

    func backgroundViewClass(for section: Int) -> UICollectionReusableView.Type? {
        return BackgroundView.self
    }

}

final class ListDataSource: ComposedDataSource, GlobalViewsProvidingDataSource {

    var placeholderView: UIView? {
        let view = UIActivityIndicatorView(style: .gray)
        view.startAnimating()
        return view
    }

    func globalHeaderConfiguration() -> DataSourceUIConfiguration? {
        return DataSourceUIConfiguration(prototype: GlobalHeaderView.fromNib, dequeueSource: .nib) { _, _, _ in }
    }

    func globalFooterConfiguration() -> DataSourceUIConfiguration? {
        return DataSourceUIConfiguration(prototype: GlobalFooterView.fromNib, dequeueSource: .nib) { _, _, _ in }
    }

}

final class PersonCell: UICollectionViewCell, ReusableViewNibLoadable {

    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var ageLabel: UILabel!

    override func awakeAfter(using aDecoder: NSCoder) -> Any? {
        print(#function)
        return super.awakeAfter(using: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        selectedBackgroundView = UIView(frame: .zero)
        selectedBackgroundView?.layer.cornerRadius = 6
        selectedBackgroundView?.layer.borderWidth = 1
        selectedBackgroundView?.layer.borderColor = UIColor.lightGray.cgColor
        selectedBackgroundView?.backgroundColor = UIColor(white: 0.88, alpha: 1)

        backgroundColor = .clear
    }

    public func prepare(person: Person) {
        nameLabel.text = person.name
        ageLabel.text = "\(person.age)"
    }

}

final class HeaderView: DataSourceHeaderFooterView, ReusableViewNibLoadable {

    @IBOutlet private weak var titleLabel: UILabel!

    public func prepare(title: String?) {
        backgroundColor = .lightGray
        titleLabel.text = title
    }

}

final class FooterView: DataSourceHeaderFooterView, ReusableViewNibLoadable {

    @IBOutlet private weak var titleLabel: UILabel!

    public func prepare(title: String?) {
        backgroundColor = .darkGray
        titleLabel.text = title
    }

}
