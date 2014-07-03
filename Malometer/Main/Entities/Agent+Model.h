//
//  Agent+Model.h
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "Agent.h"

UIKIT_EXTERN NSString *const agentNameKey;
UIKIT_EXTERN NSString *const agentDestructionPowerKey;
UIKIT_EXTERN NSString *const agentMotivationKey;
UIKIT_EXTERN NSString *const agentPictureUUIDKey;
UIKIT_EXTERN NSString *const agentAssessmentKey;

@interface Agent (Model)

+ (Agent *)createAgentInContext:(NSManagedObjectContext *)context withDictionary:(NSDictionary *)dictionary;
+ (Agent *)createAgentInContext:(NSManagedObjectContext *)context withName:(NSString *)name;

+ (NSFetchRequest *)requestAllWithOrder:(NSString *)orderKey ascending:(BOOL)ascending;
+ (NSFetchRequest *)requestWithPredicate:(NSPredicate *)predicate;
+ (NSFetchRequest *)requestWithSortDescriptors:(NSArray *)sortDescriptors;

@end
