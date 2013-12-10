//
//  viewDevice.h
//  deviceViewer
//
//  Created by Michael Bonds on 11/17/13.
//  Copyright (c) 2013 Michael Bonds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface viewDevice : UIViewController <UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSString *deviceName;
@property (weak, nonatomic) IBOutlet UITableView *table;
- (IBAction)addPictures:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imageThree;

@end
