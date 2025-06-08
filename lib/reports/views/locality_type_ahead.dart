import 'package:aiso/models/location_models.dart';
import 'package:aiso/reports/view_models/free_report_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class LocalityField extends StatefulWidget {
  const LocalityField({super.key});

  @override
  State<LocalityField> createState() => _LocalityFieldState();
}

class _LocalityFieldState extends State<LocalityField> {
  // 1) The controller that the suggestions box will drive
  late final TextEditingController _controller;
  // 2) And the FocusNode that lets TypeAheadField know when to show/hide
  late final FocusNode _focusNode;
  // 3) Your suggestions controller (holds loading / error / list state)
  late final SuggestionsController<Locality> _suggestionsController;

  Locality? _selected; // local field to show in text box

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _suggestionsController = SuggestionsController<Locality>();
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
    // final vm = Provider.of<FreeReportViewModel>(context, listen: false);
    final vm = context.watch<FreeReportViewModel>();

    return TypeAheadField<Locality>(
      suggestionsController: _suggestionsController,

      // 🔹 REQUIRED: fetch up to 3 matches from your ViewModel
      suggestionsCallback: vm.fetchLocalitySuggestions,

      // 🔹 REQUIRED: how each match looks
      itemBuilder: (context, Locality suggestion) {
        return ListTile(title: Text(suggestion.name));
      },

      // 🔹 REQUIRED: what happens when one is tapped
      // onSelected: (Locality suggestion) {
      //   vm.selectedLocality = suggestion;
      //   controller.text = suggestion.name;
      // },

      onSelected: (Locality suggestion) {
        setState(() {
          _selected = suggestion;
          vm.selectedLocality = suggestion;
        });
        _suggestionsController.close(); // ✅ dismiss suggestions
      },

      // 🔹 The actual text field: MUST use the given controller & focusNode
      builder: (context, TextEditingController controller, FocusNode focusNode) {
        // ✅ Set initial value from selectedLocality if needed
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_selected != null && controller.text != _selected!.name) {
            controller.text = _selected!.name;
          }
        });

        return TextFormField(
          controller: controller,   // <— your field’s controller
          focusNode: focusNode,     // <— and focus node
          decoration: const InputDecoration(
            labelText: 'Suburb',
            border: OutlineInputBorder(),
          ),
          validator: (val) =>
              vm.selectedLocality == null ? 'Please pick a locality' : null,
        );
      },

      

      // Optional: empty state
      emptyBuilder: (context) => const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text('No matches found'),
      ),

      // Optional: wrap the suggestions with Material/shadows
      decorationBuilder: (context, suggestionsBox) {
        return Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(8),
          child: suggestionsBox,
        );
      },
    );
  }
}
