import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/bloc/instagram_cubit.dart';
import 'package:instagram_clone/bloc/instagram_states.dart';
import 'package:instagram_clone/utils/colors.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InstagramCubit, InstagrameStates>(
      listener: (context, state) {
        if (state is PostUploadSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('post created')),
          );
        } else if (state is PostUploadErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.err)),
          );
        }
      },
      builder: (context, state) {
        TextEditingController? _controller = TextEditingController();
        return InstagramCubit.get(context).postImage == null
            ? Center(
                child: IconButton(
                  enableFeedback: true,
                  onPressed: () {
                    InstagramCubit.get(context).selectImage(context);
                  },
                  icon: const Icon(Icons.upload),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: mobileBackgroundColor,
                  leading: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_back),
                  ),
                  title: const Text('Post to'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        if (state is! PostUploadLoadingState) {
                          InstagramCubit.get(context)
                              .uploadPost(desc: _controller.text);
                        }
                      },
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          color: blueColor,
                        ),
                      ),
                    ),
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (state is PostUploadLoadingState)
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(
                                InstagramCubit.get(context).user!.photo),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextField(
                              controller: _controller,
                              decoration: const InputDecoration(
                                hintText: 'write a caption ',
                                border: InputBorder.none,
                              ),
                              maxLines: 8,
                            ),
                          ),
                          SizedBox(
                            width: 45,
                            height: 45,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(
                                      InstagramCubit.get(context).postImage!),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ));
      },
    );
  }
}
