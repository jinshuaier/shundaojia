//
//  TCSeleAdressTableViewCell.m
//  ShunDaoJia
//
//  Created by 胡高广 on 2017/12/14.
//  Copyright © 2017年 jinshuaier. All rights reserved.
//

#import "TCSeleAdressTableViewCell.h"
#import "TCReaddressInfo.h"

@interface TCSeleAdressTableViewCell ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, strong) NSString *choosetimetitle;//时间选择器title
@property (nonatomic, assign) BOOL isSelectTime;
@property (nonatomic, strong) NSString *dateAndTime;
@property (nonatomic, strong) NSUserDefaults *defaults;

@end
@implementation TCSeleAdressTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andDic:(NSDictionary *)dic andType:(NSString *)typeStr{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.defaults = [NSUserDefaults standardUserDefaults];
        //没有选择就是默认  当前时间加30分钟
        //获取当前时间
        NSDate *datanow = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        NSTimeInterval interval = 30 * 60;
        NSDate *detea = [NSDate dateWithTimeInterval:interval sinceDate:datanow];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        NSString *locationString=[dateFormatter stringFromDate:detea];
        
        _timeSeleStr = locationString;
        
        [self create:dic andType:typeStr];
    }
    return self;
}

//创建View
- (void)create:(NSDictionary *)dic andType:(NSString *)typeStr
{
    NSLog(@"%@",dic);
    self.backView = [[UIView alloc] init];
    self.backView.frame = CGRectMake(8, 0, WIDTH - 16, 46 + 50);
    self.backView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.contentView addSubview:self.backView];
    
    //能点击选择的View
    self.clickView = [[UIView alloc] init];
    self.clickView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    self.clickView.frame = CGRectMake(0, 0, self.backView.frame.size.width, 50);
    self.clickView.userInteractionEnabled = YES;
    [self.backView addSubview:self.clickView];
    //手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.clickView addGestureRecognizer:tap];
    //位置icon
    self.locationImage = [[UIImageView alloc] init];
    self.locationImage.image = [UIImage imageNamed:@"地址图标"];//(50 - 16)/2 - 2
    self.locationImage.frame = CGRectMake(8,(self.clickView.frame.size.height - 60)/2 , 14, 16);
    [self.clickView addSubview:self.locationImage];
    //地址
    
    self.adressLabel = [UILabel publicLab:@"选择收货地址" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.adressLabel.frame = CGRectMake(CGRectGetMaxX(self.locationImage.frame) + 8, (50 - 18)/2, WIDTH - 16 - 8 - 5 - (CGRectGetMaxX(self.locationImage.frame) + 8), 18);
    
    //姓名
    self.nameLabel = [UILabel publicLab:dic[@"name"] textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.locationImage.frame) + 8, 16, 42, 14);
    
    CGSize size = [self.nameLabel sizeThatFits:CGSizeMake(WIDTH - 4, 16)];
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.locationImage.frame) + 8, 16, size.width, 14);
    [self.clickView addSubview:self.nameLabel];
    
    //电话
    self.telphoneLabel = [UILabel publicLab:dic[@"mobile"] textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    self.telphoneLabel.frame = CGRectMake(CGRectGetMaxX(self.nameLabel.frame) + 24, 17, WIDTH - (CGRectGetMaxX(self.locationImage.frame) + 8), 14);
    [self.clickView addSubview:self.telphoneLabel];
    
    //传过来的地址
    NSString *addressStr = [dic[@"locaddress"] stringByAppendingString:dic[@"address"]];
    self.adressNetLabel = [UILabel publicLab:addressStr textColor:TCUIColorFromRGB(0x666666) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Medium" size:14 numberOfLines:0];
    self.adressNetLabel.frame = CGRectMake(CGRectGetMaxX(self.locationImage.frame) + 8, CGRectGetMaxY(self.nameLabel.frame) + 8, WIDTH - 16 - 25 - (CGRectGetMaxX(self.locationImage.frame) + 8), 40);
    self.adressNetLabel.hidden = YES;
    
    [self.clickView addSubview:self.adressNetLabel];
    [self.clickView addSubview:self.adressLabel];
    //小三角
    self.triangleImage = [[UIImageView alloc] init];
    self.triangleImage.image = [UIImage imageNamed:@"进入三角"];
    self.triangleImage.frame = CGRectMake(WIDTH - 16 - 8 - 5, (50 - 8)/2, 5, 8);
    [self.clickView addSubview:self.triangleImage];
    //线
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = TCLineColor;
    self.lineView.frame = CGRectMake(8, CGRectGetMaxY(self.adressLabel.frame) + 16, WIDTH - 16 - 16, 1);
    [self.clickView addSubview:self.lineView];
    
    //timeSelectView 此处判断是否为上门服务类
    self.timeSelectView = [[UIView alloc] init];
    self.timeSelectView.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame) + 1, WIDTH - 16, 46);
    self.timeSelectView.backgroundColor = [UIColor whiteColor];
    self.timeSelectView.userInteractionEnabled = YES;
    [self.backView addSubview:self.timeSelectView];
    
    // 上门服务
