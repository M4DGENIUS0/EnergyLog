import 'package:app/file/app_preferences/app_preferences.dart';
import 'package:app/file/common/constants.dart';
import 'package:app/file/generic_methods/utility_methods.dart';
import 'package:app/file/hive_storage_files/hive_storage_manager.dart';
import 'package:app/pages/home_related/battery_screen.dart';
import 'package:app/pages/home_related/device_info.dart';
import 'package:app/pages/home_related/parent_home_utilities.dart';
import 'package:app/pages/home_related/monitor_screen.dart';
import 'package:app/widgets/app_bar_widget.dart';
import 'package:app/widgets/bottom_nav_bar_widgets/bottom_navigation_bar.dart';
import 'package:app/widgets/custom_widgets/refresh_indicator_widget.dart';
import 'package:app/widgets/no_internet_botton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app/pages/home_related/app_info_screen.dart';

class ParentHome extends StatefulWidget {
  const ParentHome({super.key});

  @override
  State<ParentHome> createState() => _ParentHomeState();
}

class _ParentHomeState extends State<ParentHome> {
  int _selectedIndex = 0;

  void onRefresh() {
    setState(() {
      clearMetaData();
      // needToRefresh = true;
    });
    // loadData();
  }

  final List<Widget> _pages = [
    BatteryScreen(),
    MonitorScreen(),
    InfoScreen(),
    AppInfoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: HomeScreenUtilities().getSystemUiOverlayStyle(),
      child: PopScope(
        canPop: _selectedIndex == 0,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop && _selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          // drawer: HomeScreenDrawerWidget(
          //   drawerConfigDataList: drawerConfigList,
          //   userInfoData: {
          //     USER_PROFILE_NAME : _userName,
          //     USER_PROFILE_IMAGE : _userImage,
          //     USER_ROLE : _userRole,
          //     USER_LOGGED_IN : isLoggedIn,
          //   },
          //   homeScreenDrawerWidgetListener: (bool loginInfo){
          //     if(mounted){
          //       setState(() {
          //         isLoggedIn = loginInfo;
          //       });
          //     }
          //   },
          // ),
          body: IndexedStack(index: _selectedIndex, children: _pages),
          bottomNavigationBar: bottomNavigationBar(),
        ),
      ),
    );
  }

  PreferredSizeWidget getAppBarWidget() {
    return AppBarWidget(
      appBarTitle: APP_NAME,
      backgroundColor:
          AppThemePreferences().appTheme.sliverAppBarBackgroundColor,
      elevation: 5,
    );
  }

  Widget getBodyWidget() {
    return RefreshIndicatorWidget(
      color: AppThemePreferences.appPrimaryColor,
      edgeOffset: 200.0,
      onRefresh: () async => onRefresh(),
      child: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildBuilderDelegate(childCount: 1, (
                  BuildContext context,
                  int index,
                ) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  );
                }),
              ),
            ],
          ),
          // if (errorWhileDataLoading) getInternetConnectionErrorWidget(),
        ],
      ),
    );
  }

  // Widget getInternetConnectionErrorWidget(){
  //   return InternetConnectionErrorWidget(
  //     onPressed: ()=> checkInternetAndLoadData(),
  //   );
  // }

  void clearMetaData() {
    HiveStorageManager.clearData();
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBarWidget(
      backgroundColor:
          AppThemePreferences().appTheme.bottomNavBarBackgroundColor!,
      // selectedItemColor: AppThemePreferences().appTheme.bottomNavigationBarSelectedItemColor!,
      selectedItemColor: AppThemePreferences().appTheme.primaryColor,
      unselectedItemColor: AppThemePreferences()
          .appTheme
          .bottomNavigationBarUnSelectedItemColor!,
      currentIndex: _selectedIndex,
      design: DESIGN_02,
      itemsMap: UtilityMethods.bottomNavBarMap(),
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      curve: Curves.easeInOut,
      enableFloatingNavBar: true,
      duration: const Duration(milliseconds: 300),
      enablePaddingAnimation: true,
      splashBorderRadius: 12,
      // barMargin: EdgeInsets.symmetric(vertical: 100),
      // paddingR: const EdgeInsets.all(8),
      splashColor: Colors.grey.withValues(alpha: 0.2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    );
  }
}

class InternetConnectionErrorWidget extends StatelessWidget {
  final Function()? onPressed;

  const InternetConnectionErrorWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: SafeArea(
        top: false,
        child: NoInternetBottomActionBarWidget(onPressed: onPressed),
      ),
    );
  }
}
