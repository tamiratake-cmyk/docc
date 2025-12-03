import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/app/bloc/user/user_bloc.dart';
import 'package:flutter_application_1/app/bloc/user/user_event.dart';
import 'package:flutter_application_1/app/bloc/user/user_state.dart';
import 'package:flutter_application_1/app/widgets/error_view.dart';
import 'package:flutter_application_1/app/widgets/loading_view.dart';
import 'package:flutter_application_1/app/widgets/post_list.dart';
import 'package:flutter_application_1/app/widgets/user_header.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: () {
                   throw FormatException('Format Exception Error');
                },
                child: const Text('Throw Test Exception'),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                tooltip: 'Sign Out',
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return AnimatedOpacity(
                      opacity: 1.0,
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                    );
                } else if (state.error != null) {
                  return ErrorView(message: state.error!);

                } else if (state.user == null) {
                  return const Center(child: Text('No user data available.'));
                } else {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        UserHeader(user:  state.user!),

                        const Divider(),

                        const SizedBox(height: 20),
                        
                        Text(
                          "user posts",
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 20),
                        ...?state.posts?.map(
                          (post) =>
                          PostList(post:  post)
                        )
                      ],

                      
                    ),
                  );
                }
                
              },
            ),
          ),
        ],
      ),
    );
  }
}