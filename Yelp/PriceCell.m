//
//  PriceCell.m
//  Yelp
//
//  Created by Satyajit Rai on 6/22/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "PriceCell.h"

@interface PriceCell()
@property (weak, nonatomic) IBOutlet UISegmentedControl *priceSegments;
@end

@implementation PriceCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
