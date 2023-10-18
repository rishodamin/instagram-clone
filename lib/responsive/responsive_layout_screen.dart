import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/global_variables.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  final bool isGuest;
  const ResponsiveLayout({
    super.key,
    required this.webScreenLayout,
    required this.mobileScreenLayout,
    required this.isGuest,
  });

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    if (!widget.isGuest) {
      addData();
    }
  }

  addData() async {
    Provider.of<UserProvider>(context, listen: false).refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    print(Provider.of<UserProvider>(context).isGuest);
    return (!Provider.of<UserProvider>(context).isGuest &&
            Provider.of<UserProvider>(context).getUser == null)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : widget.mobileScreenLayout;
    // : LayoutBuilder(
    //     builder: (context, constraints) {
    //       if (constraints.maxWidth > webScreenWidth) {
    //         return widget.webScreenLayout;
    //       } else {
    //         return widget.mobileScreenLayout;
    //       }
    //     },
    //   );
  }
}
