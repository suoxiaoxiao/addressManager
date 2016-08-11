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
    
    
    // MARK: 该方法是获取授权
    [[AddressBookManager sharedInstance] addressBookAuthority:^(BOOL auth) {
    
        // MARK: 授权之后
        if (auth) {
            
            //获取通讯录列表
            NSArray *addressArray =  [[AddressBookManager sharedInstance] getAddressBookList];
            
            NSLog(@"======");
            NSLog(@"%@",addressArray);
            AddressBookModel *model = [[AddressBookModel alloc] init];
            model.surname = @"Zhao";
            model.name = @"XianSheng";
            model.phone = @[@"1ssssss"];
            
            // MARK: 删除记录
            [[AddressBookManager sharedInstance] deleteAddressBook:model WithType:0];
            // MARK: 修改记录
            [[AddressBookManager sharedInstance] replaceAddressBook:model];
            // MARK: 添加记录
            [[AddressBookManager sharedInstance] addAddressBook:model];
            addressArray =  [[AddressBookManager sharedInstance] getAddressBookList];
            NSLog(@"%@",addressArray);
            
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
