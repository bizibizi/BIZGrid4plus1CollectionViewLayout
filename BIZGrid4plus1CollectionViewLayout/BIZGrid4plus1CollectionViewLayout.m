//
//  BIZGrid4plus1CollectionViewLayout.m
//  ExampleBIZGrid4plus1CollectionViewLayout
//
//  Created by IgorBizi@mail.ru on 12/11/15.
//  Copyright © 2015 IgorBizi@mail.ru. All rights reserved.
//

#import "BIZGrid4plus1CollectionViewLayout.h"


/* Groups
 
 Small row: kImageGroupTypeSmallTop, kImageGroupTypeSmallMiddle,
 
 **     **     **     **
 (0,0)  (0,1)  (0,2)  (0,3)
 
 
 Big row: kImageGroupTypeBigRight, kImageGroupTypeBigLeft
 
 **    **     |  **   |
 (0,0) (0,1)  |  **   |
 **    **     | (0,2) |
 (1,0) (1,1)
 
 */


static NSString *cellElementKind = @"cellElementKind";


typedef enum {
    kImageGroupTypeNone,
    kImageGroupTypeSmallTop,
    kImageGroupTypeBigRight,
    kImageGroupTypeSmallMiddle,
    kImageGroupTypeBigLeft
} kImageGroupType;


@interface BIZGrid4plus1CollectionViewLayout ()
// { (NSString)elementKind : NSDictionary* }
// * { NSIndexPath : UICollectionViewLayoutAttribute }
@property (nonatomic, strong) NSDictionary *layoutDataSource;
@end


@implementation BIZGrid4plus1CollectionViewLayout


#pragma mark - LifeCycle


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.insetBetweenCells = 4;
    self.numberOfCellsInOneLineGroup = 4;
    self.numberOfCellsInTwoLineGroup = 5;
}


#pragma mark - Override


