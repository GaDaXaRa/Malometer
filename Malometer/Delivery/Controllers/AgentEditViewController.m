//
//  DetailViewController.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "AgentEditViewController.h"
#import "FreakType+Model.h"
#import "Domain+Model.h"

@interface AgentEditViewController ()<UITextFieldDelegate>
- (void)configureView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *destructionPowerAmount;
@property (weak, nonatomic) IBOutlet UILabel *motivationAmount;
@property (weak, nonatomic) IBOutlet UIStepper *destructionPowerStep;
@property (weak, nonatomic) IBOutlet UIStepper *motivationStep;
@property (weak, nonatomic) IBOutlet UILabel *agentDescription;
@property (weak, nonatomic) IBOutlet UITextField *agentTtypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *agentDomainsTextField;

@end

@implementation AgentEditViewController

static NSArray *dpsArray;
static NSArray *descriptionArray;
static NSArray *motivationsArray;

#pragma mark - Managing the detail item

- (void)setAgent:(id)newDetailItem
{
    if (_agent != newDetailItem) {
        _agent = newDetailItem;
        
        [self configureView];
    }
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObservers];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeObservers];
}

#pragma mark -
#pragma mark Configuring View

- (void)configureView
{
    [self buildAgentDataStringsArrays];
    [self configureDelegates];
    if (self.agent) {
        [self configureSubviewsAtInitValues];
        [self refreshMotivationText];
        [self refreshDestructionText];
        [self refreshAgentDescription];
        [self refreshAgentCategory];
        [self refreshAgentDomains];
    }
}

- (void)configureSubviewsAtInitValues
{
    self.title = self.agent.name;
    self.motivationStep.value = [self.agent.motivation integerValue];
    self.destructionPowerStep.value = [self.agent.destructionPower integerValue];
    self.nameTextField.text = self.agent.name;
}

- (void)buildAgentDataStringsArrays
{
    [self buildAgentDescriptionArray];
    [self buildDpsArray];
    [self buildMotivationsArray];
}

- (void)configureDelegates
{
    self.nameTextField.delegate = self;
    self.agentTtypeTextField.delegate = self;
    self.agentDomainsTextField.delegate = self;
}

#pragma mark -
#pragma mark Key Value Observing

- (void)addObservers {
    [self addObserver:self forKeyPath:@"agent.destructionPower" options:0 context:nil];
    [self addObserver:self forKeyPath:@"agent.motivation" options:0 context:nil];
    [self addObserver:self forKeyPath:@"agent.assessment" options:0 context:nil];
    [self addObserver:self forKeyPath:@"agent.name" options:0 context:nil];
}

- (void)removeObservers {
    [self removeObserver:self forKeyPath:@"agent.destructionPower"];
    [self removeObserver:self forKeyPath:@"agent.motivation"];
    [self removeObserver:self forKeyPath:@"agent.assessment"];
    [self removeObserver:self forKeyPath:@"agent.name"];
}

#pragma mark -
#pragma mark Key Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"agent.destructionPower"]) {
        [self refreshDestructionText];
    } else if ([keyPath isEqualToString:@"agent.motivation"]) {
        [self refreshMotivationText];
    } else if ([keyPath isEqualToString:@"agent.assessment"]) {
        [self refreshAgentDescription];
    } else if ([keyPath isEqualToString:@"agent.name"]) {
        self.title = self.agent.name;
    }
}

#pragma mark -
#pragma mark Actions

- (IBAction)cancelPressed:(id)sender {
    [self.delegate controller:self modifiedData:NO];
}

- (IBAction)savePressed:(id)sender {
    [self storeAgentCategory];
    [self storeAgentDomains];
    [self.delegate controller:self modifiedData:YES];
}

- (IBAction)destructionStepChanged:(id)sender {
    self.agent.destructionPower = [NSNumber numberWithDouble:self.destructionPowerStep.value];
}

- (IBAction)motivationStepChanged:(id)sender {
    self.agent.motivation = [NSNumber numberWithDouble:self.motivationStep.value];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.nameTextField endEditing:YES];
    [self.agentTtypeTextField endEditing:YES];
    [self.agentDomainsTextField endEditing:YES];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.nameTextField) {
        self.agent.name = textField.text;
    } else if (textField == self.agentDomainsTextField) {
        
    } else if (textField == self.agentTtypeTextField) {
        
    }
}

#pragma mark -
#pragma mark Helping Methods

- (void)storeAgentDomains {
    NSMutableSet *domainsSet = [[NSMutableSet alloc] init];
    NSArray *domainsArray = [self.agentDomainsTextField.text componentsSeparatedByString:@","];
    for (NSString *domainName in domainsArray) {
        Domain *domain = [Domain findDomainWithName:domainName inContext:self.agent.managedObjectContext];
        if (!domain) {
            domain = [Domain domainWithName:domainName inContext:self.agent.managedObjectContext];
        }
        [domainsSet addObject:domain];
    }
    self.agent.domains = domainsSet;
}

- (void)storeAgentCategory {
    FreakType *freakType = [FreakType findFreakTypeWithName:self.agentTtypeTextField.text inContext:self.agent.managedObjectContext];
    if (!freakType) {
        freakType = [FreakType freakeTypeWithName:self.agentTtypeTextField.text inContext:self.agent.managedObjectContext];
    }
    self.agent.category = freakType;
}

- (void)refreshAgentCategory {
    self.agentTtypeTextField.text = self.agent.category.name;
}

- (void)refreshAgentDomains {
    NSSet *domains = self.agent.domains;
    NSMutableSet *domainsNamesSet = [[NSMutableSet alloc] init];
    for (Domain *domain in domains) {
        [domainsNamesSet addObject:domain.name];
    }
    self.agentDomainsTextField.text = [[domainsNamesSet allObjects] componentsJoinedByString:@","];
}

- (void)refreshMotivationText {
    NSUInteger motivationValue = [[NSNumber numberWithDouble:self.motivationStep.value] integerValue];
    self.motivationAmount.text = motivationsArray[motivationValue];
}

- (void)refreshDestructionText {
    NSUInteger destructionValue = [self.agent.destructionPower integerValue];
    self.destructionPowerAmount.text = dpsArray[destructionValue];
}

- (void)refreshAgentDescription {
    self.agentDescription.text = descriptionArray[[self.agent.assessment integerValue]];
}

- (void)buildAgentDescriptionArray {
    descriptionArray = @[@"No Way", @"Pussy", @"Not Bad", @"Will contract", @"Serial killer"];
}

- (void)buildDpsArray {
    dpsArray = @[@"Pussy", @"Weak", @"Hurts a little", @"Bad guy", @"Destructor"];
}

- (void)buildMotivationsArray {
    motivationsArray = @[@"Fucking idiot", @"Rarely awake", @"Ok, not bad", @"Good mentalitation", @"Focused in destruction"];
}

@end
