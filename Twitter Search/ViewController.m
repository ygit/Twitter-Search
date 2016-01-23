//
//  ViewController.m
//  Twitter Search
//
//  Created by yogesh singh on 22/01/16.
//  Copyright © 2016 yogesh. All rights reserved.
//

#import <STTwitter/STTwitter.h>
#import "ViewController.h"
#import "Tweet+CoreDataProperties.h"
#import "AppDelegate.h"


@interface ViewController() <STTwitterRequestProtocol, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic) STTwitterAPI *twitter;
@property (strong, nonatomic) NSArray *dataArr;

@end


@implementation ViewController
@synthesize textField, table, twitter, dataArr;

#pragma mark - View Lifecycle


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:@"e7Mhw0VZVIlYCX99Vp2YXIsxP"
                                              consumerSecret:@"F4IfLlNSsxbsAMe0frPFb6X90PWtjDzK5LVLP7NT4pO1XMR1i0"];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    __weak typeof(self) weakSelf = self;
    
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
    
        [twitter getSearchTweetsWithQuery:@"iOS"    //or any other search term
                             successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                 
                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                 [weakSelf parseDataFromResponse:statuses];
                                 dataArr = [weakSelf fetchDataFromPersistentStore];
                                 [table reloadData];
                                 
                             } errorBlock:^(NSError *error) {
                                 
                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                 NSLog(@"error : %@", error.localizedDescription);
                             }];
        
    } errorBlock:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"error : %@", error);
    }];
}

- (void)parseDataFromResponse:(NSArray *)statuses{

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    for (NSDictionary *userDict in statuses) {
        
        Tweet *newTweet = [NSEntityDescription insertNewObjectForEntityForName:@"Tweet"
                                                        inManagedObjectContext:appDelegate.managedObjectContext];

        newTweet.userID = [userDict objectForKey:@"id_str"];
        newTweet.name = [userDict objectForKey:@"name"];
        newTweet.text = [userDict objectForKey:@"text"];
        newTweet.date = [userDict objectForKey:@"created_at"];
        //parse more attributes if desired
    }
    
    if ([appDelegate.managedObjectContext hasChanges]) {
        NSError *saveErr;
        [appDelegate.managedObjectContext save:&saveErr];
    }
}

- (NSArray *)fetchDataFromPersistentStore{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSError *fetchErr;
    NSArray *fetchedArr = [appDelegate.managedObjectContext executeFetchRequest:[NSFetchRequest fetchRequestWithEntityName:@"Tweet"]
                                                                          error:&fetchErr];
    return fetchedArr;
}

- (void)cancel{
    NSLog(@"STTwitterAPI cancel");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table Helpers

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 145.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArr.count;
}

NSString *cellIdentifier = @"cellIdentifier";

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        
        cell.detailTextLabel.numberOfLines = 1;
        cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    if (indexPath.row < dataArr.count) {
        
        Tweet *tweetObj = dataArr[indexPath.row];
        
        cell.textLabel.text = tweetObj.text;
        cell.detailTextLabel.text = tweetObj.date;
        //or create & deque a custom cell
    }
    
    return cell;
}

@end
