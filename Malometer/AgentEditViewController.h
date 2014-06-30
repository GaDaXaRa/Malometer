//
//  DetailViewController.h
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModifiedAgentDataDelegate.h"
#import "Agent.h"

@interface AgentEditViewController : UIViewController

@property (strong, nonatomic) Agent *agent;
@property (weak, nonatomic)id<ModifiedAgentDataDelegate> delegate;

@end
