//
//  ViewController.m
//  AvidlyAccountDemo
//
//  Created by 何健 on 3/4/19.
//  Copyright © 2019 何健. All rights reserved.
//

#import "ViewController.h"
#import <AASAccount/AASAccountSDK.h>
#import <AdSupport/AdSupport.h>

NSString *defaultProductID = @"1000152";

@interface ViewController () {
    UITextField *_pdtID;
    
    UIButton *_loginButton;
    UIButton *_covertLoginButton;
    UIButton *_unAwareLoginButton;
    UIButton *_getFacebookTokenButton;
    UIButton *_userInfoButton;
    UIButton *_testGameCenter;
    
    UITextField *_idfaField;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    float x = 60;
    float y = 60;
    float width = self.view.frame.size.width - x*2;
    float height = 40;
    float interval = 20;
    
    _pdtID = [[UITextField alloc] init];
    _pdtID.frame = CGRectMake(x, y, width, height);
    _pdtID.layer.borderWidth = 1.0f;
    _pdtID.layer.borderColor = [UIColor colorWithRed:0xbf/255.0f green:0xbf/255.0f blue:0xbf/255.0f alpha:1].CGColor;
    _pdtID.backgroundColor = [UIColor whiteColor];
    _pdtID.placeholder = [NSString stringWithFormat:@"请输入产品ID,不填默认 %@",defaultProductID];
    [self.view addSubview:_pdtID];
    y = _pdtID.frame.origin.y + _pdtID.frame.size.height + interval;
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginButton.backgroundColor = [UIColor orangeColor];
    _loginButton.frame = CGRectMake(x, y, width, height);
    [_loginButton setTitle:@"登录(显性)(可选择或切换登录方式)" forState:UIControlStateNormal];
    [_loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginButton];
    y = _loginButton.frame.origin.y + _loginButton.frame.size.height + interval;
    
    _covertLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _covertLoginButton.backgroundColor = [UIColor orangeColor];
    _covertLoginButton.frame = CGRectMake(x, y, width, height);
    [_covertLoginButton setTitle:@"登录(隐性)(首次需选择登录方式)" forState:UIControlStateNormal];
    [_covertLoginButton addTarget:self action:@selector(covertLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_covertLoginButton];
    y = _covertLoginButton.frame.origin.y + _covertLoginButton.frame.size.height + interval;
    
    _unAwareLoginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _unAwareLoginButton.backgroundColor = [UIColor orangeColor];
    _unAwareLoginButton.frame = CGRectMake(x, y, width, height);
    [_unAwareLoginButton setTitle:@"登录(隐性)(首次默认游客登录)" forState:UIControlStateNormal];
    [_unAwareLoginButton addTarget:self action:@selector(unAwareLoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_unAwareLoginButton];
    y = _unAwareLoginButton.frame.origin.y + _unAwareLoginButton.frame.size.height + interval;
    
    _getFacebookTokenButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _getFacebookTokenButton.backgroundColor = [UIColor orangeColor];
    _getFacebookTokenButton.frame = CGRectMake(x, y, width, height);
    [_getFacebookTokenButton setTitle:@"获取FBToken" forState:UIControlStateNormal];
    [_getFacebookTokenButton addTarget:self action:@selector(getFacebookLoginedToken) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_getFacebookTokenButton];
    y = _getFacebookTokenButton.frame.origin.y + _getFacebookTokenButton.frame.size.height + interval;
    
    _userInfoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _userInfoButton.backgroundColor = [UIColor orangeColor];
    _userInfoButton.frame = CGRectMake(x, y, width, height);
    [_userInfoButton setTitle:@"用户中心" forState:UIControlStateNormal];
    [_userInfoButton addTarget:self action:@selector(userInfo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userInfoButton];
    y = _userInfoButton.frame.origin.y + _userInfoButton.frame.size.height + interval;
    
    BOOL advertisingTrackingEnabled = [ASIdentifierManager sharedManager].advertisingTrackingEnabled;
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSLog(@"Can use idfa:%@ idfa:%@ idfv:%@",advertisingTrackingEnabled?@"YES":@"NO",idfa,idfv);
    
    UILabel *idfaLabel = [[UILabel alloc] init];
    idfaLabel.frame = CGRectMake(x, y, 50, 30);
    idfaLabel.text = @"idfa:";
    [self.view addSubview:idfaLabel];
    
    _idfaField = [[UITextField alloc] init];
    _idfaField.frame = CGRectMake(idfaLabel.frame.origin.x + idfaLabel.frame.size.width, idfaLabel.frame.origin.y, 255, 30);
    _idfaField.font = [UIFont systemFontOfSize:10];
    _idfaField.text = idfa;
    [self.view addSubview:_idfaField];
    y = _idfaField.frame.origin.y + _idfaField.frame.size.height + interval;
    
    UILabel *idfvLabel = [[UILabel alloc] init];
    idfvLabel.frame = CGRectMake(x, y, 50, 30);
    idfvLabel.text = @"idfv:";
    [self.view addSubview:idfvLabel];
    
    UITextField *idfvField = [[UITextField alloc] init];
    idfvField.frame = CGRectMake(idfvLabel.frame.origin.x + idfvLabel.frame.size.width, idfvLabel.frame.origin.y, 255, 30);
    idfvField.font = [UIFont systemFontOfSize:10];
    idfvField.text = idfv;
    [self.view addSubview:idfvField];
    y = idfvField.frame.origin.y + idfvField.frame.size.height + interval;
}

- (void)adjustCenterH:(UIView*)v{
    CGPoint center = self.view.center;
    center.y = v.frame.origin.y + v.frame.size.height/2;
    v.center = center;
}

- (void)loginClick {
    
    NSString *pid = defaultProductID;
    if (_pdtID.text != nil && ![_pdtID.text isEqualToString:@""]) {
        pid = _pdtID.text;
    }
    
    [AASAccountSDK initSDK:pid];
    
    [AASAccountSDK setLoginCallback:^(AASAccountLoginModel * _Nonnull model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_loginButton setTitle:[NSString stringWithFormat:@"gameGuestId:%@",model.gameGuestId] forState:UIControlStateNormal];
        });
        NSLog(@"AASAccountSDK login gameGuestId:%@，loginMode:%d",model.gameGuestId,model.loginMode);
        
//        [self logLoginWithModel:model];
        
    } errorCallback:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_loginButton setTitle:[NSString stringWithFormat:@"error:%i",(int)error.code] forState:UIControlStateNormal];
        });
        NSLog(@"AASAccountSDK login error:%@",error);
    }];
    [AASAccountSDK login];
}

