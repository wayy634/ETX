//
//  LCUITools.m
//  LeCai
//
//  Created by HXG on 12/28/14.
//
//

#import "LCUITools.h"

NSString * const LCNotificationShouldRefreshWebViewAfterLogin = @"LCNotificationShouldRefreshWebView";
NSString * const LCNotificationNewUserPrizeCommingFromURL = @"LCNotificationNewUserPrizeCommingFromURL";

@implementation LCUITools

//+ (void)enterRewardHistoryDetails:(LotteryType)lottery checkDuplication:(BOOL)shouldCheck
//{
//    UIViewController *targetController = nil;
//    if (lottery == FootBallModestly ||
//        lottery == FootBallRang ||
//        lottery == FootBallMix ||
//        lottery == BasketBall ||
//        lottery == BasketMix ||
//        lottery == BasketBallModestly ||
//        lottery == BasketMixSingle ||
//        lottery == BasketBS ||
//        lottery == SingleVDD ||
//        lottery == WinLose) {
//        LotteryType lotteryID;
//        if (lottery == FootBallRang) {
//            lotteryID = FootBallModestly;
//        }else{
//            lotteryID = lottery;
//        }
//        
//        LCAthleticsRewardDetailVC *althlethReVC = [[LCAthleticsRewardDetailVC alloc] initWithLotteryId:lotteryID];
//        targetController = althlethReVC;
//    }else{
//        LCRewardHistoryVC *historyVC = [[LCRewardHistoryVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//        [historyVC initRewardId:lottery title:[LTools getKindOFLotteryFromID:lottery]];
//        targetController = historyVC;
//    }
//    
//    if (shouldCheck) {
//        [LTools pushControllerFromURLScheme:targetController animated:YES];
//    } else  {
//        [LTools pushController:targetController animated:YES];
//    }
//    [targetController release];
//}
//
//+ (void)enterBetPage:(LotteryType)lotteryType shouldCheckSingle:(BOOL)shouldCheck
//{
//    CustomLotteryTypeID customLotteryTypeID = [LTools getKindOfLotteryType:lotteryType];
//    
//    if (customLotteryTypeID == CustomLotteryTypeNumber || customLotteryTypeID == CustomLotteryTypeFrequency) {
//        LCNumberChooseVC *numberChooseVC = [[LCNumberChooseVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//        LCKindOfLotteryData *data = [LTools getKindOfLotteryDataFromArray:lotteryType];
//        [numberChooseVC setData:data];
//        data.mLotteryDataOrdeListType = LotteryDataOrderListTypeNormal;
//        [LTools pushController:numberChooseVC animated:YES];
//        [numberChooseVC release] , numberChooseVC = nil;
//    } else if (customLotteryTypeID == CustomLotteryTypeCustom) {
//        LCFast3ViewController *fast3VC = [[LCFast3ViewController alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//        fast3VC.nLotteryType = lotteryType;
//        [fast3VC setFast3Data:[LTools getKindOfLotteryDataFromArray:lotteryType]];
//        [LTools pushController:fast3VC animated:YES];
//        [fast3VC release], fast3VC = nil;
//    } else if (customLotteryTypeID == CustomLotteryTypeAthletics) {
//        BOOL isSingle = NO;
//        if (shouldCheck && [LTools getObjectFromSystemKey:K_JCZQ_LASTPAY_ISSINGLE] != nil) {
//            isSingle = [[LTools getObjectFromSystemKey:K_JCZQ_LASTPAY_ISSINGLE] boolValue];
//        }
//        
//        if ([LTools shouldGotoFootballMainSingleForLottery:lotteryType isSingle:isSingle]) {
//            LCFootballSingleVC *singleVC = [[LCFootballSingleVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//            singleVC.mLotteryType = lotteryType;
//            [LTools pushController:singleVC animated:YES];
//            [singleVC release];
//        } else {
//            LCNewAthleticsVC *athleticsVC = [[LCNewAthleticsVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//            athleticsVC.isSingle = isSingle;
//            [athleticsVC setLotteryType:lotteryType];
//            [LTools pushController:athleticsVC animated:YES];
//            [athleticsVC release];
//        }
//    } else if (customLotteryTypeID == CustomLotteryTypeSprot) {
//        LCSportsVC *sportsVC = [[LCSportsVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//        [sportsVC setLotteryType:lotteryType];
//        [LTools pushController:sportsVC animated:YES];
//        [sportsVC release];
//    }
//}
//
//+ (BOOL)checkWebviewRequestURL:(NSURL *)requestURL
//{
//    NSString *urlScheme = [requestURL.scheme lowercaseString];
//    if (urlScheme.length > 0 && ![urlScheme isEqualToString:@"http"] && ![urlScheme isEqualToString:@"https"]) {
//        [LCURLSchemeManager openURL:requestURL.absoluteString advId:nil openInApp:NO webTitle:nil];
//        return NO;
//    }
//    return YES;
//}
//
//+ (NSMutableDictionary *)processQueryString:(NSURL *)aURL
//{
//    NSMutableDictionary *dataDictionary =  nil;
//    
//    if ([aURL.absoluteString rangeOfString:@"startapp"].location != NSNotFound) {
//        dataDictionary = [[[NSMutableDictionary alloc] init] autorelease];
//        NSArray *queryParams = [aURL.query componentsSeparatedByString:@"&"];
//        NSString *queryKey   = nil;
//        id queryValue = nil;
//        NSArray *keyValueArray = nil;
//        
//        for (NSString *aString in queryParams) {
//            keyValueArray = [aString componentsSeparatedByString:@"="];
//            if ([keyValueArray count] > 1) {
//                queryKey = keyValueArray[0];
//                queryValue = keyValueArray[1];
//                [dataDictionary setObject:queryValue forKey:queryKey];
//            }
//        }
//    }
//    
//    return dataDictionary;
//}
//
//+ (BOOL)processURLInApp:(NSURL *)openURL
//{
//    BOOL canHandle = NO;
//    
//    NSArray *lecaiSchemes = [[[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleURLTypes"] objectAtIndex:0] objectForKey:@"CFBundleURLSchemes"];
//    NSString *currentURLStr = [openURL.absoluteString lowercaseString];
//    
//    BOOL isLecaiScheme = NO;
//    NSString *openURLScheme = [[openURL scheme] lowercaseString];
//    if (openURLScheme.length > 0) {
//        for (NSString *aScheme in lecaiSchemes) {
//            if ([openURLScheme isEqualToString:[aScheme lowercaseString]]) {
//                isLecaiScheme = YES;
//                break;
//            }
//        }
//    }
//    
//    if (isLecaiScheme) {
//        NSMutableDictionary *dataParams = [self processQueryString:openURL];
//        if ([dataParams count] > 0) {
//            NSString *targetLocation = [dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_LOCATION];
//            
//            //            百度首页新用户赠彩: lecai://platformapi/startapp/?target=newUserPrize
//            //            lecai://platformapi/startapp/?target=selectionRandom&lotteryType=55&playType=5501&count=0
//            if (targetLocation.length > 0) {
//                NSString *source = [dataParams objectForKey:@"from"]; //打开的来源位置
//                if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_HOME] ||
//                    [targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_MAIN] ||
//                    [targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_BDHOME]) {
//                    //回主页
//                    [LTools changeRootViewController:LCBottomMenuVTypeHomePage];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_BACK]) {
//                    //回到上一级
//                    [LTools popControllerAnimated:YES];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_BET]) {
//                    //投注, 相当于从购彩大厅模拟点击相应彩种操作
//                    LotteryType lotteryType = [[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_LOTTERYTYPE] intValue];
//                    int randomNum = [[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_COUNT] intValue]; //随机产生彩种数量
//                    if (lotteryType == Fast3 || lotteryType == NewFast3) {
//                        //有randomNum
//                        LCFast3ViewController *viewController = [[LCFast3ViewController alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                        viewController.nLotteryType = lotteryType;
//                        viewController.nRandomNum = randomNum;
//                        LCKindOfLotteryData *data = [LTools getKindOfLotteryDataFromArray:lotteryType];
//                        data.mIsNeedShowAdv = YES;
//                        [viewController setFast3Data:data];
//                        [LTools pushControllerFromURLScheme:viewController animated:YES];
//                        [viewController release];
//                    } else {
//                        CustomLotteryTypeID customLotteryTypeID = [LTools getTypeFromLottery:lotteryType];
//                        if (customLotteryTypeID == CustomLotteryTypeFrequency || customLotteryTypeID == CustomLotteryTypeNumber) {
//                            //数字彩，高频彩 LCNumberChooseVC
//                            //有randomNum, 根据randomNum判断是否要自动先随机产生几注彩票
//                            //老逻辑会做这个操作注意 [[LTools getKindOfLotteryDataFromArray:lotteryType].mOrderListDataArray removeAllObjects];
//                            [[LTools getKindOfLotteryDataFromArray:lotteryType].mOrderListDataArray removeAllObjects];
//                            int playType = [[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_PLAYTYPE] intValue];
//                            LCNumberChooseVC *numberChooseVC = [[LCNumberChooseVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                            if (randomNum == 1) {
//                                numberChooseVC.mIsNeedRandomOne = YES;
//                            }
//                            LCKindOfLotteryData *data = [LTools getKindOfLotteryDataFromArray:lotteryType];
//                            data.mIsNeedShowAdv = YES;
//                            data.mLotteryDataOrdeListType = LotteryDataOrderListTypeTemp;
//                            [data.mTempOrderListDataArray removeAllObjects];
//                            [numberChooseVC setData:data];
//                            [numberChooseVC setPlayType:playType];
//                            [LTools pushControllerFromURLScheme:numberChooseVC animated:YES];
//                            [numberChooseVC release];
//                        } else if (customLotteryTypeID == CustomLotteryTypeAthletics) {
//                            //竞技彩
//                            if ([LTools shouldGotoFootballMainSingleForLottery:lotteryType isSingle:NO]) {
//                                LCFootballSingleVC *singleVC = [[LCFootballSingleVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                                singleVC.mLotteryType  = lotteryType;
//                                singleVC.mShouldShowAd = YES;
//                                [LTools pushController:singleVC animated:YES];
//                                [singleVC release];
//                            } else {
//                                LCNewAthleticsVC *athleticsVC = [[LCNewAthleticsVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                                LCKindOfLotteryData *data = [LTools getKindOfLotteryDataFromArray:lotteryType];
//                                data.mIsNeedShowAdv = YES;
//                                [athleticsVC setLotteryType:lotteryType];
//                                [LTools pushControllerFromURLScheme:athleticsVC animated:YES];
//                                [athleticsVC release];
//                            }
//                        } else if (customLotteryTypeID == CustomLotteryTypeSprot) {
//                            //体彩
//                            LCSportsVC *sportsVC = [[LCSportsVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                            LCKindOfLotteryData *data = [LTools getKindOfLotteryDataFromArray:lotteryType];
//                            data.mIsNeedShowAdv = YES;
//                            [sportsVC setLotteryType:lotteryType];
//                            [LTools pushControllerFromURLScheme:sportsVC animated:YES];
//                            [sportsVC release];
//                        }
//                    }
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_BETLIST]) {
//                    //投注列表,确认付款页
//                    int randomNum = [[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_COUNT] intValue]; //随机产生彩种数量
//                    LotteryType lotteryType = [[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_LOTTERYTYPE] intValue];
//                    if (lotteryType == Fast3 || lotteryType == NewFast3) {
//                        //有randomNum， 同上面的投注，LCFast3ViewController
//                        LCFast3ViewController *fast3VC = [[LCFast3ViewController alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                        fast3VC.nRandomNum = randomNum;
//                        fast3VC.nLotteryType = lotteryType;
//                        LCKindOfLotteryData *data = [LTools getKindOfLotteryDataFromArray:lotteryType];
//                        data.mIsNeedShowAdv = YES;
//                        [fast3VC setFast3Data:data];
//                        [LTools pushControllerFromURLScheme:fast3VC animated:YES];
//                        [fast3VC release];
//                    } else {
//                        //跳转到LCPayVC，有randomNum
//                        int playType = [[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_PLAYTYPE] intValue];
//                        LCPayVC *payVC = [[LCPayVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                        
//                        LCKindOfLotteryData *data = [LTools getKindOfLotteryDataFromArray:lotteryType];
//                        data.mLotteryDataOrdeListType = LotteryDataOrderListTypeTemp;
//                        [data.mTempOrderListDataArray removeAllObjects];
//                        [payVC setData:data
//                              playType:playType
//                                 times:1
//                            isAddMoeny:NO];
//                        [payVC random:lotteryType playType:playType count:randomNum];
//                        [LTools pushControllerFromURLScheme:payVC animated:YES];
//                        [payVC release] , payVC = nil;
//                    }
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_RECHARGE_AND_PAY]) {
//                    //充值并支付, 可能要和新重构的支付流程合并？
//                    NSString *mOrderID = [dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_ORDERID];
//                    int orderType = [[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_ORDERTYPE] intValue];
//                    
//                    if (orderType == [[[LCDataTools getOrderTypeMarkedToEnumDictionary] objectForKey:@"CHASE"] intValue]) {
//                        [LCPaymentManager startChasePhasePayment:mOrderID lotteryType:0 messageFor3rdChannel:nil sourceController:nil modelIndex:0 moneyForStats:@"-1"];
//                    } else {
//                        [LCPaymentManager startPaymentForOrder:mOrderID sourceController:nil modelIndex:0 moneyForStats:@"-1"];
//                    }
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_REWARD]) {
//                    //开奖公告
//                    [LTools changeRootViewController:LCBottomMenuVTypeReward];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_INFORMATION]) {
//                    //彩票资讯 LCInformationVC, 需要判断最顶端展示的页面是不是当前VC
//                    NSString *jumpString = [[LCDataTools getCategoryTypeMarkedToRealNameDictionary] objectForKey:[[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_CATEGORYID] uppercaseString]];
//                    LCInformationVC *informationVC = [[LCInformationVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                    //                    informationVC.mFromCategoryTitle = YES;
//                    informationVC.mJumpString = jumpString;
//                    [LTools pushControllerFromURLScheme:informationVC animated:YES];
//                    [informationVC release];
//                    
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_MAIN]) {
//                    //老版本右侧的购彩大厅，百度彩票应该是调到主页购彩大厅吧？
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_RECHARGE]) {
//                    //充值？ LCRechargeMainVC
//                    [APP_DELEGATE.mAccountTools accountLoginWithDelegate:nil
//                                                                    from:[LCChannelManager defaultLoginOpenAccountType]
//                                                                animated:YES
//                                                                 success:^(id code) {
//                                                                     LCRechargeMainVC *controller = [[LCRechargeMainVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                                                                     [LTools pushControllerFromURLScheme:controller animated:YES];
//                                                                     [controller release];
//                                                                 } fail:^(NSString *msg) {
//                                                                     
//                                                                 }];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_TOGETHER_BUY]) {
//                    //合买中心，需要将来lotteryType传进去
//                    LotteryType lotteryType = [[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_LOTTERYTYPE] intValue];
//                    [LTools changeRootViewController:LCBottomMenuVTypeTogetherBuy];
//                    LCTogetherBuyHomeVC *togetherBuyVC = [[APP_DELEGATE.mNavigationController viewControllers] objectAtIndex:0];
//                    [togetherBuyVC setallCount:0 lotter:lotteryType];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_WORLDCUP]) {
//                    //世界杯,暂时不处理
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_MESSAGECENTER]) {
//                    //消息中心
//                    NSString *messageTabType = [dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_CATEGORYID];
//                    BOOL isPersonalMessage = [messageTabType isEqualToString:@"private"];
//                    
//                    if (isPersonalMessage) {
//                        //个人消息
//                        [APP_DELEGATE.mAccountTools accountLoginWithDelegate:nil
//                                                                        from:[LCChannelManager defaultLoginOpenAccountType]
//                                                                    animated:YES
//                                                                     success:^(id code) {
//                                                                         LCMessageCenterVC *messageCenterVC = [[LCMessageCenterVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                                                                         messageCenterVC.isPushOpen = YES;
//                                                                         messageCenterVC.mCategory = @"private";
//                                                                         [LTools pushControllerFromURLScheme:messageCenterVC animated:YES];
//                                                                         [messageCenterVC release];
//                                                                     } fail:^(NSString *msg) {
//                                                                     }];
//                    } else {
//                        //公共消息
//                        LCMessageCenterVC *messageCenterVC = [[LCMessageCenterVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                        messageCenterVC.isPushOpen = YES;
//                        messageCenterVC.mCategory = @"public";
//                        [LTools pushControllerFromURLScheme:messageCenterVC animated:YES];
//                        [messageCenterVC release];
//                    }
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_INFORMATION_DETAIL]) {
//                    //资讯详情, 详情ID
//                    int newsId = [[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_LOCATION_NEWSID] intValue];
//                    LCInformationDetailVC *detailVC  = [[LCInformationDetailVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                    detailVC.mAid = newsId;
//                    detailVC.mIndex = 0;
//                    detailVC.mTotal = 0;
//                    if (source.length > 0 && [source isEqualToString:@"msgCenter"]) {
//                        detailVC.backToMessageCenter = YES;
//                        detailVC.mIndex = -1;
//                    }
//                    [LTools pushControllerFromURLScheme:detailVC animated:YES];
//                    [detailVC release];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_WIN_ORDER]) {
//                    //中奖列表
//                    [LTools changeRootViewController:LCBottomMenuVTypeMyLottery];
//                    LCAccountMainVC *accountMainVC = [[APP_DELEGATE.mNavigationController viewControllers] objectAtIndex:0];
//                    [accountMainVC openVCAndShowCategoryWithIndex:1];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_CHASE]) {
//                    //LCMyAllOrderListVC type:4
//                    [LTools changeRootViewController:LCBottomMenuVTypeMyLottery];
//                    LCAccountMainVC *accountMainVC = [[APP_DELEGATE.mNavigationController viewControllers] objectAtIndex:0];
//                    [accountMainVC openVCAndShowCategoryWithIndex:5];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_FOLLOWORDER] || [targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_FOUNDERORDER]) {
//                    //LCMyAllOrderListVC type:3
//                    //LCMyAllOrderListVC type:2
//                    [LTools changeRootViewController:LCBottomMenuVTypeMyLottery];
//                    LCAccountMainVC *accountMainVC = [[APP_DELEGATE.mNavigationController viewControllers] objectAtIndex:0];
//                    [accountMainVC openVCAndShowCategoryWithIndex:4];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_BETORDER]) {
//                    //LCMyAllOrderListVC type:1
//                    [LTools changeRootViewController:LCBottomMenuVTypeMyLottery];
//                    LCAccountMainVC *accountMainVC = [[APP_DELEGATE.mNavigationController viewControllers] objectAtIndex:0];
//                    [accountMainVC openVCAndShowCategoryWithIndex:0];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_SELECTION_SPECIAL]) {
//                    //单关配或单关固赔 LCNewAthleticsVC jczqdgp  jczq2x1
//                    NSString *lotteryTypeStr = [dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_LOTTERYTYPE];
//                    LotteryType lotteryType = FootBallSingle;
//                    if (![lotteryTypeStr isEqualToString:@"jczqdgp"]) {
//                        lotteryType = FootBallAlternative;
//                    }
//                    LCNewAthleticsVC *athleticsVC = [[LCNewAthleticsVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                    [athleticsVC setLotteryType:lotteryType];
//                    [LTools pushControllerFromURLScheme:athleticsVC animated:YES];
//                    [athleticsVC release];
//                    
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_SYNDICATE_PLAN]) {
//                    //LCTogetherBuyDetailsVC, 合买详情
//                    LCTogetherBuyDetailsVC *detailVC = [[LCTogetherBuyDetailsVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                    [detailVC setInitDateOnlyPlanID:[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_PLAN_ID]];
//                    [LTools pushControllerFromURLScheme:detailVC animated:YES];
//                    [detailVC release];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_NEWUSERPRIZE]){
//                    
//                    [[NSNotificationCenter defaultCenter] postNotificationName:LCNotificationNewUserPrizeCommingFromURL
//                                                                        object:nil];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_MyLottery]) {
//                    [LTools changeRootViewController:LCBottomMenuVTypeMyLottery];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_Discovery]) {
//                    [LTools changeRootViewController:LCBottomMenuVTypeDiscovery];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_JJC]) {
//                    LCArenaVC *arenaVC = [[LCArenaVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                    [LTools pushControllerFromURLScheme:arenaVC animated:YES];
//                    [arenaVC release];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_MissionCenter]) {
//                    [APP_DELEGATE.mAccountTools accountLoginWithDelegate:nil
//                                                                    from:[LCChannelManager defaultLoginOpenAccountType]
//                                                                animated:YES
//                                                                 success:^(id code) {
//                                                                     LCMissionMainVC *missionMainVC = [[LCMissionMainVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                                                                     [LTools pushControllerFromURLScheme:missionMainVC animated:YES];
//                                                                     [missionMainVC release];
//                                                                 } fail:^(NSString *msg) {
//                                                                     
//                                                                 }];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_MyAccount]) {
//                    [APP_DELEGATE.mAccountTools accountLoginWithDelegate:nil
//                                                                    from:[LCChannelManager defaultLoginOpenAccountType]
//                                                                animated:YES
//                                                                 success:^(id code) {
//                                                                     LCAccountSetVC *accountSet = [[LCAccountSetVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                                                                     [LTools pushControllerFromURLScheme:accountSet animated:YES];
//                                                                     [accountSet release];
//                                                                 } fail:^(NSString *msg) {
//                                                                     
//                                                                 }];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_CProfile]) {
//                    [APP_DELEGATE.mAccountTools accountLoginWithDelegate:nil
//                                                                    from:[LCChannelManager defaultLoginOpenAccountType]
//                                                                animated:YES
//                                                                 success:^(id code) {
//                                                                     LCAcountInformationVC *info = [[LCAcountInformationVC alloc] initCustomVCType:LCCustomBaseVCTypeNormal];
//                                                                     [LTools pushControllerFromURLScheme:info animated:YES];
//                                                                     [info release];
//                                                                 } fail:^(NSString *msg) {
//                                                                     
//                                                                 }];
//                    
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_BDRegister] ||
//                           [targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_BDLogin] ||
//                           [targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_LECAILOGIN]
//                           ) {
//                    BOOL shouldRefresh = ([[dataParams objectForKey:K_KEY_COMEFROM_PARAM_BACK] intValue] == 1);
//                    
//                    openAccountType openAccountType = openAccount_login_baidu;
//                    if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_BDRegister]) {
//                        openAccountType = openAccount_reg_baidu;
//                    } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_LECAILOGIN]) {
//                        openAccountType = openAccount_login_lecai;
//                    }
//                    
//                    //                    BOOL alreadyLogin = [LTools isLogin];
//                    [APP_DELEGATE.mAccountTools accountLoginWithDelegate:nil
//                                                                    from:openAccountType
//                                                                animated:YES
//                                                                 success:^(id code) {
//                                                                     if (shouldRefresh) {
//                                                                         dispatch_async(dispatch_get_main_queue(), ^{
//                                                                             [[NSNotificationCenter defaultCenter] postNotificationName:LCNotificationShouldRefreshWebViewAfterLogin object:nil];
//                                                                         });
//                                                                     }
//                                                                 } fail:^(NSString *msg) {
//                                                                 }];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_BDUnpaidOrder]) {
//                    [APP_DELEGATE.mAccountTools accountLoginWithDelegate:nil
//                                                                    from:[LCChannelManager defaultLoginOpenAccountType]
//                                                                animated:YES
//                                                                 success:^(id code) {
//                                                                     [LTools changeRootViewController:LCBottomMenuVTypeMyLottery];
//                                                                     LCAccountMainVC *accountMainVC = [[APP_DELEGATE.mNavigationController viewControllers] objectAtIndex:0];
//                                                                     [accountMainVC openVCAndShowCategoryWithIndex:3];
//                                                                 } fail:^(NSString *msg) {
//                                                                 }];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_REWARD_HISTORY]) {
//                    LotteryType lotteryType = [[dataParams objectForKey:K_KEY_COMEFROM_OUT_TO_LOTTERYTYPE] intValue];
//                    [LCUITools enterRewardHistoryDetails:lotteryType checkDuplication:YES];
//                } else if ([targetLocation isEqualToString:K_KEY_COMEFROM_OUT_TO_LOCATION_CHECKIN]) {
//                    LCCalendarMainVC *calendar = [[LCCalendarMainVC alloc]initCustomVCType:LCCustomBaseVCTypeNormal];
//                    [LTools pushController:calendar animated:YES];
//                    [calendar release],calendar = nil;
//                }
//            }
//        }
//        canHandle = YES;
//    }
//    
//    if ([currentURLStr isEqualToString:[K_BACK_URL lowercaseString]]) {
//        canHandle = YES;
//    }
//    
//    return canHandle;
//}
//
//+ (void)checkSNSLoginButtonStatus:(NSArray *)loginButtons
//{
//    UIButton *qqButton = nil;
//    UIButton *weiboButton = nil;
//    UIButton *alipayButton = nil;
//    for (UIButton *aButton in loginButtons) {
//        if (aButton.tag == LCSNSLoginTypeAlipay) {
//            alipayButton = aButton;
//        } else if (aButton.tag == LCSNSLoginTypeQQ) {
//            qqButton = aButton;
//        } else if (aButton.tag == LCSNSLoginTypeWeibo) {
//            weiboButton = aButton;
//        }
//    }
//    
//    qqButton.hidden = NO;
//    alipayButton.hidden = NO;
//    weiboButton.hidden = NO;
//    
//    if ([THIRD_PAKEGE intValue]) {
//        weiboButton.hidden = YES;
//    } else {
//        weiboButton.hidden = NO;
//    }
//    
//    if ([[LTools getObjectFromSystemKey:K_KEY_IS_SHOWQQLOGIN] boolValue]) {
//        qqButton.hidden = YES;
//    } else {
//        qqButton.hidden = NO;
//    }
//    
//    if (![WeiboSDK isWeiboAppInstalled]) {
//        weiboButton.hidden = YES;
//    }
//    
//    if (![TencentOAuth iphoneQQInstalled]) {
//        qqButton.hidden = YES;
//    }
//    
//    NSMutableArray *displayedButtons = [[NSMutableArray alloc] init];
//    
//    if (!qqButton.hidden) {
//        [displayedButtons addObject:qqButton];
//    }
//    
//    if (!alipayButton.hidden) {
//        [displayedButtons addObject:alipayButton];
//    }
//    
//    if (!weiboButton.hidden) {
//        [displayedButtons addObject:weiboButton];
//    }
//    
//    NSInteger buttonAmount = [displayedButtons count];
//    if (buttonAmount > 0) {
//        CGRect parentFrame = qqButton.superview.frame;
//        CGFloat originX = (parentFrame.size.width - (buttonAmount - 1) * 30.f - buttonAmount * 44.f) / 2.f;
//        
//        NSInteger index = 0;
//        for (UIButton *aButton in displayedButtons) {
//            CGRect tmpFrame = aButton.frame;
//            tmpFrame.origin.x = originX + index * (44.f + 30.f);
//            aButton.frame = tmpFrame;
//            index ++;
//        }
//    }
//    
//    [displayedButtons release];
//}

