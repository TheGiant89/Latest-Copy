//
//  MainViewController.m
//  deviceViewer
//
//  Created by Michael Bonds on 11/12/13.
//  Copyright (c) 2013 Michael Bonds. All rights reserved.
//

#import "MainViewController.h"
#import "MEBAppDelegate.h"
#import "addDevice.h"
#import "viewDevice.h"


@interface MainViewController ()

@end

@implementation MainViewController
{
    NSMutableArray *deviceList;
    NSManagedObjectContext *context;
    NSString *passableDeviceName;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Populate device array to use as table datasource
    //deviceList = [NSArray arrayWithObjects:@"Add New Device", nil];
    // Set table delegate and data source
    self.table.delegate = self;
    self.table.dataSource = self;

    /*
    // get core data context
    MEBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    // define entity, initialize empty request, associate request with entity, query coredata for a single property, store results in resultsArray
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DeviceStore" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
//    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"devicename", nil]];
    NSError *error;
    NSArray *resultsArray = [context executeFetchRequest:request error:&error];
    deviceList = [[NSMutableArray alloc] init];
    //App crashes if this is uncommented
    if([resultsArray count] > 0)
    {
        for(NSManagedObject *device in resultsArray)
        {
            [deviceList addObject:[device valueForKey:@"devicename"]];
        }
     }
    [deviceList addObject:@"Add New Device"];
     */
     
}

-(void)viewDidAppear:(BOOL)animated
{
    // get core data context
    MEBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    // define entity, initialize empty request, associate request with entity, query coredata for a single property, store results in resultsArray
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DeviceStore" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    //    [request setPropertiesToFetch:[NSArray arrayWithObjects:@"devicename", nil]];
    NSError *error;
    NSArray *resultsArray = [context executeFetchRequest:request error:&error];
    deviceList = [[NSMutableArray alloc] init];
    //App crashes if this is uncommented
    if([resultsArray count] > 0)
    {
        for(NSManagedObject *device in resultsArray)
        {
            [deviceList addObject:[device valueForKey:@"devicename"]];
        }
    }
    [deviceList addObject:@"Add New Device"];
    [[self table] reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    deviceList = nil;
    context = nil;
    passableDeviceName = nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [deviceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"deviceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    cell.textLabel.text = [deviceList objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *deviceName = cell.textLabel.text;
    passableDeviceName = deviceName;
    
    if([deviceName isEqualToString:@"Add New Device"])
        [self performSegueWithIdentifier:@"addSegue" sender:self];
    else
        [self performSegueWithIdentifier:@"viewSegue" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"viewSegue"])
    {
        viewDevice *destinationView = [segue destinationViewController];
        destinationView.deviceName = passableDeviceName;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view setNeedsDisplay];
}

-(IBAction)unwindFromDeviceView:(UIStoryboardSegue *)sender
{
}


@end