- (void)covertLoginClick {
    
    NSString *pid = defaultProductID;
    if (_pdtID.text != nil && ![_pdtID.text isEqualToString:@""]) {
        pid = _pdtID.text;
    }
    
    [AASAccountSDK initSDK:pid];
    
    [AASAccountSDK setLoginCallback:^(AASAccountLoginModel * _Nonnull model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_covertLoginButton setTitle:[NSString stringWithFormat:@"gameGuestId:%@",model.gameGuestId] forState:UIControlStateNormal];
        });
        NSLog(@"AASAccountSDK login gameGuestId:%@，loginMode:%d",model.gameGuestId,model.loginMode);
        
//        [self logLoginWithModel:model];
        
    } errorCallback:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_covertLoginButton setTitle:[NSString stringWithFormat:@"error:%i",(int)error.code] forState:UIControlStateNormal];
        });
        NSLog(@"AASAccountSDK login error:%@",error);
    }];
    [AASAccountSDK loginWithVisible:NO];
}

- (void)unAwareLoginClick {
    NSString *pid = defaultProductID;
    if (_pdtID.text != nil && ![_pdtID.text isEqualToString:@""]) {
        pid = _pdtID.text;
    }
    
    [AASAccountSDK initSDK:pid];
    
    [AASAccountSDK setLoginCallback:^(AASAccountLoginModel * _Nonnull model) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_unAwareLoginButton setTitle:[NSString stringWithFormat:@"gameGuestId:%@",model.gameGuestId] forState:UIControlStateNormal];
        });
        
    } errorCallback:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_unAwareLoginButton setTitle:[NSString stringWithFormat:@"error:%i",(int)error.code] forState:UIControlStateNormal];
        });
    }];
    
    [AASAccountSDK loginWithUnAware];
}

-(void)getFacebookLoginedToken {
    NSString *string ;
    string = [AASAccountSDK getFacebookLoginedToken];
    NSLog(@"FBToken is :%@",string);
}

- (void)userInfo {
    [AASAccountSDK showUserCenter:self];
}

//#pragma mark - log login
//
//- (void)logLoginWithModel:(AASAccountLoginModel *)model {
//
////    #define ACCOUNT_MODE_GUEST 1
////    #define ACCOUNT_MODE_AAS  2
////    #define ACCOUNT_MODE_FACEBOOK  3
////    #define ACCOUNT_MODE_GOOGLEPLAY  4
////    #define ACCOUNT_MODE_TWITTER  6
////    #define ACCOUNT_MODE_INSTAGRAM 8
////    #define ACCOUNT_MODE_GAMECENTER 9
////    #define ACCOUNT_MODE_ULT 10
////    #define ACCOUNT_MODE_APPLE 11
//
////    extern NSString *const TraceAnalysisLoginTypeGuest;
////    extern NSString *const TraceAnalysisLoginTypeAas;
////    extern NSString *const TraceAnalysisLoginTypeFacebook;
////    extern NSString *const TraceAnalysisLoginTypeGoogleplay;
////    extern NSString *const TraceAnalysisLoginTypeTwitter;
////    extern NSString *const TraceAnalysisLoginTypeInstagram;
////    extern NSString *const TraceAnalysisLoginTypeGamecenter;
////    extern NSString *const TraceAnalysisLoginTypeUlt;
////    extern NSString *const TraceAnalysisLoginTypeApple;
////    extern NSString *const TraceAnalysisLoginTypeOther;
//
//    NSString *loginType;
//    if (model.loginMode == 1) {
//        loginType = TraceAnalysisLoginTypeGuest;
//    }
//    else if (model.loginMode == 2) {
//        loginType = TraceAnalysisLoginTypeAas;
//    }
//    else if (model.loginMode == 3) {
//        loginType = TraceAnalysisLoginTypeFacebook;
//    }
//    else if (model.loginMode == 4) {
//        loginType = TraceAnalysisLoginTypeGoogleplay;
//    }
//    else if (model.loginMode == 6) {
//        loginType = TraceAnalysisLoginTypeTwitter;
//    }
//    else if (model.loginMode == 8) {
//        loginType = TraceAnalysisLoginTypeInstagram;
//    }
//    else if (model.loginMode == 9) {
//        loginType = TraceAnalysisLoginTypeGamecenter;
//    }
//    else if (model.loginMode == 10) {
//        loginType = TraceAnalysisLoginTypeUlt;
//    }
//    else if (model.loginMode == 11) {
//        loginType = TraceAnalysisLoginTypeApple;
//    }
//    else {
//        loginType = TraceAnalysisLoginTypeOther;
//    }
//
//    NSString *playerId = model.gameGuestId;
//    NSString *loginToken = model.signedRequest;
//    NSString *ggid = model.gameGuestId;
//
//    [TraceAnalysis logAASLoginWithType:loginType playerId:playerId loginToken:loginToken ggid:ggid extension:nil];
//}

@end
