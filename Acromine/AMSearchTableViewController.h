//
//  AMSearchTableViewController.h
//  Acromine
//
//  Created by Steven Schuldt on 2/9/16.
//  Copyright © 2016 Interlacia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMSearchTableViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, retain) NSArray *searchResultsArray;
@property (nonatomic, retain) NSString *storedSearchText;
@property (nonatomic, retain) NSDictionary *selectedItemDict;

@end
