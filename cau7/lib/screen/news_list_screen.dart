import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/news_service.dart';

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key, NewsService? newsService})
    : _newsService = newsService;

  final NewsService? _newsService;

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late final NewsService _newsService;

  List<News> _newsList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _newsService = widget._newsService ?? NewsService();
    _loadNews();
  }

  Future<void> _loadNews({bool isRefresh = false}) async {
    if (!isRefresh && !_isLoading && mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    try {
      final data = await _newsService.getNews();
      if (!mounted) return;

      setState(() {
        _newsList = data;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshNews() async {
    await _loadNews(isRefresh: true);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Dữ liệu đã được refresh')),
    );
  }

  Widget _buildNewsItem(News news) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: news.image.isNotEmpty
            ? Image.network(
          news.image,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.image_not_supported);
          },
        )
            : const Icon(Icons.article),
        title: Text(news.title),
        subtitle: Text(
          news.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tuc'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _refreshNews,
        child: _newsList.isEmpty
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 300),
            Center(child: Text('Không có dữ liệu')),
          ],
        )
            : ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: _newsList.length,
          itemBuilder: (context, index) {
            return _buildNewsItem(_newsList[index]);
          },
        ),
      ),
    );
  }
}