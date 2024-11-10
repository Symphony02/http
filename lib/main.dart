import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: NewsApp(),
    );
  }
}

class NewsApp extends StatefulWidget {
  @override
  _NewsAppState createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  List<dynamic> _articles = [];
  String _selectedCategory = 'general'; // Default category

  @override
  void initState() {
    super.initState();
    _fetchNews(); // Fetch initial news data
  }

  // Fetch news data based on the selected category
  Future<void> _fetchNews() async {
    final url =
        'https://newsapi.org/v2/top-headlines?country=us&category=$_selectedCategory&apiKey=YOUR_API_KEY';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _articles = data['articles'];
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  // Update category and fetch news
  void _updateCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _fetchNews();
    Navigator.pop(context); // Close the drawer after selecting category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App - ${_selectedCategory.toUpperCase()}'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Categories',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('General'),
              onTap: () => _updateCategory('general'),
            ),
            ListTile(
              title: Text('Business'),
              onTap: () => _updateCategory('business'),
            ),
            ListTile(
              title: Text('Entertainment'),
              onTap: () => _updateCategory('entertainment'),
            ),
            ListTile(
              title: Text('Health'),
              onTap: () => _updateCategory('health'),
            ),
            ListTile(
              title: Text('Science'),
              onTap: () => _updateCategory('science'),
            ),
            ListTile(
              title: Text('Sports'),
              onTap: () => _updateCategory('sports'),
            ),
            ListTile(
              title: Text('Technology'),
              onTap: () => _updateCategory('technology'),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchNews,
        child: _articles.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: _articles.length,
                itemBuilder: (context, index) {
                  final article = _articles[index];
                  return ListTile(
                    title: Text(article['title'] ?? 'No Title'),
                    subtitle: Text(article['description'] ?? 'No Description'),
                    onTap: () {
                      // Optional: Open article URL
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(article['title'] ?? 'No Title'),
                          content: Text(article['description'] ?? 'No Description'),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }
}
