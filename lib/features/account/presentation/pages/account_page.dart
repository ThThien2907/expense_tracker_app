import 'package:expense_tracker_app/core/assets/app_images.dart';
import 'package:expense_tracker_app/core/assets/app_vectors.dart';
import 'package:expense_tracker_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:expense_tracker_app/core/common/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/Account/presentation/widgets/account_item.dart';
import 'package:expense_tracker_app/features/auth/domain/entities/user_entity.dart';
import 'package:expense_tracker_app/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF6F6F6),
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color(0xffF6F6F6),
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<AppUserCubit, UserEntity?>(
                builder: (context, state) {
                  if (state != null) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: AppColors.light100,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 32,
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(1000),
                                    border: Border.all(
                                      color: AppColors.light60,
                                      width: 2,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000),
                                    child: state.avatar!.isEmpty
                                        ? Image.asset(
                                            height: 90,
                                            width: 90,
                                            AppImages.defaultProfileAvatar,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            state.avatar.toString(),
                                            width: 90,
                                            height: 90,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                Text(
                                  state.fullName,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.dark75,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          // Positioned(
                          //   top: 10,
                          //   right: 10,
                          //   child: IconButton(
                          //     onPressed: () {},
                          //     iconSize: 30,
                          //     icon: const Icon(
                          //       Icons.edit_outlined,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    );
                  }
                  return Container();
                },
              ),
              const SizedBox(
                height: 16,
              ),
              AccountItem(
                onTap: () {
                  context.push(RoutePaths.wallet);
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                icon: AppVectors.walletIcon,
                label: AppLocalizations.of(context)!.wallet,
              ),
              const SizedBox(
                height: 1,
              ),
              AccountItem(
                onTap: () {
                  context.push(RoutePaths.category);
                },
                icon: AppVectors.categoryIcon,
                label: AppLocalizations.of(context)!.category,
              ),
              const SizedBox(
                height: 1,
              ),
              AccountItem(
                onTap: () {
                  context.push(RoutePaths.setting);
                },
                icon: AppVectors.settingIcon,
                label: AppLocalizations.of(context)!.setting,
              ),
              const SizedBox(
                height: 1,
              ),
              AccountItem(
                onTap: () {
                  AppBottomSheet.show(
                    context: context,
                    widget: ConfirmEventBottomSheet(
                      title: '${AppLocalizations.of(context)!.logout}?',
                      subtitle: AppLocalizations.of(context)!.confirmLogout,
                      onPressedYesButton: () async {
                        try {
                          await serviceLocator<GoogleSignIn>().signOut();
                          await serviceLocator<SupabaseClient>().auth.signOut();

                          if(context.mounted) {
                            context.go(RoutePaths.onboarding);
                          }
                        } catch (e) {
                          debugPrint('Error: $e');
                          if(context.mounted) {
                            AppSnackBar.showError(context, e.toString());
                          }
                        }
                      },
                    ),
                  );
                },
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                iconColor: AppColors.red100,
                backgroundIconColor: const Color(0xffFFE2E4),
                icon: AppVectors.logoutIcon,
                label: AppLocalizations.of(context)!.logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
