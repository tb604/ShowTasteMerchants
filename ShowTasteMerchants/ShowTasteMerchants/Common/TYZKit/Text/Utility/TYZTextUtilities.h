//
//  TYZTextUtilities.h
//  51tourGuide
//
//  Created by 唐斌 on 16/3/18.
//  Copyright © 2016年 唐斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreText/CoreText.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  Whether the character is 'line break char':(字符是不是)
 U+000D (\\r or CR)
 U+2028 (Unicode line separator)
 U+000A (\\n or LF)
 U+2029 (Unicode paragraph separator)
 *
 *  @param c A character
 *
 *  @return YES or NO.
 */
static inline BOOL TYZTextIsLinebreakChar(unichar c)
{
    switch (c)
    {
        case 0x000D:
        case 0x2028:
        case 0x000A:
        case 0x2029:
            return YES;
        default:
            return NO;
    }
}

/**
 Whether the string is a 'line break':
 U+000D (\\r or CR)
 U+2028 (Unicode line separator)
 U+000A (\\n or LF)
 U+2029 (Unicode paragraph separator)
 \\r\\n, in that order (also known as CRLF)
 
 @param str A string
 @return YES or NO.
 */
static inline BOOL TYZTextIsLinebreakString(NSString * _Nullable str)
{
    if (str.length > 2 || str.length == 0)
    {
        return NO;
    }
    if (str.length == 1)
    {
        unichar c = [str characterAtIndex:0];
        return TYZTextIsLinebreakChar(c);
    }
    else
    {
        return ([str characterAtIndex:0] == '\r') && ([str characterAtIndex:1] == '\n');
    }
}

/**
 *  '\r'是回车，'\n'是换行，前者使光标到行首，后者使光标下移一格，通常敲一个回车键，即是回车，又是换行（\r\n）。Unix中每行结尾只有“<换行>”，即“\n”；Windows中每行结尾是“<换行><回车>”，即“\n\r”；Mac中每行结尾是“<回车>”。
 *
 *  @param str <#str description#>
 *
 *  @return <#return value description#>
 */
static inline NSUInteger TYZTextLinebreakTailLength(NSString * _Nullable str)
{
    if (str.length >= 2)
    {
        unichar c2 = [str characterAtIndex:str.length - 1];
        if (TYZTextIsLinebreakChar(c2))
        {
            unichar c1 = [str characterAtIndex:str.length - 2];
            if (c1 == '\r' && c2 == '\n')
            {
                return 2;
            }
            else
            {
                return 1;
            }
        }
        else
        {
            return 0;
        }
    }
    else if (str.length == 1)
    {
        return TYZTextIsLinebreakChar([str characterAtIndex:0]) ? 1 : 0;
    }
    else
    {
        return 0;
    }
}

/**
 Convert `UIDataDetectorTypes` to `NSTextCheckingType`.
 
 @param types  The `UIDataDetectorTypes` type.
 @return The `NSTextCheckingType` type.
 */
static inline NSTextCheckingType TYZTextNSTextCheckingTypeFromUIDataDetectorType(UIDataDetectorTypes types)
{
    NSTextCheckingType t = 0;
    if (types & UIDataDetectorTypePhoneNumber) t |= NSTextCheckingTypePhoneNumber;
    if (types & UIDataDetectorTypeLink) t |= NSTextCheckingTypeLink;
    if (types & UIDataDetectorTypeAddress) t |= NSTextCheckingTypeAddress;
    if (types & UIDataDetectorTypeCalendarEvent) t |= NSTextCheckingTypeDate;
    return t;
}

/**
 Whether the font is `AppleColorEmoji` font.
 
 @param font  A font.
 @return YES: the font is Emoji, NO: the font is not Emoji.
 */
static inline BOOL TYZTextUIFontIsEmoji(UIFont *font)
{
    return [font.fontName isEqualToString:@"AppleColorEmoji"];
}

/**
 Whether the font is `AppleColorEmoji` font.
 
 @param font  A font.
 @return YES: the font is Emoji, NO: the font is not Emoji.
 */
