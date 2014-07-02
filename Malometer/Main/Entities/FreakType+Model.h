//
//  FreakType+Model.h
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 01/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "FreakType.h"

@interface FreakType (Model)

+ (FreakType *)createFreakTypeInContext:(NSManagedObjectContext *)context withDictionary:(NSDictionary *)dictionary;
+ (FreakType *)freakeTypeWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;
+ (FreakType *)findFreakTypeWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end
