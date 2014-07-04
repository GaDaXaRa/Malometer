//
//  AgentsFetchedResultsControllerDelegate.h
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 04/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgentsFetchedResultsControllerDelegate : NSObject <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
