//
//  AMDetailTableViewController.m
//  Acromine
//
//  Created by Steven Schuldt on 2/9/16.
//  Copyright © 2016 Interlacia. All rights reserved.
//

#import "AMDetailTableViewController.h"
#import "Constants.h"

@implementation AMDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSNumber *freq = [self.acronymDict valueForKey:@"freq"];
    NSNumber *since = [self.acronymDict valueForKey:@"since"];
    NSInteger variations = [[self.acronymDict objectForKey:@"vars"] count];
    
    if(kVerboseMode) {
        NSLog(@"Acronym dictionary = %@", self.acronymDict);
    }
    
    self.titleLabel.text = [self.acronymDict valueForKey:@"lf"];
    self.subtitleLabel.text = [NSString stringWithFormat:@"Frequency: %@ Since: %@ Variations: %lu", freq, since, variations];
    
    self.variationsArray = [self.acronymDict objectForKey:@"vars"];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.variationsArray.count;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"VariationCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *varDict = [self.variationsArray objectAtIndex:indexPath.row];
    
    NSNumber *freq = [varDict valueForKey:@"freq"];
    NSNumber *since = [varDict valueForKey:@"since"];
    
    // Configure the cell...
    cell.textLabel.text = [varDict valueForKey:@"lf"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Frequency: %@ Since: %@", freq, since];
    
    return cell;
}

@end
