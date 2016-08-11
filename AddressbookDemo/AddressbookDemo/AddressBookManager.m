//
//  AddressBookManager.m
//  AddressbookDemo
//
//  Created by 索晓晓 on 16/8/10.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import "AddressBookManager.h"
#import <objc/objc-runtime.h>
#import <AddressBook/AddressBook.h>

#define XCODE_COLORS_ESCAPE @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color
#define NSLogBlue(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,0,255;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define NSLogRed(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg255,0,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)
#define NSLogGreen(frmt, ...) NSLog((XCODE_COLORS_ESCAPE @"fg0,255,0;" frmt XCODE_COLORS_RESET), ##__VA_ARGS__)

@implementation AddressModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
//        ({
//                City = Tiburon;                //城市
//                Country = USA;                 //国家
//                CountryCode = us;              //国家编码
//                State = CA;                    //州
//                Street = "1747 Steuart Street";//街道
//                ZIP = 94920;                   //邮政编码
//          })
        for (NSString *key in dict.allKeys) {
            
            if ([key isEqualToString:@"City"]) {
                self.City = dict[@"City"];
            }
            if ([key isEqualToString:@"Country"]) {
                self.Country = dict[@"Country"];
            }
            if ([key isEqualToString:@"CountryCode"]) {
                self.CountryCode = dict[@"CountryCode"];
            }
            if ([key isEqualToString:@"State"]) {
                self.State = dict[@"State"];
            }
            if ([key isEqualToString:@"Street"]) {
                self.Street = dict[@"Street"];
            }
            if ([key isEqualToString:@"ZIP"]) {
                self.ZIP = dict[@"ZIP"];
            }
        }
        
        
    }
    return self;
}

+ (instancetype)addressModelWithDict:(NSDictionary *)dict
{
    return [[self alloc] initWithDict:dict];
}

@end

@implementation AddressBookModel

#pragma mark - 测试输出
//+ (NSArray *)getPropertyName
//{
//    unsigned int count;
//    //获取类中所有的成员属性
//    objc_property_t *properties = class_copyPropertyList(self, &count);
//    
//    NSMutableArray *dataArray = [NSMutableArray array];
////    NSMutableArray *attArray = [NSMutableArray array];
//    
//    for (int i = 0; i < count; i ++) {
//        
//        objc_property_t property = properties[i];
//        const char * name = property_getName(property);//获取属性名字
////        const char * attributes = property_getAttributes(property);//获取属性类型
//        
//        NSString *stringName = [[NSString alloc] initWithCString:name encoding:NSASCIIStringEncoding];
////        NSString *stringAttributes = [[NSString alloc] initWithCString:attributes encoding:NSASCIIStringEncoding];
//        
////        NSLog(@"%@",stringName); //属性名称
////        NSLog(@"%@",stringAttributes); //属性类型
//        
//        [dataArray addObject:stringName];
////        [attArray addObject:stringAttributes];
//        
//    }
//    
//    return dataArray;
//}
//
//
//- (NSString *)description
//{
//    NSMutableString *str = [[NSMutableString alloc] init];
//    
//    for (NSString *obj in [AddressBookModel getPropertyName]) {
//        
//        id property = [self valueForKey:obj];
//        if ([property isKindOfClass:[NSString class]]) {
//            [str appendString:property];
//        }
//    }
//    
//    return str;
//}

