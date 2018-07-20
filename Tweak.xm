#include <CoreFoundation/CFNotificationCenter.h>
#import <Foundation/NSUserDefaults.h>

static NSString *domainString = @"com.chashmeet.hidestatusbaritemspro";
static NSString *notificationString = @"com.chashmeet.hidestatusbaritemspro/preferences.changed";

@interface NSUserDefaults (UFS_Category)
- (id)objectForKey:(NSString *)key inDomain:(NSString *)domain;
- (void)setObject:(id)value forKey:(NSString *)key inDomain:(NSString *)domain;
@end

@interface SBCoverSheetPresentationManager : NSObject 
	+(id)sharedInstance;
	-(BOOL)isVisible; 
@end

@interface SBStatusBarStateAggregator : NSObject 
	+(id)sharedInstance;
	-(void)updateStatusBarItem:(int)arg1;
@end

static BOOL enableTweak = NO;

static BOOL lsDNDSwitch = NO;
static BOOL lsAirplaneModeSwitch = NO;
static BOOL lsSignalStrengthSwitch = NO;
static BOOL lsCarrierTextSwitch = NO;
static BOOL lsWifiSwitch = NO;
static BOOL lsBatteryIconSwitch = NO;
static BOOL lsBatteryTextSwitch = NO;
static BOOL lsBluetoothSwitch = NO;
static BOOL lsAlarmSwitch = NO;
static BOOL lsLocationSwitch = NO;
static BOOL lsOrientationLockSwitch = NO;
static BOOL lsScreenMirroringSwitch = NO;
static BOOL lsVpnSwitch = NO;

static BOOL sbTimeSwitch = NO;
static BOOL sbDNDSwitch = NO;
static BOOL sbAirplaneModeSwitch = NO;
static BOOL sbSignalStrengthSwitch = NO;
static BOOL sbCarrierTextSwitch = NO;
static BOOL sbWifiSwitch = NO;
static BOOL sbBatteryIconSwitch = NO;
static BOOL sbBatteryTextSwitch = NO;
static BOOL sbBluetoothSwitch = NO;
static BOOL sbAlarmSwitch = NO;
static BOOL sbLocationSwitch = NO;
static BOOL sbOrientationLockSwitch = NO;
static BOOL sbScreenMirroringSwitch = NO;
static BOOL sbVpnSwitch = NO;

static BOOL locked;

%hook SBCoverSheetPresentationManager

int items[14] = {0, 1, 2, 3, 4, 6, 8, 9, 12, 14, 17, 18, 20, 24};

-(void)_notifyDelegateDidPresent {
	locked = YES;

	if (!enableTweak) return %orig;
	NSLog(@"will present");
	for (int i = 0; i < 14; i++ ) {
		NSLog(@"Item %d", items[i]);
		[[NSClassFromString(@"SBStatusBarStateAggregator") sharedInstance] updateStatusBarItem:items[i]];
   	}
	return %orig;
}

-(void)_notifyDelegateDidDismiss {
	locked = NO;

	if (!enableTweak) return %orig;
	NSLog(@"will dismiss");
	for (int i = 0; i < 14; i++ ) {
		NSLog(@"Item %d", items[i]);
		[[NSClassFromString(@"SBStatusBarStateAggregator") sharedInstance] updateStatusBarItem:items[i]];
   	}
	return %orig;
}

%end

%hook SBStatusBarStateAggregator

-(void)_updateTimeItems {
	if (enableTweak && sbTimeSwitch) {
		return;
	}
	return %orig;
}

