import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testing_bloc/bloc/app_bloc.dart';
import 'package:testing_bloc/bloc/app_event.dart';
import 'package:testing_bloc/bloc/app_state.dart';
import 'package:testing_bloc/views/main_popup_menu.dart';
import 'package:testing_bloc/views/storage_image_view.dart';

class FlutterGalleryView extends HookWidget {
  const FlutterGalleryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final picker = useMemoized(() => ImagePicker(), [key]);
    final images = context.watch<AppBloc>().state.images ?? [];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo Gallery'),
        actions: [
          IconButton(
            onPressed: () async {
              final image = await picker.pickImage(
                source: ImageSource.gallery,
              );
              if (image == null) {
                return;
              } else {
                context.read<AppBloc>().add(
                      AppEventToUploadImage(filePathToUpload: image.path),
                    );
              }
            },
            icon: const Icon(Icons.upload),
          ),
          const MainPopUpMenuButton(),
        ],
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: images
            .map(
              (img) => StorageImageView(image: img),
            )
            .toList(),
      ),
    );
  }
}