//    if ([typeStr isEqualToString:@"2"]){
//        //上门服务加手势
//        UITapGestureRecognizer *timeSelecTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeSelecTap)];
//        [self.timeSelectView addGestureRecognizer:timeSelecTap];
//        
//       
//    }
    
    //时间icon
    self.timeImage = [[UIImageView alloc] init];
    self.timeImage.image = [UIImage imageNamed:@"预计送达时间图标"];
    self.timeImage.frame = CGRectMake(8, (46 - 14)/2, 14, 14);
    [self.timeSelectView addSubview:self.timeImage];
    //预计到达时间
    self.sendTimeLabel = [UILabel publicLab:@"尽快送达[预计30分钟送达]" textColor:TCUIColorFromRGB(0x333333) textAlignment:NSTextAlignmentLeft fontWithName:@"PingFangSC-Regular" size:14 numberOfLines:0];
    self.sendTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.timeImage.frame) + 8, 0, WIDTH - 16 - (CGRectGetMaxX(self.timeImage.frame) + 8), 46);
    [self.timeSelectView addSubview:self.sendTimeLabel];
    
    //上门服务
    if ([typeStr isEqualToString:@"2"]){
        //上门服务加手势
        UITapGestureRecognizer *timeSelecTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeSelecTap)];
        [self.timeSelectView addGestureRecognizer:timeSelecTap];
        if (self.isSelectTime == YES){
            self.sendTimeLabel.text = [NSString stringWithFormat:@"今天%@上门",_timeSeleStr];
        } else {

        }
        //保存的时间
        //        _timeSeleStr = [self.defaults valueForKey:@"SelectTime"];
        self.sendTimeLabel.text = [NSString stringWithFormat:@"今天%@上门",_timeSeleStr];
        //预约时间的小三角
        self.sendTimeLabel.text = @"尽快到达[预计30分钟到达]";
        self.triangle_twoImage = [[UIImageView alloc] init];
        self.triangle_twoImage.image = [UIImage imageNamed:@"进入三角"];
        self.triangle_twoImage.frame = CGRectMake(WIDTH - 16 - 8 - 5, (46 - 8)/2, 5, 8);
        [self.timeSelectView addSubview:self.triangle_twoImage];
    } else if ([typeStr isEqualToString:@"0"]){
        self.sendTimeLabel.text = @"尽快到达[预计30分钟到达]";
    } else if ([typeStr isEqualToString:@"1"]){
        self.sendTimeLabel.text = @"预计3-5天送达，实际时间以物流为准";
    }
    
    if (dic != nil){
        self.adressLabel.hidden = YES;
        self.nameLabel.hidden = NO;
        self.telphoneLabel.hidden = NO;
        self.adressNetLabel.hidden = NO;
        self.triangleImage.frame = CGRectMake(WIDTH - 16 - 8 - 5, (90 - 8)/2, 5, 8);
        self.lineView.frame = CGRectMake(8, CGRectGetMaxY(self.adressNetLabel.frame) + 16, WIDTH - 16 - 16, 1);
        self.backView.frame = CGRectMake(8, 0, WIDTH - 16, 46 + 90);
        self.clickView.frame = CGRectMake(0, 0, self.backView.frame.size.width, 90);
        self.timeSelectView.frame = CGRectMake(0, CGRectGetMaxY(self.lineView.frame) + 1, WIDTH - 16, 46);
//        self.sendTimeLabel.text = [NSString stringWithFormat:@"今天%@上门",self.dateAndTime];

//        self.timeImage.frame = CGRectMake(8, CGRectGetMaxY(self.clickView.frame) + 16, 14, 14);
//        self.sendTimeLabel.frame = CGRectMake(CGRectGetMaxX(self.timeImage.frame) + 8, CGRectGetMaxY(self.clickView.frame), WIDTH - 16 - (CGRectGetMaxX(self.timeImage.frame) + 8), 46);
        
    } else {
        self.adressLabel.hidden = NO;
        self.nameLabel.hidden = YES;
        self.telphoneLabel.hidden = YES;
    }
}

