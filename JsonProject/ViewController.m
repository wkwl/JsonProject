//
//  ViewController.m
//  JsonProject
//
//  Created by sgx_05 on 2023/5/15.
//

#import "ViewController.h"
#import <Masonry.h>
#import "NSDictionary+Json.h"

@interface ViewController ()<NSTextViewDelegate>

@property (nonatomic, strong) NSMutableString *fileString;

@property (nonatomic, strong) NSMutableArray *modelNameList;

@property (nonatomic, strong) NSMutableString *mFileString;

@property (nonatomic, strong) NSMutableString *mulStr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.inputTextView.automaticQuoteSubstitutionEnabled = NO;
    self.inputTextView.delegate = self;
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

/**.h属性生成按钮**/
- (IBAction)create:(id)sender {
    [self.modelNameField.window makeFirstResponder:self.view];
    [self.modePreFieldView.window makeFirstResponder:self.view];
    
    if([self isError]){
        return;
    }
    self.fileString = [[NSMutableString alloc] initWithString:@""];
    self.outTextView.string = @"";
    self.modelNameList = [NSMutableArray array];
    
    
    NSString *jsonString = self.inputTextView.string;
    NSDictionary *jsonDic = [NSString stringToDiction:jsonString];
    if(jsonDic == nil){
        self.outTextView.string = @"";
        return;
    }
    NSString *modelName = @"Root";
    if(self.modelNameField.stringValue.length>0){
        modelName = self.modelNameField.stringValue;
    }
    [self modelDiction:jsonDic modelName:modelName];
    [self.outTextView.textStorage setAttributedString:[NSString reguLarString:self.fileString modelName:self.modelNameList]];
}



/**.m处理生成按钮方法**/
- (IBAction)modelAction:(id)sender {
    [self.modelNameField.window makeFirstResponder:self.view];
    [self.modePreFieldView.window makeFirstResponder:self.view];
    if([self isError]){
        return;
    }
    self.mFileString = [[NSMutableString alloc] initWithString:@""];
    self.outTextView.string = @"";
    self.modelNameList = [NSMutableArray array];
    /** 获取json内容并设置根model的名称*/
    NSString *jsonString = self.inputTextView.string;
    NSDictionary *jsonDic = [NSString stringToDiction:jsonString];
    if(jsonDic == nil){
        self.outTextView.string = @"";
        return;
    }
    NSString *modelName = @"Root";
    if(self.modelNameField.stringValue.length>0){
        modelName = self.modelNameField.stringValue;
    }
    [self jsonDiction:jsonDic modelName:modelName];
    self.outTextView.string = self.mFileString;
    [self.outTextView.textStorage setAttributedString:[NSString regularMString:self.mFileString modelName:self.modelNameList keyList:[jsonDic allKeys]]];
    //    [self.outTextView.textStorage setAttributedString:[NSString reguLarString:self.mFileString modelName:self.modelNameList]];
}


