import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/product_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  final ProductType productType;
  final ScrollController scrollController;
  ProductView({@required this.productType, this.scrollController});
  @override
  Widget build(BuildContext context) {
    final _productProvider = Provider.of<ProductProvider>(context, listen: false);
    int offset = 1;
    if (productType == ProductType.POPULAR_PRODUCT) {
      Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
        context, '1', Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
      );
    }

    if(!ResponsiveHelper.isDesktop(context)) {
      scrollController?.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent
            && Provider.of<ProductProvider>(context, listen: false).popularProductList != null
            && !Provider.of<ProductProvider>(context, listen: false).isLoading) {
          int pageSize;
          if (productType == ProductType.POPULAR_PRODUCT) {
            pageSize = (Provider.of<ProductProvider>(context, listen: false).popularPageSize / 10).ceil();
          }
          if (offset < pageSize) {
            offset++;
            print('end of the page');
            Provider.of<ProductProvider>(context, listen: false).showBottomLoader();
            Provider.of<ProductProvider>(context, listen: false).getPopularProductList(
              context, offset.toString(), Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
            );
          }
        }
      });

    }
    return Consumer<ProductProvider>(
      builder: (context, prodProvider, child) {
        List<Product> productList;
        if (productType == ProductType.POPULAR_PRODUCT) {
          productList = prodProvider.popularProductList;
        }

        return Column(children: [
          productList != null ? productList.length > 0 ? GridView.builder(
            gridDelegate: ResponsiveHelper.isDesktop(context) ? SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 5, mainAxisSpacing: 5, childAspectRatio: 4,crossAxisCount: ResponsiveHelper.isTab(context) ? 2 : 1),
            itemCount: productList.length,
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return ResponsiveHelper.isDesktop(context) ? Padding(
                padding: const EdgeInsets.all(5.0),
                child: ProductWidgetWeb(product: productList[index]),
              ) : ProductWidget(product: productList[index]);
            },
          ) : NoDataScreen() :
          GridView.builder(
            shrinkWrap: true,
            gridDelegate:ResponsiveHelper.isDesktop(context) ? SliverGridDelegateWithMaxCrossAxisExtent( maxCrossAxisExtent: 195, mainAxisExtent: 250) :
            SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 4,
              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 3 : ResponsiveHelper.isTab(context) ? 2 : 1),
            itemCount: 12,
            itemBuilder: (BuildContext context, int index) {return ResponsiveHelper.isDesktop(context) ? ProductWidgetWebShimmer() : ProductShimmer(isEnabled: productList == null);},
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL
            )

          ),
          SizedBox(height: 30),

          prodProvider.isLoading ? Center(child: Padding(
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)),
          )) :

          (ResponsiveHelper.isDesktop(context) && _productProvider.seeMoreButtonVisible) ? Padding(padding: const EdgeInsets.only(bottom: 70),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 500, height: 40.0,
                child: ElevatedButton(
                  style : ElevatedButton.styleFrom(primary: ColorResources.APPBAR_HEADER_COL0R, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                  onPressed: (){
                    _productProvider.moreProduct(context);
                  }, child: Text(getTranslated('see_more', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE)),
                ),
              ),
            ),
          ) : SizedBox(),
        ]);
      },
    );
  }
}
