//
//  AssessmentManager.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "AssessmentManager.h"

@implementation AssessmentManager

+ (NSUInteger)assesmentForDestructionPower:(NSUInteger)destructionPower andMotivation:(NSUInteger)motivation {
    return (destructionPower + motivation) / 2;
}

@end