static inline BOOL TYZTextCTFontIsEmoji(CTFontRef font)
{
    BOOL isEmoji = NO;
    CFStringRef name = CTFontCopyPostScriptName(font);
    if (name && CFEqual(CFSTR("AppleColorEmoji"), name)) isEmoji = YES;
    if (name) CFRelease(name);
    return isEmoji;
}

/**
 Whether the font is `AppleColorEmoji` font.
 
 @param font  A font.
 @return YES: the font is Emoji, NO: the font is not Emoji.
 */
static inline BOOL TYZTextCGFontIsEmoji(CGFontRef font)
{
    BOOL isEmoji = NO;
    CFStringRef name = CGFontCopyPostScriptName(font);
    if (name && CFEqual(CFSTR("AppleColorEmoji"), name)) isEmoji = YES;
    if (name) CFRelease(name);
    return isEmoji;
}

/**
 Whether the font contains color bitmap glyphs.
 
 @discussion Only `AppleColorEmoji` contains color bitmap glyphs in iOS system fonts.
 @param font  A font.
 @return YES: the font contains color bitmap glyphs, NO: the font has no color bitmap glyph.
 */
static inline BOOL TYZTextCTFontContainsColorBitmapGlyphs(CTFontRef font)
{
    return  (CTFontGetSymbolicTraits(font) & kCTFontTraitColorGlyphs) != 0;
}

/**
 Whether the glyph is bitmap.
 
 @param font  The glyph's font.
 @param glyph The glyph which is created from the specified font.
 @return YES: the glyph is bitmap, NO: the glyph is vector.
 */
static inline BOOL TYZTextCGGlyphIsBitmap(CTFontRef font, CGGlyph glyph)
{
    if (!font && !glyph) return NO;
    if (!TYZTextCTFontContainsColorBitmapGlyphs(font)) return NO;
    CGPathRef path = CTFontCreatePathForGlyph(font, glyph, NULL);
    if (path)
    {
        CFRelease(path);
        return NO;
    }
    return YES;
}

/**
 Get the `AppleColorEmoji` font's ascent with a specified font size.
 It may used to create custom emoji.
 
 @param fontSize  The specified font size.
 @return The font ascent.
 */
static inline CGFloat TYZTextEmojiGetAscentWithFontSize(CGFloat fontSize)
{
    if (fontSize < 16)
    {
        return 1.25 * fontSize;
    }
    else if (16 <= fontSize && fontSize <= 24)
    {
        return 0.5 * fontSize + 12;
    }
    else
    {
        return fontSize;
    }
}

/**
 Get the `AppleColorEmoji` font's descent with a specified font size.
 It may used to create custom emoji.
 
 @param fontSize  The specified font size.
 @return The font descent.
 */
static inline CGFloat TYZTextEmojiGetDescentWithFontSize(CGFloat fontSize)
{
    if (fontSize < 16)
    {
        return 0.390625 * fontSize;
    }
    else if (16 <= fontSize && fontSize <= 24)
    {
        return 0.15625 * fontSize + 3.75;
    }
    else
    {
        return 0.3125 * fontSize;
    }
    return 0;
}

/**
 Get the `AppleColorEmoji` font's glyph bounding rect with a specified font size.
 It may used to create custom emoji.
 
 @param fontSize  The specified font size.
 @return The font glyph bounding rect.
 */
static inline CGRect TYZTextEmojiGetGlyphBoundingRectWithFontSize(CGFloat fontSize)
{
    CGRect rect;
    rect.origin.x = 0.75;
    rect.size.width = rect.size.height = TYZTextEmojiGetAscentWithFontSize(fontSize);
    if (fontSize < 16)
    {
        rect.origin.y = -0.2525 * fontSize;
    } else if (16 <= fontSize && fontSize <= 24)
    {
        rect.origin.y = 0.1225 * fontSize -6;
    } else {
        rect.origin.y = -0.1275 * fontSize;
    }
    return rect;
}


/**
 Get the character set which should rotate in vertical form.
 @return The shared character set.
 */
NSCharacterSet *TYZTextVerticalFormRotateCharacterSet();

/**
 Get the character set which should rotate and move in vertical form.
 @return The shared character set.
 */
NSCharacterSet *TYZTextVerticalFormRotateAndMoveCharacterSet();



