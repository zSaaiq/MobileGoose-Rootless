#import "PXMGPRootListController.h"
#import <Preferences/PSSpecifier.h>
#import <substrate.h>
#import "Utilities.h"
@import Darwin.POSIX.spawn;

@interface UIView(Private)
- (UIViewController *)_viewControllerForAncestor;
@end

static void (*MobileGoose$UILabel$setText$orig)(id,SEL,id) = nil;
static void MobileGoose$UILabel$setText$hook(UILabel *self, SEL _cmd, NSString *text) {
	if ([self._viewControllerForAncestor isKindOfClass:[PXMGPRootListController class]]) {
		if ([self.superview isKindOfClass:[UISlider class]]) {
			text = [text componentsSeparatedByString:@"."].firstObject;
		}
	}
	MobileGoose$UILabel$setText$orig(self, _cmd, text);
}

@implementation PXMGPRootListController

+ (void)load {
	if ((self == [PXMGPRootListController class]) && !MobileGoose$UILabel$setText$orig) {
		MSHookMessageEx(
			UILabel.class,
			@selector(setText:),
			(IMP)&MobileGoose$UILabel$setText$hook,
			(IMP*)&MobileGoose$UILabel$setText$orig
		);
	}
}

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}
- (void)respring:(id)sender {
	pid_t pid;
    const char* args[] = {"killall", "backboardd", NULL};
    posix_spawn(&pid, "/var/jb/usr/bin/killall", NULL, NULL, (char* const*)args, NULL);
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	[super setPreferenceValue:value specifier:specifier];
	NSNumber *requiresRespring = [specifier propertyForKey:@"requiresRespring"];
	if (requiresRespring.boolValue) {
		for (PSSpecifier *button in _specifiers) {
			SEL action = *(PXMGPGetSelectorIvar(button, "action"));
			if (action == @selector(didRequestRespring:)) {
				[button setProperty:@YES forKey:@"enabled"];
				[self reloadSpecifier:button];
			}
		}
	}
}

- (void)setPreferenceValue:(NSNumber *)value forDangerousSlider:(PSSpecifier *)specifier {
	[self setPreferenceValue:value specifier:specifier];
	NSNumber *recommendedMax = [specifier propertyForKey:@"recommendedMax"];
	NSNumber *didShowWarning = [specifier propertyForKey:@"__didShowWarning"];
	if (!didShowWarning.boolValue && (floor(value.doubleValue) > floor(recommendedMax.doubleValue))) {
		NSString *message = [NSString
			stringWithFormat:[specifier propertyForKey:@"warningMessage"],
			recommendedMax
		];
		if (@available(iOS 9.0, *)) {
			UIAlertController *alert = [UIAlertController
				alertControllerWithTitle:@"Warning"
				message:message
				preferredStyle:UIAlertControllerStyleAlert
			];
			[alert addAction:[UIAlertAction
				actionWithTitle:@"OK"
				style:UIAlertActionStyleDefault
				handler:nil
			]];
			[self presentViewController:alert animated:YES completion:nil];
		}
		else {
		    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Warning"
		                                                                             message:message
		                                                                      preferredStyle:UIAlertControllerStyleAlert];

		    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
		                                                       style:UIAlertActionStyleDefault
		                                                     handler:nil];

		    [alertController addAction:okAction];

		    UIWindow *keyWindow = nil;
		    if (@available(iOS 13.0, *)) {
		        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
		            if (scene.activationState == UISceneActivationStateForegroundActive) {
		                keyWindow = scene.windows.firstObject;
		                break;
		            }
		        }
		    }

		    UIViewController *rootViewController = keyWindow.rootViewController;
		    [rootViewController presentViewController:alertController animated:YES completion:nil];
		}


		[specifier setProperty:@YES forKey:@"__didShowWarning"];
	}
}

- (void)setPreferenceValue:(NSNumber *)value forNotifyingSwitch:(PSSpecifier *)specifier {
	[self setPreferenceValue:value specifier:specifier];
	NSNotificationName notificationName;
	if ((value.boolValue && (notificationName = [specifier propertyForKey:@"trueNotification"])) ||
		(!value.boolValue && (notificationName = [specifier propertyForKey:@"falseNotification"])))
	{
		CFNotificationCenterPostNotification(
			CFNotificationCenterGetDarwinNotifyCenter(),
			(__bridge CFNotificationName)notificationName,
			NULL, NULL, YES
		);
	}
	if ((notificationName = [specifier propertyForKey:@"anyNotification"])) {
		[NSUserDefaults.standardUserDefaults synchronize];
		CFNotificationCenterPostNotification(
			CFNotificationCenterGetDarwinNotifyCenter(),
			(__bridge CFNotificationName)notificationName,
			NULL, NULL, YES
		);
	}
}

- (void)URLButtonPerformedAction:(PSSpecifier*)specifier {
    NSString *URLString = [specifier propertyForKey:@"url"];
    NSURL *URL;
    if (URLString && (URL = [NSURL URLWithString:URLString])) {
        [[UIApplication sharedApplication] openURL:URL options:@{} completionHandler:nil];
    }
}


@end
