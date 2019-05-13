import UIKit
import Composed

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let list1 = Family(elements: [
            Person(name: "Shaps Benkau", age: 38),
            Person(name: "Uwe", age: 60),
            Person(name: "Anne", age: 35)
        ])

        let list2 = Friends(elements: [
            Person(name: "Stewart", age: 39),
            Person(name: "Joseph Duffy", age: 24)
        ])

        let list3 = Coworkers(elements: [
            Person(name: "Stuart", age: 30),
            Person(name: "Dan", age: 12)
        ])

        let list4 = Websites(elements: [
            Person(name: "Youtube", age: 30),
            Person(name: "Google", age: 12)
        ])

        let embedded = EmbeddingDataSource(child:
            Family(elements: [
                Person(name: "Person 1", age: 1),
                Person(name: "Person 2 with a long name", age: 2),
                Person(name: "P 3", age: 3),
                Person(name: "Person 4", age: 4),
                Person(name: "Person 5", age: 5),
                Person(name: "Person 6", age: 6),
                Person(name: "Person 7", age: 7),
            ])
        )
        let sectioned = FamilyAndFriends(contentsOf: [
            list1.store.elements,
            list2.store.elements
        ])

        let innerComposed = ComposedDataSource(children: [list3])

        let countries = Countries(elements: countryNames)

        let segmented = SegmentedDataSource(children: [innerComposed, list1])
        let composed = ComposedDataSource(children: [embedded, sectioned, segmented, countries, list4])

        countries.title = "Countries"

        let layout = FlowLayout()
        layout.globalFooter.prefersFollowContent = true
        let controller = DataSourceViewController(dataSource: composed, layout: layout)

        controller.navigationItem.largeTitleDisplayMode = .never
        controller.collectionView.backgroundColor = .white

        let tab = window?.rootViewController as? UITabBarController
        let nav = tab?.viewControllers?.first as? UINavigationController
        nav?.navigationBar.prefersLargeTitles = true

        nav?.navigationBar.isHidden = false
        nav?.pushViewController(controller, animated: false)

        return true
    }

    private var countryNames: [Person] {
        var countries: [String] = []

        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        return countries.map { Person(name: $0, age: 18) }
    }

}
