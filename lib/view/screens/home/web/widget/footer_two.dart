import 'package:flutter/material.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';

class FooterTwo extends StatelessWidget {
  const FooterTwo({Key key}) : super(key: key);

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
                onTap: () => Navigator.pushNamed(context, Routes.getSupportRoute()),
                child: Text(getTranslated('contact_us', context), style: robotoRegular.copyWith(color: isHover ? Theme.of(context).primaryColor : ColorResources.getGreyBunkerColor(context))),
              );
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: OnHover(
            builder: (isHover) {
              return InkWell(
                  onTap:() => Navigator.pushNamed(context, Routes.getChatRoute(isAdmin: 'true')),
                  child: Text(getTranslated('live_chat', context), style: robotoRegular.copyWith(color: isHover ? Theme.of(context).primaryColor : ColorResources.getGreyBunkerColor(context))
                  )
              );
            }
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: OnHover(builder: (isHover) {
            return InkWell(
                onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('order')),
                child: Text(getTranslated('my_order', context), style: robotoRegular.copyWith(color: isHover ? Theme.of(context).primaryColor :  ColorResources.getGreyBunkerColor(context))
                ));
          },
          ),
        ),
      ],
    );
  }
}
