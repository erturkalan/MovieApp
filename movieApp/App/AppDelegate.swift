//
//  AppDelegate.swift
//  movieApp
//
//  Created by Ertürk Alan on 14.02.2023.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        do {
            _ = try Realm()
        } catch {
            print("Error intializing realm, \(error)")
        }
        
        configureRealm()
        return true
    }
    
    private func configureRealm() {
        let realm = try! Realm()
        
        for movie in realm.objects(Movie.self) {
            if movie.isFavorite == false {
                do {
                    try realm.write({
                        realm.delete(movie)
                    })
                } catch {
                    print("Error deleting movie object: \(error)")
                }
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
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
}

