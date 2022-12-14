import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadMoreButton extends StatefulWidget {
  final Future Function() loadMoreFunction;
  const LoadMoreButton({Key? key, required this.loadMoreFunction})
      : super(key: key);

  @override
  State<LoadMoreButton> createState() => _LoadMoreButtonState();
}

class _LoadMoreButtonState extends State<LoadMoreButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: isLoading
              ? Center(
                  child: SpinKitFoldingCube(
                    color: Theme.of(context).colorScheme.primary,
                    size: 30,
                  ),
                )
              : ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await widget.loadMoreFunction();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('Load More'),
                  ),
                ),
        ),
      );
    });
  }
}
