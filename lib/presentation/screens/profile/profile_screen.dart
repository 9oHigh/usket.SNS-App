import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/presentation/screens/profile/edit_profile_screen.dart';
import 'package:sns_app/presentation/screens/profile/provider/profile_notifier_provider.dart';

class ProfileScreen extends ConsumerWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);
    final profileNotifier = ref.read(profileNotifierProvider.notifier);

    if (profileState.user == null && !profileState.isLoading) {
      Future.delayed(Duration.zero, () {
        profileNotifier.loadUserProfile(userId);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : profileState.error.isNotEmpty
              ? Center(child: Text(profileState.error))
              : profileState.user != null
                  ? Column(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage(profileState.user!.profileImageUrl),
                          radius: 50,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          profileState.user!.username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(profileState.user!.bio),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  profileState.user!.posts.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text("Posts"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  profileState.user!.followers.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text("Followers"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  profileState.user!.following.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text("Following"),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfileScreen(user: profileState.user!),
                              ),
                            );
                          },
                          child: const Text('Edit Profile'),
                        ),
                      ],
                    )
                  : const Center(
                      child: Text("No profile information available")),
    );
  }
}
