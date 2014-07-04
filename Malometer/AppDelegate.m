//
//  AppDelegate.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "AppDelegate.h"

#import "AgentsViewController.h"

@interface AppDelegate ()

@property (strong, nonatomic) UIManagedDocument *model;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self prepareRootController];
    return YES;
}

- (void)prepareRootController
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    AgentsViewController *controller = (AgentsViewController *)navigationController.topViewController;
    controller.model = self.model;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.model.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

- (UIManagedDocument *)model {
    if (!_model) {
        NSURL *modelUrl = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Malometer.model"];
        _model = [[UIManagedDocument alloc] initWithFileURL:modelUrl];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:[modelUrl path]]) {
            [self.model openWithCompletionHandler:^(BOOL success) {
                if (!success) {
                    //ERROR
                }
            }];
        } else {
            [_model saveToURL:modelUrl forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                if (!success) {
                    //ERROR
                }
            }];
        }
    }
    
    return _model;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
