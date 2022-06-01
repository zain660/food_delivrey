import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/theme_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';

class ArrayButton extends StatelessWidget {
  final bool isLeft;
  final bool isLarge;
  final Function onTop;
  final bool isVisible;
  const ArrayButton({Key key, @required this.isLeft, @required this.isLarge, @required this.onTop, @required this.isVisible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: isVisible ?  onTop : null,
          child: Provider.of<ThemeProvider>(context,listen: false).darkTheme?Container(
            decoration: BoxDecoration(color: isVisible ? ColorResources.COLOR_WHITE : ColorResources.COLOR_HINT, shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme? 900 : 200], spreadRadius: 0, blurRadius: 25,offset: Offset(0, 4))],),
            child: Padding(
              padding: isLarge ?  const EdgeInsets.all(8.0) : const EdgeInsets.all(4.0),
              child: isLeft ? Icon(Icons.chevron_left_rounded, color: isVisible ? ColorResources.ARROW_COLOR : ColorResources.COLOR_WHITE, size: isLarge == null || isLarge ?  30 : Dimensions.PADDING_SIZE_LARGE) : Icon(Icons.chevron_right_rounded, color: isVisible ? ColorResources.ARROW_COLOR :  ColorResources.COLOR_WHITE, size: isLarge == null || isLarge ?  30 : Dimensions.PADDING_SIZE_LARGE),
            ),
          ):Container(
            decoration: BoxDecoration(color: isVisible ?  ColorResources.COLOR_HINT:ColorResources.COLOR_WHITE , shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.grey[Provider.of<ThemeProvider>(context).darkTheme? 900 : 200], spreadRadius: 0, blurRadius: 25,offset: Offset(0, 4))],),
            child: Padding(
              padding: isLarge ?  const EdgeInsets.all(8.0) : const EdgeInsets.all(4.0),
              child: isLeft ? Icon(Icons.chevron_left_rounded, color: isVisible ?
              ColorResources.COLOR_WHITE:ColorResources.ARROW_COLOR, size: isLarge == null || isLarge ?
              30 : Dimensions.PADDING_SIZE_LARGE) : Icon(Icons.chevron_right_rounded, color: isVisible ?
              ColorResources.COLOR_WHITE:ColorResources.ARROW_COLOR , size: isLarge == null || isLarge ?  30 : Dimensions.PADDING_SIZE_LARGE),
            ),
          ),
        );
  }
}
