//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var presentedVC: UIViewController?
    var openedAlert: UIAlertController?
    
    override init() {
        super.init()
        UIViewController.classInit
    }

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        // check for screenshot
        NotificationCenter.default.addObserver(
            forName: .UIApplicationUserDidTakeScreenshot,
            object: nil,
            queue: .main) { notification in
                print("\n\nScreennshot!\n\n")
                //executes after screenshot
        }
        
        self.performFirstEnterFlow()
        
        DataManager.shared.realmManager.getAccount { (acc, err) in
            isNeedToAutorise = acc != nil
            
            //MAKR: Check here isPin option from NSUserDefaults
            UserPreferences.shared.getAndDecryptCipheredMode(completion: { (pinMode, error) in
                isNeedToAutorise = (pinMode! as NSString).boolValue
                self.authorization()
            })
        }
        
        //FOR TEST NOT MAIN STRORYBOARD
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Receive", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "ReceiveStart")
//        self.window?.rootViewController = initialViewController
//        self.window?.makeKeyAndVisible()
//        self.realmConfig()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        DataManager.shared.finishRealmSession()
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        NotificationCenter.default.post(name: Notification.Name("hideKeyboard"), object: nil)
        DataManager.shared.finishRealmSession()
        DataManager.shared.realmManager.getAccount { (acc, err) in
            isNeedToAutorise = acc != nil
            
            //MARK: Check here isPin option from NSUserDefaults
            UserPreferences.shared.getAndDecryptCipheredMode(completion: { (pinMode, error) in
                 isNeedToAutorise = (pinMode as! NSString).boolValue
            })

            if self.presentedVC != nil {
                self.presentedVC?.dismiss(animated: true, completion: nil)
                self.openedAlert?.dismiss(animated: true, completion: nil)
            }
        }
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        if self.presentedVC != nil {
            presentedVC?.dismiss(animated: true, completion: nil)
            openedAlert?.dismiss(animated: true, completion: nil)
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        self.authorization()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        DataManager.shared.finishRealmSession()
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func performFirstEnterFlow() {
        guard self.window != nil && self.window?.rootViewController != nil else {
            return
        }
        
        let assetVC = self.window?.rootViewController?.childViewControllers[0].childViewControllers[0] as! AssetsViewController
        switch isDeviceJailbroken() {
        case true:
            assetVC.presenter.isJailed = true
        case false:
            assetVC.presenter.isJailed = false
            DataManager.shared.getServerConfig { (hardVersion, softVersion, err) in
                let dictionary = Bundle.main.infoDictionary!
                let buildVersion = (dictionary["CFBundleVersion"] as! NSString).integerValue
                
                //MARK: change > to <
                if err != nil || buildVersion > hardVersion! {
                    assetVC.isFlowPassed = true
                    assetVC.viewDidLoad()
                    let _ = UserPreferences.shared
                    self.saveMkVersion()
                } else {
                    assetVC.presentUpdateAlert()
                }
            }
        }
    }
    
    func saveMkVersion(){
        if UserDefaults.standard.value(forKey: "MKVersion") != nil {
            
        } else {
            UserDefaults.standard.set("1.0", forKey: "MKVersion")
        }
    }
    
    func authorization() {
        if isNeedToAutorise {
            self.window?.isUserInteractionEnabled = false
            let authVC = SecureViewController()
//            authVC.modalPresentationStyle = .overCurrentContext
            let selectedIndex = (self.window?.rootViewController as! CustomTabBarViewController).selectedIndex
            (self.window?.rootViewController?.childViewControllers[selectedIndex] as! UINavigationController).topViewController?.present(authVC, animated: true, completion: nil)
            isNeedToAutorise = false
        }
    }

//    func realmConfig () {
//        let config = Realm.Configuration(
//            // Set the new schema version. This must be greater than the previously used
//            // version (if you've never set a schema version before, the version is 0).
//            schemaVersion: 1,
//
//            // Set the block which will be called automatically when opening a Realm with
//            // a schema version lower than the one set above
//            migrationBlock: { migration, oldSchemaVersion in
//
//                if oldSchemaVersion < 1 {
//                    //                    MARK: here is simple example
//
//                    //                    migration.enumerate(WorkoutSet.className()) { oldObject, newObject in
//                    //                        newObject?["setCount"] = setCount
//                    //                    }
//                }
//            }
//        )
//        Realm.Configuration.defaultConfiguration = config
//    }
}

