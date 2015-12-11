//
//  BIZCollectionViewLayout4plus1Grid.h
//  ExampleBIZCollectionViewLayout4plus1Grid
//
//  Created by IgorBizi@mail.ru on 12/11/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BIZCollectionViewLayout4plus1Grid : UICollectionViewLayout
@property (nonatomic) CGFloat insetBetweenCells;
@property (nonatomic) NSInteger numberOfCellsInOneLineGroup;
@property (nonatomic) NSInteger numberOfCellsInTwoLineGroup;
//For subclasses
- (void)setup;
@end
