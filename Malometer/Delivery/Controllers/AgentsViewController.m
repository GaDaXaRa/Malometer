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
#import "AgentsFetchedResultsControllerDelegate.h"
#import "AgentsTableViewDatasource.h"

static NSString *const detailCreateSegueName = @"CreateAgent";
static NSString *const detailEditSegueName = @"EditAgent";

@interface AgentsViewController ()

@property (strong, nonatomic) AgentsFetchedResultsControllerDelegate *fetchedResultsControllerDelegate;
@property (strong, nonatomic) AgentsTableViewDatasource *tableViewDataSource;

@end

@implementation AgentsViewController

#pragma mark -
#pragma mark Lazy getting

- (AgentsFetchedResultsControllerDelegate *)fetchedResultsControllerDelegate {
    if (!_fetchedResultsControllerDelegate) {
        _fetchedResultsControllerDelegate = [[AgentsFetchedResultsControllerDelegate alloc] init];
        _fetchedResultsControllerDelegate.tableView = self.tableView;
        _fetchedResultsControllerDelegate.fetchedResultsController = self.fetchedResultsController;
    }
    
    return _fetchedResultsControllerDelegate;
}

- (AgentsTableViewDatasource *)tableViewDataSource {
    if (!_tableViewDataSource) {
        _tableViewDataSource = [[AgentsTableViewDatasource alloc] init];
        _tableViewDataSource.fetchedResultsController = self.fetchedResultsController;
    }
    
    return _tableViewDataSource;
}

#pragma mark -
#pragma mark View lifecycle

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self.tableViewDataSource;
    [self titleForDomains];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

#pragma mark -
#pragma mark Navigation

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
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:@"category.name" cacheName:@"Master"];
    self.fetchedResultsController.delegate = self.fetchedResultsControllerDelegate;
    
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
    self.title = [NSString stringWithFormat:@"Controlled domains: %lu", (unsigned long)controlledDomains];
}

@end
