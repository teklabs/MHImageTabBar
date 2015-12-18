
import UIKit
import Parse
//import ParseFacebookUtils

import ParseFacebookUtilsV4
import ParseTwitterUtils
import MBProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        Parse.setApplicationId("oUuHAfy2K9KHPOj12TumNGe7tx2GSbyhCXjHCz8o", clientKey: "fJ2fqkZ1lsRqXfRiS2z6EM2A7egK7xQQirnSx77J")
        //PFFacebookUtils.initializeFacebook()
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions);
        PFTwitterUtils.initializeWithConsumerKey("3Q9hMEKqqSg4ie2pibZ2sVJuv", consumerSecret: "IEZ9wv2d1EpXNGFKGp7sAGdxRtyqtPwygyciFZwTHTGhPp4FMj")

        
        let userDefaults = NSUserDefaults.groupUserDefaults()
        
        
        let defaultACL: PFACL = PFACL()
        // Enable public read access by default, with any newly created PFObjects belonging to the current user
        //defaultACL.setPublicReadAccess(true)
        PFACL.setDefaultACL(defaultACL, withAccessForCurrentUser: true)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

   // func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   // }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(aTabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        // The empty UITabBarItem behind our Camera button should not load a view controller
        return viewController != aTabBarController.viewControllers![TabBarControllerViewControllerIndex.EmptyTabBarItemIndex.rawValue]
    }

    
    
    func application(application: UIApplication,
        openURL url: NSURL,
        sourceApplication: String?,
        annotation: AnyObject?) -> Bool {
            return FBSDKApplicationDelegate.sharedInstance().application(application,
                openURL: url,
                sourceApplication: sourceApplication,
                annotation: annotation)
    }
    
    
    //Make sure it isn't already declared in the app delegate (possible redefinition of func error)
    func applicationDidBecomeActive(application: UIApplication) {
        FBSDKAppEvents.activateApp()
    }

}