- (IBAction)jsonLineAction:(id)sender {
  
    self.inputTextView.string = [self.inputTextView.string removeSpace:self.inputTextView.string];
    self.inputTextView.string = [self.inputTextView.string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if(self.inputTextView.string.length == 0){
        return;
    }
    [self lineInputData];
    [self.modelNameField.window makeFirstResponder:self.view];
    [self.modePreFieldView.window makeFirstResponder:self.view];
    
}



/**属性文件内容生成 */
- (NSMutableString *)modelDiction:(NSDictionary *)jsonDic modelName:(NSString *)modelName {
    NSString *modelObject = [NSString stringWithFormat:@"%@Model",modelName];
    NSString *preName = self.modePreFieldView.stringValue ? self.modePreFieldView.stringValue:@"";
    NSString *newModelName = [NSString stringWithFormat:@"%@%@",preName,modelObject];
    [self.modelNameList addObject:newModelName];
    
    NSArray *keyLists = [jsonDic allKeys];
    NSMutableString *modelString = [NSMutableString stringWithFormat:@""];
    NSString *start =[NSString stringWithFormat:@"@interface %@%@%@ : NSObject\n\n",preName,modelName,@"Model"];
    [modelString appendString:start];
    
    for(int i = 0;i<keyLists.count;i++){
        NSString *key = keyLists[i];
        id value = [jsonDic objectForKey:key];
        NSString *propertyStr;
        if([value isKindOfClass:[NSString class]]){
            propertyStr = [NSString stringWithFormat:@"@property (nonatomic, copy ) NSString *%@;\n\n",key];
        }else if ([value isKindOfClass:[NSDictionary class]]){
            [self modelDiction:value modelName:key];
            propertyStr = [NSString stringWithFormat:@"@property (nonatomic, strong) %@%@Model *%@;\n\n",preName,key,key];
            [modelString appendString:propertyStr];
            continue;
        }else if([value isKindOfClass:[NSArray class]]){
            id firstObjct = [value firstObject];
            if([firstObjct isKindOfClass:[NSDictionary class]]){
                NSString *subModelName = [NSString stringWithFormat:@"%@",key];
                [self modelDiction:firstObjct modelName:subModelName];
                propertyStr = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray <%@%@Model *> *%@;\n\n",preName,subModelName,key];
                [modelString appendString:propertyStr];
                continue;
            }else{
                propertyStr = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;\n\n",key];
            }
            
        }else {
            propertyStr = [NSString stringWithFormat:@"@property (nonatomic, copy ) NSString *%@;\n\n",key];
        }
        [modelString appendString:propertyStr];
    }
    
    NSString *end =@"@end \n\n\n\n\n\n";
    [modelString appendString:end];
    [self.fileString appendString:modelString];
    //    NSLog(@"%@",modelString);
    return modelString;
    
}


/**.m文件方法等内容处理**/
- (NSMutableString *)jsonDiction:(NSDictionary *)jsonDic modelName:(NSString *)modelName {
    NSString *modelObject = [NSString stringWithFormat:@"%@Model",modelName];
    NSString *preName = self.modePreFieldView.stringValue ? self.modePreFieldView.stringValue:@"";
    NSString *newModelName = [NSString stringWithFormat:@"%@%@",preName,modelObject];
    [self.modelNameList addObject:newModelName];
    
    NSMutableString *mActionString = [[NSMutableString alloc] initWithString:@""];
    
    NSArray *keyLists = [jsonDic allKeys];
    NSString *start =[NSString stringWithFormat:@"@implementation %@%@%@\n\n",preName,modelName,@"Model"];
    NSString *actionStr = @"+ (id)initWithiDiction:(NSDictionary *)dic {\n";
    NSString *fistLineStr = [NSString stringWithFormat:@"    %@%@ *obj = [[[self class] alloc] init];\n",modelName,@"Model"];
    NSString *secondLineStr = @"    if(obj){\n";
    [mActionString appendString:start];
    [mActionString appendString:actionStr];
    [mActionString appendString:fistLineStr];
    [mActionString appendString:secondLineStr];
    
    
    
    for(int i = 0;i<keyLists.count;i++){
        NSString *key = keyLists[i];
        id value = [jsonDic objectForKey:key];
        NSString *valueStr=@"";
        if([value isKindOfClass:[NSString class]]){
            valueStr = [NSString stringWithFormat:@"      obj.%@ = WK_EncodeStringFromDic(dic, @\"%@\");\n",key,key];
        }else if ([value isKindOfClass:[NSDictionary class]]){
            NSString *subDicModelName = [NSString stringWithFormat:@"%@Model",key];
            valueStr = [NSString stringWithFormat:@"      obj.%@ = [%@%@ initWithiDiction:WK_EncodeDicFromDic(dic, @\"%@\")];\n",key,preName,subDicModelName,key];
            [mActionString appendString:valueStr];
            [self jsonDiction:value modelName:key];
            continue;
        }else if ([value isKindOfClass:[NSNumber class]]){
            valueStr = [NSString stringWithFormat:@"      obj.%@ = WK_EncodeStringFromDic(dic, @\"%@\");\n",key,key];
        }else if ([value isKindOfClass:[NSArray class]]){
            id firstObjct = [value firstObject];
            if([firstObjct isKindOfClass:[NSDictionary class]]){
                
                NSString *subModelName = [NSString stringWithFormat:@"%@",key];
                [self jsonDiction:firstObjct modelName:subModelName];
                valueStr = [NSString stringWithFormat:@"      obj.%@ = [%@%@Model modelArrayDiction: WK_EncodeArrayFromDic(dic, @\"%@\")];\n",key,preName,subModelName,key];
                [mActionString appendString:valueStr];
                continue;
                
            }else{
                valueStr = [NSString stringWithFormat:@"      obj.%@ = WK_EncodeArrayFromDic(dic, @\"%@\");\n",key,key];
            }
        }else {
            valueStr = [NSString stringWithFormat:@"      obj.%@ = WK_EncodeStringFromDic(dic, @\"%@\");\n",key,key];
        }
        [mActionString appendString:valueStr];
    }
    [mActionString appendString:@"    }\n"];
    [mActionString appendString:@"    return obj;\n"];
    [mActionString appendString:@"}\n\n"];
    NSString *end =@"@end \n\n\n\n\n\n";
    [mActionString appendString:end];
    [self.mFileString appendString:mActionString];
    return mActionString;
}


- (void)lineInputData {
    NSString *jsonString = self.inputTextView.string;
 
    [self makeString];
    [self.inputTextView.textStorage setAttributedString:[self attibuteString:jsonString]];
    [self isError];
   
}


- (BOOL)isError {
    NSString *jsonString = self.inputTextView.string;
    NSError *error = nil;
    NSDictionary *dic =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    if(error){
        self.outTextView.string = error.userInfo.description;
        self.outTextView.textColor = [NSColor redColor];
        return YES;
    }else{
        self.outTextView.string = @"";
        return NO;
    }
}



- (NSAttributedString *)jsonStringOriWithDict:(NSDictionary *)dict{
    if(dict == nil){
        return nil;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if(error){
        return [[NSAttributedString alloc] initWithString:@""];
    }
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSAttributedString *attStr = [self attibuteString:jsonString];
    
 
    return attStr;
    //    return jsonString;
}


- (NSAttributedString *)attibuteString:(NSString *)jsonString {
    NSDictionary *attrDict = @{NSFontAttributeName:[NSFont fontWithName:@"Menlo" size:14],
                               NSForegroundColorAttributeName: [NSColor blackColor],
    };
    
    NSString *regS =@"\".*?\"";
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:regS options:0 error:NULL];
    NSArray<NSTextCheckingResult *> *ranges = [reg matchesInString:jsonString options:0 range:NSMakeRange(0, [jsonString length])];
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:jsonString attributes:@{NSForegroundColorAttributeName:[NSColor blackColor]}];
    [attStr addAttributes:attrDict range:NSMakeRange(0, jsonString.length-1)];
    
    for (int i = 0; i < ranges.count; i++) {
        [attStr setAttributes:@{NSForegroundColorAttributeName:[NSColor colorWithCalibratedRed:154/255.0 green:0 blue:18/255.0 alpha:1.0],NSFontAttributeName:[NSFont systemFontOfSize:14]} range:ranges[i].range];
    }
    return attStr;
}

