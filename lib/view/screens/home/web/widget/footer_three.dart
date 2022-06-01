import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';

class FooterThree extends StatelessWidget {
  const FooterThree({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(getTranslated('quick_links', context), style: robotoRegular.copyWith(fontWeight: FontWeight.w700, color: ColorResources.getGreyBunkerColor(context))),
        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: OnHover(
              builder: (isHover) {
                return InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.getPolicyRoute()),
                    child: Text(getTranslated('privacy_policy', context), style: robotoRegular.copyWith(color: isHover ? Theme.of(context).primaryColor : ColorResources.getGreyBunkerColor(context))));
              }
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: OnHover(
              builder: (isHover) {
                return InkWell(
                    onTap: () => Navigator.pushNamed(context, Routes.getTermsRoute()),
                    child: Text(getTranslated('terms_and_condition', context), style: robotoRegular.copyWith(color: isHover ? Theme.of(context).primaryColor : ColorResources.getGreyBunkerColor(context))
                    ));
              }
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: OnHover(
              builder: (isHover) {
                return InkWell(
                  onTap: () => Navigator.pushNamed(context, Routes.getAboutUsRoute()),
                  child: Text(getTranslated('about_us', context), style: robotoRegular.copyWith(color: isHover ? Theme.of(context).primaryColor : ColorResources.getGreyBunkerColor(context))
                  )
                );

              }
          ),
        ),
      ],
    );
  }
}
