//
//  AppDelegate.m
//  RemoteNotificationDemo
//
//  Created by NavchinaMacBook on 15/8/4.
//  Copyright (c) 2015年 NavchinaMacBook. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property(nonatomic) BOOL registered;
@end

@implementation AppDelegate


#pragma mark - 注册远程通知
//用户点击默认按钮、app图标时调用此方法。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//注册通知事件
    // 第一个事件
    
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc]init];
    //创建一个identify用于标记action
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    //如果activationMode设置为UIUserNotificationActivationModeForeground，则authenticationRequired将被系统强制设置为yes，将忽视后面的设置。
    //选择在什么情况加激活应用程序。
    acceptAction.activationMode = UIUserNotificationActivationModeBackground;
    //提示字体颜色：yes ：红色 no :蓝色
    acceptAction.destructive = NO;
    //是否需要密码验证，yes需要，no：不需要
    acceptAction.authenticationRequired = NO;
    
//    第二个事件
    UIMutableUserNotificationAction *meetingAction = [[UIMutableUserNotificationAction alloc]init];
    //创建一个identify用于标记action
    meetingAction.identifier = @"MEETING_IDENTIFIER";
    meetingAction.title = @"OK";
    //如果activationMode设置为UIUserNotificationActivationModeForeground，则authenticationRequired将被系统强制设置为yes，将忽视后面的设置。
    //选择在什么情况加激活应用程序。
    meetingAction.activationMode = UIUserNotificationActivationModeBackground;
    //提示字体颜色：yes ：红色 no :蓝色
    meetingAction.destructive = YES;
    //是否需要密码验证，yes需要，no：不需要
    meetingAction.authenticationRequired = NO;
    
    
//添加到不同的类别中去
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc]init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
    [inviteCategory setActions:@[acceptAction,meetingAction] forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[acceptAction,meetingAction] forContext:UIUserNotificationActionContextMinimal];
    
//注册通知类别
    NSSet *categories = [NSSet setWithObjects:inviteCategory,/*alarmCategory*/ nil];
    
    CGFloat systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (systemVersion >= 8.0) {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    //向ios操作系统注册远程通知，以获取decice Token.
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"%@",deviceToken);
    const void *deviceTokenBytes = [deviceToken bytes];
    //注册成功
    self.registered = YES;
    //发送给本地服务器
//    [self sendProviderDeviceToken:deviceTokenBytes];
    
    
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //注册device Token时失败。
    NSLog(@"%@",error);
}
#pragma mark - 用户点击按钮后执行方法
-(void)handleAcceptActionWithNotification:(NSDictionary *)userInfo
{
    //设置用户点击按钮后程序需要执行的操作。
}
#pragma mark - 收到远程通知
//收到用户点击事件 （应用程序在后台，用户点击一个按钮时触发）
-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler
{
    //具体实现
    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]) {
        [self handleAcceptActionWithNotification:userInfo];
    }
    if ([identifier isEqualToString:@"MEETING_IDENTIFIER"]) {
        //执行具体操作。
    }
    
    completionHandler();
}
//应用程序在前台收到远程通知时会调用此方法，如果此方法不被实现则会调用application:didReceiveRemoteNotification
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSString *itemName = [userInfo objectForKey:@"ToDoItemKey"];
    //具体的实现
    application.applicationIconBadgeNumber = 3;
    
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
}

@end
