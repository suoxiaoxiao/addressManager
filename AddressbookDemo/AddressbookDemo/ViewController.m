//
//  ViewController.m
//  AddressbookDemo
//
//  Created by 索晓晓 on 16/8/10.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "ViewController.h"
#import "AddressBookManager.h"


@interface ViewController ()


@property (nonatomic ,strong)NSMutableArray *addressArray;//获取到的通讯录

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[AddressBookManager sharedInstance] addressBookAuthority:^(BOOL auth) {
    
        if (auth) {
           NSArray *addressArray =  [[AddressBookManager sharedInstance] getAddressBookList];
            
            NSLog(@"======");
            NSLog(@"%@",addressArray);
//            AddressBookModel *model = [[AddressBookModel alloc] init];
//            model.surname = @"Zhao";
//            model.name = @"XianSheng";
//            model.phone = @[@"1ssssss"];
//            [[AddressBookManager sharedInstance] deleteAddressBook:model WithType:0];
//            [[AddressBookManager sharedInstance] replaceAddressBook:model];
//            [[AddressBookManager sharedInstance] addAddressBook:model];
//            addressArray =  [[AddressBookManager sharedInstance] getAddressBookList];
//            NSLog(@"%@",addressArray);
            
        }
    }];
//    [[AddressBookManager sharedInstance] getAddressBookList];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
