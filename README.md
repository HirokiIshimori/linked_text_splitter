# linked_text_splitter
Convert text containing hyperlinks, etc., into a "TextSpan" list.

It supports hyperlinks, @ marks, and hashtags like Twitter.

<img width=250, src="https://user-images.githubusercontent.com/36340609/164297956-db31d803-3e7c-436e-b707-65ba93fa74a5.gif"/>

The @ marks and hashtags can also be filtered. Only matching string candidates can be link-colored.

If you wish to use this feature, specify the "filteredMemberList" or "filteredHashTagList" property.

```dart
final splitter = LinkedTextSplitter(
  linkStyle: linkStyle,
  linkRegExp: LinkedTextSplitter.defaultLinkRegExp,
  atSignRegExp: LinkedTextSplitter.defaultAtSignRegExp,
  hashTagRegExp: LinkedTextSplitter.defaultHashTagRegExp,
  filteredMemberList: ['king', 'user'],
  filteredHashTagList: ['test'],
);
```

## Usage

### RichText Widget

Use LinkedTextSplitter for RichText's text property.

```dart
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
)
```

### TextField Widget

To support TextField, create a custom TextEditingController class.

This is an example.

```dart
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
```

In this example, only "king" and "user" are set to blue text with the @ marks.

```dart
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
```

After that, we can apply the TextEditingController custom class to the controller property of TextFiled.

```dart
TextField(
  controller: linkedTextEditingController,
  decoration: const InputDecoration(
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red)
    ),
  ),
  keyboardType: TextInputType.multiline,
  maxLines: 10,
),
```
