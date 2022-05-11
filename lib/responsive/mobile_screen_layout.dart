import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/bloc/instagram_cubit.dart';
import 'package:instagram_clone/bloc/instagram_states.dart';
import 'package:instagram_clone/utils/colors.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstagramCubit, InstagrameStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: PageView(
            children: InstagramCubit.get(context).pages,
            controller: InstagramCubit.get(context).pageController,
            physics: const NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: primaryColor,
            currentIndex: InstagramCubit.get(context).currentIndex,
            onTap: InstagramCubit.get(context).pageChange,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: mobileBackgroundColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
                backgroundColor: mobileBackgroundColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_circle),
                label: 'Post',
                backgroundColor: mobileBackgroundColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favories',
                backgroundColor: mobileBackgroundColor,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: mobileBackgroundColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
