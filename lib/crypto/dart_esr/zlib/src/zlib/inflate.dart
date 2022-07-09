// ignore_for_file: always_use_package_imports, non_constant_identifier_names, prefer_final_locals, unnecessary_parenthesis, cast_nullable_to_non_nullable, avoid_redundant_argument_values, invariant_booleans, constant_identifier_names

import 'dart:typed_data';
import '../util/archive_exception.dart';
import '../util/input_stream.dart';
import '../util/output_stream.dart';
import 'huffman_table.dart';

class Inflate {
  InputStreamBase? input;
  dynamic output;

  Inflate(List<int> bytes, [int? uncompressedSize])
      : input = InputStream(bytes),
        output = OutputStream(size: uncompressedSize) {
    _inflate();
  }

  Inflate.buffer(this.input, [int? uncompressedSize]) : output = OutputStream(size: uncompressedSize) {
    _inflate();
  }

  Inflate.stream([this.input, dynamic output_stream]) : output = output_stream ?? OutputStream() {
    _inflate();
  }

  void streamInput(List<int> bytes) {
    if (input is InputStream) {
      var i = input as InputStream?;
      if (input != null) {
        i!.offset = _blockPos;
      }
      final inputLen = (input == null ? 0 : input!.length);
      final newLen = inputLen + bytes.length;
      final newBytes = Uint8List(newLen);
      if (input != null) {
        newBytes.setRange(0, input!.length, i!.buffer, i.offset);
      }
      newBytes.setRange(inputLen, newLen, bytes, 0);
      input = InputStream(newBytes);
    } else {
      input = InputStream(bytes);
    }
  }

  List<int>? inflateNext() {
    _bitBuffer = 0;
    _bitBufferLen = 0;
    if (output is OutputStream) {
      output.clear();
    }
    if (input == null || input!.isEOS) {
      return null;
    }

    try {
      if (input is InputStream) {
        var i = input as InputStream;
        _blockPos = i.offset;
      }
      _parseBlock();
      // If it didn't finish reading the block, it will have thrown an exception
      _blockPos = 0;
    } catch (e) {
      return null;
    }

    if (output is OutputStream) {
      return output.getBytes() as List<int>?;
    }
    return null;
  }

  /// Get the decompressed data.
  List<int>? getBytes() {
    return output.getBytes() as List<int>?;
  }

  void _inflate() {
    _bitBuffer = 0;
    _bitBufferLen = 0;
    if (input == null) {
      return;
    }

    while (!input!.isEOS) {
      final more = _parseBlock();
      if (!more) {
        break;
      }
    }
  }

  /// Parse deflated block.  Returns true if there is more to read, false
  /// if we're done.
  bool _parseBlock() {
    if (input!.isEOS) {
      return false;
    }

    // Each block has a 3-bit header
    final hdr = _readBits(3);

    // BFINAL (is this the final block)?
    final bfinal = (hdr & 0x1) != 0;

    // BTYPE (the type of block)
    final btype = hdr >> 1;
    switch (btype) {
      case _BLOCK_UNCOMPRESSED:
        _parseUncompressedBlock();
        break;
      case _BLOCK_FIXED_HUFFMAN:
        _parseFixedHuffmanBlock();
        break;
      case _BLOCK_DYNAMIC_HUFFMAN:
        _parseDynamicHuffmanBlock();
        break;
      default:
        // reserved or other
        throw ArchiveException('unknown BTYPE: $btype');
    }

    // Continue while not the final block
    return !bfinal;
  }

  /// Read a number of bits from the input stream.
  int _readBits(int length) {
    if (length == 0) {
      return 0;
    }

    // not enough buffer
    while (_bitBufferLen < length) {
      if (input!.isEOS) {
        throw ArchiveException('input buffer is broken');
      }

      // input byte
      final octet = input!.readByte();

      // concat octet
      _bitBuffer |= octet << _bitBufferLen;
      _bitBufferLen += 8;
    }

    // output byte
    final octet = _bitBuffer & ((1 << length) - 1);
    _bitBuffer >>= length;
    _bitBufferLen -= length;

    return octet;
  }

