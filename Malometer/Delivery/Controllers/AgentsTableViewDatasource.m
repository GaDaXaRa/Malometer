//
//  AgentsTableViewDatasource.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 04/07/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "AgentsTableViewDatasource.h"
#import "AgentsFetchedResultsControllerDelegate.h"

static NSString *const cellIdentifier = @"Cell";

@implementation AgentsTableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *categoryName = [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    NSNumber *dpAvg = [[[[self.fetchedResultsController sections] objectAtIndex:section] objects] valueForKeyPath:@"@avg.destructionPower"];
    return [NSString stringWithFormat:@"%@ (%@)", categoryName, dpAvg];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    AgentsFetchedResultsControllerDelegate *fetchedResultControllerDelegate = (AgentsFetchedResultsControllerDelegate *)self.fetchedResultsController.delegate;
    [fetchedResultControllerDelegate configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


@end
