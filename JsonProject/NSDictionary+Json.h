//
//  NSDictionary+Json.h
//  JsonProject
//
//  Created by sgx_05 on 2023/5/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Json)



@end

@interface NSString (JsonStr)




//去除空格
- (NSString *)removeSpace:(NSString *)str;

//json字符串转字典
+(NSDictionary *)stringToDiction:(NSString *)str;

/** 设置属性文本颜色*/
+(NSAttributedString *)reguLarString:(NSString *)str;

+(NSAttributedString *)reguLarString:(NSString *)str modelName:(nullable NSArray *)modelName;

/**.m文件内容颜色设置**/
+(NSAttributedString *)regularMString:(NSString *)str modelName:(nullable NSArray *)modelName keyList:(NSArray *)keyList;
@end

NS_ASSUME_NONNULL_END