  /// Read huffman code using [table].
  int _readCodeByTable(HuffmanTable table) {
    final codeTable = table.table;
    final maxCodeLength = table.maxCodeLength;

    // Not enough buffer
    while (_bitBufferLen < maxCodeLength) {
      if (input!.isEOS) {
        break;
      }

      final octet = input!.readByte();

      _bitBuffer |= octet << _bitBufferLen;
      _bitBufferLen += 8;
    }

    // read max length
    final codeWithLength = codeTable![_bitBuffer & ((1 << maxCodeLength) - 1)];
    final codeLength = codeWithLength >> 16;

    _bitBuffer >>= codeLength;
    _bitBufferLen -= codeLength;

    return codeWithLength & 0xffff;
  }

  void _parseUncompressedBlock() {
    // skip buffered header bits
    _bitBuffer = 0;
    _bitBufferLen = 0;

    final len = _readBits(16);
    final nlen = _readBits(16) ^ 0xffff;

    // Make sure the block size checksum is valid.
    if (len != 0 && len != nlen) {
      throw ArchiveException('Invalid uncompressed block header');
    }

    // check size
    if (len > input!.length) {
      throw ArchiveException('Input buffer is broken');
    }

    output.writeInputStream(input!.readBytes(len));
  }

  void _parseFixedHuffmanBlock() {
    _decodeHuffman(_fixedLiteralLengthTable, _fixedDistanceTable);
  }

  void _parseDynamicHuffmanBlock() {
    // number of literal and length codes.
    final numLitLengthCodes = _readBits(5) + 257;
    // number of distance codes.
    final numDistanceCodes = _readBits(5) + 1;
    // number of code lengths.
    final numCodeLengths = _readBits(4) + 4;

    // decode code lengths
    final codeLengths = Uint8List(_ORDER.length);
    for (var i = 0; i < numCodeLengths; ++i) {
      codeLengths[_ORDER[i]] = _readBits(3);
    }

    final codeLengthsTable = HuffmanTable(codeLengths);

    // literal and length code
    final litlenLengths = Uint8List(numLitLengthCodes);

    // distance code
    final distLengths = Uint8List(numDistanceCodes);

    final litlen = _decode(numLitLengthCodes, codeLengthsTable, litlenLengths);

    final dist = _decode(numDistanceCodes, codeLengthsTable, distLengths);

    _decodeHuffman(HuffmanTable(litlen), HuffmanTable(dist));
  }

  void _decodeHuffman(HuffmanTable litlen, HuffmanTable dist) {
    while (true) {
      final code = _readCodeByTable(litlen);

      if (code < 0 || code > 285) {
        throw ArchiveException('Invalid Huffman Code $code');
      }

      // 256 - End of Huffman block
      if (code == 256) {
        break;
      }

      // [0, 255] - Literal
      if (code < 256) {
        output.writeByte(code & 0xff);
        continue;
      }

      // [257, 285] Dictionary Lookup
      // length code
      final ti = code - 257;

      var codeLength = _LENGTH_CODE_TABLE[ti] + _readBits(_LENGTH_EXTRA_TABLE[ti]);

      // distance code
      final distCode = _readCodeByTable(dist);
      if (distCode >= 0 && distCode <= 29) {
        final distance = _DIST_CODE_TABLE[distCode] + _readBits(_DIST_EXTRA_TABLE[distCode]);

        // lz77 decode
        while (codeLength > distance) {
          output.writeBytes(output.subset(-distance));
          codeLength -= distance;
        }

        if (codeLength == distance) {
          output.writeBytes(output.subset(-distance));
        } else {
          output.writeBytes(output.subset(-distance, codeLength - distance));
        }
      } else {
        throw ArchiveException('Illegal unused distance symbol');
      }
    }

    while (_bitBufferLen >= 8) {
      _bitBufferLen -= 8;
      input!.rewind(1);
    }
  }

