//
//  YelpTableViewCell.h
//  Yelp
//
//  Created by Satyajit Rai on 6/20/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YelpTableViewCell : UITableViewCell
- (void)setBusiness: (NSDictionary*) business withRank:(int)rank;
@end
