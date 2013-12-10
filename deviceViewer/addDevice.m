//
//  addDevice.m
//  deviceViewer
//
//  Created by Michael Bonds on 11/12/13.
//  Copyright (c) 2013 Michael Bonds. All rights reserved.
//

#import "addDevice.h"
#import "MEBAppDelegate.h"
#import "MainViewController.h"

@interface addDevice ()

@end

@implementation addDevice
{
    NSArray *deviceInfo; // Stored text to display in table cells
    NSDate *warrantyStartDate; // Warranty start date
    NSDate *warrantyEndDate; // Warranty end date
    UISwitch *switchview; // toggle switch in table cell
    NSManagedObjectContext *context;
    CGPoint originalCenter; // Original center point of the view

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Table datasource
    deviceInfo = [NSArray arrayWithObjects:@"Warranty Start Date: ", @"Warranty End Date: ", @"Warranty Renewable?", @"Add Documentation", nil];
    self.table.delegate = self;
    self.table.dataSource = self;
    
    // Hide datepicker view and set datepicker mode
    self.datePickerView.hidden = YES;
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    
    // get coredata context
    MEBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    originalCenter = self.view.center;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    deviceInfo = nil;
    warrantyEndDate = nil;
    warrantyStartDate = nil;
    switchview = nil;
    context = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [deviceInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"deviceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.textLabel.text = [deviceInfo objectAtIndex:indexPath.row];
    
    // Populate first two table cells with data information
    if(indexPath.row == 0 || indexPath.row == 1)
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString *dateString;
        dateString = [dateFormatter stringFromDate:self.datePicker.date];
    
        NSString *currentText = cell.textLabel.text;
        NSString *appendedText = [currentText stringByAppendingString:dateString];
        if(indexPath.row == 0)
            warrantyStartDate = self.datePicker.date;
        else
            warrantyEndDate = self.datePicker.date;
        cell.textLabel.text = appendedText;
    }
    
    // Create a switch in the warranty renewable cell
    if ([cell.textLabel.text  isEqual: @"Warranty Renewable?"])
    {
        switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
        cell.accessoryView = switchview;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // present the datepicker if first two table cells are touched
    if(indexPath.row == 0 || indexPath.row == 1)
    {
        self.datePickerView.hidden = NO;
    
        [self.table reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (IBAction)pickerViewDoneButton:(id)sender
{
    self.datePickerView.hidden = YES;
}

-(bool)textFieldShouldReturn:(UITextField *)textField
{
    self.view.center = originalCenter;
    return [textField resignFirstResponder];
}

- (IBAction)viewDone:(id)sender
{
    NSManagedObject *deviceToAdd = [NSEntityDescription insertNewObjectForEntityForName:@"DeviceStore" inManagedObjectContext:context];
    
    // User is required to at least add a device name and serial number
    if(![self.deviceName.text isEqualToString:@""] && ![self.serialNumber.text isEqualToString:@""])
    {
        [deviceToAdd setValue:self.deviceName.text forKey:@"devicename"];
        [deviceToAdd setValue:self.serialNumber.text forKey:@"deviceserial"];
        [deviceToAdd setValue:warrantyStartDate forKey:@"startdate"];
        [deviceToAdd setValue:warrantyEndDate forKey:@"enddate"];
        if(switchview.on)
        {
            bool yesBool = YES;
            NSNumber *boolNumber = [NSNumber numberWithBool:yesBool];
            [deviceToAdd setValue:boolNumber forKey:@"renewable"];
        }
        else
        {
            bool yesBool = NO;
            NSNumber *boolNumber = [NSNumber numberWithBool:yesBool];
            [deviceToAdd setValue:boolNumber forKey:@"renewable"];
        }
        [deviceToAdd setValue:self.phoneSupport.text forKey:@"phone"];
        [deviceToAdd setValue:self.emailSupport.text forKey:@"email"];
        
        NSError *error;

        if(![context save:&error])
        {
            NSLog(@"Save error: %@", [error localizedDescription]);
        }
    }
    else
    {
        UIAlertView *needData = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a device name and serial number" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [needData show];
    }
}

-(bool)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    // Stops segue from occuring if device name or serial number are not entered
    if(([self.deviceName.text isEqualToString:@""] || [self.serialNumber.text isEqualToString:@""]) && [sender tag] == 101)
        return NO;
    else
        return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    // Moves the view above the keyboard if phone or email text fields are selected
    if(self.phoneSupport.isFirstResponder)
    {
        self.view.center = CGPointMake(originalCenter.x, 80);
    }
    if(self.emailSupport.isFirstResponder)
    {
        self.view.center = CGPointMake(originalCenter.x, 80);
    }
}

@end