- (instancetype)initWithObj:(id)recordRef
{
    if (self = [super init]) {
        
        //取得记录中得信息
        //名称
        NSString *firstName=(__bridge NSString *) ABRecordCopyValue((__bridge ABRecordRef)(recordRef), kABPersonFirstNameProperty);//注意这里进行了强转，不用自己释放资源
        NSLogBlue(@"firstName = %@",firstName);
        if (firstName == nil ) {
            firstName = @"";
        }
        self.name = firstName;
        //姓氏
        NSString *lastName=(__bridge NSString *)ABRecordCopyValue((__bridge ABRecordRef)(recordRef), kABPersonLastNameProperty);
        NSLogBlue(@"lastName = %@",lastName);
        if (lastName == nil ) {
            lastName = @"";
        }
        self.surname = lastName;
        //电话
        ABMultiValueRef phoneNumbersRef= ABRecordCopyValue((__bridge ABRecordRef)(recordRef), kABPersonPhoneProperty);//获取手机号，注意手机号是ABMultiValueRef类，有可能有多条
       NSArray *phoneNumbers=(__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumbersRef);//取得CFArraryRef类型的手机记录并转化为NSArrary
//        NSLogBlue(@"phoneNumbers = %@",phoneNumbers);
        
//        long count= ABMultiValueGetCount(phoneNumbersRef);
//        
//        NSMutableArray *phoneNumbers = [NSMutableArray array];
//        for(int i=0;i<count;i++) {
//            [phoneNumbers addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phoneNumbersRef, i))];
//           }
        NSLogBlue(@"phoneNumbers = %@",phoneNumbers);
        self.phone = phoneNumbers;
        //邮箱
        ABMultiValueRef emailRef= ABRecordCopyValue((__bridge ABRecordRef)(recordRef), kABPersonEmailProperty);//获取邮箱，注意是ABMultiValueRef类，有可能有多条
        NSArray *emailRefs=(__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(emailRef);//取得CFArraryRef类型的转化为NSArrary
        NSLogBlue(@"emailRef = %@",emailRefs);
        self.email = emailRefs;
        
        
        //地址
        ABMultiValueRef addressRef =ABRecordCopyValue((__bridge ABRecordRef)(recordRef), kABPersonAddressProperty);//注意这里进行了强转，不用自己释放资源
        NSArray *addressRefs=(__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(addressRef);//取得CFArraryRef类型的转化为NSArrary
        NSLogBlue(@"address = %@",addressRefs);
        
        NSMutableArray *adds = [NSMutableArray array];
        for (NSDictionary *addObj in addressRefs) {
            
            AddressModel *model = [AddressModel addressModelWithDict:addObj];
            
            [adds addObject:model];
        }
        self.addresses = adds;
        
        //头像
        if(ABPersonHasImageData((__bridge ABRecordRef)(recordRef))){//如果有照片数据
            NSData *imageData= (__bridge NSData *)(ABPersonCopyImageData((__bridge ABRecordRef)(recordRef)));
            
            self.head = [UIImage imageWithData:imageData];
            NSLogGreen(@"有头像");
        }else{
            NSLogGreen(@"无头像");
            self.head = [UIImage new];
        }
        
        //编号
        NSInteger addressID =ABRecordGetRecordID((__bridge ABRecordRef)(recordRef));
        NSLogGreen(@"addressID = %ld",addressID);
        
        self.addressID = addressID;
        
        NSLogRed(@"============");
        
        
    }
    return self;
}

+ (instancetype)addressModelWithObj:(id)obj
{
    return [[self alloc] initWithObj:obj];
}

@end


@interface AddressBookManager ()

@property (nonatomic ,assign)ABAddressBookRef addressBook;//通讯录

@end

@implementation AddressBookManager

+ (instancetype)sharedInstance
{
    static AddressBookManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AddressBookManager alloc] init];
        //创建通讯录对象
        instance.addressBook=ABAddressBookCreateWithOptions(NULL, NULL);
        
    });
    return instance;
}

#pragma mark - 获取通讯录权限
/**
 * 获取通讯录权限
 */
- (void)addressBookAuthority:(void (^)(BOOL auth))block
{
    __block BOOL ret = NO;
    //请求访问用户通讯录,注意无论成功与否block都会调用
     ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
         if (!granted) {
             NSLogRed(@"未获得通讯录访问权限！");
         }else{
             NSLogGreen(@"获得通讯录访问权限！");
             ret = YES;
         }
         
         if (block) {
             block(ret);
         }
    });
}
#pragma mark - 返回授权状态
/**
 * 返回授权状态
 */
- (AddressBookAuthStatus)getAuthStatus
{
    return (AddressBookAuthStatus)ABAddressBookGetAuthorizationStatus();
}
#pragma mark - 获取通讯录目录
/**
 * 获取通讯录目录
 */
- (NSArray *)getAddressBookList
{
    //取得通讯录访问授权
    AddressBookAuthStatus authorization= [self getAuthStatus];
    //如果未获得授权
    if (authorization != kAddressBookAuthStatusAuthorized) {
         NSLog(@"尚未获得通讯录访问授权！");
          return @[];
      }
    //取得通讯录中所有人员记录
    CFArrayRef allPeople= ABAddressBookCopyArrayOfAllPeople(self.addressBook);
    
    NSArray *allPersonArray = (__bridge NSArray *)allPeople;
    //释放资源
    CFRelease(allPeople);
    
    return [self setUpAddressBookWithAllPerson:allPersonArray];
}