/// Convert degrees to radians.(度转换为弧度。)
static inline CGFloat TYZTextDegreesToRadians(CGFloat degrees)
{
    return degrees * M_PI / 180;
}

/// Convert radians to degrees.
static inline CGFloat TYZTextRadiansToDegrees(CGFloat radians)
{
    return radians * 180 / M_PI;
}



/// Get the transform rotation.
/// @return the rotation in radians [-PI,PI] ([-180°,180°])
static inline CGFloat TYZTextCGAffineTransformGetRotation(CGAffineTransform transform)
{
    return atan2(transform.b, transform.a);
}

/// Get the transform's scale.x
static inline CGFloat TYZTextCGAffineTransformGetScaleX(CGAffineTransform transform)
{
    return  sqrt(transform.a * transform.a + transform.c * transform.c);
}

/// Get the transform's scale.y
static inline CGFloat TYZTextCGAffineTransformGetScaleY(CGAffineTransform transform)
{
    return sqrt(transform.b * transform.b + transform.d * transform.d);
}

/// Get the transform's translate.x
static inline CGFloat TYZTextCGAffineTransformGetTranslateX(CGAffineTransform transform)
{
    return transform.tx;
}

/// Get the transform's translate.y
static inline CGFloat TYZTextCGAffineTransformGetTranslateY(CGAffineTransform transform)
{
    return transform.ty;
}

/**
 If you have 3 pair of points transformed by a same CGAffineTransform:
 p1 (transform->) q1
 p2 (transform->) q2
 p3 (transform->) q3
 This method returns the original transform matrix from these 3 pair of points.
 
 @see http://stackoverflow.com/questions/13291796/calculate-values-for-a-cgaffinetransform-from-three-points-in-each-of-two-uiview
 */
CGAffineTransform TYZTextCGAffineTransformGetFromPoints(CGPoint before[3], CGPoint after[3]);

/// Get the transform which can converts a point from the coordinate system of a given view to another.
CGAffineTransform TYZTextCGAffineTransformGetFromViews(UIView *from, UIView *to);

/// Create a skew transform.
static inline CGAffineTransform TYZTextCGAffineTransformMakeSkew(CGFloat x, CGFloat y)
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform.c = -x;
    transform.b = y;
    return transform;
}

/// Negates/inverts a UIEdgeInsets.
static inline UIEdgeInsets TYZTextUIEdgeInsetsInvert(UIEdgeInsets insets)
{
    return UIEdgeInsetsMake(-insets.top, -insets.left, -insets.bottom, -insets.right);
}

/// Convert CALayer's gravity string to UIViewContentMode.
UIViewContentMode TYZTextCAGravityToUIViewContentMode(NSString *gravity);

/// Convert UIViewContentMode to CALayer's gravity string.
NSString *TYZTextUIViewContentModeToCAGravity(UIViewContentMode contentMode);



/**
 Returns a rectangle to fit the @param rect with specified content mode.
 
 @param rect The constrant rect
 @param size The content size
 @param mode The content mode
 @return A rectangle for the given content mode.
 @discussion UIViewContentModeRedraw is same as UIViewContentModeScaleToFill.
 */
CGRect TYZTextCGRectFitWithContentMode(CGRect rect, CGSize size, UIViewContentMode mode);

/// Returns the center for the rectangle.
static inline CGPoint TYZTextCGRectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

/// Returns the area of the rectangle.
static inline CGFloat TYZTextCGRectGetArea(CGRect rect)
{
    if (CGRectIsNull(rect)) return 0;
    rect = CGRectStandardize(rect);
    return rect.size.width * rect.size.height;
}

/// Returns the distance between two points.
static inline CGFloat TYZTextCGPointGetDistanceToPoint(CGPoint p1, CGPoint p2)
{
    return sqrt((p1.x - p2.x) * (p1.x - p2.x) + (p1.y - p2.y) * (p1.y - p2.y));
}