-(BOOL)_setItem:(int)item enabled:(BOOL)enableItem {
	// 0: Time but not working
    // 1: DND
    // 2: Airplane Mode
    // 3: Mobile Signal
    // 4: Carrier Text
    // 6: WiFi icon
    // 8: Battery icon
    // 9: Battery % text
    // 10: Battery % text same?
    // 11: Something related to battery
    // 12: Bluetooth icon
    // 13: Phone and key icon?
    // 14: Alarm icon
    // 17: Location icon
    // 18: Orientation lock icon
    // 20: Screen mirroring icon
    // 22: Related to audio
    // 24: VPN icon
    // 25: Related to call outward icon
    // 27: Black square icon
	// 34: Plugged in earphones

	// NSLog(@"set item called");

	if (!enableTweak) return %orig;

	//NSLog(@"locked called %d", locked);

	switch (item) {
		case 0:
			return !locked && sbTimeSwitch ? %orig(item, NO) : %orig;
		case 1:
			return locked && lsDNDSwitch ? %orig(item, NO) : !locked && sbDNDSwitch ? %orig(item, NO) : %orig;
		case 2:
			return locked && lsAirplaneModeSwitch ? %orig(item, NO) : !locked && sbAirplaneModeSwitch ? %orig(item, NO) : %orig;
		case 3:
			return locked && lsSignalStrengthSwitch ? %orig(item, NO) : !locked && sbSignalStrengthSwitch ? %orig(item, NO) : %orig;
		case 4:
			return locked && lsCarrierTextSwitch ? %orig(item, NO) : !locked && sbCarrierTextSwitch ? %orig(item, NO) : %orig;
		case 6:
			return locked && lsWifiSwitch ? %orig(item, NO) : !locked && sbWifiSwitch ? %orig(item, NO) : %orig;
		case 8:
			return locked && lsBatteryIconSwitch ? %orig(item, NO) : !locked && sbBatteryIconSwitch ? %orig(item, NO) : %orig;
		case 9:
			return locked && lsBatteryTextSwitch ? %orig(item, NO) : !locked && sbBatteryTextSwitch ? %orig(item, NO) : %orig;
		case 12:
			return locked && lsBluetoothSwitch ? %orig(item, NO) : !locked && sbBluetoothSwitch ? %orig(item, NO) : %orig;
		case 14:
			return locked && lsAlarmSwitch ? %orig(item, NO) : !locked && sbAlarmSwitch ? %orig(item, NO) : %orig;
		case 17:
			return locked && lsLocationSwitch ? %orig(item, NO) : !locked && sbLocationSwitch ? %orig(item, NO) : %orig;
		case 18:
			return locked && lsOrientationLockSwitch ? %orig(item, NO) : !locked && sbOrientationLockSwitch ? %orig(item, NO) : %orig;
		case 20:
			return locked && lsScreenMirroringSwitch ? %orig(item, NO) : !locked && sbScreenMirroringSwitch ? %orig(item, NO) : %orig;
		case 24:
			return locked && lsVpnSwitch ? %orig(item, NO) : !locked && sbVpnSwitch ? %orig(item, NO) : %orig;
    	default:
      		return %orig;
	}
}

%end

static void notificationCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {	

	enableTweak = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"enableTweak" inDomain:domainString] boolValue];
	sbTimeSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbTimeSwitch" inDomain:domainString] boolValue];
	
	lsDNDSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsDNDSwitch" inDomain:domainString] boolValue];
	sbDNDSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbDNDSwitch" inDomain:domainString] boolValue];

	lsAirplaneModeSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsAirplaneModeSwitch" inDomain:domainString] boolValue];
	sbAirplaneModeSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbAirplaneModeSwitch" inDomain:domainString] boolValue];

	lsSignalStrengthSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsSignalStrengthSwitch" inDomain:domainString] boolValue];
	sbSignalStrengthSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbSignalStrengthSwitch" inDomain:domainString] boolValue];

	lsCarrierTextSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsCarrierTextSwitch" inDomain:domainString] boolValue];
	sbCarrierTextSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbCarrierTextSwitch" inDomain:domainString] boolValue];

	lsWifiSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsWifiSwitch" inDomain:domainString] boolValue];
	sbWifiSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbWifiSwitch" inDomain:domainString] boolValue];

	lsBatteryIconSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsBatteryIconSwitch" inDomain:domainString] boolValue];
	sbBatteryIconSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbBatteryIconSwitch" inDomain:domainString] boolValue];

	lsBatteryTextSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsBatteryTextSwitch" inDomain:domainString] boolValue];
	sbBatteryTextSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbBatteryTextSwitch" inDomain:domainString] boolValue];

	lsBluetoothSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsBluetoothSwitch" inDomain:domainString] boolValue];
	sbBluetoothSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbBluetoothSwitch" inDomain:domainString] boolValue];

	lsAlarmSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsAlarmSwitch" inDomain:domainString] boolValue];
	sbAlarmSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbAlarmSwitch" inDomain:domainString] boolValue];

	lsLocationSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsLocationSwitch" inDomain:domainString] boolValue];
	sbLocationSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbLocationSwitch" inDomain:domainString] boolValue];

	lsOrientationLockSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsOrientationLockSwitch" inDomain:domainString] boolValue];
	sbOrientationLockSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbOrientationLockSwitch" inDomain:domainString] boolValue];

	lsScreenMirroringSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsScreenMirroringSwitch" inDomain:domainString] boolValue];
	sbScreenMirroringSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbScreenMirroringSwitch" inDomain:domainString] boolValue];

	lsVpnSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"lsVpnSwitch" inDomain:domainString] boolValue];
	sbVpnSwitch = [(NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:@"sbVpnSwitch" inDomain:domainString] boolValue];

}

%ctor {
	//NSAutoreleasePool *pool = [NSAutoreleasePool new];
	//set initial `enable' variable
	notificationCallback(NULL, NULL, NULL, NULL, NULL);

	//register for notifications
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, notificationCallback, (CFStringRef)notificationString, NULL, CFNotificationSuspensionBehaviorCoalesce);
	//[pool release];
}