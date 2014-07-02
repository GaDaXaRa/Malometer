//
//  Domain+Model.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 01/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "Domain+Model.h"

static NSString *const domainNameKey = @"name";

@implementation Domain (Model)

+ (Domain *)createDomainInContext:(NSManagedObjectContext *)contex withDictionary:(NSDictionary *)dictionary {
    Domain *domain = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Domain class]) inManagedObjectContext:contex];
    
    domain.name = [dictionary valueForKey:@"name"];
    
    return domain;
}

+ (Domain *)domainWithName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    Domain *domain = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Domain class]) inManagedObjectContext:context];
    domain.name = name;
    
    return domain;
}

+ (Domain *)findDomainWithName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Domain class])];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", domainNameKey, name];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    return [results firstObject];
}

+ (NSFetchRequest *)requestForDomains {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([Domain class])];
    [fetchRequest setFetchBatchSize:20];
    
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(SUBQUERY(agents,$x,$x.destructionPower >= 3)).@count > 1"];
    
    return fetchRequest;
}

@end
