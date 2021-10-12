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
		
		let date = Date()
		let formatter = DateFormatter()
		formatter.dateFormat = "dd.MM.yyyy"
		let todaysDate = formatter.string(from: date)
	
//		if UserDefaults.standard.string(forKey: Constants.LocalNotifications.LAST_FACT_DATE) == nil {
        if UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: Constants.LocalNotifications.LAST_FACT_DATE) == nil {
			AppDelegate.pullFact()
            print("empty UserDefaults")
//			UserDefaults.standard.set(todaysDate, forKey: Constants.LocalNotifications.LAST_FACT_DATE)
            UserDefaults(suiteName: "group.com.hirerussians.factly")!.set(todaysDate, forKey: Constants.LocalNotifications.LAST_FACT_DATE)
		}
		else {
//			let lastFactDate = UserDefaults.standard.string(forKey: Constants.LocalNotifications.LAST_FACT_DATE)
            let lastFactDate = UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: Constants.LocalNotifications.LAST_FACT_DATE)
			
			// Check if 24 hours have passed since the last fact was pulled
			if formatter.date(from: lastFactDate!)! < formatter.date(from: todaysDate)! {
                print("lastFactDate: \(formatter.date(from: lastFactDate!)!) and todaysDate: \(formatter.date(from: todaysDate)!)")
                print("there are some data in UserDefaults and lastFactDate < todaysDate")
				AppDelegate.pullFact()
//				UserDefaults.standard.set(todaysDate, forKey: Constants.LocalNotifications.LAST_FACT_DATE)
                UserDefaults(suiteName: "group.com.hirerussians.factly")!.set(todaysDate, forKey: Constants.LocalNotifications.LAST_FACT_DATE)
			}
		}
	}
	
	func applicationWillResignActive(_ application: UIApplication) {
		UIApplication.shared.applicationIconBadgeNumber = 0
	}
	
	
	
	/* MARK: Core Functionality
	/////////////////////////////////////////// */
	class func pullFact() {
//        SharedFunctions.shared.pullFact()
		let url = "https://opentdb.com/api.php?amount=1&type=multiple"
		Utils.getFact(url, callback: {(params: String, urlContents: String) -> Void in
			if urlContents.characters.count > 5 {
				DispatchQueue.main.async(execute: {
					// Get data
					let result = (urlContents.parseJSONString.value(forKey: "results")! as! NSArray)[0] as! NSDictionary
					var question = result.value(forKey: "question")! as! String
					var answer = result.value(forKey: "correct_answer")! as! String
					question = question.replacingOccurrences(of: "&quot;", with: "", options: .literal, range: nil)
					answer = answer.replacingOccurrences(of: "&quot;", with: "", options: .literal, range: nil)
					question = question.replacingOccurrences(of: "&ldquo;", with: "", options: .literal, range: nil)
					answer = answer.replacingOccurrences(of: "&rdquo;", with: "", options: .literal, range: nil)
					question = question.removingPercentEncoding!
					answer = answer.removingPercentEncoding!
					
//					UserDefaults.standard.set(question, forKey: Constants.Defaults.LATEST_FACT_QUESTION)
//					UserDefaults.standard.set(answer, forKey: Constants.Defaults.LATEST_FACT_ANSWER)
                    UserDefaults(suiteName: "group.com.hirerussians.factly")!.set(question, forKey: Constants.Defaults.LATEST_FACT_QUESTION)
                    UserDefaults(suiteName: "group.com.hirerussians.factly")!.set(answer, forKey: Constants.Defaults.LATEST_FACT_ANSWER)
				})
			}
		})
	}
}

