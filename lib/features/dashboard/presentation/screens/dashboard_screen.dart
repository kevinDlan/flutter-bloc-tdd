import 'package:education_app/core/common/app/providers/user_provider.dart';
import 'package:education_app/core/themes/app_pallete.dart';
import 'package:education_app/features/auth/data/models/user_model.dart';
import 'package:education_app/features/dashboard/providers/dashboard_controller.dart';
import 'package:education_app/features/dashboard/utils/dashboard_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String routeName = '/dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<_MenuItem> menuItems = const [
    _MenuItem(
      label: 'Home',
      boldIcon: IconlyBold.home,
      lightIcon: IconlyLight.home,
    ),
    _MenuItem(
      label: 'Materials',
      boldIcon: IconlyBold.document,
      lightIcon: IconlyLight.document,
    ),
    _MenuItem(
      label: 'Chat',
      boldIcon: IconlyBold.chat,
      lightIcon: IconlyLight.chat,
    ),
    _MenuItem(
      label: 'Profil',
      boldIcon: IconlyBold.profile,
      lightIcon: IconlyLight.profile,
    ),
  ];

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
      stream: DashboardUtils.userDataStream,
      builder: (_, snapshot) {
        if (snapshot.hasData && snapshot.data is UserModel) {
          context.read<UserProvider>().user = snapshot.data;
        }

        return Consumer<DashboardController>(
          builder: (_, controller, __) {
            return Scaffold(
              body: IndexedStack(
                index: controller.currentIndex,
                children: controller.screens,
              ),
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: controller.currentIndex,
                showSelectedLabels: false,
                backgroundColor: AppPallete.whiteColor,
                elevation: 8,
                onTap: controller.changeIndex,
                items: [
                  for (int i = 0; i < menuItems.length; i++)
                    BottomNavigationBarItem(
                      icon: Icon(
                        controller.currentIndex == i
                            ? menuItems[i].boldIcon
                            : menuItems[i].lightIcon,
                        color: controller.currentIndex == i
                            ? AppPallete.primaryColour
                            : Colors.grey,
                      ),
                      label: menuItems[i].label,
                      backgroundColor: AppPallete.whiteColor,
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.label,
    required this.boldIcon,
    required this.lightIcon,
  });

  final String label;
  final IconData boldIcon;
  final IconData lightIcon;
}
