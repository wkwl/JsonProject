//
//  NSObject+Model.h
//  testPod
//
//  Created by sgx_05 on 2023/5/18.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (Model)

+ (id)initWithiDiction:(NSDictionary *)dic;

+ (NSArray *)modelArrayDiction:(NSArray *)array;

NSString *WK_EncodeStringFromDic(NSDictionary *dic, NSString *key);

NSArray *WK_EncodeArrayFromDic(NSDictionary *dic, NSString *key);

NSDictionary *WK_EncodeDicFromDic(NSDictionary *dic, NSString *key);

@end

NS_ASSUME_NONNULL_END
