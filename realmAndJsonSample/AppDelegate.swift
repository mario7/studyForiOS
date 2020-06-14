//
//  AppDelegate.swift
//  realmAndJsonSample
//
//  Created by snowman on 2020/04/07.
//  Copyright © 2020 snowman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var backgroundTaskID : UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier(rawValue: 0)
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        confirmKeyPathType()
        keyPathSortWithAge()
        
        //accessRealmMangagerNormal()
        //accessRealmManagerWithPrimaryKey()
        return true
    }
    
     public func confirmKeyPathType() {
        var studentModel = StudentModel()
        //keyPath 設定
        let nameKeyPath = \StudentModel.name
        
        print(" \(#function) keyPath type: \(String(describing: type(of: nameKeyPath)))")
        // WritableKeyPath<User, String>
        print(" \(#function) keyPath name before: \(studentModel.name)")
        
        studentModel[keyPath: nameKeyPath ] = "updated"
        
        print(" \(#function) keyPath name after: \(studentModel.name)")
        
    }
    
     public func keyPathSortWithAge() {
        
        let array =  [StudentModel(studentId: "003", name: "3", age: "10"),
        StudentModel(studentId: "002", name: "1", age: "15"),
        StudentModel(studentId: "001", name: "2", age: "20")]
        
        let results = array.sorted{ $0.age > $1.age }
            
         print(" \(#function) 1.sorted result: \(results) ")
       
        let results2 = array.sorted(by: \StudentModel.age)
        
         print(" \(#function) 2.sorted result: \(results2) ")
        
        let results3 = array.sorted(by: \StudentModel.studentId)
        
         print(" \(#function) 3.sorted result: \(results3) ")
    }
    
    private func applicationWillResignActive(application: UIApplication) {
        self.backgroundTaskID = application.beginBackgroundTask(){
            [weak self] in
            application.endBackgroundTask((self?.backgroundTaskID)!)
            self?.backgroundTaskID = UIBackgroundTaskIdentifier.invalid
        }
    }

    func accessRealmMangagerNormal() {
        let fileName = "student"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return
        }
        let accessor = RealmStudentAccess()
        accessor.insertRealmManagerFromJson1(url)
        accessor.updateRealmManagerForStudent()
        accessor.filterRealmManagerForStudent()

    }
    
    func accessRealmManagerWithPrimaryKey() {
        let fileName = "student"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            return
        }
        
        let accessor = RealmStudentAccess()
        accessor.deleteRealmManagerForStudent()
        accessor.insertRealmManagerFromJson1(url)
        //accessor.insertRealmManagerFromJson2(url)
        
        //accessor.insertRealmManagerForSudent(jsonStr: dataStudentStr1)
        //accessor.insertRealmManagerForSudent(jsonStr: dataStudentStr2)
        accessor.updateRealmManagerForStudent()
        //accessor.filterRealmManagerForStudent()
        accessor.deleteRealmManagerForStudent()
        
    }
    
    // MARK: UISceneSession Lifecycle

    @available (iOS 13.0,*)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available (iOS 13.0,*)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

