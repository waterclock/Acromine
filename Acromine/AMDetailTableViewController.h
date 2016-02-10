//
//  AMDetailTableViewController.h
//  Acromine
//
//  Created by Steven Schuldt on 2/9/16.
//  Copyright © 2016 Interlacia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMDetailTableViewController : UITableViewController

@property (nonatomic, retain) NSArray *variationsArray;
@property (nonatomic, retain) NSDictionary *acronymDict;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
