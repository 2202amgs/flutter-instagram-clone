import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/constant.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool isShowUser = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          decoration: const InputDecoration(
            labelText: 'search for user',
            border: InputBorder.none,
          ),
          controller: _controller,
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                isShowUser = false;
              });
            }
          },
          onFieldSubmitted: (value) {
            setState(() {
              isShowUser = true;
            });
          },
        ),
      ),
      body: isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where('username', isGreaterThanOrEqualTo: _controller.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                              userId: (snapshot.data! as dynamic).docs[index]
                                  ['uid'])));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          (snapshot.data! as dynamic).docs[index]['photo']),
                    ),
                    title: Text(
                        (snapshot.data! as dynamic).docs[index]['username']),
                  ),
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  const Center(child: CircularProgressIndicator());
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (BuildContext context, int index) =>
                      Image.network(
                          (snapshot.data! as dynamic).docs[index]['photourl'],
                          fit: BoxFit.cover),
                  staggeredTileBuilder: (int index) =>
                      MediaQuery.of(context).size.width > webWidth
                          ? StaggeredTile.count(
                              (index % 7 == 0) ? 2 : 1,
                              (index % 7 == 0) ? 2 : 1,
                            )
                          : StaggeredTile.count(
                              (index % 7 == 0) ? 1 : 1,
                              (index % 7 == 0) ? 1 : 1,
                            ),
                );
              },
            ),
    );
  }
}
