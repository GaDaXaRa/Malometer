//
//  AgentToAgentMigrationPolicy.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 02/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "AgentToAgentMigrationPolicy.h"
#import "Agent+Model.h"
#import "Power+Model.h"

@implementation AgentToAgentMigrationPolicy

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError *__autoreleasing *)error {    
    
    NSManagedObject *newAgent = [NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName] inManagedObjectContext:[manager destinationContext]];
    
    [newAgent setValue:[sInstance valueForKey:@"name"] forKey:@"name"];
    [newAgent setValue:[sInstance valueForKey:@"destructionPower"] forKey:@"destructionPower"];
    [newAgent setValue:[sInstance valueForKey:@"motivation"] forKey:@"motivation"];
    
    Power *power = [Power fetchPowerByName:[sInstance valueForKey:@"power"] inContext:manager.destinationContext];
    if (!power) {
        power = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Power class]) inManagedObjectContext:manager.destinationContext];
    }
    
    NSSet *powers = [NSSet setWithArray:@[power]];
    
    [newAgent setValue:powers forKey:@"powers"];
    
    [manager associateSourceInstance:sInstance withDestinationInstance:newAgent forEntityMapping:mapping];
    
    return YES;
}

@end
