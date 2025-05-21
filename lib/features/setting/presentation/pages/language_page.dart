import 'package:expense_tracker_app/core/common/constant/app_const.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/loading/loading.dart';
import 'package:expense_tracker_app/core/common/widgets/snack_bar/app_snack_bar.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/setting/presentation/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = context.read<SettingBloc>().state.setting.language;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.language,
        centerTitle: true,
      ),
      body: BlocConsumer<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state.status == SettingStatus.loading) {
            Loading.show(context);
          } else {
            Loading.hide(context);
          }
          if (state.status == SettingStatus.failure) {
            AppSnackBar.showError(
              context,
              GetLocalizedName.getLocalizedName(
                context,
                state.errorMessage,
              ),
            );
          }
          if (state.status == SettingStatus.success) {
            setState(() {
              selectedValue =
                  context.read<SettingBloc>().state.setting.language;
            });
          }
        },
        builder: (context, state) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              itemBuilder: (context, index) {
                return SettingItem(
                  name: GetLocalizedName.getLocalizedName(
                    context,
                    AppConst.languages[index],
                  ),
                  value: AppConst.languages[index],
                  selectedValue: selectedValue,
                  onTap: () {
                    setState(() {
                      context.read<SettingBloc>().add(SettingLanguageChanged(
                            language: AppConst.languages[index],
                          ));
                    });
                  },
                );
              },
              separatorBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: MediaQuery.of(context).size.width,
                  height: 1,
                  color: AppColors.light40,
                );
              },
              itemCount: AppConst.languages.length,
            ),
          );
        },
      ),
    );
  }
}
