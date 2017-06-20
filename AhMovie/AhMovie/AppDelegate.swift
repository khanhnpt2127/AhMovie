//
//  AppDelegate.swift
//  AhMovie
//
//  Created by TK Nguyen on 6/16/17.
//  Copyright © 2017 tknguyen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    
        let nowPlayingNC = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        
        
        let nowPlayingVC = nowPlayingNC.topViewController as! MoviesViewController
        nowPlayingVC.tabBarItem.title = "Now Playing"
        nowPlayingVC.tabBarItem.image = UIImage(named: "now_playing")
        nowPlayingVC.isNowPlaying = true
        
        let topratedNC = storyboard.instantiateViewController(withIdentifier: "MoviesNavigationController") as! UINavigationController
        
        
        let topratedVC = topratedNC.topViewController as! MoviesViewController
        topratedVC.tabBarItem.title = "Top Rated"
        topratedVC.tabBarItem.image = UIImage(named: "top_rated")
        
        
        
//        let npviewcontroller =  MoviesViewController(nibName: nil, bundle: nil)
//        var nav1 = UINavigationController()
//        nav1.viewControllers = [nowPlayingNC]
        
        
        
//        let trviewcontroller = MoviesViewController(nibName: nil, bundle: nil)
//        var nav2 = UINavigationController()
//        nav2.viewControllers = [trviewcontroller]
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [nowPlayingNC, topratedNC]
        
        
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        
        
        
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


}

