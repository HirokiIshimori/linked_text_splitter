import 'package:flutter/material.dart';
import 'package:linked_text_splitter/linked_text_splitter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final LinkedTextEditingController linkedTextEditingController;

  @override
  void initState() {
    super.initState();
    linkedTextEditingController = LinkedTextEditingController(
      text: '@user https://www.google.com #Test',
      linkStyle: const TextStyle(
        color: Colors.blue,
      ),
      memberNames: ['king', 'user'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              RichText(
                text: TextSpan(
                  children: LinkedTextSplitter.normal(
                      linkStyle: const TextStyle(
                        color: Colors.blue,
                      ),
                      onAtSignTap: (value) {
                        print('Name: $value');
                      },
                      onLinkTap: (value) async {
                        await launch(value);
                        print('Link: $value');
                      },
                      onHashTagTap: (value) {
                        print('Tag: $value');
                      }
                  ).create(
                    '@user https://www.google.com test. #Hello',
                    const TextStyle(color: Colors.black
                    )
                  ),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: TextField(
                  controller: linkedTextEditingController,
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red)
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LinkedTextEditingController extends TextEditingController {
  final TextStyle linkStyle;
  List<String>? memberNames;

  LinkedTextEditingController({
    String? text,
    required this.linkStyle,
    this.memberNames,
  })  : super(text: text);

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing
  }) {
    final splitter = LinkedTextSplitter(
      linkStyle: linkStyle,
      linkRegExp: LinkedTextSplitter.defaultLinkRegExp,
      atSignRegExp: LinkedTextSplitter.defaultAtSignRegExp,
      hashTagRegExp: LinkedTextSplitter.defaultHashTagRegExp,
      filteredMemberList: memberNames,
      filteredHashTagList: null,
    );

    return TextSpan(style: style, children: splitter.create(text, style));
  }
}