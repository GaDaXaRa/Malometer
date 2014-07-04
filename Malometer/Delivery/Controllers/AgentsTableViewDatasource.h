//
//  AgentsTableViewDatasource.h
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 04/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AgentsTableViewDatasource : NSObject <UITableViewDataSource>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
