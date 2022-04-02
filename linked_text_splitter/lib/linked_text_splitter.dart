library linked_text_splitter;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linked_text_splitter/model/constants.dart';

class LinkedTextSplitter {
  final RegExp linkRegExp;
  final RegExp atSignRegExp;
  final TextStyle linkStyle;
  Iterable<String>? matchList;
  final Function(String match)? onTap;

  LinkedTextSplitter({
    required this.linkRegExp,
    required this.linkStyle,
    required this.atSignRegExp,
    required this.matchList,
    this.onTap,
  });

  LinkedTextSplitter.normal(
      {this.matchList, required this.linkStyle, required this.onTap})
      : linkRegExp = defaultLinkRegExp,
        atSignRegExp = defaultAtSignRegExp;

  static final _letters = Language.values
      .map((e) => e.letter)
      .reduce((v, e) => v + e);

  static final _regExp =
      symbols + numbers + _letters;

  static final defaultLinkRegExp = RegExp(
    httpRegExp,
    caseSensitive: false,
    dotAll: true,
  );

  static final defaultAtSignRegExp = RegExp(
    '(?:^|\\s)([#@]([$_regExp]+))',
    multiLine: true,
  );

  List<TextSpan> create(String text, TextStyle style) {
    final children = <TextSpan>[];

    _split(
      text: text,
      regExp: linkRegExp,
      style: style,
      children: children,
      onTap: onTap,
      onNonMatch: (string, children) {
        _split(
          text: string,
          regExp: atSignRegExp,
          children: children,
          style: style,
          onNonMatch: (string, children) {
            children.add(TextSpan(text: string, style: style));
          },
          matchList: matchList,
        );
      },
    );

    return children.where((element) => element.text?.isNotEmpty ?? false).toList();
  }

  void _split({
    required String text,
    required RegExp regExp,
    required List<TextSpan> children,
    required TextStyle style,
    Function(String match)? onTap,
    Function(String, List<TextSpan> children)? onNonMatch,
    Iterable<String>? matchList,
  }) {
    bool _checkMatch(String target) {
      if (matchList == null) {
        return false;
      }
      return !matchList.any((e) => e == target.trim());
    }

    text.splitMapJoin(
      regExp,
      onMatch: (match) {
        children.add(
          TextSpan(
            text: match[0],
            style:
            _checkMatch(match[0].toString()) ? style : linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
              final word = match[0];
                if (onTap != null && word != null) {
                  onTap(word);
                }
              },
          ),
        );
        return '';
      },
      onNonMatch: (text) {
        if (onNonMatch != null) {
          onNonMatch(text, children);
        }
        return '';
      },
    );
  }
}