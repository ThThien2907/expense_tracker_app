import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/network/connection_checker.dart';
import 'package:expense_tracker_app/features/category/data/models/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CategoryRemoteDatasource {
  Future<Either> loadCategories();

}

class CategoryRemoteDatasourceImpl implements CategoryRemoteDatasource {
  final SupabaseClient supabaseClient;
  final ConnectionChecker connectionChecker;

  CategoryRemoteDatasourceImpl(
      this.supabaseClient,
      this.connectionChecker,
      );

  @override
  Future<Either> loadCategories() async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      final response = await supabaseClient.from('categories').select();

      return Right(response.map((e) => CategoryModel.fromMap(e)).toList());
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
