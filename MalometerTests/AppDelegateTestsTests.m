//
//  AppDelegateTestsTests.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 01/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//


#import <XCTest/XCTest.h>
//#import <OCMock/OCMock.h>
#import "AppDelegate.h"
#import "AgentsViewController.h"

@interface MocFake : NSManagedObjectContext

@property (nonatomic)BOOL hasSaved;
@property (nonatomic)BOOL withChanges;

@end

@implementation MocFake

- (BOOL)hasChanges {
    return self.withChanges;
}

- (BOOL)save:(NSError *__autoreleasing *)error {
    self.hasSaved = YES;
    return YES;
}

@end

@interface AppDelegateTestsTests : XCTestCase {
    // Core Data stack objects.
    NSManagedObjectModel *model;
    NSPersistentStoreCoordinator *coordinator;
    NSPersistentStore *store;
    NSManagedObjectContext *context;
    // Object to test.
    AppDelegate *sut;
}

@end


@implementation AppDelegateTestsTests

#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

//    [self createCoreDataStack];
//    [self createFixture];
    [self createSut];
}

- (void) createCoreDataStack {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    model = [NSManagedObjectModel mergedModelFromBundles:@[bundle]];
    coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    store = [coordinator addPersistentStoreWithType: NSInMemoryStoreType
                                      configuration: nil
                                                URL: nil
                                            options: nil
                                              error: NULL];
    context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = coordinator;
}

- (void) createFixture {
    // Test data
}

- (void) createSut {
    sut = [[AppDelegate alloc] init];
}

- (void) tearDown {
    [self releaseSut];
//    [self releaseFixture];
//    [self releuaseCoreDataStack];

    [super tearDown];
}

- (void) releaseSut {
    sut = nil;
}

- (void) releaseFixture {

}

- (void) releaseCoreDataStack {
    context = nil;
    store = nil;
    coordinator = nil;
    model = nil;
}

#pragma mark - Basic test

- (void) testObjectIsNotNil {
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}

- (void) testManagedObjectContextIsNotNil {
    XCTAssertNotNil(sut.managedObjectContext, @"MOC must not be nil");
}

- (void) testManagedObjectModelShouldNotNil {
    XCTAssertNotNil(sut.managedObjectModel, @"Managed object model must not be nil");
}

- (void) testPersistentStoreCoordinatorShouldNotNil {
    XCTAssertNotNil(sut.persistentStoreCoordinator, @"Persistent store coordinator must not be nil");
}

- (void) testShouldReturnDocumentsFolder {
    NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    XCTAssertEqualObjects(url, [sut applicationDocumentsDirectory], @"Should return document folder");
}

- (void) testShouldSaveContext {
    MocFake *mocFake = [[MocFake alloc] init];
    mocFake.withChanges = YES;
    [sut setValue:mocFake forKey:@"managedObjectContext"];
    [sut saveContext];
    XCTAssertTrue(mocFake.hasSaved, @"SUT must call save method");
}

- (void) testShouldNotSaveContext {
    MocFake *mocFake = [[MocFake alloc] init];
    mocFake.withChanges = NO;
    [sut setValue:mocFake forKey:@"managedObjectContext"];
    [sut saveContext];
    XCTAssertFalse(mocFake.hasSaved, @"SUT must call save method");
}

@end