- (CGSize)collectionViewContentSize
{
    // look for cell that frame has max Y and use it as collectionView height
    __block CGFloat maxCellY = 0;
    [self.layoutDataSource[cellElementKind] enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL * _Nonnull stop) {
        
        CGFloat maxY = CGRectGetMaxY(attributes.frame);
        if (maxY > maxCellY) {
            maxCellY = maxY;
        }
    }];
    
    CGFloat h = maxCellY + self.collectionView.contentInset.top + self.collectionView.contentInset.bottom;
    return CGSizeMake(self.collectionView.bounds.size.width, h);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    // reload cell's frame if bounds changed
    return !CGSizeEqualToSize(newBounds.size, self.collectionView.bounds.size);
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    NSMutableDictionary *layoutDataSource = [NSMutableDictionary dictionary];
    NSMutableDictionary *layoutDataSourceCells = [NSMutableDictionary dictionary];
    
    // Start values
    kImageGroupType imageGroupType = kImageGroupTypeSmallTop;
    CGFloat currentImageGroupY = 0;
    CGFloat currentIndexOfItemInSmallGroup = 0;
    CGFloat currentIndexOfItemInBigGroup = 0;
    CGRect frame = CGRectZero;
    
    // Calculate size of cells
    // No inset at the left, right, top, bottom of collectionView. Insets only between cells
    CGFloat smallCellSize = (self.collectionView.bounds.size.width - self.insetBetweenCells * (self.numberOfCellsInOneLineGroup - 1)) / self.numberOfCellsInOneLineGroup;
    CGFloat bigCellSize = smallCellSize * 2 + self.insetBetweenCells;
    
    CGFloat smallImageGroupHeight = smallCellSize + self.insetBetweenCells;
    CGFloat bigImageGroupHeight = bigCellSize + self.insetBetweenCells;
    
    // Iterate throught cells
    for (NSInteger i = 0; i < self.collectionView.numberOfSections; i++)
    {
        for (NSUInteger j = 0; j < [self.collectionView numberOfItemsInSection:i]; j++)
        {
            // Find current group
            // Repeat 4 groups
            switch (imageGroupType)
            {
                    // 1 line of small cells in small group
                case kImageGroupTypeSmallMiddle:
                case kImageGroupTypeSmallTop:
                {
                    NSInteger insetY = 0;
                    NSInteger insetX = currentIndexOfItemInSmallGroup;
                    frame = [self frameForCellWithSize:smallCellSize smallImageGroupSize:smallImageGroupHeight insetX:insetX groupY:currentImageGroupY insetY:insetY];
                    
                    //last item checking
                    if (insetX == self.numberOfCellsInOneLineGroup - 1) {
                        // go to the next group
                        currentImageGroupY += smallImageGroupHeight;
                        imageGroupType = [self nextImageGroupType:imageGroupType];
                        currentIndexOfItemInSmallGroup = 0;
                    } else {
                        // increase index and go to the next item
                        currentIndexOfItemInSmallGroup++;
                    }
                }
                    break;
                    
                    
                    // 2 lines of small cells in big group
                case kImageGroupTypeBigLeft:
                {
                    NSInteger currentItem = currentIndexOfItemInBigGroup;
                    NSInteger insetY = 0;
                    NSInteger insetX = 0;
                    CGFloat cellSize = 0;
                    
                    switch (currentItem) {
                            //big item
                        case 0:
                            insetY = 0;
                            insetX = 0;
                            cellSize = bigCellSize;
                            break;
                            
                            //top left small item
                        case 1:
                            insetY = 0;
                            insetX = 2;
                            cellSize = smallCellSize;
                            break;
                            
                            //top right small item
                        case 2:
                            insetY = 0;
                            insetX = 3;
                            cellSize = smallCellSize;
                            break;
                            
                            //bottom left small item
                        case 3:
                            insetY = 1;
                            insetX = 2;
                            cellSize = smallCellSize;
                            break;
                            
                            //bottom right small item
                        case 4:
                            insetY = 1;
                            insetX = 3;
                            cellSize = smallCellSize;
                            
                            break;
                            
                        default:
                            NSLog(@"ERROR prepareLayout: unexpected item");
                            break;
                    }
                    
                    frame = [self frameForCellWithSize:cellSize smallImageGroupSize:smallImageGroupHeight insetX:insetX groupY:currentImageGroupY insetY:insetY];
                    
                    //last item checking
                    if (currentItem == self.numberOfCellsInTwoLineGroup - 1) {
                        // go to the next group
                        currentImageGroupY += bigImageGroupHeight;
                        imageGroupType = [self nextImageGroupType:imageGroupType];
                        currentIndexOfItemInBigGroup = 0;
                    } else {
                        // increase index and go to the next item
                        currentIndexOfItemInBigGroup++;
                    }
                }
                    break;
                    
                case kImageGroupTypeBigRight:
                {
                    NSInteger currentItem = currentIndexOfItemInBigGroup;
                    NSInteger insetY = 0;
                    NSInteger insetX = 0;
                    CGFloat cellSize = 0;
                    
                    switch (currentItem) {
                            
                            //top left small item
                        case 0:
                            insetY = 0;
                            insetX = 0;
                            cellSize = smallCellSize;
                            break;
                            
                            //top right small item
                        case 1:
                            insetY = 0;
                            insetX = 1;
                            cellSize = smallCellSize;
                            break;
                            
                            //big item
                        case 2:
                            insetY = 0;
                            insetX = 2;
                            cellSize = bigCellSize;
                            break;
                            
                            //bottom left small item
                        case 3:
                            insetY = 1;
                            insetX = 0;
                            cellSize = smallCellSize;
                            break;
                            
                            //bottom right small item
                        case 4:
                            insetY = 1;
                            insetX = 1;
                            cellSize = smallCellSize;
                            
                            break;
                            
                        default:
                            NSLog(@"ERROR prepareLayout: unexpected item");
                            break;
                    }
                    
                    frame = [self frameForCellWithSize:cellSize smallImageGroupSize:smallImageGroupHeight insetX:insetX groupY:currentImageGroupY insetY:insetY];
                    
                    //last item checking
                    if (currentItem == self.numberOfCellsInTwoLineGroup - 1) {
                        // go to the next group
                        currentImageGroupY += bigImageGroupHeight;
                        imageGroupType = [self nextImageGroupType:imageGroupType];
                        currentIndexOfItemInBigGroup = 0;
                    } else {
                        // increase index and go to the next item
                        currentIndexOfItemInBigGroup++;
                    }
                }
                    break;
                    
                default:
                    NSLog(@"ERROR prepareLayout: unexpected imageGroupType");
                    break;
                    
            }
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            UICollectionViewLayoutAttributes *cellAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            cellAttributes.frame = frame;
            layoutDataSourceCells[indexPath] = cellAttributes;
        }
    }
    
    layoutDataSource[cellElementKind] = [layoutDataSourceCells copy];
    self.layoutDataSource = [layoutDataSource copy];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];
    
    [self.layoutDataSource enumerateKeysAndObjectsUsingBlock:^(NSString *elementKind, NSDictionary *elementKindDataSource, BOOL * _Nonnull stop) {
        
        [elementKindDataSource enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *itemAttributes, BOOL * _Nonnull stop) {
            
            if (CGRectIntersectsRect(rect, itemAttributes.frame)) {
                [attributes addObject:itemAttributes];
            }
        }];
    }];
    
    return [attributes copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutDataSource[cellElementKind][indexPath];
}


#pragma mark - Calculations


- (CGRect)frameForCellAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = CGRectZero;
    
    return frame;
}

- (CGRect)frameForCellWithSize:(CGFloat)cellSize
           smallImageGroupSize:(CGFloat)smallImageGroupSize
                        insetX:(NSInteger)insetX
                        groupY:(CGFloat)groupY
                        insetY:(NSInteger)insetY
{
    return CGRectMake(insetX * smallImageGroupSize,
                      groupY + insetY * smallImageGroupSize,
                      cellSize,
                      cellSize);
}

- (kImageGroupType)nextImageGroupType:(kImageGroupType)type
{
    switch (type)
    {
        case kImageGroupTypeNone:
        {
            return kImageGroupTypeSmallTop;
        } break;
            
        case kImageGroupTypeSmallTop:
        {
            return kImageGroupTypeBigRight;
        } break;
            
        case kImageGroupTypeBigRight:
        {
            return kImageGroupTypeSmallMiddle;
        } break;
            
        case kImageGroupTypeSmallMiddle:
        {
            return kImageGroupTypeBigLeft;
        } break;
            
        case kImageGroupTypeBigLeft:
        {
            return kImageGroupTypeSmallTop;
        } break;
            
        default:
        {
            NSLog(@"ERROR nextGroupTypeForGroupType: unexpected type");
            return kImageGroupTypeNone;
        } break;
    }
}

@end