+ (UIView *)creatLineView:(CGRect)_frame bgColor:(UIColor *)_color {
    UIView *line = [[[UIView alloc]initWithFrame:_frame] autorelease];
    if (!_color) {
        line.backgroundColor = K_COLOR_MAIN_LINE;
    }else{
        line.backgroundColor = _color;
    }
    return line;
}

+ (UIView *)creatDashedLineView:(CGRect)_frame {
    UIView *line = [[[UIView alloc]initWithFrame:_frame] autorelease];
    UIImage *image = [UIImage imageNamed:@"Icon_dashedLine.png"];
    line.backgroundColor = [UIColor colorWithPatternImage:image];
    return line;
}

+ (UILabel *)creatNewLabel:(CGRect)_frame text:(NSString *)_text color:(UIColor *)_color font:(UIFont *)_font textAlinment:(NSTextAlignment)_alignment {
    UILabel *label = [[[UILabel alloc] initWithFrame:_frame] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.text = _text;
    label.textColor = _color;
    label.textAlignment = _alignment;
    label.font = _font;
    return label;
}

- (CGAffineTransform)transformForOrientation {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationLandscapeLeft == orientation) {
        return CGAffineTransformMakeRotation(M_PI*1.5);
    } else if (UIInterfaceOrientationLandscapeRight == orientation) {
        return CGAffineTransformMakeRotation(M_PI/2);
    } else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
        return CGAffineTransformMakeRotation(-M_PI);
    } else {
        return CGAffineTransformIdentity;
    }
}