/// Returns the minmium distance between a point to a rectangle.
static inline CGFloat TYZTextCGPointGetDistanceToRect(CGPoint p, CGRect r)
{
    r = CGRectStandardize(r);
    if (CGRectContainsPoint(r, p)) return 0;
    CGFloat distV, distH;
    if (CGRectGetMinY(r) <= p.y && p.y <= CGRectGetMaxY(r))
    {
        distV = 0;
    }
    else
    {
        distV = p.y < CGRectGetMinY(r) ? CGRectGetMinY(r) - p.y : p.y - CGRectGetMaxY(r);
    }
    if (CGRectGetMinX(r) <= p.x && p.x <= CGRectGetMaxX(r))
    {
        distH = 0;
    }
    else
    {
        distH = p.x < CGRectGetMinX(r) ? CGRectGetMinX(r) - p.x : p.x - CGRectGetMaxX(r);
    }
    return MAX(distV, distH);
}


/// Get main screen's scale.
CGFloat TYZTextScreenScale();

/// Get main screen's size. Height is always larger than width.
CGSize TYZTextScreenSize();

/// Convert point to pixel.
static inline CGFloat TYZTextCGFloatToPixel(CGFloat value)
{
    return value * TYZTextScreenScale();
}

/// Convert pixel to point.
static inline CGFloat TYZTextCGFloatFromPixel(CGFloat value)
{
    return value / TYZTextScreenScale();
}

/// floor point value for pixel-aligned
static inline CGFloat TYZTextCGFloatPixelFloor(CGFloat value)
{
    CGFloat scale = TYZTextScreenScale();
    return floor(value * scale) / scale;
}

/// round point value for pixel-aligned
static inline CGFloat TYZTextCGFloatPixelRound(CGFloat value)
{
    CGFloat scale = TYZTextScreenScale();
    return round(value * scale) / scale;
}

