import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	/* MARK: Init
	/////////////////////////////////////////// */
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		// Styling
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor(hex: Constants.Colors.BLUE_DARK)]
		
		return true
	}

	func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
		Utils.setRootViewController(viewName: Constants.Views.FACT)
		completionHandler() // per developer documentation, app will terminate if we fail to call this
	}
	
	func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
		NotificationCenter.default.post(name: Notification.Name(rawValue: "FactlyShouldRefresh"), object: self)
	}
	
	func applicationDidBecomeActive(_ application: UIApplication) {
		NotificationCenter.default.post(name: Notification.Name(rawValue: "FactlyShouldRefresh"), object: self)
	
		Utils.setupLocalNotifications(application: application)
		Utils.scheduleLocalNotification()
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		UIApplication.shared.applicationIconBadgeNumber = 0
	}
}

