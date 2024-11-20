import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/core/constants/colors.dart';
import 'package:sns_app/presentation/screens/profile/provider/profile_notifier_provider.dart';
import 'package:sns_app/presentation/screens/signin/signin_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ProfileScreenState();
}

class ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);

    return Scaffold(
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileState.user == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No user data available'),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SigninScreen()),
                          );
                        },
                        child: const Text('Go to Login'),
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
                      const SizedBox(height: 16),
                      Text(
                        profileState.user!.nickname,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(profileState.user!.bio),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text(
                                profileState.user!.followers.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('Followers'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                profileState.user!.followings.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('Following'),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                profileState.user!.postIds.length.toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const Text('Posts'),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: main_color),
                        onPressed: () {
                          context.push('/profileEdit');
                        },
                        child: const Text('프로필 수정하기',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
    );
  }
}
