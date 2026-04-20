import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cau7/models/news.dart';
import 'package:cau7/screen/news_list_screen.dart';
import 'package:cau7/services/news_service.dart';

class FakeNewsService extends NewsService {
  int callCount = 0;

  @override
  Future<List<News>> getNews() async {
    callCount++;

    if (callCount == 1) {
      return [
        News(
          id: '1',
          title: 'Tin cu',
          content: 'Noi dung cu',
          image: '',
        ),
      ];
    }

    return [
      News(
        id: '2',
        title: 'Tin moi',
        content: 'Noi dung moi',
        image: '',
      ),
    ];
  }
}

void main() {
  testWidgets('Pull to refresh reloads news data', (WidgetTester tester) async {
    final fakeService = FakeNewsService();

    await tester.pumpWidget(
      MaterialApp(home: NewsListScreen(newsService: fakeService)),
    );

    await tester.pumpAndSettle();

    expect(find.text('Tin cu'), findsOneWidget);
    expect(fakeService.callCount, 1);

    await tester.drag(find.byType(ListView), const Offset(0, 300));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.text('Tin moi'), findsOneWidget);
    expect(fakeService.callCount, 2);
  });
}
