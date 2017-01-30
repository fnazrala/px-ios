//
//  AppDelegate.swift
//  MercadoPagoSDKExamples
//
//  Created by Matias Gualino on 6/4/15.
//  Copyright (c) 2015 MercadoPago. All rights reserved.
//

import UIKit
import CoreData
import MercadoPagoSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var nav: UINavigationController?


    
    func application(_ application: UIApplication,
            didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //SET SITE
        MercadoPagoContext.setSite(MercadoPagoContext.Site.MPE)
        
        
    
        //ARGENTINA
        //MercadoPagoContext.setPublicKey("TEST-971766e1-383e-420f-9b69-cecd4c63d071")
        
        
        //PERU
        
            //test
        //MercadoPagoContext.setPublicKey("TEST-962a648a-959f-457c-a4df-a6fbe3f10c82")
        
            //produ
        //MercadoPagoContext.setPublicKey("APP_USR-d16a4b81-58d3-4167-8067-e12dd16b549a")

        
        
            //test con permisos
        //MercadoPagoContext.setPublicKey("TEST-540bb6d1-44d5-4607-92bf-3075023f53a0")
        
            //produ con permisos
        MercadoPagoContext.setPublicKey("APP_USR-9fc1aacb-3558-421e-a7cc-b9ddc9a8d48a")
        
        
        
        
            //produ backend
        //MercadoPagoContext.setPublicKey("APP_USR-b2a01cb3-2f31-4ee8-bd65-d0d939a727bd")
        
        
        
        
        
        
        
        
        //URUGUAY
        
            //test
        //MercadoPagoContext.setPublicKey("TEST-e7b54e3e-f1a7-4518-868d-4a3e6d8b0b30")
        
            //produ
        //MercadoPagoContext.setPublicKey("APP_USR-83c6e8f7-3b0e-4290-96a1-c222560a891c")
        
        
        
        //COLOMBIA
        
            //test
        //MercadoPagoContext.setPublicKey("TEST-d661b2f9-3241-421d-bd9e-7d1a42b27d1c")
        
            //produ
        //MercadoPagoContext.setPublicKey("APP_USR-399e7628-3d81-423f-a7cf-5ad8341eb06e")
        
        
        
        //VENEZUELA
       
            //test
        //MercadoPagoContext.setPublicKey("TEST-d5639c69-1b7f-4777-9ed0-d0e74bfc2c3b")
        
            //produ
        //MercadoPagoContext.setPublicKey("APP_USR-a865216a-a035-4629-8ec4-b1e1908b8b0d")
       // MercadoPagoContext.setPublicKey("APP_USR-8e3869a6-638f-45cd-b5b7-267c8e6f2b09")
        
        
        
        
        
        
        
        
        
        
        
        
        
        
     //   MercadoPagoContext.setMerchantAccessToken(ExamplesUtils.MERCHANT_ACCESS_TOKEN)

        MercadoPagoContext.setDisplayDefaultLoading(flag: false)
        

        MercadoPagoContext.setLanguage(language: MercadoPagoContext.Languages._SPANISH)
//        let tracker = TrackerExample()
//        
//        MercadoPagoContext.setTrack(listener: tracker)
        MercadoPagoContext.setBaseURL("https://private-0c3e9-testingcustomer.apiary-mock.com")
        MercadoPagoContext.setCustomerURI("/get_customer")

        

        //MercadoPagoContext.setAccountMoneyAvailable(accountMoneyAvailable: true)

        //Pinto de rojo el color primerio


        //MercadoPagoContext.setupPrimaryColor(UIColor.black, complementaryColor: UIColor.black)
        let decorationPreference = DecorationPreference()
        decorationPreference.setBaseColor(hexColor: "#CA254D")
        
        MercadoPagoContext.setDecorationPreference(decorationPreference: decorationPreference)
        
        CardFormViewController.showBankDeals = true
        
        
        // Initialize window
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.px_white()
        
        self.nav = UINavigationController()

        
        let exmaplesViewController = MainExamplesViewController()
        
        // Put vaultController at the top of navigator.
        self.nav!.pushViewController(exmaplesViewController, animated: false)
        
        self.window?.rootViewController = self.nav

        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.mercadopago.MercadoPagoSDKExamples" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] 
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "MercadoPagoSDKExamples", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("MercadoPagoSDKExamples.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
		do {
			var aux : AnyObject? = try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
			if aux == nil {
				coordinator = nil
				// Report any error we got.
				var dict = [String: AnyObject]()
				dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
				dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
				dict[NSUnderlyingErrorKey] = error
				error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
				// Replace this with code to handle the error appropriately.
				// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
				NSLog("Unresolved error \(error), \(error!.userInfo)")
				abort()
			}

		} catch {
			
		}
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
			do {
				try moc.save()
				if moc.hasChanges {
					// Replace this implementation with code to handle the error appropriately.
					// abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
					//NSLog("Unresolved error \(error), \(error!.userInfo)")
					abort()
				}
			} catch {
				
			}
        }
    }

}

//class TrackerExample :  MPTrackListener {
//    func trackScreen(screenName : String){
//        print("***** Trackeada \(screenName)")
//    }
//    func trackEvent(screenName : String?, action: String!, result: String?, extraParams: [String:String]?){
//        print("***** Trackeado Evento en \(screenName) accion \(action) y result \(result)")
//    }
//}

