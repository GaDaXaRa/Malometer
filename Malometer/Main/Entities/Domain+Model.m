//
//  Domain+Model.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 01/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "Domain+Model.h"

@implementation Domain (Model)

+ (Domain *)domainWithName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    Domain *domain = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Domain class]) inManagedObjectContext:context];
    domain.name = name;
    
    return domain;
}

+ (Domain *)findDomainWithName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([Domain class])];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    return [results lastObject];
}

@end
