import UIKit
import Composed

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

        let family = PeopleDataSource(elements: [
            Person(name: "Shaps Benkau", age: 38),
            Person(name: "Uwe", age: 60),
            Person(name: "Anne", age: 35)
            ])

        family.title = "Family"

        let friends = PeopleDataSource(elements: [
            Person(name: "Stewart", age: 39),
            Person(name: "Joseph Duffy", age: 24)
            ])

        friends.title = "Friends"

        let composed = ComposedDataSource()

        composed.append(family)
        composed.append(friends)
//        composed.append(family)
//        composed.append(friends)
//        composed.append(family)
//        composed.append(friends)
//        composed.append(family)
//        composed.append(friends)

        let controller = DataSourceViewController(dataSource: composed)

        (window?.rootViewController as? UINavigationController)?
            .pushViewController(controller, animated: false)

        return true
    }
}

