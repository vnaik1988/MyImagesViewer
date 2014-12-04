
#import "SCImageViewController.h"
#import "SCImageScrollView.h"
#import "SCImagesViewerData.h"
@implementation SCImageViewController

+ (SCImageViewController *)photoViewControllerForPageIndex:(NSUInteger)pageIndex
{
    if (pageIndex < [[SCImagesViewerData sharedInstance] photoCount])
    {
        return [[self alloc] initWithPageIndex:pageIndex];
    }
    return nil;
}

- (id)initWithPageIndex:(NSInteger)pageIndex
{
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil)
    {
        _pageIndex = pageIndex;
    }
    return self;
}

- (void)loadView
{
    // replace our view property with our custom image scroll view
    SCImageScrollView *scrollView = [[SCImageScrollView alloc] init];
    scrollView.index = _pageIndex;
    
    self.view = scrollView;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // set the navigation bar's title to indicate which photo index we are viewing,
    // note that our parent is MyPageViewController
    //
    self.parentViewController.navigationItem.title =
        [NSString stringWithFormat:@"%@ of %@", [@(self.pageIndex+1) stringValue], [@([[SCImagesViewerData sharedInstance] photoCount]) stringValue]];
}




@end