- (void)setTimeSeleStr:(NSString *)timeSeleStr
{
    _timeSeleStr = timeSeleStr;
}
#pragma mark -- 手势
- (void)tap
{
    NSLog(@"地址");
    if ([self.delegate respondsToSelector:@selector(adressTap)]) {
        [self.delegate  adressTap];
    }
    
    if ([self.delegate respondsToSelector:@selector(timeSecletTap:)]) {
        [self.delegate  timeSecletTap:_timeSeleStr];
    }
}

#pragma mark -- 选择时间的手势
- (void)timeSelecTap
{
    NSLog(@"选择手势");
    [self backViews];
    
    self.choosetimetitle = @"预约时间";
    [self creatalphaView];
}
//创建时间选择器
-(void)creatalphaView{

    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT - 384,WIDTH, 384)];
    contentView.backgroundColor = TCUIColorFromRGB(0xFFFFFF);
    [self.backView addSubview:contentView];
    
    UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH - 10 - 16, (57 - 16)/2, 16, 16)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"关闭按钮"] forState:(UIControlStateNormal)];
    [closeBtn addTarget:self action:@selector(closealphaView) forControlEvents:(UIControlEventTouchUpInside)];
    [contentView addSubview:closeBtn];
    
    UILabel *titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 57)];
    titlelabel.text = self.choosetimetitle;
    titlelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    titlelabel.textColor = TCUIColorFromRGB(0x525F66);
    titlelabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:titlelabel];
    
    //线
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, CGRectGetMaxY(titlelabel.frame), WIDTH, 1);
    lineView.backgroundColor = TCLineColor;
    [contentView addSubview:lineView];
    
    
    UIDatePicker *oneDatapicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(60, CGRectGetMaxY(lineView.frame), WIDTH - 120, 286)];
    oneDatapicker.timeZone = [NSTimeZone timeZoneWithName:@"GTM"]; // 设置时区，中国在东八区
    oneDatapicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60 * -1]; // 设置最小时间
    oneDatapicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:72 * 60 * 60]; // 设置最大时间
    
    
    oneDatapicker.datePickerMode = UIDatePickerModeTime; // 设置样式
    // 以下为全部样式
    // typedef NS_ENUM(NSInteger, UIDatePickerMode) {
    //    UIDatePickerModeTime,           // 只显示时间
    //    UIDatePickerModeDate,           // 只显示日期
    //    UIDatePickerModeDateAndTime,    // 显示日期和时间
    //    UIDatePickerModeCountDownTimer  // 只显示小时和分钟 倒计时定时器
    // };
    [oneDatapicker addTarget:self action:@selector(oneDatePickerValueChanged:) forControlEvents:UIControlEventValueChanged]; // 添加监听器
    [contentView addSubview:oneDatapicker];
    
    UIButton *SuBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 384 - 48, WIDTH, 48)];
    [SuBtn setBackgroundColor:TCUIColorFromRGB(0xF99E20)];
    [SuBtn setTitle:@"确认" forState:(UIControlStateNormal)];
    [SuBtn setTitleColor:TCUIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    [SuBtn addTarget:self action:@selector(clickSU:) forControlEvents:(UIControlEventTouchUpInside)];
    SuBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    SuBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:SuBtn];
}

#pragma mark - 实现oneDatePicker的监听方法
- (void)oneDatePickerValueChanged:(UIDatePicker *) sender {
    
    NSDate *select = [sender date]; // 获取被选中的时间
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"HH:mm"; // 设置时间和日期的格式
    self.dateAndTime = [selectDateFormatter stringFromDate:select]; // 把date类型转为设置好格式的
    self.sendTimeLabel.text = [NSString stringWithFormat:@"今天%@上门",self.dateAndTime];
    _timeSeleStr = self.dateAndTime;
//    //保存本地
//    [self.defaults setObject:self.dateAndTime forKey:@"SelectTime"];
    
    self.isSelectTime = YES;
    
}
     //创建背景view
- (void)backViews{
         _backView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
         _backView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
         UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapBack)];
         [_backView addGestureRecognizer:tap];
         [[UIApplication sharedApplication].keyWindow addSubview:_backView];
}

-(void)clickSU:(UIButton *)sender{
//    NSString *TimeStr = [self.defaults valueForKey:@"SelectTime"];
    if ([self.delegate respondsToSelector:@selector(timeSecletTap:)]) {
        [self.delegate  timeSecletTap:_timeSeleStr];
    }
    [self closealphaView];
}
-(void)closealphaView{
    [UIView animateWithDuration:0.3f animations:^{
    }completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
        self.backView = nil;
    }];
}

- (void)tapBack
{
    [self closealphaView];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
