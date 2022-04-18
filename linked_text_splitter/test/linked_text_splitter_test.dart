import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:linked_text_splitter/linked_text_splitter.dart';

void main() {
  group('LinkedTextSplitter Test', (){
    final memberList = [
      'king',
      'queen',
      'jack',
      'ace',
      'joker',
    ];

    final hashTagList = <String>[
      'car',
      'bike',
      'airplane',
      'ship',
    ];

    final splitter = LinkedTextSplitter.normal(
      linkStyle: const TextStyle(
        color: Colors.blue,
      ),
      filteredMemberList: memberList,
      filteredHashTagList: hashTagList,
    );

    test('No link, no assignment.', () {
      final children = splitter.create(
        'AAAAAAA',
        const TextStyle(color: Colors.red),
      );
      expect(children.length, 1);
      expect(children[0].style?.color, Colors.red);
      expect(children[0].text, 'AAAAAAA');
    });

    test('linked, no assignment.', () {
      var children = splitter.create(
        'AAAAAAA http://www.google.com BBBBB',
        const TextStyle(color: Colors.red),
      );
      expect(children.length, 3);
      expect(children[0].style?.color, Colors.red);
      expect(children[1].style?.color, Colors.blue);
      expect(children[2].style?.color, Colors.red);

      expect(children[0].text, 'AAAAAAA ');
      expect(children[1].text, 'http://www.google.com');
      expect(children[2].text, ' BBBBB');

      children.clear();

      children = splitter.create(
        'http://www.google.com BBBBB AAAAAAA',
        const TextStyle(color: Colors.red),
      );

      expect(children.length, 2);
      expect(children[0].style?.color, Colors.blue);
      expect(children[1].style?.color, Colors.red);

      expect(children[0].text, 'http://www.google.com');
      expect(children[1].text, ' BBBBB AAAAAAA');

      children = splitter.create(
        'BBBBB AAAAAAA http://www.google.com',
        const TextStyle(color: Colors.red),
      );

      expect(children.length, 2);
      expect(children[0].style?.color, Colors.red);
      expect(children[1].style?.color, Colors.blue);

      expect(children[0].text, 'BBBBB AAAAAAA ');
      expect(children[1].text, 'http://www.google.com');

      children = splitter.create(
        'http://www.google.com BBBBB https://www.yahoo.co.jp AAAAAAA https://twitter.com/Butaiura_pr',
        const TextStyle(color: Colors.red),
      );

      expect(children.length, 5);
      expect(children[0].style?.color, Colors.blue);
      expect(children[1].style?.color, Colors.red);
      expect(children[2].style?.color, Colors.blue);
      expect(children[3].style?.color, Colors.red);
      expect(children[4].style?.color, Colors.blue);

      expect(children[0].text, 'http://www.google.com');
      expect(children[1].text, ' BBBBB ');
      expect(children[2].text, 'https://www.yahoo.co.jp');
      expect(children[3].text, ' AAAAAAA ');
      expect(children[4].text, 'https://twitter.com/Butaiura_pr');

      children = splitter.create(
        'BBBBB AAAAAAA http://www.google.com',
        const TextStyle(color: Colors.red),
      );

      expect(children.length, 2);
      expect(children[0].style?.color, Colors.red);
      expect(children[1].style?.color, Colors.blue);

      expect(children[0].text, 'BBBBB AAAAAAA ');
      expect(children[1].text, 'http://www.google.com');
    });

    test('No link, assigned.', () {
      var children = splitter.create(
        '@king AAAAAAA',
        const TextStyle(color: Colors.red),
      );

      expect(children.length, 2);
      expect(children[0].style?.color, Colors.blue);
      expect(children[1].style?.color, Colors.red);
      expect(children[0].text, '@king');
      expect(children[1].text, ' AAAAAAA');

      children = splitter.create(
        '@king AAAAAAA @queen BBBBBB',
        const TextStyle(color: Colors.red),
      );

      expect(children.length, 4);
      expect(children[0].style?.color, Colors.blue);
      expect(children[1].style?.color, Colors.red);
      expect(children[2].style?.color, Colors.blue);
      expect(children[3].style?.color, Colors.red);
      expect(children[0].text, '@king');
      expect(children[1].text, ' AAAAAAA');
      expect(children[2].text, ' @queen');
      expect(children[3].text, ' BBBBBB');

      children = splitter.create(
        '@king @jack @heart AAAAAAA BBBBBB',
        const TextStyle(color: Colors.red),
      );

      expect(children.length, 4);
      expect(children[0].style?.color, Colors.blue);
      expect(children[1].style?.color, Colors.blue);
      expect(children[2].style?.color, Colors.red);
      expect(children[3].style?.color, Colors.red);
      expect(children[0].text, '@king');
      expect(children[1].text, ' @jack');
      expect(children[2].text, ' @heart');
      expect(children[3].text, ' AAAAAAA BBBBBB');
    });

    test('No link, assigned.', () {
      var children = splitter.create(
        '@king AAAAAAA',
        const TextStyle(color: Colors.red),
      );

      expect(children.length, 2);
      expect(children[0].style?.color, Colors.blue);
      expect(children[1].style?.color, Colors.red);
      expect(children[0].text, '@king');
      expect(children[1].text, ' AAAAAAA');

      children = splitter.create(
        '@king AAAAAAA @queen BBBBBB',
        const TextStyle(color: Colors.red),
      );

      expect(children.length, 4);
      expect(children[0].style?.color, Colors.blue);
      expect(children[1].style?.color, Colors.red);
      expect(children[2].style?.color, Colors.blue);
      expect(children[3].style?.color, Colors.red);
      expect(children[0].text, '@king');
      expect(children[1].text, ' AAAAAAA');
      expect(children[2].text, ' @queen');
      expect(children[3].text, ' BBBBBB');

      children = splitter.create(
        '@king @jack @heart AAAAAAA BBBBBB',
        const TextStyle(color: Colors.red),
      );

      expect(children.length, 4);
      expect(children[0].style?.color, Colors.blue);
      expect(children[1].style?.color, Colors.blue);
      expect(children[2].style?.color, Colors.red);
      expect(children[3].style?.color, Colors.red);
      expect(children[0].text, '@king');
      expect(children[1].text, ' @jack');
      expect(children[2].text, ' @heart');
      expect(children[3].text, ' AAAAAAA BBBBBB');
    });

    test('Linked, assigned.', () {
      final children = splitter.create(
        '@king AAAAAAA http://www.google.com @joker ああああいいい https://www.yahoo.co.jp',
        const TextStyle(color: Colors.red),
      );

      expect(children.length, 6);
      expect(children[0].style?.color, Colors.blue);
      expect(children[1].style?.color, Colors.red);
      expect(children[2].style?.color, Colors.blue);
      expect(children[3].style?.color, Colors.blue);
      expect(children[4].style?.color, Colors.red);
      expect(children[5].style?.color, Colors.blue);

      expect(children[0].text, '@king');
      expect(children[1].text, ' AAAAAAA ');
      expect(children[2].text, 'http://www.google.com');
      expect(children[3].text, ' @joker');
      expect(children[4].text, ' ああああいいい ');
      expect(children[5].text, 'https://www.yahoo.co.jp');
    });

    test('Linked, assigned, hashTag.', () {
      final children = splitter.create(
        '@king AAAAAAA http://www.google.com @joker ああああいいい #car https://www.yahoo.co.jp',
        const TextStyle(color: Colors.red),
      );
      
      expect(children.length, 8);
      expect(children[0].style?.color, Colors.blue);
      expect(children[1].style?.color, Colors.red);
      expect(children[2].style?.color, Colors.blue);
      expect(children[3].style?.color, Colors.blue);
      expect(children[4].style?.color, Colors.red);
      expect(children[5].style?.color, Colors.blue);
      expect(children[6].style?.color, Colors.red);
      expect(children[7].style?.color, Colors.blue);

      expect(children[0].text, '@king');
      expect(children[1].text, ' AAAAAAA ');
      expect(children[2].text, 'http://www.google.com');
      expect(children[3].text, ' @joker');
      expect(children[4].text, ' ああああいいい');
      expect(children[5].text, ' #car');
      expect(children[6].text, ' ');
      expect(children[7].text, 'https://www.yahoo.co.jp');
    });
  });


}