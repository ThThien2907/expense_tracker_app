import 'package:expense_tracker_app/core/common/extensions/currency_formatter.dart';
import 'package:expense_tracker_app/core/common/widgets/app_bar/custom_app_bar.dart';
import 'package:expense_tracker_app/core/common/widgets/button/month_picker_button.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/core/navigation/app_router.dart';
import 'package:expense_tracker_app/core/theme/app_colors.dart';
import 'package:expense_tracker_app/features/setting/presentation/bloc/setting_bloc.dart';
import 'package:expense_tracker_app/features/transaction/presentation/widgets/transaction_list_by_month.dart';
import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class DetailWalletPage extends StatefulWidget {
  const DetailWalletPage({
    super.key,
    required this.walletEntity,
  });

  final WalletEntity walletEntity;

  @override
  State<DetailWalletPage> createState() => _DetailWalletPageState();
}

class _DetailWalletPageState extends State<DetailWalletPage> {
  DateTime initialDate = DateTime.now();
  DateFormat dateFormat = DateFormat('MM/yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.detailWallet,
        centerTitle: true,
        action: [
          IconButton(
            onPressed: () async {
              final result = await context
                  .push(RoutePaths.wallet + RoutePaths.addOrEditWallet, extra: {
                'isEdit': true,
                'wallet': widget.walletEntity,
              });
              if (result != null) {
                if (context.mounted) {
                  context.pop();
                }
              }
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            const SizedBox(
              height: 32,
            ),
            Text(
              widget.walletEntity.name,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                color: AppColors.light20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              CurrencyFormatter.format(
                amount: widget.walletEntity.balance,
                toCurrency: context.read<SettingBloc>().state.setting.currency,
              ),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 32,
                color: AppColors.dark75,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(
              height: 56,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                MonthPickerButton(
                  initialDate: initialDate,
                  onTap: (date) {
                    setState(() {
                      initialDate = date;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            TransactionListByMonth(
              walletId: widget.walletEntity.walletId,
              initialDate: initialDate,
            ),
          ],
        ),
      ),
    );
  }
}
