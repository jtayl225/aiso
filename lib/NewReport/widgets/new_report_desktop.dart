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
              children: _buildSearchTargetChildren(vm),
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

            SizedBox(height: 60),

            if (vm.localities.isNotEmpty) const Text('Selected locations:'),

            SizedBox(height: 10),

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

            SizedBox(height: 10),

            if (vm.nearbyLocalities.isNotEmpty) const Text('Suggested nearby locations:'),

            SizedBox(height: 10),

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

List<Widget> _buildSearchTargetChildren(NewReportViewModel vm) {
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

    // ConstrainedBox(
    //   constraints: BoxConstraints(maxWidth: 400.0),
    //   child: _buildDropdownField<Industry>(
    //     label: 'Location',
    //     value: vm.selectedIndustry,
    //     items:
    //         vm.industries
    //             .map((i) => DropdownMenuItem(value: i, child: Text(i.name)))
    //             .toList(),
    //     onChanged: (i) => vm.selectedIndustry = i,
    //   ),
    // ),
  ];
}
