import 'dart:async';
import '../data/google_maps_repository.dart';
import '../domain/google_places_details_result.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';

class GoogleAddressAutocomplete extends StatefulWidget {
  final bool enabled;
  final Future<void> Function(Future<GooglePlacesDetailsResult> res) onResult;
  const GoogleAddressAutocomplete({super.key, required this.onResult, required this.enabled});

  @override
  State<GoogleAddressAutocomplete> createState() => _GoogleAddressAutocompleteState();
}

class _GoogleAddressAutocompleteState extends State<GoogleAddressAutocomplete> {
  final controller = TextEditingController();
  final inputKey = LabeledGlobalKey("googleaddresssearchdropdown_");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.enabled) return;
        FocusScope.of(context).unfocus();
        //var position = inputKey.getKeyPosition(context);
        Navigator.of(context, rootNavigator: true).push(_GoogleAddressDropdownPopupRoute(
            (data) async {
              if (mounted) Navigator.of(context, rootNavigator: true).pop();
              await widget.onResult(GoogleMapsRepo.getPlaceDetails(data.placeId!));
            },
            (data) => data.description,
            (data) async {
              var res = await GoogleMapsRepo.searchAddresses(data);
              return res.predictions;
            },
            controller,
            inputKey));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          key: inputKey,
          // controller: controller,
          enabled: false,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: const InputDecoration(
              labelText: 'Auto-complete Address', isDense: true, contentPadding: EdgeInsets.all(12)),
        ),
      ),
    );
  }
}

class _GoogleAddressDropdownPopupRoute<T> extends PopupRoute<T> {
  final TextEditingController textEditingController;
  final Future<List<T>> Function(String content) onSearch;
  final Future<void> Function(T item) onItemSelect;
  final String Function(T item) title;
  final LabeledGlobalKey<State<StatefulWidget>> position;
  _GoogleAddressDropdownPopupRoute(
      this.onItemSelect, this.title, this.onSearch, this.textEditingController, this.position);
  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'popup_search_${T.runtimeType}';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return GoogleAddressDropdownContent(
        textEditingController: textEditingController,
        onSearch: onSearch,
        onItemSelect: onItemSelect,
        title: title,
        animation: animation,
        position: position);
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 100);
}

class GoogleAddressDropdownContent<T> extends StatefulWidget {
  final TextEditingController textEditingController;
  final Future<List<T>> Function(String content) onSearch;
  final Future<void> Function(T item) onItemSelect;
  final String Function(T item) title;
  final Animation<double> animation;
  final LabeledGlobalKey<State<StatefulWidget>> position;
  const GoogleAddressDropdownContent(
      {super.key,
      required this.textEditingController,
      required this.onSearch,
      required this.onItemSelect,
      required this.title,
      required this.animation,
      required this.position});

  @override
  State<GoogleAddressDropdownContent<T>> createState() => _GoogleAddressDropdownContentState<T>();
}

class _GoogleAddressDropdownContentState<T> extends State<GoogleAddressDropdownContent<T>> {
  Future<List<T>>? searchFuture;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var columnChildren = [
      Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: TextField(
          autofocus: true,
          decoration: const InputDecoration(
              hintText: 'Auto-complete Address', isDense: true, contentPadding: EdgeInsets.all(12)),
          style: Theme.of(context).textTheme.bodyMedium,
          onChanged: (value) {
            if (_debounce?.isActive ?? false) {
              _debounce?.cancel();
            }
            _debounce = Timer(const Duration(milliseconds: 500), () {
              setState(() {
                if (value.length > 2) {
                  searchFuture = widget.onSearch(value);
                } else {
                  searchFuture = null;
                }
              });
            });
          },
        ),
      ),
      Flexible(
        child: FutureBuilder(
          future: searchFuture,
          builder: (context, snapshot) {
            return switch (snapshot.connectionState) {
              (ConnectionState.none) => const SizedBox.shrink(),
              (ConnectionState.waiting) => const CircularProgressIndicator.adaptive(),
              (_) => Scrollbar(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        for (var item in snapshot.data!)
                          ListTile(
                            title: Text(widget.title(item), style: Theme.of(context).textTheme.bodyMedium),
                            onTap: () async => await widget.onItemSelect(item),
                          )
                      ]
                          .addBetween(const Divider(
                            height: 0,
                          ))
                          .toList(),
                    ),
                  ),
                )
            };
          },
        ),
      )
    ];
    var pos = widget.position.getKeyPosition(context);
    return Stack(
      children: [
        Positioned(
          top: pos!.relativeRect.top > pos.relativeRect.bottom ? null : pos.relativeRect.top,
          bottom: pos.relativeRect.bottom >= pos.relativeRect.top ? null : pos.relativeRect.bottom,
          left: pos.relativeRect.left,
          right: pos.relativeRect.right,
          child: AnimatedBuilder(
            animation: widget.animation,
            builder: (context, child) => Material(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(10),
                child: ClipRRect(
                  clipBehavior: Clip.antiAlias,
                  borderRadius: BorderRadius.circular(10),
                  child: Align(
                    heightFactor: widget.animation.value,
                    child: Container(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: pos.relativeRect.top > pos.relativeRect.bottom
                            ? columnChildren.reversed.toList()
                            : columnChildren,
                      ),
                    ),
                  ),
                )),
          ),
        ),
      ],
    );
  }
}
