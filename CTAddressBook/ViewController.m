//
//  ViewController.m
//  CTAddressBook
//
//  Created by AlanYen on 2016/8/4.
//  Copyright © 2016年 Alan-App. All rights reserved.
//

#import "ViewController.h"
#import "CTAddressBookManager.h"

@interface CTTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation CTTableViewCell

@end

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *personEntityArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CTAddressBook";
    
    CTAddressBookManager *manager = [CTAddressBookManager manager];
    CTAddressBookAuthStatus status = [manager getAuthStatus];
    if (status == kCTAddressBookAuthStatusNotDetermined) {
        [[CTAddressBookManager manager] askUserWithSuccess:^{
            self.personEntityArray = [manager getPersonInfoArray];
            [self.tableView reloadData];
        } failure:^{
            NSLog(@"失敗");
        }];
    }
    else if (status == kCTAddressBookAuthStatusAuthorized) {
        self.personEntityArray = [manager getPersonInfoArray];
        [self.tableView reloadData];
    }
    else {
        NSLog(@"沒有權限");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - [UITableViewDataSource]

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.personEntityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CTTableViewCell"
                                                        forIndexPath:indexPath];
    
    CTPersonInfoEntity *info = [self.personEntityArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = info.fullname;
    cell.detailLabel.text = info.phoneNumber;

    if (info.imageData) {
        cell.profileImageView.image = [UIImage imageWithData:info.imageData];
    }
    else {
        cell.profileImageView.image = [UIImage imageNamed:@"profile"];
    }
    cell.profileImageView.layer.cornerRadius = (CGRectGetHeight(cell.profileImageView.frame) * 0.5);

    return cell;
}

#pragma mark -
#pragma mark - [UITableViewDelegate]

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    return 66.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end