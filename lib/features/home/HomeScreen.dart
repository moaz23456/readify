import 'package:flutter/material.dart';
import 'package:readify/core/theme/app_color.dart';
import 'package:readify/core/widgets/brown_app_bar.dart';
import 'package:readify/features/home/data/home_repository.dart';
import 'package:readify/features/home/widgets/feed_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = HomeRepository();
  late Future<List<FeedItem>> _feedFuture;

  @override
  void initState() {
    super.initState();
    _feedFuture = _repository.getFeed();
  }

  void _reload() {
    setState(() {
      _feedFuture = _repository.getFeed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrownAppBar(title: 'Home'),
      body: FutureBuilder<List<FeedItem>>(
        future: _feedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Something went wrong'),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _reload,
                    child: const Text('Try again'),
                  ),
                ],
              ),
            );
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No activity yet'));
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () async => _reload(),
            child: ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return FeedCard(item: items[index]);
              },
            ),
          );
        },
      ),
    );
  }
}