import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/NewReport/view_models/new_report_view_model.dart';
import 'package:aiso/NewReport/widgets/locality_card.dart';
import 'package:aiso/reports/view_models/free_report_view_model.dart';
import 'package:aiso/Widgets/flexible_layout.dart';
import 'package:aiso/Widgets/generic_type_ahead.dart';
import 'package:aiso/models/industry_model.dart';
import 'package:aiso/models/location_models.dart';
import 'package:aiso/models/search_target_model.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewReportDesktop extends StatefulWidget {
  const NewReportDesktop({super.key});

  @override
  State<NewReportDesktop> createState() => _NewReportDesktopState();
}

class _NewReportDesktopState extends State<NewReportDesktop> {
  @override
  Widget build(BuildContext context) {
    // final vm = Provider.of<FreeReportViewModel>(context);
    final vm = context.watch<NewReportViewModel>();

    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create new report!',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 30,
                height: 0.9,
              ),
              textAlign: TextAlign.start,
            ),

            SizedBox(height: 60),

            /// search target
            FlexibleLayout(
              layoutType: LayoutType.row,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 0.0,
              children: _buildSearchTargetChildren(context, vm),
            ),

            SizedBox(height: 60),

            /// Prompt
            FlexibleLayout(
              layoutType: LayoutType.row,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 0.0,
              children: _buildPromptChildren(vm),
            ),

            SizedBox(height: 60),

            /// Location
            FlexibleLayout(
              layoutType: LayoutType.row,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 0.0,
              children: _buildLocationsChildren(vm),
            ),

            if (vm.nearbyLocalities.isNotEmpty) const SizedBox(height: 60),

            if (vm.localities.isNotEmpty) const Text('Selected locations:'),

            if (vm.localities.isNotEmpty) const SizedBox(height: 10),

            Wrap(
              spacing: 4,
              runSpacing: 4,
              children:
                  vm.localities.map((locality) {
                    return LocalityCard(
                      locality: locality,
                      icon: Icons.remove,
                      tooltip: 'Remove locality',
                      onPressed: () => vm.removeLocality(locality),
                    );
                  }).toList(),
            ),

            if (vm.nearbyLocalities.isNotEmpty) const SizedBox(height: 10),

            if (vm.nearbyLocalities.isNotEmpty) const Text('Suggested nearby locations:'),

            if (vm.nearbyLocalities.isNotEmpty) const SizedBox(height: 10),

            Wrap(
              spacing: 4,
              runSpacing: 4,
              children:
                  vm.nearbyLocalities.map((locality) {
                    return LocalityCard(
                      locality: locality,
                      icon: Icons.add,
                      tooltip: 'Add locality',
                      onPressed: () {
                        final success = vm.addLocality(locality);
                        if (!success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Maximum of 10 locations allowed'),
                            ),
                          );
                        }
                      },
                    );
                  }).toList(),
            ),

            SizedBox(height: 60),

            ElevatedButton(onPressed: () {}, child: Text('Generate report!')),
          ],
        ),
      ),
    );
  }
}

Widget _buildDropdownField<T>({
  required String label,
  required T? value,
  required List<DropdownMenuItem<T>> items,
  required ValueChanged<T?> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
      validator: (val) => val == null ? 'Required' : null,
    ),
  );
}

List<Widget> _buildSearchTargetChildren(
  BuildContext context,
  NewReportViewModel vm,
) {
  return [
    ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Target.',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
              height: 0.9,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 14),
          Text(
            'The "search target" is the business or person (e.g., real estate agency or real estate agent) that you wish to monitor.',
            style: TextStyle(fontSize: 14, height: 1.7),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    ),
    Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400.0),
          child: _buildDropdownField<Industry>(
            label: 'Search Target',
            value: vm.selectedIndustry,
            items:
                vm.industries
                    .map((i) => DropdownMenuItem(value: i, child: Text(i.name)))
                    .toList(),
            onChanged: (i) => vm.selectedIndustry = i,
          ),
        ),
        // SizedBox(height: 14),
        TextButton(
          onPressed: () => _showCreateTargetDialog(context),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 14.0, color: Colors.black87),
              children: [
                TextSpan(text: "Don't have a search target? "),
                TextSpan(
                  text: "Create a new one!",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  ];
}

List<Widget> _buildPromptChildren(NewReportViewModel vm) {
  return [
    ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Prompt.',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
              height: 0.9,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 14),
          Text(
            'The prompt that you wish to report on. For example, "Best real estate agency in ...". This prompt will be tailored to each location selected below.',
            style: TextStyle(fontSize: 14, height: 1.7),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    ),

    ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400.0),
      child: _buildDropdownField<String>(
        label: 'Prompt',
        value: vm.selectedPromptType,
        items:
            vm.promptTypes
                .map((i) => DropdownMenuItem(value: i, child: Text(i)))
                .toList(),
        onChanged: (i) => vm.selectedPromptType = i,
      ),
    ),
  ];
}

List<Widget> _buildLocationsChildren(NewReportViewModel vm) {
  return [
    ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Locations.',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
              height: 0.9,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 14),
          Text(
            'The locations that you wish to report on.',
            style: TextStyle(fontSize: 14, height: 1.7),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    ),

    Column(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400.0),
          child: _buildDropdownField<Country>(
            label: 'Country',
            value: vm.selectedCountry,
            items:
                vm.countries
                    .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                    .toList(),
            onChanged: (c) => vm.selectedCountry = c,
          ),
        ),

        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400.0),
          child: _buildDropdownField<Region>(
            label: 'State',
            value: vm.selectedRegion,
            items:
                (vm.selectedCountry?.regions ?? [])
                    .map((r) => DropdownMenuItem(value: r, child: Text(r.name)))
                    .toList(),
            onChanged: (r) => vm.selectedRegion = r,
          ),
        ),

        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400.0),
          child: GenericTypeAheadField<Locality>(
            label: 'Suburb',
            selected: vm.selectedLocality,
            suggestionsCallback: vm.fetchLocalitySuggestions,
            displayString: (loc) => loc.name,
            onSelected: (loc) => vm.selectedLocality = loc,
            validator:
                () =>
                    vm.selectedLocality == null
                        ? 'Please pick a locality'
                        : null,
          ),
        ),
      ],
    ),
  ];
}

void _showCreateTargetDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Create a New Search Target",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                "This is where you'd allow the user to create a new target.",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text("Cancel"),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    child: const Text("Create"),
                    onPressed: () {
                      // Add your creation logic here
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
