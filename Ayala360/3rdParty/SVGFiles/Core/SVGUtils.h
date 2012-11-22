//
//  SVGUtils.h
//  SVGKit
//
//  Copyright Matt Rajca 2010-2011. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>

#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>

#endif

#define RGB_N(v) (v) / 255.0f

typedef struct {
	uint8_t r;
	uint8_t g;
	uint8_t b;
	uint8_t a;
} SVGColor;

SVGColor SVGColorMake (uint8_t r, uint8_t g, uint8_t b, uint8_t a);
SVGColor SVGColorFromString (const char *string);
#if TARGET_OS_IPHONE
SVGColor SVGColorWithUIColor(UIColor *uiColor);
#endif

NSString *SVGStringFromSVGColor(SVGColor color);
NSString *SVGStringFromCGColor(CGColorRef color);

CGFloat SVGPercentageFromString (const char *string);

CGMutablePathRef CreateSVGPathFromPointsInString (const char *string, boolean_t close);
CGColorRef CGColorWithSVGColor (SVGColor color);
