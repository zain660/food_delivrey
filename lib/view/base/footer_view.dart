import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/footer_one.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/footer_three.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/footer_two.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterView extends StatelessWidget {
  const FooterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorResources.getFooterColor(context),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_LARGE),
          child: IntrinsicHeight(
            child: Column(
              children: [
                Expanded(
                  child: SizedBox(
                    width: 1170,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                            flex: 3,
                            child: FooterOne(),
                        ),
                        Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.status || Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.status?
                        Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(getTranslated('download_our_app', context), style: robotoRegular.copyWith(fontWeight: FontWeight.w700, color: ColorResources.getGreyBunkerColor(context), fontSize: Dimensions.FONT_SIZE_LARGE)),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_LARGE),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.status?
                                      OnHover(
                                          builder: (hover) {
                                            return InkWell(
                                                onTap: (){
                                                  _launchURL(Provider.of<SplashProvider>(context, listen: false).configModel.playStoreConfig.link);
                                                },
                                                child: Image.asset(Images.play_store,height: 50,fit: BoxFit.contain));
                                          }
                                      ):SizedBox(),
                                      SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),
                                      Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.status?
                                      OnHover(
                                          builder: (hover) {
                                            return InkWell(
                                                onTap: (){
                                                  _launchURL(Provider.of<SplashProvider>(context, listen: false).configModel.appStoreConfig.link);
                                                },
                                                child: Image.asset(Images.app_store,height: 50,fit: BoxFit.contain));
                                          }
                                      ):SizedBox()
                                    ],
                                  ),

                                ),
                              ],
                            )
                        ):SizedBox(),
                        Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                              child: FooterTwo(),
                            ),
                        ),
                        Expanded(
                            flex: 1,
                            child: FooterThree(),
                        ),

                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 1170,
                  child: Center(
                    child: Text('copyright@2022 ${Provider.of<SplashProvider>(context,listen: false).configModel.restaurantName}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}