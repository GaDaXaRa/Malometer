//
//  MasterViewController.h
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "ModifiedAgentDataDelegate.h"

@interface AgentsViewController : UITableViewController <ModifiedAgentDataDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIManagedDocument *model;

@end
