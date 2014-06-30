//
//  DetailViewController.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "AgentEditViewController.h"

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
        self.motivationStep.value = [self.agent.motivation integerValue];
        self.destructionPowerStep.value = [self.agent.destructionPower integerValue];
        self.nameTextField.text = self.agent.name;
        [self refreshMotivationText];
        [self refreshDestructionText];
        [self refreshAgentDescription];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserver:self forKeyPath:@"agent.destructionPower" options:0 context:nil];
    [self addObserver:self forKeyPath:@"agent.motivation" options:0 context:nil];
    [self addObserver:self forKeyPath:@"agent.assessment" options:0 context:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeObserver:self forKeyPath:@"agent.destructionPower"];
    [self removeObserver:self forKeyPath:@"agent.motivation"];
    [self removeObserver:self forKeyPath:@"agent.assessment"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    }
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
    self.agent.destructionPower = [NSNumber numberWithDouble:self.destructionPowerStep.value];
}

- (IBAction)motivationStepChanged:(id)sender {
    self.agent.motivation = [NSNumber numberWithDouble:self.motivationStep.value];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark Helping Methods

- (void)assignAgentValues {
    self.agent.name = self.nameTextField.text;
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
