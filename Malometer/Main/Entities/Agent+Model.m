//
//  Agent+Model.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "Agent+Model.h"

NSString *const nameKey = @"name";
NSString *const destructionPowerKey = @"destructionPower";
NSString *const motivationKey = @"motivation";
NSString *const pictureURLKey = @"pictureURL";
NSString *const assessmentKey = @"assessment";

@implementation Agent (Model)

- (void)setMotivation:(NSNumber *)motivation {
    [self willChangeValueForKey:motivationKey];
    [self setPrimitiveValue:motivation forKey:motivationKey];
    [self didChangeValueForKey:motivationKey];
    [self refreshAssement];
}

- (void)setDestructionPower:(NSNumber *)destructionPower {
    [self willChangeValueForKey:destructionPowerKey];
    [self setPrimitiveValue:destructionPower forKey:destructionPowerKey];
    [self didChangeValueForKey:destructionPowerKey];
    [self refreshAssement];
}

- (void)refreshAssement {
    [self willChangeValueForKey:assessmentKey];
    [self setPrimitiveValue:[self assesmentFormula] forKey:assessmentKey];
    [self didChangeValueForKey:assessmentKey];
}

- (NSNumber *)assesmentFormula {
    return [NSNumber numberWithInteger:([self.destructionPower integerValue] + [self.motivation integerValue]) / 2];
}

@end