- (void)makeString {
    self.mulStr = [NSMutableString string];
      NSString *str = self.inputTextView.string;
      
      NSInteger tab = 0;
      for (int i=0; i<str.length; i++) {
          NSString *temp = [str substringWithRange:NSMakeRange(i, 1)];
          //
          if([temp isEqualToString:@"{"]){
              
              [self.mulStr appendString:@"{\n"];
              
              tab++;
              [self addSpaceWithTag:tab];
              
          
          }else if ([temp isEqualToString:@"["]){
              [self.mulStr appendString:@"[\n"];

              tab++;
              [self addSpaceWithTag:tab];
          
          }else if ([temp isEqualToString:@","]){

              [self.mulStr appendString:@",\n"];
              [self addSpaceWithTag:tab];
          }else if ([temp isEqualToString:@"}"]){
              [self.mulStr appendString:@"\n"];
              tab--;
              [self addSpaceWithTag:tab];
              [self.mulStr appendString:@"}"];
          }else if ([temp isEqualToString:@"]"]){
              [self.mulStr appendString:@"\n"];
              tab--;
              [self addSpaceWithTag:tab];
              [self.mulStr appendString:@"]"];
              
          }else{
              [self.mulStr appendString:temp];
          
          }

      }
    self.inputTextView.string=self.mulStr;
}


-(void)addSpaceWithTag:(NSInteger)tab{
    for (NSInteger i=0; i<tab; i++) {
        [self.mulStr appendString:@"  "];
    }
}

- (void)textDidChange:(NSNotification *)notification {
}
@end
