//
//  Agent.h
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 02/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Domain, FreakType;

@interface Agent : NSManagedObject

@property (nonatomic, retain) NSNumber * assessment;
@property (nonatomic, retain) NSNumber * destructionPower;
@property (nonatomic, retain) NSNumber * motivation;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pictureURL;
@property (nonatomic, retain) FreakType *category;
@property (nonatomic, retain) NSSet *domains;
@property (nonatomic, retain) NSSet *powers;
@end

@interface Agent (CoreDataGeneratedAccessors)

- (void)addDomainsObject:(Domain *)value;
- (void)removeDomainsObject:(Domain *)value;
- (void)addDomains:(NSSet *)values;
- (void)removeDomains:(NSSet *)values;

- (void)addPowersObject:(NSManagedObject *)value;
- (void)removePowersObject:(NSManagedObject *)value;
- (void)addPowers:(NSSet *)values;
- (void)removePowers:(NSSet *)values;

@end
