import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/presentation/screens/profile/provider/profile_notifier_provider.dart';
import 'package:sns_app/presentation/screens/signin/signin_screen.dart';

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      body: profileState.isLoading
          ? Center(child: CircularProgressIndicator())
          : profileState.user == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No user data available'),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SigninScreen()),
                          );
                        },
                        child: Text('Go to Login'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          profileState.user!.profileImageUrl,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        profileState.user!.nickname,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(profileState.user!.bio),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                profileState.user!.followers.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Followers'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                profileState.user!.followings.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Following'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                profileState.user!.postIds.length.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text('Posts'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.push('/profileEdit');
                        },
                        child: Text('프로필 수정'),
                      ),
                    ],
                  ),
                ),
    );
  }
}