+ (void)scaleAnmiartionView:(UIView *)view_ andDuration
                           :(NSTimeInterval)duration_ andAnimationDelay
                           :(NSTimeInterval)delay andScale_X
                           :(CGFloat)scale_x_ andScale_y
                           :(CGFloat)scale_y_ finishedBlock:(void (^)(void))continuAnimations_ {
    [UIView animateWithDuration:duration_ animations:^{
        
        [UIView setAnimationDelay:delay];
        view_.transform = CGAffineTransformScale(view_.transform, scale_x_, scale_y_);
        
    } completion:^(BOOL finished) {
        if (continuAnimations_) {
            continuAnimations_();
        }
    }];
}

+ (void)slowDisplay:(UIView *)view_ andDuration
                   :(NSTimeInterval)duration_ andAnimationDelay
                   :(NSTimeInterval)delay finishedBlock:(void (^)(void))continuAnimations_ {
  [UIView animateWithDuration:duration_ animations:^{
        [UIView setAnimationDelay:delay];
        [view_ setAlpha:1.0f];
    } completion:^(BOOL finished) {
        if (continuAnimations_) {
            continuAnimations_();
        }
    }];
    
}

+ (void)slowDisplay:(UIView *)view_ andDuration
                   :(NSTimeInterval)duration_ andAnimationDelay
                   :(NSTimeInterval)delay {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:duration_];
    [UIView setAnimationDelay:delay];
    [UIView setAnimationDelegate:self];
    [view_ setAlpha:1.0f];
    [UIView commitAnimations];
    
}

