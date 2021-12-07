import 'dart:async';
import 'package:flutter/material.dart';

class StreamWidget extends StatelessWidget {
  const StreamWidget({
    Key? key,
    required this.streamController,
    required this.builder,
  }) : super(key: key);

  final StreamController<bool> streamController;
  final AsyncWidgetBuilder<bool> builder;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: streamController.stream,
      initialData: false,
      builder: builder,
    );
  }
}
