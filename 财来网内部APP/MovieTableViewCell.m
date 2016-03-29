//
//  MovieTableViewCell.m
//  财来网内部APP
//
//  Created by 陈思远 on 15/10/29.
//  Copyright © 2015年 陈思远. All rights reserved.
//

#import "MovieTableViewCell.h"

@implementation MovieTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovieObj:(MovieObj *)movieObj
{
    _movieObj = movieObj;
    self.imageView.image = [UIImage imageNamed:@"lyjbjt"];
    self.nameString.text = movieObj.nameString;
}


@end
