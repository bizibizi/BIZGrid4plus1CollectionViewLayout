//
//  BIZGrid4plus1CollectionViewLayout.h
//  ExampleBIZGrid4plus1CollectionViewLayout
//
//  Created by IgorBizi@mail.ru on 12/11/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BIZGrid4plus1CollectionViewLayout : UICollectionViewLayout
@property (nonatomic) CGFloat insetBetweenCells;
@property (nonatomic) NSInteger numberOfCellsInOneLineGroup;
@property (nonatomic) NSInteger numberOfCellsInTwoLineGroup;
//For subclasses
- (void)setup;
@end
