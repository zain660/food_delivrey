import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/cart_model.dart';
import 'package:flutter_restaurant/data/model/response/product_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/provider/wishlist_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:flutter_restaurant/view/base/rating_bar.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/CartBottomSheetWeb.dart';
import 'package:provider/provider.dart';

import '../../../../base/custom_snackbar.dart';

class ProductWidgetWeb extends StatelessWidget {
  final Product product;

  ProductWidgetWeb({@required this.product});

  @override
  Widget build(BuildContext context) {
    double _startingPrice;
    double _endingPrice;
    if(product.choiceOptions.length != 0) {
      List<double> _priceList = [];
      product.variations.forEach((variation) => _priceList.add(variation.price));
      _priceList.sort((a, b) => a.compareTo(b));
      _startingPrice = _priceList[0];
      if(_priceList[0] < _priceList[_priceList.length-1]) {
        _endingPrice = _priceList[_priceList.length-1];
      }
    }else {
      _startingPrice = product.price;
    }

    double _discountedPrice = PriceConverter.convertWithDiscount(context, product.price, product.discount, product.discountType);

    bool _isAvailable = product.availableTimeStarts !=null && product.availableTimeEnds !=null? DateConverter.isAvailable(product.availableTimeStarts, product.availableTimeEnds, context) : false;
    return OnHover(
      builder: (isHover) {
        return InkWell(
          onTap: () {
            showDialog(context: context, builder: (con) => Dialog(
              child: CartBottomSheetWeb(
                product: product, fromSetMenu: true,
                callback: (CartModel cartModel) {
                  showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                  },
              ),
            ));
            },
          child: Stack(
            children: [
              Container(
                // height: 220,
                // width: 170,
                decoration: BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme ? 700 : 300], blurRadius: 5, spreadRadius: 1)]),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                            child: FadeInImage.assetNetwork(
                              placeholder: Images.placeholder_rectangle, fit: BoxFit.cover, height: 105, width: 195,
                              image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${product.image}',
                              imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle,  fit: BoxFit.cover,  height: 105, width: 195),
                            ),
                          ),
                          _isAvailable ? SizedBox() : Positioned(
                            top: 0, left: 0, bottom: 0, right: 0,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(10)), color: Colors.black.withOpacity(0.6)),
                              child: Text(getTranslated('not_available_now', context), textAlign: TextAlign.center,
                                  style: rubikRegular.copyWith(color: Colors.white, fontSize: Dimensions.FONT_SIZE_SMALL)
                              ),
                            ),
                          ),
                        ],
                      ),

                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(product.name, style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getCartTitleColor(context)), maxLines: 2, overflow: TextOverflow.ellipsis,textAlign: TextAlign.center),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            RatingBar(rating: product.rating.length > 0 ? double.parse(product.rating[0].average) : 0.0, size: Dimensions.PADDING_SIZE_DEFAULT),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _discountedPrice > 0 ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                    child: Text('${PriceConverter.convertPrice(context, _startingPrice, asFixed: 1)}''${_endingPrice!= null ? ' - ${PriceConverter.convertPrice(context, _endingPrice, asFixed: 1)}' : ''}',
                                      style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, decoration: TextDecoration.lineThrough))) : SizedBox(),
                                  Text('${PriceConverter.convertPrice(context, _startingPrice, discount: product.discount, discountType: product.discountType, asFixed: 1)}''${_endingPrice!= null
                                      ? ' - ${PriceConverter.convertPrice(context, _endingPrice, discount: product.discount, discountType: product.discountType, asFixed: 1)}' : ''}',
                                    style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.APPBAR_HEADER_COL0R))
                                ],
                              ),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: 100,
                                child: FittedBox(
                                  child: ElevatedButton(
                                      style : ElevatedButton.styleFrom(primary: ColorResources.APPBAR_HEADER_COL0R, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                                      onPressed: (){
                                        showDialog(context: context, builder: (con) => Dialog(
                                          child: CartBottomSheetWeb(
                                            product: product, fromSetMenu: true,
                                            callback: (CartModel cartModel) {
                                              showCustomSnackBar(getTranslated('added_to_cart', context), context, isError: false);
                                            },
                                          ),
                                        ));
                                      },
                                      child: Text(getTranslated('quick_view', context),style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL))
                                  )),
                                ),
                              ),
                          ]),
                        ),
                      ),

                    ]),
              ),
              Positioned.fill(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Consumer<WishListProvider>(builder: (context, wishList, child) {
                        return InkWell(
                          onTap: () {
                            wishList.wishIdList.contains(product.id) ? wishList.removeFromWishList(product, (message) {})
                                : wishList.addToWishList(product, (message) {});
                            },
                          child: Icon(
                            wishList.wishIdList.contains(product.id) ? Icons.favorite : Icons.favorite_border,
                            color: wishList.wishIdList.contains(product.id) ? Theme.of(context).primaryColor : ColorResources.COLOR_WHITE),
                        );
                      }),
                    ),
                  )
              )
            ],
          ),
        );
      }
    );
  }
}



