import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

navigationTo(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
}
