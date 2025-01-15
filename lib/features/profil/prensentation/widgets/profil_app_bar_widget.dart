import 'dart:async';

import 'package:education_app/core/common/extensions/context_extension.dart';
import 'package:education_app/core/common/models/custom_pop_menu_item.dart';
import 'package:education_app/core/common/widgets/pop_item.dart';
import 'package:education_app/core/services/injection_container.dart';
import 'package:education_app/core/themes/app_pallete.dart';
import 'package:education_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:education_app/features/profil/prensentation/screens/edit_profil_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconly/iconly.dart';

class ProfilAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  const ProfilAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Account',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      actions: [
        PopupMenuButton(
          offset: const Offset(0, 50),
          icon: const Icon(Icons.more_horiz),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          itemBuilder: (_) => <CustomPopMenuItem>[
            CustomPopMenuItem(
              title: 'Edit Profil',
              icon: const Icon(
                Icons.edit_outlined,
                color: AppPallete.neutralTextColour,
              ),
              onTap: () {
                context.push(
                  BlocProvider(
                    create: (_) => sl<AuthBloc>(),
                    child: const EditProfilScreen(),
                  ),
                );
              },
            ),
            const CustomPopMenuItem(
              title: 'Notifications',
              icon: Icon(
                IconlyLight.notification,
                color: AppPallete.neutralTextColour,
              ),
            ),
            const CustomPopMenuItem(
              title: 'Help',
              icon: Icon(
                Icons.help_outline_outlined,
                color: AppPallete.neutralTextColour,
              ),
            ),
            const CustomPopMenuItem(
              icon: Divider(
                height: 1,
                color: Colors.grey,
                indent: 13,
                endIndent: 13,
              ),
            ),
            CustomPopMenuItem(
              title: 'Logout',
              icon: const Icon(
                IconlyLight.notification,
                color: AppPallete.neutralTextColour,
              ),
              onTap: () async {
                final navigator = Navigator.of(context);
                await sl<FirebaseAuth>().signOut();
                unawaited(
                  navigator.pushNamedAndRemoveUntil(
                    '/',
                    (__) => false,
                  ),
                );
              },
            ),
          ]
              .map(
                (item) => PopupMenuItem<void>(
                  // padding: EdgeInsets.zero,
                  height: item.icon is Divider ? 1 : kMinInteractiveDimension,
                  onTap: () => item.onTap?.call(),
                  child: item.icon is Icon
                      ? PopItem(
                          title: item.title,
                          icon: item.icon,
                        )
                      : item.icon,
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
