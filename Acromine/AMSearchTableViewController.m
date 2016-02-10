//
//  AMSearchTableViewController.m
//  Acromine
//
//  Created by Steven Schuldt on 2/9/16.
//  Copyright © 2016 Interlacia. All rights reserved.
//

#import "AMSearchTableViewController.h"
#import "Constants.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <AFNetworking/AFNetworking.h>
#import "AMDetailTableViewController.h"

@interface AMSearchTableViewController ()

@end

@implementation AMSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - SearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchText isEqualToString:@""]) {
        self.storedSearchText = @"";
        self.searchResultsArray = nil;
        [self.tableView reloadData];
        return;
    }
    
    self.storedSearchText = searchText;
    SEL performSearch = @selector(performSearch);
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:performSearch object:nil];
    [self performSelector:performSearch withObject:nil afterDelay:kSearchInputDelay];
}

- (void)performSearch {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?sf=%@", kAcromineServer, self.storedSearchText]];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        self.searchResultsArray = nil;
        
        [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            if([responseObject isKindOfClass:[NSArray class]] && [(NSArray *)responseObject count]) {
                 self.searchResultsArray = [[responseObject objectAtIndex:0] objectForKey:@"lfs"];
                if(kVerboseMode) {
                    NSLog(@"responseObject: %@", [responseObject objectAtIndex:0]);
                    NSLog(@"response count: %lu", self.searchResultsArray.count);
                }
           }
       } failure:^(NSURLSessionTask *operation, NSError *error) {
            // Acromine server response JSON can occasionally confound AFNetworking parser, and this creates a spurious error condition.
            // Attempt Apple JSON parsing as a fallback...
            NSError *parseError = nil;
            id responseObject = [NSJSONSerialization
                                     JSONObjectWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                     options:NSJSONReadingMutableContainers
                                     error:&parseError];
            
            if(parseError == nil) {
                // successfully parsed
                if([responseObject isKindOfClass:[NSArray class]] && [(NSArray *)responseObject count]) {
                    self.searchResultsArray = [[responseObject objectAtIndex:0] objectForKey:@"lfs"];
                    if(kVerboseMode) {
                        NSLog(@"responseObject: %@", [responseObject objectAtIndex:0]);
                        NSLog(@"response count: %lu", self.searchResultsArray.count);
                    }
                }
            } else {
                NSString* errorResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Search Response Error", @"Search Response Error")
                                                                               message:errorResponse
                                                                        preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action) {}];
                
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
           
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
         }];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResultsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"AcronymCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *acronymDict = [self.searchResultsArray objectAtIndex:indexPath.row];
    
    NSNumber *freq = [acronymDict valueForKey:@"freq"];
    NSNumber *since = [acronymDict valueForKey:@"since"];
    NSInteger variations = [[acronymDict objectForKey:@"vars"] count];
    
    // Configure the cell...
    cell.textLabel.text = [acronymDict valueForKey:@"lf"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Frequency: %@ Since: %@ Variations: %lu", freq, since, variations];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    self.selectedItemDict = [self.searchResultsArray objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"DetailSegue" sender:self];
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if([[segue identifier] isEqualToString:@"DetailSegue"]) {
         AMDetailTableViewController *detailViewController = segue.destinationViewController;
         [detailViewController setAcronymDict:self.selectedItemDict];
     }
 }



@end
