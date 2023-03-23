
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/common/const/colors.dart';
import 'package:flutter_riverpod/common/layout/default_layout.dart';




class RootTab extends StatelessWidget {
  const RootTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: const Scaffold(
        body: Center(
          child: Text(
            'Root Tab',
          ),
        ),
      ),
    );
  }
}
