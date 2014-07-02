//
//  Domain+Model.h
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 01/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "Domain.h"

@interface Domain (Model)

+ (Domain *)createDomainInContext:(NSManagedObjectContext *)contex withDictionary:(NSDictionary *)dictionary;
+ (Domain *)domainWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;
+ (Domain *)findDomainWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;
+ (NSFetchRequest *)requestForDomains;

@end
