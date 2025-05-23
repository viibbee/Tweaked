#import <UIKit/UIKit.h>
%hook SpringBoard

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    %orig;

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Vhi"
                                                                   message:@"Добро пожаловать"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *button0 = [UIAlertAction actionWithTitle:@"Канал"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
        NSURL *url = [NSURL URLWithString:@"https://t.me/iosgodsoficial"];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }
    }];
    [alert addAction:button0];

    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    });
}

%end
