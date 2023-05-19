//
//  NSDictionary+Json.m
//  JsonProject
//
//  Created by sgx_05 on 2023/5/17.
//

#import "NSDictionary+Json.h"
#import <Cocoa/Cocoa.h>

@implementation NSDictionary (Json)



@end


@implementation NSString (JsonStr)



//去除字符串中所有空格
- (NSString *)removeSpace:(NSString *)str {
    if(str == nil){
        return @"";
    }
    NSArray *arr = [str componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *myString = [arr componentsJoinedByString:@""];
    return myString;
}


//json字符串转字典
+ (NSDictionary *)stringToDiction:(NSString *)str {
    if(str == nil){
        return nil;
    }
    str = [str removeSpace:str];
    NSError *error;
    
    
//    [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if(error){
        NSLog(@"%@",error);
        return nil;
    }
    return dic;
}

+(NSAttributedString *)reguLarString:(NSString *)str {
    return [self reguLarString:str modelName:nil];
}

+(NSAttributedString *)reguLarString:(NSString *)str modelName:(NSArray *)modelName {
    NSDictionary *attrDict = @{NSFontAttributeName:[NSFont fontWithName:@"Menlo" size:14],
                                NSForegroundColorAttributeName: [NSColor blackColor],
    };
    NSString *paternStr = @"@interface|@property|nonatomic|strong|copy|assign|NSObject|@end";
    NSMutableString *objectName = [[NSMutableString alloc]initWithString:@""];
    for(int i =0;i<modelName.count;i++){
        [objectName appendFormat:@"%@",modelName[i]];
        if(i!=modelName.count-1){
            [objectName appendString:@"|"];
        }
    }
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:paternStr options:0 error:NULL];
       
    NSArray<NSTextCheckingResult *> *ranges = [regular matchesInString:str options:0 range:NSMakeRange(0, [str length])];
       
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[NSColor blackColor]}];
    [attStr addAttributes:attrDict range:NSMakeRange(0, str.length-1)];
    for (int i = 0; i < ranges.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName:[NSColor colorWithSRGBRed:156/255.20 green:40/255.0 blue:149/255.0 alpha:1.0],NSFontAttributeName:[NSFont systemFontOfSize:14]} range:ranges[i].range];
    }
  
    NSRegularExpression *regular1 = [NSRegularExpression regularExpressionWithPattern:@"NSString|NSArray" options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *ranges1 = [regular1 matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    for (int i = 0; i < ranges1.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName:[NSColor colorWithSRGBRed:67/255.20 green:24/255.0 blue:167/255.0 alpha:1.0],NSFontAttributeName:[NSFont systemFontOfSize:14]} range:ranges1[i].range];
    }
    
    NSRegularExpression *regular2 = [NSRegularExpression regularExpressionWithPattern:objectName options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *ranges2 = [regular2 matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    for (int i = 0; i < ranges2.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName:[NSColor colorWithSRGBRed:23/255.20 green:159/255.0 blue:189/255.0 alpha:1.0],NSFontAttributeName:[NSFont systemFontOfSize:14]} range:ranges2[i].range];
    }
       
    return attStr;
}


/**.m文件内容颜色设置**/
+(NSAttributedString *)regularMString:(NSString *)str modelName:(nullable NSArray *)modelName keyList:(NSArray *)keyList{
    NSDictionary *attrDict = @{NSFontAttributeName:[NSFont fontWithName:@"Menlo" size:14],
                                NSForegroundColorAttributeName: [NSColor blackColor],
    };
    NSString *paternStr = @"@implementation|id|if|return|self|@end|initWithiDiction|modelArrayDiction|init";
    NSMutableString *objectName = [[NSMutableString alloc]initWithString:@""];
    NSMutableString *dicKeyName = [[NSMutableString alloc] initWithString:@""];
    for(int i =0;i<modelName.count;i++){
        [objectName appendFormat:@"%@",modelName[i]];
        [objectName appendString:@"|"];
    }
    for(int i =0;i<keyList.count;i++){
        [dicKeyName appendFormat:@"\"%@\"",keyList[i]];
        if(keyList.count-1 != i){
            [dicKeyName appendString:@"|"];
        }
    }
    [objectName appendString:@"WK_EncodeStringFromDic|WK_EncodeArrayFromDic|WK_EncodeDicFromDic"];
    
   
    
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:paternStr options:0 error:NULL];
       
    NSArray<NSTextCheckingResult *> *ranges = [regular matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSForegroundColorAttributeName:[NSColor blackColor]}];
    [attStr addAttributes:attrDict range:NSMakeRange(0, str.length-1)];
    
    for (int i = 0; i < ranges.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName:[NSColor colorWithSRGBRed:156/255.20 green:40/255.0 blue:149/255.0 alpha:1.0],NSFontAttributeName:[NSFont systemFontOfSize:14]} range:ranges[i].range];
    }
    
    NSRegularExpression *regular1 = [NSRegularExpression regularExpressionWithPattern:@"NSString|class|alloc|NSArray|NSDictionary" options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *ranges1 = [regular1 matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    for (int i = 0; i < ranges1.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName:[NSColor colorWithSRGBRed:67/255.20 green:24/255.0 blue:167/255.0 alpha:1.0],NSFontAttributeName:[NSFont systemFontOfSize:14]} range:ranges1[i].range];
    }
    
    
    NSRegularExpression *regular2 = [NSRegularExpression regularExpressionWithPattern:objectName options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *ranges2 = [regular2 matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    for (int i = 0; i < ranges2.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName:[NSColor colorWithSRGBRed:23/255.20 green:159/255.0 blue:189/255.0 alpha:1.0],NSFontAttributeName:[NSFont systemFontOfSize:14]} range:ranges2[i].range];
    }
    
    NSString *regularStr3 =@"\".*?\"";
    NSRegularExpression *regular3 = [NSRegularExpression regularExpressionWithPattern:regularStr3 options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *ranges3 = [regular3 matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    
    for (int i = 0; i < ranges3.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName:[NSColor redColor],NSFontAttributeName:[NSFont systemFontOfSize:14]} range:ranges3[i].range];
    }
    
    NSString *regularStr =@"(?<=(obj.)).*?(?==)";
    NSRegularExpression *regular4 = [NSRegularExpression regularExpressionWithPattern:regularStr options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *ranges4 = [regular4 matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    for (int i = 0; i < ranges4.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName:[NSColor colorWithSRGBRed:23/255.20 green:159/255.0 blue:189/255.0 alpha:1.0],NSFontAttributeName:[NSFont systemFontOfSize:14]} range:ranges4[i].range];
    }

    return attStr;
}
@end
