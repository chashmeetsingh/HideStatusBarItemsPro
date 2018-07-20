#include "hidestatusbaritems.h"
#include <spawn.h>
#include <signal.h>

@implementation HideStatusBarItemsRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}
	return _specifiers;
}

-(void)twitterContactMethod {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"twitter:///user?screen_name=cchashmeetsingh"]];
}

-(void)paypalDonateMethod {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.paypal.me/chashmeet/1usd"]];
}

-(void)respring {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure?" message:@"This will respring your device and apply the changes." preferredStyle:UIAlertControllerStyleAlert];

  	UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){ 
		pid_t pid;
		const char* args[] = {"killall", "backboardd", NULL};
		posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
    }];
  	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
  	[alert addAction:cancel];
  	[alert addAction:ok];
  	[self presentViewController:alert animated:YES completion:nil];
}

@end
