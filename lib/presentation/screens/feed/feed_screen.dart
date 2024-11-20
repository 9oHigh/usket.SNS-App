import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sns_app/data/models/post_model.dart';
import 'package:sns_app/presentation/screens/feed/provider/feed_notifier_provider.dart';
import 'package:sns_app/presentation/screens/signin/provider/signin_notifier_provider.dart';
import 'package:sns_app/presentation/widgets/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedNotifier = ref.read(feedNotifierProvider.notifier);
    final feedState = ref.watch(feedNotifierProvider);
    final signinState = ref.watch(signinNotifierProvider);

    return Scaffold(
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return PostCard(
                          post: PostModel.fromDocument(
                              snapshot.data!.docs[index]));
                    });
              } else {
                return Container();
              }
            }));
  }
}
