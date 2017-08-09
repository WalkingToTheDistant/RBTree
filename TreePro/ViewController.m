//
//  ViewController.m
//  TreePro
//
//  Created by LHJ on 2017/7/17.
//  Copyright © 2017年 LHJ. All rights reserved.
//

#import "ViewController.h"
#import "RBTreeView.h"
#import "RBTree.h"

#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

#define RGBColor(r,g,b)     RGBAColor(r,g,b,1.0)

typedef enum : int{
    ViewTag_AddNode = 1, /* 添加一个节点 */
}ViewTag;

@interface ViewController ()

@end

@implementation ViewController
{
    RBTreeView *mRBTreeView;
    UIScrollView *mScrollView;
    UITextView *mTextViewForAdd;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    mScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [mScrollView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:mScrollView];
    
    mRBTreeView = [[RBTreeView alloc] initWithFrame:mScrollView.bounds];
    [mRBTreeView setBackgroundColor:[UIColor whiteColor]];
    [mScrollView addSubview:mRBTreeView];
    
    UIButton *btn = [UIButton new];
    [btn setFrame:CGRectMake(0, 0, 50, 50)];
    [btn.layer setCornerRadius:4.0];
    [btn setClipsToBounds:YES];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setTag:ViewTag_AddNode];
    [btn setContentMode:UIViewContentModeCenter];
    [btn setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    mTextViewForAdd = [UITextView new];
    [mTextViewForAdd setFrame:CGRectMake(56, 0, 50, 50)];
    [mTextViewForAdd setBackgroundColor:[UIColor clearColor]];
    [mTextViewForAdd setTextColor:[UIColor blueColor]];
    [mTextViewForAdd setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:mTextViewForAdd];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) clickBtn:(UIButton*) btn
{
    int value = ((int)random())%1000;
    
    __block UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"新加节点" message:@"输入新节点的节点值" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入节点值";
        textField.keyboardType = UIKeyboardTypeNamePhonePad;
        textField.returnKeyType = UIReturnKeyDone;
    }];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:alertActionCancel];
    
    UIAlertAction *alertActionCommit = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alertController.textFields[0];
        NSString *str = textField.text;
        [[RBTree sharedRBTree] addValue:@([str intValue])];
        [mTextViewForAdd setText:[NSString stringWithFormat:@"%i", value]];
        [self adjustTreeView];
    }];
    [alertController addAction:alertActionCommit];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    
}

- (void) adjustTreeView
{
    [mRBTreeView adjustTreeView:^(CGSize sizeView) {
        [mScrollView setContentSize:sizeView];
        CGPoint pointOffset = CGPointZero;
        if(sizeView.width > CGRectGetWidth(mScrollView.bounds)){
            pointOffset.x = (sizeView.width - CGRectGetWidth(mScrollView.bounds))/2;
        }
        if(sizeView.height > CGRectGetHeight(mScrollView.bounds)){
            pointOffset.y = (sizeView.height - CGRectGetHeight(mScrollView.bounds))/2;
        }
        [mScrollView setContentOffset:pointOffset animated:NO];
    }];
}

@end
