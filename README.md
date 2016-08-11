# addressManager
# 集成了系统通讯录  可增删改查 
# Use it
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

        // MARK: 删除通讯录记录
        [[AddressBookManager sharedInstance] deleteAddressBook:model WithType:0];
        // MARK: 修改通讯录记录
        [[AddressBookManager sharedInstance] replaceAddressBook:model];
        // MARK: 添加通讯录记录
        [[AddressBookManager sharedInstance] addAddressBook:model];
        addressArray =  [[AddressBookManager sharedInstance] getAddressBookList];
        NSLog(@"%@",addressArray);

    }
}];