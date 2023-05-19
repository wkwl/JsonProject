//
//  NSObject+Model.m
//  testPod
//
//  Created by sgx_05 on 2023/5/18.
//

#import "NSObject+Model.h"

@implementation NSObject (Model)
+ (id)initWithiDiction:(NSDictionary *)dic {
    id obj = [[[self class] alloc] init];
    if(obj){
        
    }
    return obj;
}

+ (NSArray *)modelArrayDiction:(NSArray *)array {
    NSMutableArray *list = [NSMutableArray array];
    for (int i = 0; i<array.count; i++) {
        NSDictionary *dic = array[i];
       id object = [self initWithiDiction:dic];
        [list addObject:object];
    }
    return list;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

NSString *WK_EncodeStringFromDic(NSDictionary *dic, NSString *key)
{
    if (nil != dic && [dic isKindOfClass:[NSDictionary class]]) {
        id temp = [dic objectForKey:key];
        if ([temp isKindOfClass:[NSString class]]) {
            NSString *string = [NSString stringWithFormat:@"%@",temp];
            return string;
        }
        else if ([temp isKindOfClass:[NSNumber class]]) {
            NSString *string = [NSString stringWithFormat:@"%@",temp];
            return string;
        }
    }
    return @"";
}

NSArray *WK_EncodeArrayFromDic(NSDictionary *dic, NSString *key)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSArray class]]) {
        return temp;
    }
    return nil;
}
NSDictionary *WK_EncodeDicFromDic(NSDictionary *dic, NSString *key)
{
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id temp = [dic objectForKey:key];
    if ([temp isKindOfClass:[NSDictionary class]]) {
        return temp;
    }
    return nil;
}

@end
