import 'package:flutter/material.dart';
import 'package:relaxing_collection/pages/home/bubble_breaker/bubble_breaker.dart';

class Home extends StatefulWidget{
  const Home({super.key});
  
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  late Future _initFuture;
  final List<Map<String, Object>> _games = [
    {"color": Colors.cyan,        "icon": Icons.bubble_chart, "title": "Bubble Breaker",  "game": BubbleBreaker()},
    {"color": Colors.blueAccent,  "icon": Icons.padding,      "title": "Game2",           "game": BubbleBreaker()},
    {"color": Colors.green,       "icon": Icons.radar,        "title": "Game3",           "game": BubbleBreaker()},
    {"color": Colors.amber,       "icon": Icons.face,         "title": "Game4",           "game": BubbleBreaker()},
    {"color": Colors.blueGrey,    "icon": Icons.hail,         "title": "Game5",           "game": BubbleBreaker()}
  ];
  int _crossAxisCount = 2;
  double _childAspectRatio = 4 / 3;

  Future<bool> _init() async {
    return true;
  }

  @override
  void initState() {
    super.initState();

    _initFuture = _init();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final size = MediaQuery.of(context).size;

    setState(() {
      _crossAxisCount = size.width >= size.height ? 3 : 2;
      _childAspectRatio = size.width >= size.height ? 2 / 1 : 4 / 3;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const CircularProgressIndicator();

        return Scaffold(
          appBar: AppBar(title: Text("Relaxing Collection")),
          body: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: _childAspectRatio,
            ),
            itemCount: _games.length,
            itemBuilder: (context, index) {
              Map<String, Object> game = _games[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => game["game"] as Widget,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: game["color"] as Color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        size: 48.0,
                        game["icon"] as IconData,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Text(
                        game["title"] as String,
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }
    );
  }
}