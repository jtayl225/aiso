import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class GenericTypeAheadField<T> extends StatefulWidget {
  final Future<List<T>> Function(String) suggestionsCallback;
  final void Function(T) onSelected;
  final String Function(T) displayString;
  final String? label;
  final T? selected;
  final String? Function()? validator;

  const GenericTypeAheadField({
    super.key,
    required this.suggestionsCallback,
    required this.onSelected,
    required this.displayString,
    this.label,
    this.selected,
    this.validator,
  });

  @override
  State<GenericTypeAheadField<T>> createState() => _GenericTypeAheadFieldState<T>();
}

class _GenericTypeAheadFieldState<T> extends State<GenericTypeAheadField<T>> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late final SuggestionsController<T> _suggestionsController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _suggestionsController = SuggestionsController<T>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _suggestionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadField<T>(
      suggestionsController: _suggestionsController,
      suggestionsCallback: widget.suggestionsCallback,
      itemBuilder: (context, suggestion) =>
          ListTile(title: Text(widget.displayString(suggestion))),
      onSelected: (suggestion) {
        widget.onSelected(suggestion);
        _controller.text = widget.displayString(suggestion);
        _suggestionsController.close();
      },
      builder: (context, controller, focusNode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (widget.selected != null &&
              controller.text != widget.displayString(widget.selected!)) {
            controller.text = widget.displayString(widget.selected!);
          }
        });

        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: widget.label ?? 'Select an item',
            border: const OutlineInputBorder(),
          ),
          validator: (_) => widget.validator?.call(),
        );
      },
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No matches found'),
      ),
      decorationBuilder: (context, child) {
        return Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: child,
        );
      },
    );
  }
}
