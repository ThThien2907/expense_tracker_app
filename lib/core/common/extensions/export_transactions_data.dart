import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:expense_tracker_app/core/common/extensions/get_localized_name.dart';
import 'package:expense_tracker_app/core/languages/app_localizations.dart';
import 'package:expense_tracker_app/features/transaction/domain/entities/transaction_entity.dart';
import 'package:expense_tracker_app/features/wallet/domain/entities/wallet_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportTransactionsData {
  ExportTransactionsData._();

  static Future<bool> exportTransactionsDataToExcel({
    required BuildContext context,
    required List<TransactionEntity> transactions,
    required List<WalletEntity> wallets,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final transactionsByDate = transactions
          .where((e) =>
              e.createdAt.isBefore(DateTime(endDate.year, endDate.month, endDate.day + 1)) &&
              e.createdAt.isAfter(startDate))
          .toList();
      transactionsByDate.sort((a, b) => a.createdAt.compareTo(b.createdAt));

      var excel = Excel.createExcel();
      Sheet sheet = excel['Transactions'];

      sheet.appendRow([
        TextCellValue(AppLocalizations.of(context)!.startDate),
        DateCellValue(
          year: startDate.year,
          month: startDate.month,
          day: startDate.day,
        ),
      ]);

      sheet.appendRow([
        TextCellValue(AppLocalizations.of(context)!.endDate),
        DateCellValue(
          year: endDate.year,
          month: endDate.month,
          day: endDate.day,
        ),
      ]);

      sheet.appendRow([
        TextCellValue('No.'),
        TextCellValue(AppLocalizations.of(context)!.day),
        TextCellValue(AppLocalizations.of(context)!.category),
        TextCellValue(AppLocalizations.of(context)!.type),
        TextCellValue(AppLocalizations.of(context)!.amount),
        TextCellValue(AppLocalizations.of(context)!.wallet),
        TextCellValue(AppLocalizations.of(context)!.description),
      ]);

      int count = 1;
      for (var transaction in transactionsByDate) {
        final wallet = wallets.firstWhere((e) => e.walletId == transaction.walletId);
        sheet.appendRow([
          IntCellValue(count),
          DateCellValue(
            year: transaction.createdAt.year,
            month: transaction.createdAt.month,
            day: transaction.createdAt.day,
          ),
          TextCellValue(GetLocalizedName.getLocalizedName(context, transaction.category.name)),
          TextCellValue(transaction.category.type == 0
              ? AppLocalizations.of(context)!.expense
              : AppLocalizations.of(context)!.income),
          DoubleCellValue(transaction.amount),
          TextCellValue(wallet.name),
          TextCellValue(transaction.description),
        ]);
        count++;
      }

      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }

      final Uint8List fileBytes = Uint8List.fromList(excel.encode()!);

      final filename = 'transactions_${DateTime.now().microsecondsSinceEpoch}.xlsx';

      final tempPath = '/data/data/com.example.expense_tracker_app/cache/$filename';
      final tempFile = File(tempPath);
      await tempFile.writeAsBytes(fileBytes);

      final savedPath = await FlutterFileDialog.saveFile(
          params: SaveFileDialogParams(
        sourceFilePath: tempFile.path,
        fileName: filename,
      ));

      if (savedPath != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
