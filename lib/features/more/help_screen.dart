import 'package:flutter/material.dart';
import 'package:readify/core/theme/app_color.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('Help')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Android',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Ask question'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('Contact us'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              tabs: [
                Tab(text: 'Articles'),
                Tab(text: 'Questions & Answers'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: const [
                      _ArticleTile(
                        title: 'Where can I find my shelves on Readify?',
                        info: '50975 Views  .  Nov 11, 2023  .  Knowledge',
                      ),
                    ],
                  ),
                  ListView(
                    padding: const EdgeInsets.all(20),
                    children: const [
                      _QuestionTile(),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleTile extends StatelessWidget {
  final String title;
  final String info;

  const _ArticleTile({required this.title, required this.info});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            info,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionTile extends StatelessWidget {
  const _QuestionTile();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why is my book count for my reading challenge wrong? '
              'It says I have read 31 when I have only read 29. How can I fix this?',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 8),
        Text(
          'Android . July 11, 2023 at 2:30 AM',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.visibility_outlined,
                size: 18, color: AppColors.textSecondary),
            SizedBox(width: 4),
            Text('144'),
            SizedBox(width: 16),
            Icon(Icons.thumb_up_alt_outlined,
                size: 18, color: AppColors.textSecondary),
            SizedBox(width: 4),
            Text('2'),
            SizedBox(width: 16),
            Icon(Icons.chat_bubble_outline,
                size: 18, color: AppColors.textSecondary),
            SizedBox(width: 4),
            Text('1'),
            SizedBox(width: 16),
            Icon(Icons.check_circle_outline,
                size: 18, color: AppColors.primary),
            SizedBox(width: 4),
            Text('Answered', style: TextStyle(color: AppColors.primary)),
          ],
        ),
      ],
    );
  }
}