/// ceil point value for pixel-aligned
static inline CGFloat TYZTextCGFloatPixelCeil(CGFloat value)
{
    CGFloat scale = TYZTextScreenScale();
    return ceil(value * scale) / scale;
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGFloat TYZTextCGFloatPixelHalf(CGFloat value)
{
    CGFloat scale = TYZTextScreenScale();
    return (floor(value * scale) + 0.5) / scale;
}

/// floor point value for pixel-aligned
static inline CGPoint TYZTextCGPointPixelFloor(CGPoint point)
{
    CGFloat scale = TYZTextScreenScale();
    return CGPointMake(floor(point.x * scale) / scale,
                       floor(point.y * scale) / scale);
}

/// round point value for pixel-aligned
static inline CGPoint TYZTextCGPointPixelRound(CGPoint point)
{
    CGFloat scale = TYZTextScreenScale();
    return CGPointMake(round(point.x * scale) / scale,
                       round(point.y * scale) / scale);
}

/// ceil point value for pixel-aligned
static inline CGPoint TYZTextCGPointPixelCeil(CGPoint point)
{
    CGFloat scale = TYZTextScreenScale();
    return CGPointMake(ceil(point.x * scale) / scale,
                       ceil(point.y * scale) / scale);
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGPoint TYZTextCGPointPixelHalf(CGPoint point)
{
    CGFloat scale = TYZTextScreenScale();
    return CGPointMake((floor(point.x * scale) + 0.5) / scale,
                       (floor(point.y * scale) + 0.5) / scale);
}



/// floor point value for pixel-aligned
static inline CGSize TYZTextCGSizePixelFloor(CGSize size)
{
    CGFloat scale = TYZTextScreenScale();
    return CGSizeMake(floor(size.width * scale) / scale,
                      floor(size.height * scale) / scale);
}

/// round point value for pixel-aligned
static inline CGSize TYZTextCGSizePixelRound(CGSize size)
{
    CGFloat scale = TYZTextScreenScale();
    return CGSizeMake(round(size.width * scale) / scale,
                      round(size.height * scale) / scale);
}

/// ceil point value for pixel-aligned
static inline CGSize TYZTextCGSizePixelCeil(CGSize size)
{
    CGFloat scale = TYZTextScreenScale();
    return CGSizeMake(ceil(size.width * scale) / scale,
                      ceil(size.height * scale) / scale);
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGSize TYZTextCGSizePixelHalf(CGSize size)
{
    CGFloat scale = TYZTextScreenScale();
    return CGSizeMake((floor(size.width * scale) + 0.5) / scale,
                      (floor(size.height * scale) + 0.5) / scale);
}



/// floor point value for pixel-aligned
static inline CGRect TYZTextCGRectPixelFloor(CGRect rect)
{
    CGPoint origin = TYZTextCGPointPixelCeil(rect.origin);
    CGPoint corner = TYZTextCGPointPixelFloor(CGPointMake(rect.origin.x + rect.size.width,
                                                         rect.origin.y + rect.size.height));
    CGRect ret = CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
    if (ret.size.width < 0) ret.size.width = 0;
    if (ret.size.height < 0) ret.size.height = 0;
    return ret;
}

/// round point value for pixel-aligned
static inline CGRect TYZTextCGRectPixelRound(CGRect rect)
{
    CGPoint origin = TYZTextCGPointPixelRound(rect.origin);
    CGPoint corner = TYZTextCGPointPixelRound(CGPointMake(rect.origin.x + rect.size.width,
                                                         rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

/// ceil point value for pixel-aligned
static inline CGRect TYZTextCGRectPixelCeil(CGRect rect)
{
    CGPoint origin = TYZTextCGPointPixelFloor(rect.origin);
    CGPoint corner = TYZTextCGPointPixelCeil(CGPointMake(rect.origin.x + rect.size.width,
                                                        rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

/// round point value to .5 pixel for path stroke (odd pixel line width pixel-aligned)
static inline CGRect TYZTextCGRectPixelHalf(CGRect rect)
{
    CGPoint origin = TYZTextCGPointPixelHalf(rect.origin);
    CGPoint corner = TYZTextCGPointPixelHalf(CGPointMake(rect.origin.x + rect.size.width,
                                                        rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}



/// floor UIEdgeInset for pixel-aligned
static inline UIEdgeInsets TYZTextUIEdgeInsetPixelFloor(UIEdgeInsets insets)
{
    insets.top = TYZTextCGFloatPixelFloor(insets.top);
    insets.left = TYZTextCGFloatPixelFloor(insets.left);
    insets.bottom = TYZTextCGFloatPixelFloor(insets.bottom);
    insets.right = TYZTextCGFloatPixelFloor(insets.right);
    return insets;
}

/// ceil UIEdgeInset for pixel-aligned
static inline UIEdgeInsets TYZTextUIEdgeInsetPixelCeil(UIEdgeInsets insets)
{
    insets.top = TYZTextCGFloatPixelCeil(insets.top);
    insets.left = TYZTextCGFloatPixelCeil(insets.left);
    insets.bottom = TYZTextCGFloatPixelCeil(insets.bottom);
    insets.right = TYZTextCGFloatPixelCeil(insets.right);
    return insets;
}



static inline UIFont * _Nullable TYZTextFontWithBold(UIFont *font)
{
    if (![font respondsToSelector:@selector(fontDescriptor)]) return font;
    return [UIFont fontWithDescriptor:[font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold] size:font.pointSize];
}

static inline UIFont * _Nullable TYZTextFontWithItalic(UIFont *font)
{
    if (![font respondsToSelector:@selector(fontDescriptor)]) return font;
    return [UIFont fontWithDescriptor:[font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitItalic] size:font.pointSize];
}

static inline UIFont * _Nullable TYZTextFontWithBoldItalic(UIFont *font)
{
    if (![font respondsToSelector:@selector(fontDescriptor)]) return font;
    return [UIFont fontWithDescriptor:[font.fontDescriptor fontDescriptorWithSymbolicTraits:UIFontDescriptorTraitBold | UIFontDescriptorTraitItalic] size:font.pointSize];
}



/**
 Convert CFRange to NSRange
 @param range CFRange @return NSRange
 */
static inline NSRange TYZTextNSRangeFromCFRange(CFRange range)
{
    return NSMakeRange(range.location, range.length);
}

/**
 Convert NSRange to CFRange
 @param range NSRange @return CFRange
 */
static inline CFRange TYZTextCFRangeFromNSRange(NSRange range)
{
    return CFRangeMake(range.location, range.length);
}


/// Returns YES in App Extension.
BOOL TYZTextIsAppExtension();

/// Returns nil in App Extension.
UIApplication * _Nullable TYZTextSharedApplication();

NS_ASSUME_NONNULL_END
































