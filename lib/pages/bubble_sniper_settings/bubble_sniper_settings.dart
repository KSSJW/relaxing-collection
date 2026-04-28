import 'package:flutter/material.dart';
import 'package:relaxing_collection/pages/bubble_sniper/bubble_sniper_functions.dart';

class BubbleSniperSettings extends StatefulWidget{
  const BubbleSniperSettings({super.key});
  
  @override
  State<StatefulWidget> createState() => BubbleSniperSettingsState();
}

class BubbleSniperSettingsState extends State<BubbleSniperSettings> {
  late Future _initFuture;

  int _duration = 50;

  Future<bool> _init() async {
    final result = await Future.wait([
      BubbleSniperFunctions().getDuration()
    ]);

    setState(() {
      _duration = result[0];
    });

    return true;
  }

  @override
  void initState() {
    super.initState();

    _initFuture = _init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        
        return Scaffold(
          appBar: AppBar(title: const Text("Bubble Sniper Settings")),
          body: ListView(
            children: [
              Column(
                children: [
                  Text("Some features require a restart to take effect.")
                ],
              ),

              SizedBox(height: 16.0),

              ListTile(
                leading: const Icon(Icons.bubble_chart),
                title: const Text("Bubble Duration"),
                trailing: Text(
                  "$_duration ms",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Slider(
                value: _duration.toDouble(),
                min: 0.0,
                max: 1000.0,
                divisions: 100,
                label: _duration.toString(),
                onChanged: (value) {
                  setState(() {
                    _duration = value.toInt();
                  });
                },
                onChangeEnd: (value) {
                  BubbleSniperFunctions().saveDuration(value.toInt());
                },
              ),

              const Divider(),

              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text("Delete Record"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Delete Record"),
                        content: const Text(
                          "Your record will be deleted.",
                          style: TextStyle(
                            color: Colors.red
                          ),
                        ),
                        actions: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                child: Text("Cancel"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text("Delete"),
                                onPressed: () {
                                  BubbleSniperFunctions().saveHighScore(0);
                                  BubbleSniperFunctions().saveLowestLatency(0);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          )
                        ],
                      );
                    }
                  );
                }
              )
            ],
          ),
        );
      },
    );
  }
}