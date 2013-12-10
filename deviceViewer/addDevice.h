//
//  addDevice.h
//  deviceViewer
//
//  Created by Michael Bonds on 11/12/13.
//  Copyright (c) 2013 Michael Bonds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addDevice : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;
- (IBAction)pickerViewDoneButton:(id)sender;
- (IBAction)viewDone:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *serialNumber;
@property (weak, nonatomic) IBOutlet UITextField *deviceName;
@property (weak, nonatomic) IBOutlet UITextField *phoneSupport;
@property (weak, nonatomic) IBOutlet UITextField *emailSupport;


@end
