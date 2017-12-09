//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    override init() {
        super.init()
        UIViewController.classInit
    }

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //FOR TEST NOT MAIN STRORYBOARD
//        self.window = UIWindow(frame: UIScreen.main.bounds)
//        let storyboard = UIStoryboard(name: "Receive", bundle: nil)
//        let initialViewController = storyboard.instantiateViewController(withIdentifier: "ReceiveStart")
//        self.window?.rootViewController = initialViewController
//        self.window?.makeKeyAndVisible()
//        self.realmConfig()
        
//        switch isDeviceJailbroken() {
//        case true:
//            (self.window?.rootViewController?.childViewControllers[0].childViewControllers[0] as! AssetsViewController).presenter.isJailed = true
//        case false:
//            (self.window?.rootViewController?.childViewControllers[0].childViewControllers[0] as! AssetsViewController).presenter.isJailed = false
//        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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

