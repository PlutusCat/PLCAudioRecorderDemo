#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "JHAnimationChainLink.h"
#import "JHChainableAnimator.h"
#import "JHChainableBlocks.h"
#import "JHKeyframeAnimation.h"
#import "JHKeyframeAnimationFunctions.h"
#import "JHChainableAnimations.h"

FOUNDATION_EXPORT double JHChainableAnimationsVersionNumber;
FOUNDATION_EXPORT const unsigned char JHChainableAnimationsVersionString[];

