//
//  ModifiedAgentDataDelegate.h
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AgentEditViewController;

@protocol ModifiedAgentDataDelegate <NSObject>
- (void)controller:(AgentEditViewController *)controller modifiedData:(BOOL)modified;
@end
