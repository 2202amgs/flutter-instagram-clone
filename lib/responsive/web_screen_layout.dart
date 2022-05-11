import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../bloc/instagram_cubit.dart';
import '../bloc/instagram_states.dart';

class WebScreenLayout extends StatelessWidget {
  const WebScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstagramCubit, InstagrameStates>(
      listener: (context, state) {},
      builder: (context, state) {
        InstagramCubit cubit = InstagramCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: webBackgroundColor,
            title: SvgPicture.asset('assets/ic_instagram.svg',
                color: primaryColor, height: 32),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () {
                  cubit.pageChange(0);
                },
                icon: Icon(
                  Icons.home,
                  color:
                      cubit.currentIndex == 0 ? primaryColor : secondaryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  cubit.pageChange(1);
                },
                icon: Icon(
                  Icons.search,
                  color:
                      cubit.currentIndex == 1 ? primaryColor : secondaryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  cubit.pageChange(2);
                },
                icon: Icon(
                  Icons.add_a_photo,
                  color:
                      cubit.currentIndex == 2 ? primaryColor : secondaryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  cubit.pageChange(3);
                },
                icon: Icon(
                  Icons.favorite,
                  color:
                      cubit.currentIndex == 3 ? primaryColor : secondaryColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  cubit.pageChange(4);
                },
                icon: Icon(
                  Icons.person,
                  color:
                      cubit.currentIndex == 4 ? primaryColor : secondaryColor,
                ),
              ),
            ],
          ),
          body: PageView(
            controller: cubit.pageController,
            children: cubit.pages,
          ),
        );
      },
    );
  }
}
