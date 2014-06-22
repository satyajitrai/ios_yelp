//
//  YelpTableViewCell.m
//  Yelp
//
//  Created by Satyajit Rai on 6/20/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "YelpTableViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface YelpTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *poster;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImage;
@property (weak, nonatomic) IBOutlet UILabel *reviewsLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *distLabel;
@property (weak, nonatomic) IBOutlet UILabel *costLabel;
@end

@implementation YelpTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBusiness: (NSDictionary*) business {
    self.titleLabel.text = business[@"name"];
    NSURL * ratingUrl = [NSURL URLWithString: business[@"rating_img_url"]];
    
    [self.ratingImage setImageWithURLRequest:[NSURLRequest requestWithURL:ratingUrl] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.ratingImage.image = image;
    } failure:nil];
    
    self.reviewsLabel.text = [NSString stringWithFormat:@"%@ Reviews", business[@"review_count"]];
    
    NSArray *addresses = business[@"location"][@"address"];
    self.addressLabel.text = (addresses.count > 0) ? addresses[0] : @"";
    NSURL *posterUrl = [NSURL URLWithString:business[@"image_url"]];
    [self.poster setImageWithURLRequest:[NSURLRequest requestWithURL:posterUrl] placeholderImage:[UIImage imageNamed:@"placeholder"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.poster.image = image;
    } failure:nil];
    
    NSMutableArray *categories = [[NSMutableArray alloc]init];
    for (NSArray *objs in business[@"categories"]) {
        [categories addObject:objs[0]];
    }
    NSString *categoryText = [categories componentsJoinedByString:@", "];
    self.tagLabel.text = categoryText;
    
    self.distLabel.text = @"0.0 mi";
    self.costLabel.text = @"$$";
}

@end
