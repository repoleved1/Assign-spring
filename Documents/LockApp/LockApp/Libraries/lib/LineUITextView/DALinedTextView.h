//
//  DALinedTextView.h
//  LockApp
//
//  Created by Phung Anh Dung on 1/6/20.
//  Copyright © 2020 Anh Dũng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DALinedTextView : UITextView

@property (nonatomic, strong) UIColor *horizontalLineColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *verticalLineColor UI_APPEARANCE_SELECTOR;

@end
NS_ASSUME_NONNULL_END
