//
//  AppDelegate.swift
//  Assignment3
//
//  Created by admin on 2020/10/31.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , NetworkListener{
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //configure the firebase
        FirebaseApp.configure()
        
        requestNotificationAuthorization()
        
        return true
    }
    // MARK: - Network Listener
    func onRequest() {
        
    }
    
    func onResponse(response: AnyObject?, error: Error?) {
        
    }
    
    // MARK: - Notification Service
    func requestNotificationAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (auth, error) in
            if auth {
                self.initAction()
                self.initNotification()
            }
        }
        
        
    }
    
    func initAction(){
        //define action
        let addToFavorite = UNNotificationAction(identifier: "addToFavorite", title: "Add to favorite", options: [])
        
        //add action to categeroy
        let categeroy = UNNotificationCategory(identifier: "mealSuggestion", actions: [addToFavorite], intentIdentifiers: [], options: [])
        
        //add categeroy to notification framework
        UNUserNotificationCenter.current().setNotificationCategories([categeroy])
    }
    
    func initNotification(){
        var mComp = DateComponents()
        var nComp = DateComponents()
        var eComp = DateComponents()
        mComp.hour = 7
        mComp.minute = 30
        nComp.hour = 11
        nComp.minute = 30
        eComp.hour = 5
        eComp.minute = 30
        //eComp.second = 30
        let mTrigger = UNCalendarNotificationTrigger(dateMatching: mComp, repeats: true)
        let nTrigger = UNCalendarNotificationTrigger(dateMatching: nComp, repeats: true)
        let eTrigger = UNCalendarNotificationTrigger(dateMatching: eComp, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Meal Suggestion"
        content.body = "Time to prepare meal. No ideas? Come and check it out!"
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "mealSuggestion"

        
        let mRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: mTrigger)
        let nRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nTrigger)
        let eRequest = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: eTrigger)
        
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().add(mRequest)
        UNUserNotificationCenter.current().add(nRequest)
        UNUserNotificationCenter.current().add(eRequest)
    }
    

    // MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Assignment3")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

