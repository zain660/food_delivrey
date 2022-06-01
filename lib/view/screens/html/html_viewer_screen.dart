import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/html_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_ui/universal_ui.dart';
import 'package:url_launcher/url_launcher.dart';


class HtmlViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  HtmlViewerScreen({@required this.htmlType});

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final double _width = MediaQuery.of(context).size.width;
    String _data = htmlType == HtmlType.TERMS_AND_CONDITION ? Provider.of<SplashProvider>(context, listen: false).configModel.termsAndConditions??''
        : htmlType == HtmlType.ABOUT_US ? Provider.of<SplashProvider>(context, listen: false).configModel.aboutUs??''
        : htmlType == HtmlType.PRIVACY_POLICY ? Provider.of<SplashProvider>(context, listen: false).configModel.privacyPolicy??'' : 'Empty';

    if(_data != null && _data.isNotEmpty) {
      _data = _data.replaceAll('href=', 'target="_blank" href=');
    }

    String _viewID = htmlType.toString();
    if(ResponsiveHelper.isWeb()) {
      try{
        ui.platformViewRegistry.registerViewFactory(_viewID, (int viewId) {
          html.IFrameElement _ife = html.IFrameElement();
          _ife.width = '1170';
          _ife.height = MediaQuery.of(context).size.height.toString();
          _ife.srcdoc = _data;
          _ife.contentEditable = 'false';
          _ife.style.border = 'none';
          _ife.allowFullscreen = true;
          return _ife;
        });
      }catch(e) {}
    }
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) :  CustomAppBar(context: context, title: getTranslated(htmlType == HtmlType.TERMS_AND_CONDITION ? 'terms_and_condition'
          : htmlType == HtmlType.ABOUT_US ? 'about_us' : htmlType == HtmlType.PRIVACY_POLICY ? 'privacy_policy' : 'no_data_found', context)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                  child: Container(
                    width: _width > 700 ? 700 : _width,
                    padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                    decoration: _width > 700 ? BoxDecoration(
                      color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                    ) : null,
                    height: MediaQuery.of(context).size.height,
                  //  color: ResponsiveHelper.isWeb() ? Colors.white : Theme.of(context).cardColor,
                    child: ResponsiveHelper.isWeb() ? SingleChildScrollView(
                      child: Column(
                        children: [
                          ResponsiveHelper.isDesktop(context) ? Container(
                            height: 100, alignment: Alignment.center,
                            child: SelectableText(getTranslated(htmlType == HtmlType.TERMS_AND_CONDITION ? 'terms_and_condition'
                                : htmlType == HtmlType.ABOUT_US ? 'about_us' : htmlType == HtmlType.PRIVACY_POLICY ? 'privacy_policy' : 'no_data_found', context),
                              style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.getWhiteAndBlack(context)),
                            ),
                          ) : SizedBox(),
                          SizedBox(height: 30),
                         HtmlWidget(
                           _data.isNotEmpty?_data ?? '':'',
                           key: Key(htmlType.toString()),
                           textStyle: TextStyle(color: ColorResources.getWhiteAndBlack(context)),
                           onTapUrl: (String url) {
                             return  launch(url);
                           },
                         ),
                         // Expanded(child: HtmlElementView(viewType: _viewID, key: Key(htmlType.toString() ))),
                        ],
                      ),
                    ) : SingleChildScrollView(
                      padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                      physics: BouncingScrollPhysics(),
                      child: HtmlWidget(
                        _data.isNotEmpty ? _data ?? '':'',
                        key: Key(htmlType.toString()),
                        textStyle: TextStyle(color: ColorResources.getWhiteAndBlack(context)),
                        onTapUrl: (String url) {
                          return launch(url);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if(ResponsiveHelper.isDesktop(context)) FooterView()
          ],
        ),
      ),
    );
  }
}