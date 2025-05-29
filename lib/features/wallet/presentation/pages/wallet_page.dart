import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/button/app_button.dart';
import 'package:expense_tracker_app/core/common/widgets/total_balance/total_balance.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:expense_tracker_app/features/wallet/presentation/bloc/wallet_bloc.dart';
import 'package:expense_tracker_app/features/wallet/presentation/widgets/wallet_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.wallet,
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 54,
            ),
            const TotalBalance(),
            const SizedBox(
              height: 54,
            ),
            BlocConsumer<WalletBloc, WalletState>(
              listener: (context, state) {},
              builder: (context, state) {
                List<WalletEntity> wallets = [...state.wallets];
                wallets.removeWhere((wallet) => wallet.walletId == 'total');

                if (wallets.isEmpty) {
                  return Text(
                    AppLocalizations.of(context)!.doNotHaveWallet,
                    style: const TextStyle(
                      color: AppColors.light20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  );
                }
                return Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return WalletItem(
                        wallet: wallets[index],
                      );
                    },
                    separatorBuilder: (context, index) => Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: AppColors.light60,
                    ),
                    itemCount: wallets.length,
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: AppButton(
                onPressed: () {
                  context.push(
                    RoutePaths.wallet + RoutePaths.addOrEditWallet,
                    extra: ({
                      'isEdit': false,
                    }),
                  );
                },
                buttonText: AppLocalizations.of(context)!.addNewWallet,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