+(void)rotationAnmiartionView:(UIView*)view_ andDuration
                             :(NSTimeInterval)duration andRotation
                             :(NSString*)rotation_ andAngle
                             :(CGFloat)angle_ andRepeatCount
                             :(NSInteger)repeatCount_ {
    NSString* rotation=@"transform.rotation.x";
    if ([rotation_ isEqualToString:@"y"]) {
        rotation = @"transform.rotation.y";
    }else if ([rotation_ isEqualToString:@"z"]){
        rotation = @"transform.rotation.z";
    }
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:rotation];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * angle_ ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeatCount_;
    [view_.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

+(void)swingAnmiartionView:(UIView*)view_ andDuration
                             :(NSTimeInterval)duration andRotation
                             :(NSString*)rotation_ andRepeatCount
                          :(NSInteger)repeatCount_ andAngle:(CGFloat)angle_ {
    NSString* rotation=@"transform.rotation.x";
    if ([rotation_ isEqualToString:@"y"]) {
        rotation = @"transform.rotation.y";
    }else if ([rotation_ isEqualToString:@"z"]){
        rotation = @"transform.rotation.z";
    }
            CABasicAnimation *momAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            momAnimation.fromValue = [NSNumber numberWithFloat:0-angle_];
            momAnimation.toValue =   [NSNumber numberWithFloat:angle_];
            momAnimation.duration = duration;
            momAnimation.repeatCount = repeatCount_;
            momAnimation.autoreverses = YES;
            momAnimation.delegate = self;
            [view_.layer addAnimation:momAnimation forKey:@"animateLayer"];
}

+ (void)animationView:(UIView *)aView
                fromX:(float)fromX
                fromY:(float)fromY
                  toX:(float)toX
                  toY:(float)toY
                delay:(float)delayTime
             duration:(float)durationTime
             finishedBlock:(void (^)(void))continuAnimations_{
    
       [UIView animateWithDuration:durationTime animations:^{
       [aView setFrame:CGRectMake(fromX, fromY, aView.frame.size.width, aView.frame.size.height)];
       [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
       [UIView setAnimationDelay:delayTime];
       [UIView setAnimationDuration:durationTime];
       [aView setFrame:CGRectMake(toX, toY, aView.frame.size.width, aView.frame.size.height)];
  } completion:^(BOOL finished) {
      if (continuAnimations_) {
          continuAnimations_();
      }
  }];
    
}

@end
