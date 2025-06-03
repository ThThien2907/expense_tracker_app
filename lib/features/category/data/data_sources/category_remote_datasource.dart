import 'package:dartz/dartz.dart';
import 'package:expense_tracker_app/core/network/connection_checker.dart';
import 'package:expense_tracker_app/features/category/data/models/category_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class CategoryRemoteDatasource {
  Future<Either> loadCategories();

  Future<Either> addNewCategory({
    required String name,
    required String iconName,
    required String color,
    required int type,
  });

  Future<Either> editCategory({
    required String categoryId,
    required String name,
    required String iconName,
    required String color,
  });

  Future<Either> deleteCategory({
    required String categoryId,
  });
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
      final user = supabaseClient.auth.currentUser!;
      final response = await supabaseClient
          .from('categories')
          .select()
          .or('user_id.eq.${user.id},user_id.is.null');

      return Right(response.map((e) => CategoryModel.fromMap(e)).toList());
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> addNewCategory({
    required String name,
    required String iconName,
    required String color,
    required int type,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }
      final user = supabaseClient.auth.currentUser!;

      final response = await supabaseClient.from('categories').insert({
        'name': name,
        'icon_name': iconName,
        'color': color,
        'type': type,
        'user_id': user.id,
      }).select();

      return Right(CategoryModel.fromMap(response.first));
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> editCategory({
    required String categoryId,
    required String name,
    required String iconName,
    required String color,
  }) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }

      final response = await supabaseClient
          .from('categories')
          .update({
            'name': name,
            'icon_name': iconName,
            'color': color,
          })
          .eq('category_id', categoryId)
          .select();

      return Right(CategoryModel.fromMap(response.first));
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteCategory({required String categoryId}) async {
    try {
      if (!await (connectionChecker.hasInternetConnection())) {
        return const Left('No internet connection');
      }

      await supabaseClient.rpc(
        'delete_category',
        params: ({
          'p_category_id': categoryId,
        }),
      );

      return const Right('Delete Success');
    } on PostgrestException catch (e) {
      return Left(e.message);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
