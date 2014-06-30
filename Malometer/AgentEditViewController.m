//
//  DetailViewController.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "AgentEditViewController.h"
#import "AssessmentManager.h"


@interface AgentEditViewController ()
- (void)configureView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *destructionPowerAmount;
@property (weak, nonatomic) IBOutlet UILabel *motivationAmount;
@property (weak, nonatomic) IBOutlet UIStepper *destructionPowerStep;
@property (weak, nonatomic) IBOutlet UIStepper *motivationStep;
@property (weak, nonatomic) IBOutlet UILabel *agentDescription;

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

- (void)configureView
{
    [self buildAgentDescriptionArray];
    [self buildDpsArray];
    [self buildMotivationsArray];
    if (self.agent) {
        self.motivationStep.value = [[self.agent valueForKey:@"motivation"] integerValue];
        self.destructionPowerStep.value = [[self.agent valueForKey:@"destructionPower"] integerValue];
        self.nameTextField.text = [self.agent valueForKey:@"name"];
        [self refreshMotivationText];
        [self refreshDestructionText];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Actions

- (IBAction)cancelPressed:(id)sender {
    [self.delegate controller:self modifiedData:NO];
}

- (IBAction)savePressed:(id)sender {
    [self assignAgentValues];
    [self.delegate controller:self modifiedData:YES];
}

- (IBAction)destructionStepChanged:(id)sender {
    [self refreshDestructionText];
}

- (IBAction)motivationStepChanged:(id)sender {
    [self refreshMotivationText];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark Helping Methods

- (void)assignAgentValues {
    [self.agent setValue:[NSNumber numberWithDouble:self.motivationStep.value] forKey:@"motivation"];
    [self.agent setValue:[NSNumber numberWithDouble:self.destructionPowerStep.value] forKey:@"destructionPower"];
    [self.agent setValue:self.nameTextField.text forKey:@"name"];
}

- (void)refreshMotivationText {
    NSUInteger motivationValue = [[NSNumber numberWithDouble:self.motivationStep.value] integerValue];
    self.motivationAmount.text = motivationsArray[motivationValue];
    [self refreshAgentDescription];
}

- (void)refreshDestructionText {
    NSUInteger destructionValue = [[NSNumber numberWithDouble:self.destructionPowerStep.value] integerValue];
    self.destructionPowerAmount.text = dpsArray[destructionValue];
    [self refreshAgentDescription];
}

- (void)refreshAgentDescription {
    NSUInteger motivationValue = [[NSNumber numberWithDouble:self.motivationStep.value] integerValue];
    NSUInteger destructionValue = [[NSNumber numberWithDouble:self.destructionPowerStep.value] integerValue];
    NSUInteger assessmentValue = [AssessmentManager assesmentForDestructionPower:destructionValue andMotivation:motivationValue];
    self.agentDescription.text = descriptionArray[assessmentValue];
}

- (void)buildAgentDescriptionArray {
    descriptionArray = @[@"No Way", @"Pussy", @"Not Bad", @"OK", @"Serial killer"];
}

- (void)buildDpsArray {
    dpsArray = @[@"Pussy", @"Weak", @"Hurts a little", @"Bad guy", @"Destructor"];
}

- (void)buildMotivationsArray {
    motivationsArray = @[@"Fucking idiot", @"Rarely awake", @"Ok, not bad", @"Good mentalitation", @"Focused in destruction"];
}

@end
