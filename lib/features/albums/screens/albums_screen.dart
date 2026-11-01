import 'package:axscend_tech_test/config/app_theme.dart';
import 'package:axscend_tech_test/features/albums/models/album.dart';
import 'package:axscend_tech_test/features/albums/providers/albums_provider.dart';
import 'package:axscend_tech_test/features/albums/repositories/album_repository.dart';
import 'package:axscend_tech_test/networking/api_client.dart';
import 'package:axscend_tech_test/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Albums')),
      body: ChangeNotifierProvider(
        create: (_) =>
            AlbumsProvider(repo: AlbumRepository(ApiClient()), userId: userId),
        child: const AlbumList(),
      ),
    );
  }
}

class AlbumList extends StatefulWidget {
  const AlbumList({super.key});

  @override
  State<AlbumList> createState() => _AlbumListState();
}

class _AlbumListState extends State<AlbumList> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AlbumsProvider>();

    return RefreshIndicator(
      onRefresh: () => provider.refresh(),
      child: GridView.builder(
        itemCount: provider.albums.length + (provider.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (provider.hasError) {
            return const ErrorMessageWidget();
          }

          if (index == provider.albums.length) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              provider.loadNextPage();
            });

            return const Center(child: CircularProgressIndicator());
          }

          final album = provider.albums[index];

          return AlbumCard(album: album);
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
      ),
    );
  }
}

class AlbumCard extends StatelessWidget {
  const AlbumCard({super.key, required this.album});

  final Album album;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () => context.go('./${album.id}/photos'),
      child: SizedBox(
        height: 200,
        child: Card(
          color: AppColors.albumBackground,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(album.title, style: theme.textTheme.bodyMedium),
            ),
          ),
        ),
      ),
    );
  }
}
