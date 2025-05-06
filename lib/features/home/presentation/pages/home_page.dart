import 'package:expense_tracker_app/core/common/cubits/app_user_cubit.dart';
import 'package:expense_tracker_app/core/common/cubits/app_user_cubit.dart';
import 'package:expense_tracker_app/core/common/widgets/loading/loading.dart';
import 'package:expense_tracker_app/features/auth/domain/entities/user_entity.dart';
import 'package:expense_tracker_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:expense_tracker_app/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var supabaseClient = Supabase.instance.client;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              // context.read<AuthBloc>().add(AuthLogOut());
              if (supabaseClient.auth.currentUser != null) {
                print(supabaseClient.auth.currentUser!.id.toString());
                supabaseClient.auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => OnboardingPage()),
                    (route) => false);
                print('user log out succ');
              } else {
                print('user logged out');
              }
            },
            child: Text('Logout'),
          ),
          BlocBuilder<AppUserCubit, UserEntity?>(
            builder: (context, user) {
              return ElevatedButton(
                onPressed: () {
                  print(supabaseClient.auth.currentUser.toString());
                  print(user.toString());
                },
                child: Text('user'),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              Loading.show(
                context,
              );
            },
            child: Text('show'),
          ),
          ElevatedButton(
            onPressed: () {
              Loading.hide(context);
            },
            child: Text('hide'),
          ),
        ],
      ),
    );
  }
}
