import 'package:axscend_tech_test/features/albums/models/photo.dart';
import 'package:axscend_tech_test/features/albums/providers/photos_provider.dart';
import 'package:axscend_tech_test/features/albums/repositories/album_repository.dart';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:axscend_tech_test/widgets/error_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotosScreen extends StatelessWidget {
  const PhotosScreen({super.key, required this.albumId});

  final int albumId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photos')),
      body: ChangeNotifierProvider(
        create: (_) => PhotosProvider(
          repo: AlbumRepository(context.read<ApiClient>()),
          albumId: albumId,
        ),
        child: const PhotoList(),
      ),
    );
  }
}

class PhotoList extends StatefulWidget {
  const PhotoList({super.key});

  @override
  State<PhotoList> createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PhotosProvider>();

    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: GridView.builder(
        itemCount: provider.photos.length + (provider.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (provider.hasError) {
            return const ErrorMessageWidget();
          }

          if (index == provider.photos.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.loadNextPage();
            });

            return const Center(child: CircularProgressIndicator());
          }

          final photo = provider.photos[index];

          return PhotoCard(photo: photo);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
      ),
    );
  }
}

class PhotoCard extends StatelessWidget {
  const PhotoCard({super.key, required this.photo});

  final Photo photo;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: .antiAlias,
      child: CachedNetworkImage(imageUrl: photo.thumbnailUrl),
    );
  }
}
