import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/address_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:flutter_restaurant/view/screens/address/widget/address_widget.dart';
import 'package:flutter_restaurant/view/screens/address/widget/permission_dialog.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';


class AddressScreen extends StatefulWidget {
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : CustomAppBar(context: context, title: getTranslated('address', context)),
      floatingActionButton: _isLoggedIn ? Padding(
        padding:  EdgeInsets.only(top: ResponsiveHelper.isDesktop(context) ?  Dimensions.PADDING_SIZE_LARGE : 0),
        child: !ResponsiveHelper.isDesktop(context) ? FloatingActionButton(
          child: Icon(
              Icons.add, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () => _checkPermission(context, Routes.getAddAddressRoute('address', 'add', AddressModel())),
        ) : null,
      ) : null,
      floatingActionButtonLocation: ResponsiveHelper.isDesktop(context) ? FloatingActionButtonLocation.endTop : FloatingActionButtonLocation.endFloat,
      body: _isLoggedIn ? Consumer<LocationProvider>(
        builder: (context, locationProvider, child) {
          return locationProvider.addressList != null ? locationProvider.addressList.length > 0 ? RefreshIndicator(
            onRefresh: () async {
              await Provider.of<LocationProvider>(context, listen: false).initAddressList(context);
            },
            backgroundColor: Theme.of(context).primaryColor,
            child: Scrollbar(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.isDesktop(context) ?  Dimensions.PADDING_SIZE_DEFAULT : Dimensions.PADDING_SIZE_SMALL),
                        child: SizedBox(
                          width: 1170,
                          child: ResponsiveHelper.isDesktop(context) ?  Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                child: OnHover(
                                  builder: (isHover) {
                                    return InkWell(
                                      onTap: () => _checkPermission(context, Routes.getAddAddressRoute('address', 'add', AddressModel())),
                                    hoverColor: Colors.transparent,
                                      child: Container(
                                        width: 110.0,
                                        decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(30.0)),
                                        padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL, vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                                        child: Row(
                                          children: [
                                            Icon(Icons.add_circle, color: ColorResources.COLOR_WHITE),
                                            SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                            Text(getTranslated('add_new', context), style: rubikRegular.copyWith(color: ColorResources.COLOR_WHITE))
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                ),
                              ),
                              GridView.builder(
                                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: Dimensions.PADDING_SIZE_DEFAULT, childAspectRatio: 4),
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                itemCount: locationProvider.addressList.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) => AddressWidget(
                                  addressModel: locationProvider.addressList[index], index: index,
                                ),
                              ),
                            ],
                          ) : ListView.builder(
                              padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                              itemCount: locationProvider.addressList.length,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) => AddressWidget(
                                addressModel: locationProvider.addressList[index], index: index,
                              ),
                        ),
                      ),
                    ),
                    ),
                   // if(ResponsiveHelper.isDesktop(context)) CustomButton(btnTxt: 'Add'),
                    if(ResponsiveHelper.isDesktop(context)) FooterView(),
                  ],
                ),
              ),
            ),
          ) : NoDataScreen()
              : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : NotLoggedInScreen(),
    );
  }

  void _checkPermission(BuildContext context, String navigateTo) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied) {
      showCustomSnackBar(getTranslated('you_have_to_allow', context), context);
    }else if(permission == LocationPermission.deniedForever) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => PermissionDialog());
    }else {
      Navigator.pushNamed(context, navigateTo);
    }
  }
}
