//
//  MainViewController.h
//  deviceViewer
//
//  Created by Michael Bonds on 11/12/13.
//  Copyright (c) 2013 Michael Bonds. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *table;


@end
