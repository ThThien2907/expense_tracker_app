import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/setting/presentation/widgets/setting_parent_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.setting,
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            SettingParentItem(
              settingName: AppLocalizations.of(context)!.currency,
              selectedSetting: context.read<SettingBloc>().state.setting.currency,
              onTap: () {
                context.push(RoutePaths.setting + RoutePaths.currency);
              },
            ),
            SettingParentItem(
              settingName: AppLocalizations.of(context)!.language,
              selectedSetting: GetLocalizedName.getLocalizedName(
                context,
                context.read<SettingBloc>().state.setting.language,
              ),
              onTap: () {
                context.push(RoutePaths.setting + RoutePaths.language);
              },
            ),
          ],
        ),
      ),
    );
  }
}
