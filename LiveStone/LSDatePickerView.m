//
//  LSDatePickerView.m
//  testPickerView
//
//  Created by 郑克明 on 16/5/23.
//  Copyright © 2016年 Cocos. All rights reserved.
//

#import "LSDatePickerView.h"

@interface LSDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;

@property (nonatomic, strong) NSArray *yearsArray;
@property (nonatomic, strong) NSArray *monthsArray;
@property (nonatomic, strong) NSArray *daysArray;
@property (nonatomic, strong) NSArray *hoursArray;

@end

@implementation LSDatePickerView

- (void)awakeFromNib{
    [super awakeFromNib];
    if (!self.maxYears) {
        self.maxYears = 20;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    
    [self setupDatePickerView];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxYears = 20;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self setupDatePickerView];
    }
    return self;
}

- (instancetype) init{
    return [self initWithFrame:CGRectZero];
}

- (void)setupDatePickerView{
    NSMutableArray *yearsArr = [[NSMutableArray alloc] init];
    NSMutableArray *monthsArr = [[NSMutableArray alloc] init];
    NSMutableArray *daysArr = [[NSMutableArray alloc] init];
    NSMutableArray *hoursArr = [[NSMutableArray alloc] init];
    
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar]
                                         components:NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | kCFCalendarUnitHour
                                         fromDate:[NSDate date]];
    for (NSInteger i = nowComponents.year; i < nowComponents.year + self.maxYears; i ++) {
        [yearsArr addObject:@(i)];
    }
    self.yearsArray = yearsArr;
    
    for (NSInteger i = 1; i <= 12; i ++) {
        [monthsArr addObject:@(i)];
    }
    self.monthsArray = monthsArr;
    
    for (NSInteger i = 1; i <= 31; i ++) {
        [daysArr addObject:@(i)];
    }
    self.daysArray = daysArr;
    
    for (NSInteger i = 1; i <= 24; i ++) {
        [hoursArr addObject:@(i)];
    }
    self.hoursArray = hoursArr;
    
    //Set tool bar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelClick:)];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirmClick:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[leftItem, flexibleItem, rightItem];
    [self addSubview:toolBar];
    
    //Set picker view
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, 0, self.frame.size.height - 44)];
    pickerView.showsSelectionIndicator=YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [pickerView selectRow:nowComponents.month - 1 inComponent:1 animated:NO];
    [pickerView selectRow:nowComponents.day - 1 inComponent:2 animated:NO];
    [pickerView selectRow:nowComponents.hour - 1 inComponent:3 animated:NO];
    
    [self addSubview:pickerView];
    
    self.pickerView = pickerView;
    
    
}

- (void)cancelClick:(id)sender{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirmClick:(id)sender{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = [self.daysArray[[self.pickerView selectedRowInComponent:2]] integerValue];
    dateComponents.month = [self.monthsArray[[self.pickerView selectedRowInComponent:1]] integerValue];
    dateComponents.year = [self.yearsArray[[self.pickerView selectedRowInComponent:0]] integerValue];
    dateComponents.hour = [self.hoursArray[[self.pickerView selectedRowInComponent:3]] integerValue];
    
    if (self.confirmBlock) {
        self.confirmBlock([[NSCalendar currentCalendar] dateFromComponents:dateComponents]);
    }
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLabel = (UILabel *)view;
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 60, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:16.0f]];
    }
    
    if (component == 0){
        pickerLabel.text =  [NSString stringWithFormat:@"%@年",[self.yearsArray objectAtIndex:row]];
    }else if (component == 1){
        pickerLabel.text =  [NSString stringWithFormat:@"%@月",[self.monthsArray objectAtIndex:row]];
    }else if (component == 2){
        pickerLabel.text =  [NSString stringWithFormat:@"%@日",[self.daysArray objectAtIndex:row]];
    }else if (component == 3){
        pickerLabel.text =  [NSString stringWithFormat:@"%@时",[self.hoursArray objectAtIndex:row]];
    }
    
    return pickerLabel;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 60;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 1 || component == 0) {
        [pickerView reloadComponent:2];
    }
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.maxYears;
    }else if (component == 1){
        return [self.monthsArray count];
    }else if (component == 2){
        NSInteger selcYear = [[self.yearsArray objectAtIndex:[pickerView selectedRowInComponent:0]] integerValue];
        NSInteger selcMonth = [[self.monthsArray objectAtIndex:[pickerView selectedRowInComponent:1]] integerValue];
        if (selcMonth != 2) {
            if (selcMonth == 4 || selcMonth == 6 || selcMonth == 9 || selcMonth == 11) {
                return 30;
            }else{
                return 31;
            }
        }else{
            if( ((selcYear % 4 == 0) && (selcYear % 100 != 0)) || (selcYear % 400 == 0) ){
                return 29;
            }
            else{
                return 28;
            }
        }
        return [self.daysArray count];
    }else if (component == 3){
        return [self.hoursArray count];
    }
    return 0;
}


@end
