//
//  FSCalendarStaticHeader.m
//  FSCalendar
//
//  Created by dingwenchao on 9/17/15.
//  Copyright (c) 2015 Wenchao Ding. All rights reserved.
//

#import "FSCalendarStickyHeader.h"
#import "FSCalendar.h"
#import "FSCalendarWeekdayView.h"
#import "FSCalendarExtensions.h"
#import "FSCalendarConstants.h"
#import "FSCalendarDynamicHeader.h"

@interface FSCalendarStickyHeader ()

@property (weak  , nonatomic) UIView  *contentView;
@property (weak  , nonatomic) UIView  *bottomBorder;
@property (weak  , nonatomic) FSCalendarWeekdayView *weekdayView;

@end

@implementation FSCalendarStickyHeader

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIView *view;
        UILabel *monthLabel;
        UILabel *label;

        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor clearColor];
        [self addSubview:view];
        self.contentView = view;

        monthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        monthLabel.textAlignment = NSTextAlignmentLeft;
        monthLabel.numberOfLines = 0;
        [_contentView addSubview:monthLabel];
        self.titleLabel = monthLabel;

        label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentRight;
        label.numberOfLines = 0;
        [_contentView addSubview:label];
        self.yearLabel = label;

        view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = FSCalendarStandardLineColor;
        [_contentView addSubview:view];
        self.bottomBorder = view;

        FSCalendarWeekdayView *weekdayView = [[FSCalendarWeekdayView alloc] init];
        [self.contentView addSubview:weekdayView];
        self.weekdayView = weekdayView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _contentView.frame = self.bounds;

    CGFloat weekdayHeight = _calendar.preferredWeekdayHeight;
    CGFloat weekdayMargin = weekdayHeight * 0.1;
    CGFloat titleWidth = _contentView.fs_width;
    CGFloat offset = 15;

    self.weekdayView.frame = CGRectMake(0, _contentView.fs_height-weekdayHeight-weekdayMargin, self.contentView.fs_width, weekdayHeight);

    _bottomBorder.frame = CGRectMake(offset, _contentView.fs_height-weekdayHeight-weekdayMargin*2, _contentView.fs_width - offset, 1.0);
    _titleLabel.frame = CGRectMake(offset, 0, titleWidth, _contentView.frame.size.height - weekdayHeight);
    _yearLabel.frame = CGRectMake(0, 0, titleWidth - offset, _contentView.frame.size.height - weekdayHeight);
}

#pragma mark - Properties

- (void)setCalendar:(FSCalendar *)calendar
{
    if (![_calendar isEqual:calendar]) {
        _calendar = calendar;
        _weekdayView.calendar = calendar;
        [self configureAppearance];
    }
}

#pragma mark - Private methods

- (void)configureAppearance
{
    _titleLabel.font = self.calendar.appearance.headerTitleFont;
    _titleLabel.textColor = self.calendar.appearance.headerTitleColor;

    _yearLabel.font = self.calendar.appearance.headerYearFont;
    _yearLabel.textColor = self.calendar.appearance.headerYearColor;
    [self.weekdayView configureAppearance];
}

- (void)setMonth:(NSDate *)month
{
    _month = month;
    _calendar.formatter.dateFormat = self.calendar.appearance.headerDateFormat;
    NSDateComponents *components = [[NSCalendar currentCalendar] components: NSCalendarUnitYear | NSCalendarUnitMonth fromDate: month];
    NSArray *monthNames = [_calendar.formatter standaloneMonthSymbols];

    self.titleLabel.text = [[monthNames objectAtIndex:(components.month  - 1)] capitalizedString];
    self.yearLabel.text = [NSString stringWithFormat: @"%ld", (long)[components year]];
}

@end