- (NSMutableArray *)setUpAddressBookWithAllPerson:(NSArray *)allPerson
{
    NSMutableArray *temp = [NSMutableArray array];
    
    for (int i = 0 ;i < allPerson.count;i++) {
        
        //取得一条人员记录
        ABRecordRef recordRef=(__bridge ABRecordRef)allPerson[i];
        AddressBookModel *model = [[AddressBookModel alloc] initWithObj:(__bridge id)(recordRef)];
        [temp addObject:model];
    }
    return temp;
}
#pragma mark - 删除通讯录
/**
 * 删除通讯录
 */
- (void)deleteAddressBook:(AddressBookModel *)deleteModel WithType:(AddressBookDeleteType)deleteType
{
    if (deleteType == AddressBookDeleteTypeName) {
        
        [self deletetWithName:deleteModel.name];
        
    }else{
        
        [self deleteWithID:(ABRecordID)deleteModel.addressID];
    }
    
}
- (void)deletetWithName:(NSString *)personName
{
    CFStringRef personNameRef=(__bridge CFStringRef)(personName);
    CFArrayRef recordsRef= ABAddressBookCopyPeopleWithName(self.addressBook, personNameRef);//根据人员姓名查找
    CFIndex count= CFArrayGetCount(recordsRef);//取得记录数
    for (CFIndex i=0; i!=count; ++i) {
        ABRecordRef recordRef=CFArrayGetValueAtIndex(recordsRef, i);//取得指定的记录
        ABAddressBookRemoveRecord(self.addressBook, recordRef, NULL);//删除
    }
    ABAddressBookSave(self.addressBook, NULL);//删除之后提交更改
    CFRelease(recordsRef);
}

- (void)deleteWithID:(ABRecordID)addressID
{
    ABRecordRef recordRef = ABAddressBookGetPersonWithRecordID(self.addressBook,addressID);
    if (recordRef) {
        ABAddressBookRemoveRecord(self.addressBook, recordRef, NULL);//删除
        ABAddressBookSave(self.addressBook, NULL);//删除之后提交更改
        CFRelease(recordRef);
    }
}


#pragma mark - 根据RecordID修改通讯录
/**
 * 根据RecordID修改通讯录
 */
- (void)replaceAddressBook:(AddressBookModel *)replaceModel
{
    ABRecordRef recordRef=ABAddressBookGetPersonWithRecordID(self.addressBook,(ABRecordID)replaceModel.addressID);
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, (__bridge CFTypeRef)(replaceModel.name), NULL);//添加名
    ABRecordSetValue(recordRef, kABPersonLastNameProperty, (__bridge CFTypeRef)(replaceModel.surname), NULL);//添加姓
    ABMutableMultiValueRef multiValueRef =ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(multiValueRef, (__bridge CFStringRef)([replaceModel.phone firstObject]), kABWorkLabel, NULL);
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
    //保存记录，提交更改
    ABAddressBookSave(self.addressBook, NULL);
    //释放资源
    CFRelease(multiValueRef);
}

#pragma mark - 添加通讯录
/**
 * 添加通讯录
 */
- (void)addAddressBook:(AddressBookModel *)addModel
{
    //创建一条记录
    ABRecordRef recordRef= ABPersonCreate();
    ABRecordSetValue(recordRef, kABPersonFirstNameProperty, (__bridge CFTypeRef)(addModel.name), NULL);//添加名
    ABRecordSetValue(recordRef, kABPersonLastNameProperty, (__bridge CFTypeRef)(addModel.surname), NULL);//添加姓
    ABMutableMultiValueRef multiValueRef =ABMultiValueCreateMutable(kABStringPropertyType);//添加设置多值属性
    ABMultiValueAddValueAndLabel(multiValueRef, (__bridge CFStringRef)([addModel.phone firstObject]), kABWorkLabel, NULL);//添加工作电话
    ABRecordSetValue(recordRef, kABPersonPhoneProperty, multiValueRef, NULL);
    //添加记录
    ABAddressBookAddRecord(self.addressBook, recordRef, NULL);
    //保存通讯录，提交更改
    ABAddressBookSave(self.addressBook, NULL);
    //释放资源
    CFRelease(recordRef);
    CFRelease(multiValueRef);
}

@end
