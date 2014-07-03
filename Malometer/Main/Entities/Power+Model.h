//
//  Power+Model.h
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 02/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "Power.h"

@interface Power (Model)

+ (Power *)fetchPowerByName:(NSString *)name inContext:(NSManagedObjectContext *)context;

@end
