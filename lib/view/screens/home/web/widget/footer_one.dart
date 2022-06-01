
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/news_letter_controller.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FooterOne extends StatelessWidget {
  const FooterOne({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _newsLetterController = TextEditingController();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            children: [
              Provider.of<SplashProvider>(context).baseUrls != null?  Consumer<SplashProvider>(
                  builder:(context, splash, child) => FadeInImage.assetNetwork(
                    placeholder: Images.placeholder_rectangle,
                    image:  '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}',
                    width: 101, height: 106,
                    imageErrorBuilder: (c, o, s) => Image.asset(Images.logo, width: 101, height: 106),
                  )): SizedBox(),
              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
            ]),
        Text(getTranslated('news_letter', context), style: robotoRegular.copyWith(fontWeight: FontWeight.w600, color: ColorResources.getGreyBunkerColor(context))),

        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

        Text(getTranslated('subscribe_to_our', context), style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.getGreyBunkerColor(context))),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),


        Container(width: 350,
          child: OnHover(
              builder: (isHover) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(30),

                  ),
                  height: 40.0,
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(decoration : InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(27.0),
                            borderSide: BorderSide(style: BorderStyle.none, width: 0),
                          ),
                          hintText: getTranslated('your_email_address', context),
                          hintStyle : Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyBunkerColor(context)),
                        ),
                          controller: _newsLetterController,
                        ),

                      ),
                      InkWell(
                        onTap:(){
                          String email = _newsLetterController.text.trim().toString();
                          if (email.isEmpty) {
                            showCustomSnackBar(getTranslated('enter_email_address', context), context);
                          }else if (EmailChecker.isNotValid(email)) {
                            showCustomSnackBar(getTranslated('enter_valid_email', context), context);
                          }else{
                            Provider.of<NewsLetterProvider>(context, listen: false).addToNewsLetter(context, email).then((value) {
                              _newsLetterController.clear();
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                          child: Container(width: 80, alignment: Alignment.center, decoration: BoxDecoration(color: ColorResources.APPBAR_HEADER_COL0R,
                              borderRadius: BorderRadius.circular(27.0)), child: Padding(
                            padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
                            child: Text(getTranslated('subscribe', context), style: rubikRegular.copyWith(color: ColorResources.COLOR_WHITE, fontSize: Dimensions.FONT_SIZE_DEFAULT)
                            ),
                          )),
                        ),
                      )

                    ],
                  ),
                );
              }
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Text(getTranslated('flow_us_on', context), style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: ColorResources.getGreyBunkerColor(context))),
        ),
        Consumer<SplashProvider>(
            builder: (context, socialController,_) {

              return Container(height: 50,
                child: ListView.builder(

                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: socialController.configModel.socialMediaLink.length,
                  itemBuilder: (BuildContext context, index){
                    String name = socialController.configModel.socialMediaLink[index].name;
                    print('Name ===>$name');
                    String icon;
                    if(name=='facebook'){
                      icon = Images.facebook_icon;
                    }else if(name=='linkedin'){
                      icon = Images.linked_in_icon;
                    } else if(name=='youtube'){
                      icon = Images.youtube_icon;
                    }else if(name=='twitter'){
                      icon = Images.twitter_icon;
                    }else if(name=='instagram'){
                      icon = Images.in_sta_gram_icon;
                    }else if(name=='pinterest'){
                      icon = Images.pinterest;
                    }
                    return  socialController.configModel.socialMediaLink.length > 0?
                    InkWell(
                      onTap: (){
                        _launchURL(socialController.configModel.socialMediaLink[index].link);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child:ImageIcon(AssetImage(icon), size: Dimensions.PADDING_SIZE_EXTRA_LARGE, color: ColorResources.APPBAR_HEADER_COL0R),
                      ),
                    ):SizedBox();

                  },),
              );
            }
        ),
      ],
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