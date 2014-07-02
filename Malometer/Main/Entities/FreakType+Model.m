//
//  FreakType+Model.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 01/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "FreakType+Model.h"

NSString *const freakTypePropertyName = @"name";

@implementation FreakType (Model)

+ (FreakType *)createFreakTypeInContext:(NSManagedObjectContext *)context withDictionary:(NSDictionary *)dictionary {
    FreakType *freakType = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([FreakType class]) inManagedObjectContext:context];
    
    freakType.name = [dictionary valueForKey:@"name"];
    
    return freakType;
}

+ (FreakType *)freakeTypeWithName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    FreakType *freakType = [NSEntityDescription insertNewObjectForEntityForName:@"FreakType" inManagedObjectContext:context];
    freakType.name = name;
    
    return freakType;
}

+ (FreakType *)findFreakTypeWithName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"FreakType"];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", freakTypePropertyName, name];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    return [results lastObject];
}

@end
