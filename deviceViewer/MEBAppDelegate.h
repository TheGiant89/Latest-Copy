//
//  MEBAppDelegate.h
//  deviceViewer
//
//  Created by Michael Bonds on 11/12/13.
//  Copyright (c) 2013 Michael Bonds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MEBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
