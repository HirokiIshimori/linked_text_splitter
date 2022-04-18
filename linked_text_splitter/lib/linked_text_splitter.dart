library linked_text_splitter;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:linked_text_splitter/model/constants.dart';

class LinkedTextSplitter {
  final RegExp linkRegExp;
  final RegExp atSignRegExp;
  final RegExp hashTagRegExp;
  final TextStyle linkStyle;
  Iterable<String>? filteredMemberList;
  Iterable<String>? filteredHashTagList;
  final Function(String match)? onLinkTap;
  final Function(String match)? onAtSignTap;
  final Function(String match)? onHashTagTap;

  LinkedTextSplitter({
    required this.linkRegExp,
    required this.linkStyle,
    required this.atSignRegExp,
    required this.hashTagRegExp,
    required this.filteredMemberList,
    required this.filteredHashTagList,
    this.onLinkTap,
    this.onAtSignTap,
    this.onHashTagTap,
  });

  LinkedTextSplitter.normal({
    this.filteredMemberList,
    this.filteredHashTagList,
    required this.linkStyle,
    this.onLinkTap,
    this.onAtSignTap,
    this.onHashTagTap
  }) : linkRegExp = defaultLinkRegExp,
        atSignRegExp = defaultAtSignRegExp,
        hashTagRegExp = defaultHashTagRegExp;

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
    '(?!\\n)(?:^|\\s)([@]([$_regExp]+))',
    multiLine: true,
  );

  static final defaultHashTagRegExp = RegExp(
    '(?!\\n)(?:^|\\s)([#]([$_regExp]+))',
    multiLine: true,
  );

  List<TextSpan> create(String text, TextStyle? style) {
    final children = <TextSpan>[];

    _split(
      text: text,
      regExp: linkRegExp,
      style: style,
      children: children,
      onTap: onLinkTap,
      onNonMatch: (string, children) {
        _split(
          text: string,
          regExp: atSignRegExp,
          style: style,
          children: children,
          onTap: onAtSignTap,
          matchList: filteredMemberList?.map((e) => '@$e'),
          onNonMatch: (string, children) {
            _split(
              text: string,
              regExp: hashTagRegExp,
              style: style,
              children: children,
              onTap: onHashTagTap,
              matchList: filteredHashTagList?.map((e) => '#$e'),
              onNonMatch: (string, children) {
                children.add(TextSpan(text: string, style: style));
              },
            );
          },
        );
      },
    );

    return children.where((element) => element.text?.isNotEmpty ?? false).toList();
  }

  void _split({
    required String text,
    required RegExp regExp,
    required List<TextSpan> children,
    TextStyle? style,
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

    final TapGestureRecognizer? recognizer;
    if (onTap != null) {

    }

    text.splitMapJoin(
      regExp,
      onMatch: (match) {
        children.add(
          TextSpan(
            text: match[0],
            style:
            _checkMatch(match[0].toString()) ? style : linkStyle,
            recognizer: onTap != null ?
            (TapGestureRecognizer()..onTap = () {
              final word = match[0];
                if (word != null) {
                  onTap(word);
                }
            }) : null,
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