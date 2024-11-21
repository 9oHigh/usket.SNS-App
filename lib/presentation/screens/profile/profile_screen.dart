import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sns_app/presentation/screens/profile/provider/profile_notifier_provider.dart';

class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = 3;
    final spacing = 4.0;
    final itemWidth =
        (screenWidth - spacing * (crossAxisCount - 1)) / crossAxisCount;

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
                          Navigator.pushNamed(context, '/signin');
                        },
                        child: Text('Go to Login'),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Followers'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    profileState.user!.followings.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Following'),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    profileState.userPosts.length.toString(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('Posts'),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          TextButton(
                            onPressed: () {
                              context.push('/profileEdit');
                            },
                            child: Text('프로필 수정'),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: profileState.userPosts.isEmpty
                          ? Center(child: Text('게시물이 없습니다.'))
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 0),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                spacing: spacing,
                                runSpacing: spacing,
                                children: _buildPhotoGrid(
                                  profileState.userPosts.length,
                                  crossAxisCount,
                                  itemWidth,
                                  profileState.userPosts.map((post) {
                                    return Container(
                                      width: itemWidth,
                                      height: itemWidth,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: NetworkImage(post.imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
    );
  }

  List<Widget> _buildPhotoGrid(
    int totalPhotos,
    int crossAxisCount,
    double itemWidth,
    List<Widget> photoWidgets,
  ) {
    final remainder = totalPhotos % crossAxisCount;

    if (remainder > 0) {
      final emptySpaces = crossAxisCount - remainder;
      for (int i = 0; i < emptySpaces; i++) {
        photoWidgets.add(Container(
          width: itemWidth,
          height: itemWidth,
          color: Colors.transparent,
        ));
      }
    }
    return photoWidgets;
  }
}
