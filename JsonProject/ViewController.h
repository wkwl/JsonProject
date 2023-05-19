//
//  ViewController.h
//  JsonProject
//
//  Created by sgx_05 on 2023/5/15.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

/**json字符串textView**/
@property (unsafe_unretained) IBOutlet NSTextView *inputTextView;

/** json转model属性textView*/
@property (unsafe_unretained) IBOutlet NSTextView *outTextView;

/** 设置根model名称*/
@property (weak) IBOutlet NSTextField *modelNameField;
/** model 前缀名称*/
@property (weak) IBOutlet NSTextField *modePreFieldView;

@end

