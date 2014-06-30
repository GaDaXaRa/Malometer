//
//  DetailViewController.m
//  Malometer
//
//  Created by Miguel Santiago Rodríguez on 30/06/14.
//  Copyright (c) 2014 ironhack. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *destructionPowerAmount;
@property (weak, nonatomic) IBOutlet UILabel *motivationAmount;
@property (weak, nonatomic) IBOutlet UIStepper *destructionPowerStep;
@property (weak, nonatomic) IBOutlet UIStepper *motivationStep;

@property (strong, nonatomic) NSArray *namesArray;
@property (strong, nonatomic) NSArray *dpsArray;
@property (strong, nonatomic) NSArray *motivationsArray;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
