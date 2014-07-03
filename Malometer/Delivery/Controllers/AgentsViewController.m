//
//  MasterViewController.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "AgentsViewController.h"

#import "Agent+Model.h"
#import "Domain+Model.h"
#import "AgentEditViewController.h"

static NSString *const detailCreateSegueName = @"CreateAgent";
static NSString *const detailEditSegueName = @"EditAgent";
static NSString *const cellIdentifier = @"Cell";

@interface AgentsViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation AgentsViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self titleForDomains];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

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
    [self configureCell:cell atIndexPath:indexPath];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:detailCreateSegueName]) {
        [self prepareAgentEditControllerForSegue:segue andAgent:[self createNewAgent]];
    } else if ([segue.identifier isEqualToString:detailEditSegueName]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self prepareAgentEditControllerForSegue:segue andAgent:[self findAgentByIndexPath:indexPath]];
    }
}

- (void)prepareAgentEditControllerForSegue:(UIStoryboardSegue *)segue andAgent:(Agent *)agent {
    UINavigationController *nextController = [segue destinationViewController];
    AgentEditViewController *detailController = [nextController.viewControllers firstObject];
    detailController.delegate = self;
    detailController.agent = agent;
}

- (Agent *)createNewAgent
{
    [self.managedObjectContext.undoManager beginUndoGrouping];
    Agent *agent = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([Agent class]) inManagedObjectContext:self.managedObjectContext];
    return agent;
}

- (Agent *)findAgentByIndexPath:(NSIndexPath *)indexPath
{
    [self.managedObjectContext.undoManager beginUndoGrouping];
    Agent *agent = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//    NSString *power = indexPath.row % 2 == 0 ? @"Intelligence" : @"Strength";
//    agent.power = power;
    return agent;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [Agent requestWithSortDescriptors:[self buildSortDescriptors]];
    [NSFetchedResultsController deleteCacheWithName:@"Master"];
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"category.name" cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}

- (NSArray *)buildSortDescriptors {
    NSSortDescriptor *categoryNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"category.name" ascending:YES];
    NSSortDescriptor *destPowSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentDestructionPowerKey ascending:NO];
    NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentNameKey ascending:YES];
   return @[categoryNameSortDescriptor, destPowSortDescriptor, nameSortDescriptor];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Agent *agent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = agent.name;
}

#pragma mark -
#pragma mark ModifiedAgentData Delegate

- (void)controller:(AgentEditViewController *)controller modifiedData:(BOOL)modified {
    [self.managedObjectContext.undoManager setActionName:@"Evil editing"];
    [self.managedObjectContext.undoManager endUndoGrouping];
    if (modified) {
        [self.managedObjectContext save:nil];
    } else {
        [self.managedObjectContext.undoManager undo];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark Helping Methods

- (void)titleForDomains {
    NSError *error;
    NSUInteger controlledDomains = [self.managedObjectContext countForFetchRequest:[Domain requestForDomains]
                                                                             error:&error];
    self.title = [NSString stringWithFormat:@"Controlled domains: %d", controlledDomains];
}

@end
