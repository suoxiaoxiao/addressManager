//
//  AddressBookManager.h
//  AddressbookDemo
//
//  Created by 索晓晓 on 16/8/10.
//  Copyright © 2016年 SXiao.RR. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AddressModel :NSObject
//        (
//            {
//                City = Tiburon;                //城市
//                Country = USA;                 //国家
//                CountryCode = us;              //国家编码
//                State = CA;                    //州
//                Street = "1747 Steuart Street";//街道
//                ZIP = 94920;                   //邮政编码
//            }
//        )

@property (nonatomic ,strong)NSString *City;//城市
@property (nonatomic ,strong)NSString *Country;//国家
@property (nonatomic ,strong)NSString *CountryCode;//国家编码
@property (nonatomic ,strong)NSString *State;//州
@property (nonatomic ,strong)NSString *Street;//街道
@property (nonatomic ,strong)NSString *ZIP;//邮政编码

+ (instancetype)addressModelWithDict:(NSDictionary *)dict;

@end


@interface AddressBookModel : NSObject
@property (nonatomic ,strong)NSString *surname;//姓
@property (nonatomic ,strong)NSString *name;// 名称
@property (nonatomic ,strong)NSArray *phone;//电话
@property (nonatomic ,strong)NSArray *email;//邮箱
@property (nonatomic ,strong)NSArray *addresses;//地址
@property (nonatomic ,strong)NSString *info;//其他
@property (nonatomic ,strong)UIImage *head;//头像
@property (nonatomic , assign)NSInteger addressID;//编号

- (instancetype)initWithObj:(id)obj;

+ (instancetype)addressModelWithObj:(id)obj;

@end

typedef enum :NSInteger{
    kAddressBookAuthStatusNotDetermined = 0,    // deprecated, use CNAuthorizationStatusNotDetermined
    kAddressBookAuthStatusRestricted,           // deprecated, use CNAuthorizationStatusRestricted
    kAddressBookAuthStatusDenied,               // deprecated, use CNAuthorizationStatusDenied
    kAddressBookAuthStatusAuthorized            // deprecated, use CNAuthorizationStatusAuthorized
}AddressBookAuthStatus;

typedef enum : NSUInteger {
    AddressBookDeleteTypeName = 0, //根据名称删除
    AddressBookDeleteTypeID,       //根据ID删除
} AddressBookDeleteType;

@interface AddressBookManager : NSObject



+ (instancetype)sharedInstance;


/**
 * 返回授权状态
 */
- (AddressBookAuthStatus)getAuthStatus;

/**
 * 获取通讯录权限
 * @param auth YES:同意访问通讯录 
 *             NO:不同意访问通讯录
 */
- (void)addressBookAuthority:(void (^)(BOOL auth))block;

/**
 * 获取通讯录目录
 */
- (NSArray *)getAddressBookList;

/**
 * 删除通讯录
 * @param deleteType 根据类型删除
 * @param 如果是根据名称删除 根据传的这个名称 检索出所有不管是姓名还是名称是这个的都删除掉
 */
- (void)deleteAddressBook:(AddressBookModel *)deleteModel WithType:(AddressBookDeleteType)deleteType;

/**
 * 根据RecordID修改通讯录
 * 修改姓,名称,工作电话
 */
- (void)replaceAddressBook:(AddressBookModel *)replaceModel;

/**
 * 添加通讯录
 */
- (void)addAddressBook:(AddressBookModel *)addModel;

@end