  List<int> _decode(int num, HuffmanTable table, List<int> lengths) {
    var prev = 0;
    var i = 0;
    while (i < num) {
      final code = _readCodeByTable(table);
      switch (code) {
        case 16:
          // Repeat last code
          var repeat = 3 + _readBits(2);
          while (repeat-- > 0) {
            lengths[i++] = prev;
          }
          break;
        case 17:
          // Repeat 0
          var repeat = 3 + _readBits(3);
          while (repeat-- > 0) {
            lengths[i++] = 0;
          }
          prev = 0;
          break;
        case 18:
          // Repeat lots of 0s.
          var repeat = 11 + _readBits(7);
          while (repeat-- > 0) {
            lengths[i++] = 0;
          }
          prev = 0;
          break;
        default: // [0, 15]
          // Literal bitlength for this code.
          if (code < 0 || code > 15) {
            throw ArchiveException('Invalid Huffman Code: $code');
          }
          lengths[i++] = code;
          prev = code;
          break;
      }
    }

    return lengths;
  }

  int _bitBuffer = 0;
  int _bitBufferLen = 0;
  int _blockPos = 0;

  // enum BlockType
  static const int _BLOCK_UNCOMPRESSED = 0;
  static const int _BLOCK_FIXED_HUFFMAN = 1;
  static const int _BLOCK_DYNAMIC_HUFFMAN = 2;

  /// Fixed huffman length code table
  static const List<int> _FIXED_LITERAL_LENGTHS = [
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    9,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    7,
    8,
    8,
    8,
    8,
    8,
    8,
    8,
    8
  ];
  final HuffmanTable _fixedLiteralLengthTable = HuffmanTable(_FIXED_LITERAL_LENGTHS);

  /// Fixed huffman distance code table
  static const List<int> _FIXED_DISTANCE_TABLE = [
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5,
    5
  ];
  final HuffmanTable _fixedDistanceTable = HuffmanTable(_FIXED_DISTANCE_TABLE);

  /// Max backward length for LZ77.
  static const int _MAX_BACKWARD_LENGTH = 32768; // ignore: unused_field

  /// Max copy length for LZ77.
  static const int _MAX_COPY_LENGTH = 258; // ignore: unused_field

  /// Huffman order
  static const List<int> _ORDER = [16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15];

  /// Huffman length code table.
  static const List<int> _LENGTH_CODE_TABLE = [
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    13,
    15,
    17,
    19,
    23,
    27,
    31,
    35,
    43,
    51,
    59,
    67,
    83,
    99,
    115,
    131,
    163,
    195,
    227,
    258
  ];

  /// Huffman length extra-bits table.
  static const List<int> _LENGTH_EXTRA_TABLE = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    1,
    1,
    1,
    2,
    2,
    2,
    2,
    3,
    3,
    3,
    3,
    4,
    4,
    4,
    4,
    5,
    5,
    5,
    5,
    0,
    0,
    0
  ];

  /// Huffman dist code table.
  static const List<int> _DIST_CODE_TABLE = [
    1,
    2,
    3,
    4,
    5,
    7,
    9,
    13,
    17,
    25,
    33,
    49,
    65,
    97,
    129,
    193,
    257,
    385,
    513,
    769,
    1025,
    1537,
    2049,
    3073,
    4097,
    6145,
    8193,
    12289,
    16385,
    24577
  ];

  /// Huffman dist extra-bits table.
  static const List<int> _DIST_EXTRA_TABLE = [
    0,
    0,
    0,
    0,
    1,
    1,
    2,
    2,
    3,
    3,
    4,
    4,
    5,
    5,
    6,
    6,
    7,
    7,
    8,
    8,
    9,
    9,
    10,
    10,
    11,
    11,
    12,
    12,
    13,
    13
  ];
}
