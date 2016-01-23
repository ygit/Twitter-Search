//
//  ViewController.m
//  Twitter Search
//
//  Created by yogesh singh on 22/01/16.
//  Copyright © 2016 yogesh. All rights reserved.
//

#import <STTwitter/STTwitter.h>
#import "ViewController.h"
#import "AppDelegate.h"


@interface ViewController() <STTwitterRequestProtocol, UITextFieldDelegate, UITableViewDataSource>

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
    
    [twitter verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
    
        [twitter getSearchTweetsWithQuery:textField.text
                             successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                 
                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                 NSLog(@"searchMetadata : %@", searchMetadata);
                                 NSLog(@"statuses : %@", statuses);
                                 
                             } errorBlock:^(NSError *error) {
                                 
                                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                 NSLog(@"error : %@", error.localizedDescription);
                             }];
        
    } errorBlock:^(NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        NSLog(@"error : %@", error);
    }];
    
    
}

- (void)cancel{
    NSLog(@"STTwitterAPI cancel");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - UI Helpers

- (IBAction)textFieldEditingDidEnd:(UITextField *)sender {
    
}


#pragma mark - Table Helpers



@end
