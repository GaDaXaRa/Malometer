//
//  Agent.h
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Agent : NSManagedObject

@property (nonatomic, retain) NSNumber * destructionPower;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * motivation;

@end
