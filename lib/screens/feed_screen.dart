import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/bloc/instagram_cubit.dart';
import 'package:instagram_clone/bloc/instagram_states.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/constant.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstagramCubit, InstagrameStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: MediaQuery.of(context).size.width > webWidth
              ? null
              : AppBar(
                  backgroundColor: MediaQuery.of(context).size.width > 600
                      ? webBackgroundColor
                      : mobileBackgroundColor,
                  title: SvgPicture.asset('assets/ic_instagram.svg',
                      color: primaryColor, height: 32),
                  centerTitle: false,
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.message_outlined,
                          color: primaryColor),
                    ),
                  ],
                ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('posts').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data?.docs.length ?? 0,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.symmetric(
                    vertical:
                        MediaQuery.of(context).size.width > webWidth ? 15 : 0,
                    horizontal: MediaQuery.of(context).size.width > webWidth
                        ? MediaQuery.of(context).size.width * 0.3
                        : 0,
                  ),
                  child: PostCard(
                    snap: snapshot.data!.docs[index],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
