import UIKit
import Social

class Fact: UIViewController {
	
	@IBOutlet var bgImageView: UIImageView?
	@IBOutlet var questionAndAnswerLabel: UILabel?
	@IBOutlet var appNameLabel: UILabel?
	@IBOutlet var facebookButton: RoundButton?
	@IBOutlet var twitterButton: RoundButton?
	@IBOutlet var shareButton: RoundButton?
	@IBOutlet var refreshFactButton: UIButton!
	@IBOutlet var menuButton: UIButton!
	
	
	var grayBGView: UIViewController!
	var decodedString: String!
	
	/* MARK: Initialising
	/////////////////////////////////////////// */
	override func viewDidLoad() {
		// Styling
		menuButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 21, style: .solid)
		menuButton.setTitle(String.fontAwesomeIcon(name: .bars), for: .normal)
		refreshFactButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 21, style: .solid)
		refreshFactButton.setTitle(String.fontAwesomeIcon(name: .redo), for: .normal)
		
		
		// Gray bg view
		grayBGView = UIViewController()
		grayBGView.view.frame = UIScreen.main.bounds
		grayBGView.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		self.view.addSubview(grayBGView.view)
		
		
		// Button iamges
		facebookButton?.setImage(Utils.imageResize(UIImage(named: "facebook")!, sizeChange: CGSize(width: 22, height: 22)).withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
		twitterButton?.setImage(Utils.imageResize(UIImage(named: "twitter")!, sizeChange: CGSize(width: 21, height: 21)).withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
		shareButton?.setImage(Utils.imageResize(UIImage(named: "share")!, sizeChange: CGSize(width: 22, height: 22)).withRenderingMode(UIImageRenderingMode.alwaysTemplate), for: .normal)
		
		
		// Bring views to front
		self.view.bringSubview(toFront: refreshFactButton!)
		self.view.bringSubview(toFront: menuButton!)
		self.view.bringSubview(toFront: questionAndAnswerLabel!)
		self.view.bringSubview(toFront: appNameLabel!)
		self.view.bringSubview(toFront: facebookButton!)
		self.view.bringSubview(toFront: twitterButton!)
		self.view.bringSubview(toFront: shareButton!)
		
		if UserDefaults.standard.string(forKey: Constants.Defaults.LATEST_FACT_ANSWER) != nil &&
            UserDefaults.standard.string(forKey: Constants.Defaults.LATEST_FACT_QUESTION) != nil {
			updateFact()
		}
		
		// Add observer that will the fact label when a new one is pulled
//		UserDefaults.standard.addObserver(self, forKeyPath: Constants.Defaults.LATEST_FACT_ANSWER, options: NSKeyValueObservingOptions.new, context: nil)
        UserDefaults(suiteName: "group.com.hirerussians.factly")!.addObserver(self, forKeyPath: Constants.Defaults.LATEST_FACT_ANSWER, options: NSKeyValueObservingOptions.new, context: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleObserver),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
	}
    
    @objc func handleObserver() {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
        let todaysDate = formatter.string(from: date)
    
        if UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: Constants.LocalNotifications.LAST_FACT_DATE) == nil {
            SharedFunctions.lastPullFact { result in
                if result {
                    UserDefaults(suiteName: "group.com.hirerussians.factly")!.set(todaysDate, forKey: Constants.LocalNotifications.LAST_FACT_DATE)
                    self.updateFact(isFirstLaunch: true)
                }
            }
        } else {
            updateFact()
//            let lastFactDate = UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: Constants.LocalNotifications.LAST_FACT_DATE)
//
//            // For testing
//            let components = Set<Calendar.Component>([.second, .minute, .hour])
//            let differenceOfDate = Calendar.current.dateComponents(components, from: formatter.date(from: lastFactDate!)!, to: formatter.date(from: todaysDate)!)
//
//            guard let hours = differenceOfDate.hour,
//                  let minutes = differenceOfDate.minute,
//                  let seconds = differenceOfDate.second else { return }
//
//            // Check if 24 hours have passed since the last fact was pulled
//            if hours == 0 && minutes >= 5 {
//
//                print("there are some data in UserDefaults and lastFactDate < todaysDate")
//                SharedFunctions.lastPullFact { result in
//                    if result {
//                        self.updateFact()
//                    }
//                }
//
//                UserDefaults(suiteName: "group.com.hirerussians.factly")!.set(todaysDate, forKey: Constants.LocalNotifications.LAST_FACT_DATE)
//            }
        }
    }
	
	override func viewWillLayoutSubviews() {
		// Get & set random picture bg
		let pictures = ["australia", "canada", "fire", "forest", "iceland", "italy", "mountain", "mountains", "night", "night_house", "snow", "switzerland"]
		let randomPic = pictures[Int(arc4random_uniform(UInt32(pictures.count)))]
		bgImageView?.image = UIImage(named: randomPic)
	}
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	
	
	/* MARK: Observers
	/////////////////////////////////////////// */
	override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
		if keyPath == Constants.Defaults.LATEST_FACT_ANSWER {
			updateFact()
		}
	}
	
	deinit {
//		UserDefaults.standard.removeObserver(self, forKeyPath: Constants.Defaults.LATEST_FACT_ANSWER)
        UserDefaults(suiteName: "group.com.hirerussians.factly")!.removeObserver(self, forKeyPath: Constants.Defaults.LATEST_FACT_ANSWER)
	}

	
	
	/* MARK: Button Actions
	/////////////////////////////////////////// */
	@IBAction func refreshFactButtonPressed(_ sender: AnyObject) {
//        SharedFunctions.lastPullFact { result in
//            if result {
//                self.updateFact()
//            }
//        }
	}
	
	@IBAction func menuButtonPressed(_ sender: AnyObject) {
		Utils.presentView(self, viewName: Constants.Views.SETTINGS_NAV_CONTROLLER)
	}
	
	@IBAction func shareToFacebookButtonPressed(_ sender: UIButton) {
		Utils.post(toService: SLServiceTypeFacebook, view: self, fact: self.decodedString)
	}
	
	@IBAction func shareToTwitterButtonPressed(_ sender: UIButton) {
		Utils.post(toService: SLServiceTypeTwitter, view: self, fact: self.decodedString)
	}
	
	@IBAction func shareButtonPressed(_ sender: UIButton) {
		Utils.openShareView(viewController: self, fact: self.decodedString)
	}
	
	
	
	/* MARK: Core Functionality
	/////////////////////////////////////////// */
    func updateFact(isFirstLaunch: Bool = false) {
		// Get data
        let currentDate = Date()
        var sheduledDateString: String?
        
        var question = ""
        var answer = ""
        
        if isFirstLaunch {
            question = UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: Constants.Defaults.LATEST_FACT_QUESTION)! as String
            answer = UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: Constants.Defaults.LATEST_FACT_ANSWER)! as String
        } else {
            sheduledDateString = UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: Constants.LocalNotifications.SHEDULED_FACT_DATE)
            
            guard let sheduledDateString = sheduledDateString else { return }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy hh:mm:ss"
            let sheduledDate = formatter.date(from: sheduledDateString)!
            
            if currentDate >= sheduledDate {
                question = UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: Constants.Defaults.SHEDULED_FACT_QUESTION)! as String
                answer = UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: Constants.Defaults.SHEDULED_FACT_ANSWER)! as String
            } else {
                question = UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: Constants.Defaults.LATEST_FACT_QUESTION)! as String
                answer = UserDefaults(suiteName: "group.com.hirerussians.factly")!.string(forKey: Constants.Defaults.LATEST_FACT_ANSWER)! as String
            }
        }
        
		// Decode string
		self.decodedString = (question + "\n\nAnswer: " + answer).decode
		questionAndAnswerLabel?.text = self.decodedString
		
		// show buttons
		facebookButton?.isHidden = false
		twitterButton?.isHidden = false
		shareButton?.isHidden = false
	}
}
