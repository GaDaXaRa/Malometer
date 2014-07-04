//
//  AppDelegate.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "AppDelegate.h"

#import "AgentsViewController.h"
#import "FreakType+Model.h"
#import "Agent+Model.h"

@interface AppDelegate ()

@property (readonly, strong, nonatomic) NSManagedObjectContext *backgroundContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *rootContext;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize rootContext = _rootContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize backgroundContext = _backgroundContext;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self importDataInMOC:self.backgroundContext];
    [self prepareRootController];
    return YES;
}

- (void)prepareRootController
{
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    AgentsViewController *controller = (AgentsViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark -
#pragma mark Prepare context hierarchy

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    _managedObjectContext.parentContext = self.rootContext;
    _managedObjectContext.undoManager = [self buildUndoManager];
    return _managedObjectContext;
}

- (NSManagedObjectContext *)backgroundContext {
    if (_backgroundContext != nil) {
        return _backgroundContext;
    }
    
    _backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    _backgroundContext.parentContext = self.managedObjectContext;
    return _backgroundContext;
}

- (NSManagedObjectContext *)rootContext {
    if (_rootContext != nil) {
        return _rootContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _rootContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_rootContext setPersistentStoreCoordinator:coordinator];
    }
    return _rootContext;
    
}

#pragma mark - Core Data stack

- (NSUndoManager *)buildUndoManager
{
    NSUndoManager *undoManager = [[NSUndoManager alloc] init];
    undoManager.groupsByEvent = NO;
    undoManager.levelsOfUndo = 10;
    return undoManager;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Malometer" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Malometer.sqlite"];
    
    NSError *error = nil;
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES};
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark Fake importer

- (void)importDataInMOC:(NSManagedObjectContext *)context {
    [context performBlockAndWait:^{
        FreakType *category = [FreakType freakeTypeWithName:@"Evil Agent" inContext:context];
        
        for (int i = 0; i < 10000; i ++) {
            NSString *agentName = [NSString stringWithFormat:@"Evil Agent %i", i];
            Agent *agent = [Agent createAgentInContext:context withName:agentName];
            agent.category = category;
        }
        
        [context save:NULL];
        
        [self.managedObjectContext performBlock:^{
            [self.managedObjectContext save:NULL];
            [self.rootContext performBlock:^{
                [self.rootContext save:NULL];
            }];
            
        }];
    }];
}

@end
