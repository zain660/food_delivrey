import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/notification_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/screens/notification/widget/notification_dialog.dart';
import 'package:provider/provider.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;

    Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : CustomAppBar(context: context, title: getTranslated('notification', context)),
      body: Consumer<NotificationProvider>(
        builder: (context, notificationProvider, child) {
          final double _width = MediaQuery.of(context).size.width;
          List<DateTime> _dateTimeList = [];
          return notificationProvider.notificationList != null ? notificationProvider.notificationList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<NotificationProvider>(context, listen: false).initNotificationList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
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
                            child: Center(
                              child: ListView.builder(
                                  itemCount: notificationProvider.notificationList.length,
                                  padding: EdgeInsets.zero,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    DateTime _originalDateTime = DateConverter.isoStringToLocalDate(notificationProvider.notificationList[index].createdAt);
                                    DateTime _convertedDate = DateTime(_originalDateTime.year, _originalDateTime.month, _originalDateTime.day);
                                    bool _addTitle = false;
                                    if(!_dateTimeList.contains(_convertedDate)) {
                                      _addTitle = true;
                                      _dateTimeList.add(_convertedDate);
                                    }
                                    return InkWell(
                                      onTap: () {
                                        showDialog(context: context, builder: (BuildContext context) {
                                          return NotificationDialog(notificationModel: notificationProvider.notificationList[index]);
                                        });
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          _addTitle ? Padding(
                                            padding: EdgeInsets.fromLTRB(10, 10, 10, 2),
                                            child: Text(DateConverter.isoStringToLocalDateOnly(notificationProvider.notificationList[index].createdAt)),
                                          ) : SizedBox(),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
                                                Text(
                                                  notificationProvider.notificationList[index].title, overflow: TextOverflow.ellipsis, maxLines: 3,
                                                  style: Theme.of(context).textTheme.headline2.copyWith(
                                                    fontSize: Dimensions.FONT_SIZE_DEFAULT,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                SizedBox(height: 20),
                                                Container(height: 1, color: ColorResources.COLOR_GREY.withOpacity(.2))
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            height: 100, width: 100,
                                            margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Theme.of(context).primaryColor.withOpacity(0.20)),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child: FadeInImage.assetNetwork(
                                                placeholder: Images.placeholder_banner, height: 100, width: 100, fit: BoxFit.cover,
                                                image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.notificationImageUrl}/${notificationProvider.notificationList[index].image}',
                                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_banner, height: 100, width:100, fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if(ResponsiveHelper.isDesktop(context)) FooterView(),
                  ],
                ),
              ),
            ),
          )
              : NoDataScreen()
              : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        }
      ),
    );
  }
}
