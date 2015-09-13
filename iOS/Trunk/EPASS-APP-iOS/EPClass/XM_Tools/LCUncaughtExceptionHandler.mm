//
//  LCUncaughtExceptionHandler.m
//  LeCai
//
//  Created by lehecaiminib on 13-3-27.
//
//

#import "LCUncaughtExceptionHandler.h"
NSString *applicationDocumentsDirectory() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

void UncaughtExceptionHandler(NSException *exception) {
//    NSArray *arr = [exception callStackSymbols];
//    NSString *reason = [exception reason];
//    NSString *name = [exception name];
//    
//    NSString *url = [NSString stringWithFormat:@"=============异常崩溃报告=============\nname:\n%@\nreason:\n%@\ncallStackSymbols:\n%@",
//                     name,reason,[arr componentsJoinedByString:@"\n"]];
//    NSString *path = [applicationDocumentsDirectory() stringByAppendingPathComponent:@"Exception.txt"];
//    [url writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    //除了可以选择写到应用下的某个文件，通过后续处理将信息发送到服务器等
    //还可以选择调用发送邮件的的程序，发送信息到指定的邮件地址
    //或者调用某个处理程序来处理这个信息
    
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *urlStr = [NSString stringWithFormat:@"mailto://hexiaoguang@lehecai.com?subject=bug报告&body=感谢您的配合!<br><br><br>"
                        "错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                        name,reason,[arr componentsJoinedByString:@"<br>"]];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

@implementation LCUncaughtExceptionHandler

-(NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

+ (void)setDefaultHandler
{
    NSSetUncaughtExceptionHandler (&UncaughtExceptionHandler);
    struct sigaction sigAction;
    
    sigAction.sa_sigaction = signalHandler;
    
    sigAction.sa_flags = SA_SIGINFO;
    
    sigemptyset(&sigAction.sa_mask);
    
    sigaction(SIGQUIT, &sigAction, NULL);
    
    sigaction(SIGILL, &sigAction, NULL);
    
    sigaction(SIGTRAP, &sigAction, NULL);
    
    sigaction(SIGABRT, &sigAction, NULL);
    
    sigaction(SIGEMT, &sigAction, NULL);
    
    sigaction(SIGFPE, &sigAction, NULL);
    
    sigaction(SIGBUS, &sigAction, NULL);
    
    sigaction(SIGSEGV, &sigAction, NULL);
    
    sigaction(SIGSYS, &sigAction, NULL);
    
    sigaction(SIGPIPE, &sigAction, NULL);
    
    sigaction(SIGALRM, &sigAction, NULL);
    
    sigaction(SIGXCPU, &sigAction, NULL);
    
    sigaction(SIGXFSZ, &sigAction, NULL);
}

+ (NSUncaughtExceptionHandler*)getHandler
{
    return NSGetUncaughtExceptionHandler();
}

void signalHandler(int sig, siginfo_t *info, void *context){
    NSException *exception = [NSException
                              exceptionWithName:@"UncaughtExceptionHandlerSignalExceptionName"
                              reason:
                              [NSString stringWithFormat:
                               NSLocalizedString(@"Signal %d was raised.\n"
                                                 , nil),
                               signal]
                              userInfo:
                              [NSDictionary
                               dictionaryWithObject:[NSNumber numberWithInt:sig]
                               forKey:@"UncaughtExceptionHandlerSignalKey"]];
    
    NSArray *arr = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name = [exception name];
    NSString *urlStr = [NSString stringWithFormat:@"mailto://hexiaoguang@lecai.com?subject=bug报告&body=感谢您的配合!<br><br><br>"
                        "错误详情:<br>%@<br>--------------------------<br>%@<br>---------------------<br>%@",
                        name,reason,[arr componentsJoinedByString:@"<br>"]];
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication] openURL:url];
}

@end


