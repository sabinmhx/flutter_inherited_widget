import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyScreen(),
    );
  }
}

/// Inherited Widget to transfer data down the widget tree

class MyInheritedWidget extends InheritedWidget {
  final Widget child;
  final String text;
  const MyInheritedWidget({
    Key? key,
    required this.child,
    required this.text,
  }) : super(key: key, child: child);

  /// Method to take nearest instance of MyInheritedWidget from the context

  static MyInheritedWidget of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MyInheritedWidget>()!;

  @override
  bool updateShouldNotify(MyInheritedWidget oldWidget) =>
      oldWidget.text != text;
}

/// Class to manage state and notify listeners
class Update with ChangeNotifier {
  String text = "Old";

  /// Method to update the text and notify listeners

  updateText(String newText) {
    text = newText;
    notifyListeners();
  }
}

class MyScreen extends StatelessWidget {
  MyScreen({super.key});
  final notifier = Update();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inherited Widget"),
      ),
      body: ListenableBuilder(
        listenable: notifier,
        builder: (context, child) {
          return MyInheritedWidget(
            text: notifier.text, // Pass the text from the notifier
            child: Builder(
              builder: (BuildContext innerContext) {
                // Access the text using MyInheritedWidget.of(context)
                return Center(
                  child: Text(MyInheritedWidget.of(innerContext).text),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          notifier.updateText("New"); // Update the text when button is pressed
        },
        child: const Text("Update"),
      ),
    );
  }
}
