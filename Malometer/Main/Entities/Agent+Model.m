//
//  Agent+Model.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "Agent+Model.h"
#import "FreakType+Model.h"
#import "Domain+Model.h"

NSString *const agentNameKey = @"name";
NSString *const agentDestructionPowerKey = @"destructionPower";
NSString *const agentMotivationKey = @"motivation";
NSString *const agentPictureUUIDKey = @"pictureURL";
NSString *const agentAssessmentKey = @"assessment";

@implementation Agent (Model)

+ (Agent *)createAgentInContext:(NSManagedObjectContext *)context withDictionary:(NSDictionary *)dictionary {
    Agent *agent = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Agent class]) inManagedObjectContext:context];
    
    agent.name = [dictionary valueForKey:@"name"];
    agent.motivation = [dictionary valueForKey:@"motivation"];
    agent.destructionPower = [dictionary valueForKey:@"dp"];
    
    agent.category = [FreakType findFreakTypeWithName:[dictionary valueForKey:@"category"] inContext:context];
    
    NSArray *domains = [dictionary valueForKey:@"domains"];
    NSMutableSet *agentDomains = [[NSMutableSet alloc] init];
    for (NSString *domainString in domains) {
        Domain *domain = [Domain findDomainWithName:domainString inContext:context];
        [agentDomains addObject:domain];
    }
    
    agent.domains = agentDomains;
    
    return agent;
}

+ (Agent *)createAgentInContext:(NSManagedObjectContext *)context withName:(NSString *)name {
    Agent *agent = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Agent class]) inManagedObjectContext:context];
    agent.name = name;
    
    return agent;
}

+ (NSFetchRequest *)requestAllWithOrder:(NSString *)orderKey ascending:(BOOL)ascending {
    NSFetchRequest *fetchRequest = [Agent entityRequestWithBatchSize:20];
    
    [fetchRequest setSortDescriptors:[Agent sortDescriptorsWithOrder:orderKey ascending:ascending]];
    
    return fetchRequest;
}

+ (NSFetchRequest *)requestWithPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [Agent entityRequestWithBatchSize:20];
    fetchRequest.predicate = predicate;
    
    [fetchRequest setSortDescriptors:[Agent sortDescriptorsWithOrder:agentNameKey ascending:YES]];
    
    return fetchRequest;
}

+ (NSFetchRequest *)requestWithSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [Agent entityRequestWithBatchSize:20];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    return fetchRequest;
}

+ (NSFetchRequest *)entityRequestWithBatchSize:(NSUInteger)batchSize {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Agent class])];
    [fetchRequest setFetchBatchSize:batchSize];
    
    return fetchRequest;
}

+ (NSArray *)sortDescriptorsWithOrder:(NSString *)orderKey ascending:(BOOL)ascending {
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:orderKey ascending:ascending];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    return sortDescriptors;
}

- (void)setMotivation:(NSNumber *)motivation {
    [self willChangeValueForKey:agentMotivationKey];
    [self setPrimitiveValue:motivation forKey:agentMotivationKey];
    [self didChangeValueForKey:agentMotivationKey];
    [self refreshAssement];
}

- (void)setDestructionPower:(NSNumber *)destructionPower {
    [self willChangeValueForKey:agentDestructionPowerKey];
    [self setPrimitiveValue:destructionPower forKey:agentDestructionPowerKey];
    [self didChangeValueForKey:agentDestructionPowerKey];
    [self refreshAssement];
}

- (NSNumber *)assessment {
    return [self assesmentFormula];
}

- (void)refreshAssement {
    [self willChangeValueForKey:agentAssessmentKey];
    [self setPrimitiveValue:[self assesmentFormula] forKey:agentAssessmentKey];
    [self didChangeValueForKey:agentAssessmentKey];
}

- (NSNumber *)assesmentFormula {
    return [NSNumber numberWithInteger:([self.destructionPower integerValue] + [self.motivation integerValue]) / 2];
}

@end