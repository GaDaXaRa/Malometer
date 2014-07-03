//
//  Power+Model.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 02/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "Power+Model.h"

@implementation Power (Model)

+ (Power *)fetchPowerByName:(NSString *)name inContext:(NSManagedObjectContext *)context {
    Power *power = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Power class]) inManagedObjectContext:context];
    
    power.name = name;
    
    return power;
}

@end
