//
//  SceneDelegate.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/8/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit
import Firebase
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Set initial view based on the user logged in information
        self.window = UIWindow(windowScene: windowScene)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Listening for user logging in state change
        Auth.auth().addStateDidChangeListener { (auth, user) in
          if user != nil {
            // User is logged in
            print("from scenedelegate:user is logged in")
            let homeView = storyboard.instantiateViewController(identifier: Constants.Storyboard.homeTabViewController) as! MainTabController
            self.window?.rootViewController = homeView
            self.window?.makeKeyAndVisible()
            
          }
          else{
            // No user is signed in
            print("from scenedelegate:user is not logged in")
            let mainView = storyboard.instantiateViewController(identifier: Constants.Storyboard.mainViewController)
            self.window?.rootViewController = mainView
            self.window?.makeKeyAndVisible()
          }
           
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

