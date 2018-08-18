//
//  RestaurantIntroEditViewController.m
//  ChefDating
//
//  Created by 唐斌 on 16/6/21.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import "RestaurantIntroEditViewController.h"
#import "LocalCommon.h"
#import "TYZPlaceholderTextView.h"

@interface RestaurantIntroEditViewController () <UITextViewDelegate>
{
    UIView *_bgView;
    
    TYZPlaceholderTextView *_placeTextView;
    
    /**
     *  字数
     */
    UILabel *_numLabel;
    
    BOOL _isNum;
}

- (void)initWithBgView;

- (void)initWithPlaceTextView;

- (void)initWithNumLabel;


@end

@implementation RestaurantIntroEditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)initWithVar
{
    [super initWithVar];
    
}

- (void)initWithNavBar
{
    [super initWithNavBar];
    
    [self initWithBackButton];
    
}

- (void)initWithSubView
{
    [super initWithSubView];
    
    [self initWithBgView];
    
    [self initWithPlaceTextView];
    
    _isNum = NO;
    if (_fontNumber != 0)
    {
        [self initWithNumLabel];
        _isNum = YES;
    }
}

- (void)clickedBack:(id)sender
{
    if (self.popResultBlock)
    {
        self.popResultBlock(objectNull(_placeTextView.text));
    }
    [super clickedBack:sender];
}

- (void)initWithBgView
{
    CGRect frame = CGRectMake(0, 20, [[UIScreen mainScreen] screenWidth], 120);
    _bgView = [[UIView alloc] initWithFrame:frame];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bgView];
}

- (void)initWithPlaceTextView
{
//    UIColor *color = [UIColor colorWithHexString:@"#cccccc"];
//    NSAttributedString *placeHolder = [[NSAttributedString alloc] initWithString:_placeholder attributes:@{NSFontAttributeName: FONTSIZE(15), NSForegroundColorAttributeName: color}];
    CGRect frame = CGRectMake(0, 0, [[UIScreen mainScreen] screenWidth], _bgView.height);
    _placeTextView = [[TYZPlaceholderTextView alloc] initWithFrame:frame];
    _placeTextView.delegate = self;
    _placeTextView.placeholder = _placeholder;
    _placeTextView.placeholderColor = [UIColor colorWithHexString:@"cccccc"];
    _placeTextView.font = FONTSIZE_15;
    _placeTextView.text = _content;
    _placeTextView.textColor = [UIColor colorWithHexString:@"#323232"];
    _placeTextView.returnKeyType = UIReturnKeyDone;
    _placeTextView.keyboardType = UIKeyboardAppearanceDefault;
    [_bgView addSubview:_placeTextView];
    [_placeTextView becomeFirstResponder];
}

- (void)initWithNumLabel
{
    _numLabel = [TYZCreateCommonObject createWithLabel:self.view labelFrame:CGRectMake(30, _bgView.bottom + 5, [[UIScreen mainScreen] screenWidth] - 60, 18) textColor:[UIColor colorWithHexString:@"#646464"] fontSize:FONTSIZE_12 labelTag:0 alignment:NSTextAlignmentRight];
    NSInteger num = _fontNumber - [_content length];
    num = (num < 0 ? 0 : num);
    _numLabel.text = [NSString stringWithFormat:@"%d字", (int)num];
}

#pragma mark UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        [self clickedBack:nil];
        return YES;
    }
    
    if (_isNum)
    {
        if (text.length == 0)
        {
//            debugLog(@"删除");
            NSInteger existedLength = textView.text.length - 1;
            _numLabel.text = [NSString stringWithFormat:@"%d字", (int)(_fontNumber - existedLength)];
//            debugLog(@"len=%d", (int)existedLength);
            return YES;
        }
//        debugLog(@"text=%@", text);
//        debugLog(@"=%d", (int)range.location);
//        NSInteger existedLength = textView.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = text.length;
//        NSInteger len = existedLength - selectedLength + replaceLength;
//        _numLabel.text = [NSString stringWithFormat:@"%d字", (int)(_fontNumber - len)];
        if (range.location > _fontNumber)
        {
            return NO;
        }
    }
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
//    debugLog(@"length=%d", textView.text.length);
    if (_isNum)
    {
        if (textView.text.length > _fontNumber)
        {
            textView.text = [textView.text substringToIndex:_fontNumber];
        }
        
        _numLabel.text = [NSString stringWithFormat:@"%d字", (int)(_fontNumber - textView.text.length)];
    }
}

@end


























