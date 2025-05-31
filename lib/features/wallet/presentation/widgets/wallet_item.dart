import 'package:expense_tracker_app/core/assets/app_vectors.dart';
import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/common/widgets/icon/app_icon.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WalletItem extends StatelessWidget {
  const WalletItem({super.key, required this.wallet, this.onTap});

  final WalletEntity wallet;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        return Material(
          color: AppColors.light100,
          child: InkWell(
            onTap: onTap ?? () {
              context.push(RoutePaths.wallet + RoutePaths.detailWallet, extra: {
                'wallet': wallet,
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  AppIcon(
                    icon: wallet.walletId == 'total' ? AppVectors.worldIcon : wallet.type == 0
                        ? AppVectors.walletIcon
                        : AppVectors.bankIcon,
                    size: 52,
                    iconSize: 32,
                    backgroundIconColor: AppColors.light60,
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Text(
                      GetLocalizedName.getLocalizedName(context, wallet.name),
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        color: AppColors.dark100,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.format(
                      amount: wallet.balance,
                      toCurrency: state.setting.currency,
                    ),
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 18,
                      color: AppColors.dark100,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
