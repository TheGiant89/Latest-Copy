//
//  viewDevice.m
//  deviceViewer
//
//  Created by Michael Bonds on 11/17/13.
//  Copyright (c) 2013 Michael Bonds. All rights reserved.
//

#import "viewDevice.h"
#import "MEBAppDelegate.h"

@interface viewDevice ()

@end

@implementation viewDevice
{
    NSArray *resultsArray; // array returned by the database
    NSManagedObjectContext *context;
    NSMutableArray *tableContent; // results array is formatted for output and stored here
    NSString *deviceTitle; // used by other methods
    int imageAddNumber; // Used to keep track of what image number is being added
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
    self.table.delegate = self;
    self.table.dataSource = self;
    
    MEBAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DeviceStore" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:@"devicename like %@", self.deviceName]];
    NSError *error;
    resultsArray = [context executeFetchRequest:request error:&error];
    
    tableContent = [[NSMutableArray alloc] init];

    // If the results array is returned with any data in it, the data is found, read, and formatted for output to table cells
    if([resultsArray count] > 0)
    {
        for(NSManagedObject *device in resultsArray)
        {
            if([device valueForKey:@"devicename"] != nil)
            {
                NSString *deviceName = [NSString stringWithFormat:@"Device Name %@", [device valueForKey:@"devicename"]];
                deviceTitle = [NSString stringWithFormat:@"%@", [device valueForKey:@"devicename"]];;
                [tableContent addObject:deviceName];
            }
            else
            {
                NSString *deviceName = @"Device Name";
                [tableContent addObject:deviceName];
            }
            
            if([device valueForKey:@"deviceserial"] != nil)
            {
                NSString *deviceSerial = [NSString stringWithFormat:@"Serial Number %@", [device valueForKey:@"deviceserial"]];
                [tableContent addObject:deviceSerial];
            }
            else
            {
                NSString *deviceSerial = @"Serial Number";
                [tableContent addObject:deviceSerial];
            }
            
            if([device valueForKey:@"phone"] != nil)
            {
                NSString *phone = [NSString stringWithFormat:@"Support Phone %@", [device valueForKey:@"phone"]];
                [tableContent addObject:phone];
            }
            else
            {
                NSString *phone = @"Support Phone";
                [tableContent addObject:phone];
            }
            
            if([device valueForKey:@"email"] != nil)
            {
                NSString *email = [NSString stringWithFormat:@"Support Email %@", [device valueForKey:@"email"]];
                [tableContent addObject:email];
            }
            else
            {
                NSString *email = @"Support Email";
                [tableContent addObject:email];
            }
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            NSString *dateString;
            NSString *currentText;
            NSString *appendedText;
            
            if([device valueForKey:@"startdate"] != nil)
            {
                dateString = [dateFormatter stringFromDate:[device valueForKey:@"startdate"]];
                currentText = @"Warranty Start ";
                appendedText = [currentText stringByAppendingString:dateString];
            
                [tableContent addObject:appendedText];
            }
            else
            {
                appendedText = @"Warranty Start";
                [tableContent addObject:appendedText];

            }
            
            if([device valueForKey:@"enddate"] != nil)
            {
                
                dateString = [dateFormatter stringFromDate:[device valueForKey:@"enddate"]];
                currentText = @"Warranty End ";
                appendedText = [currentText stringByAppendingString:dateString];
            
                [tableContent addObject:appendedText];
            }
            else
            {
                appendedText = @"Warranty End";
                [tableContent addObject:appendedText];
            }
            
            NSNumber *renewable = [device valueForKey:@"renewable"];
        
            [tableContent addObject:renewable];
        }
    }
    imageAddNumber = 1;
    
    [self retreiveImages];
}

-(void)retreiveImages
{
    int imageReadNumber = 1;    // Loop counter
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    
    while (imageReadNumber < 4)
    {
        NSString *imageName = [NSString stringWithFormat:@"%@_%d", deviceTitle, imageReadNumber];
        NSString *filePath = [documentsPath stringByAppendingPathComponent:imageName];
        
        NSData *jpegData = [NSData dataWithContentsOfFile:filePath];
        if(jpegData != nil)
        {
            UIImage *imageToDisplay = [UIImage imageWithData:jpegData];
            switch (imageReadNumber)
            {
                case 1:
                    self.imageOne.image = imageToDisplay;
                    break;
                case 2:
                    self.imageTwo.image = imageToDisplay;
                    break;
                case 3:
                    self.imageThree.image = imageToDisplay;
                    break;
                default:
                    break;
            }
            self.imageOne.image = imageToDisplay;
        }
        imageReadNumber++;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    resultsArray = nil;
    context = nil;
    tableContent = nil;
    deviceTitle = nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"deviceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    NSNumber *number = [NSNumber numberWithBool:YES];
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = [tableContent objectAtIndex:0];
            break;
        case 1:
            cell.textLabel.text = [tableContent objectAtIndex:1];
            break;
        case 2:
            cell.textLabel.text = [tableContent objectAtIndex:2];
            break;
        case 3:
            cell.textLabel.text = [tableContent objectAtIndex:3];
            break;
        case 4:
            cell.textLabel.text = [tableContent objectAtIndex:4];
            break;
        case 5:
            cell.textLabel.text = [tableContent objectAtIndex:5];
            break;
        case 6:
            if([[tableContent objectAtIndex:6] isEqualToNumber:number])
                cell.textLabel.text = @"Warranty is Renewable";
            else
                cell.textLabel.text = @"Warranty is Not Renewable";
    }
    
    return cell;
}

/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *deviceName = cell.textLabel.text;
    
    if([deviceName isEqualToString:@"Add New Device"])
        [self performSegueWithIdentifier:@"addSegue" sender:self];
    else
        [self performSegueWithIdentifier:@"viewSegue" sender:self];
}
*/

- (IBAction)addPictures:(id)sender
{
    [self startMediaBrowserFromViewController:self usingDelegate:self];
}

- (BOOL) startMediaBrowserFromViewController: (UIViewController*) controller
                               usingDelegate: (id <UIImagePickerControllerDelegate,
                                               UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeSavedPhotosAlbum] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    mediaUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    
    mediaUI.allowsEditing = NO;
    
    mediaUI.delegate = delegate;
    
    [controller presentViewController: mediaUI animated: YES completion:nil];
    return YES;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    if(imageAddNumber <= 3)
    {
        UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
        NSData *imageData = UIImageJPEGRepresentation(selectedImage, 1.0);
    
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
    
        NSString *imageName = [NSString stringWithFormat:@"%@_%d", deviceTitle, imageAddNumber];
    
        NSString *fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
    
        [imageData writeToFile:fullPathToFile atomically:NO];
    
        imageAddNumber++;
        [self retreiveImages];
    }
}


@end
