import 'package:aiso/Home/widgets/centered_view.dart';
import 'package:aiso/NewReport/view_models/new_report_view_model.dart';
import 'package:aiso/NewReport/widgets/locality_card.dart';
import 'package:aiso/locator.dart';
import 'package:aiso/models/db_timestamps_model.dart';
import 'package:aiso/models/entity_model.dart';
import 'package:aiso/models/search_target_type_enum.dart';
import 'package:aiso/reports/view_models/free_report_view_model.dart';
import 'package:aiso/Widgets/row_col.dart';
import 'package:aiso/Widgets/generic_type_ahead.dart';
import 'package:aiso/models/industry_model.dart';
import 'package:aiso/models/location_models.dart';
import 'package:aiso/models/search_target_model.dart';
import 'package:aiso/routing/app_router.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewReportForm extends StatefulWidget {
  final RowColType rowColType;
  const NewReportForm({
    super.key,
    required this.rowColType,
    });

  @override
  State<NewReportForm> createState() => _NewReportFormState();
}

class _NewReportFormState extends State<NewReportForm> {
  final TextEditingController reportTitleController = TextEditingController();
  // reportTitleController.text = '';
  // late NewReportViewModel vm;

  @override
  void initState() {
    super.initState();

    // Access ViewModel from Provider or another source
    // vm = context.read<NewReportViewModel>();
    // vm.init();

    // Set initial text once
    reportTitleController.text = '';
  }

  @override
  void dispose() {
    // Always dispose controllers
    reportTitleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final vm = Provider.of<FreeReportViewModel>(context);
    // final vm = context.watch<NewReportViewModel>();
    final rowColType = widget.rowColType;
    final double spacing = 40;

    final vm = context.watch<NewReportViewModel>();

    // final TextEditingController reportTitleController = TextEditingController();
    // reportTitleController.text = vm.reportTitle ?? '';

    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

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

            // if (vm.isLoading)
            //   SizedBox(height: 60), 
            //   const Center(child: CircularProgressIndicator()),

            SizedBox(height: 60),

            RowCol(
              layoutType: rowColType,
              spacing: spacing,
              children: _buildReportTitleChildren(vm, reportTitleController),
            ),

            SizedBox(height: 60),

            // Text(
            //   'Title.',
            //   style: TextStyle(
            //     fontWeight: FontWeight.w800,
            //     fontSize: 25,
            //     height: 0.9,
            //   ),
            //   textAlign: TextAlign.start,
            // ),

            // SizedBox(height: 14),

            // TextField(
            //   controller: reportTitleController,
            //   decoration: const InputDecoration(
            //     labelText: 'Report Title',
            //     border: OutlineInputBorder(),
            //   ),
            //   onChanged: (value) {
            //     vm.reportTitle = value;
            //   },
            // ),

            // SizedBox(height: 14),

            /// search target
            RowCol(
              layoutType: rowColType,
              spacing: spacing,
              children: _buildSearchTargetChildren(context, vm),
            ),

            SizedBox(height: 60),

            // /// Prompt
            // FlexibleLayout(
            //   layoutType: LayoutType.row,
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   spacing: 0.0,
            //   children: _buildPromptChildren(vm),
            // ),

            // SizedBox(height: 30),

            // if (vm.selectedPromptType?.isNotEmpty == true &&
            //     vm.selectedSearchTarget != null)
            //   Text(
            //     '${vm.selectedPromptType} '
            //     '${vm.selectedSearchTarget!.entityType == EntityType.business ? 'real estate agencies' : 'real estate agents'} in ...',
            //     style: const TextStyle(
            //       fontSize: 14,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.black,
            //     ),
            //   ),

            // SizedBox(height: 60),

            /// Location
            RowCol(
              layoutType: rowColType,
              spacing: spacing,
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

            if (vm.nearbyLocalities.isNotEmpty)
              const Text('Suggested nearby locations:'),

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

            ElevatedButton(
              onPressed:
                  vm.isFormValid
                      ? () async {
                        await vm.createAndRunPaidReport();
                        appRouter.go(reportsRoute);
                      }
                      : null, // disables the button
              child: Text('Generate report!'),
            ),
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

List<Widget> _buildReportTitleChildren(
  NewReportViewModel vm,
  TextEditingController reportTitleController,
) {
  // final TextEditingController reportTitleController = TextEditingController();
  // reportTitleController.text = '';

  return [
    ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 600.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Title.',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
              height: 0.9,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 14),
          Text(
            'Give your report a title.',
            style: TextStyle(fontSize: 14, height: 1.7),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    ),

    Align(
      alignment: Alignment.center,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400.0),
        child: TextField(
          controller: reportTitleController,
          decoration: const InputDecoration(
            labelText: 'Report Title',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            vm.reportTitle = value;
          },
        ),
      ),
    ),
  ];
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
            'Business details.',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 25,
              height: 0.9,
            ),
            textAlign: TextAlign.start,
          ),
          SizedBox(height: 14),
          Text(
            'Add your business details. This can be a either business or person (e.g., real estate agency or real estate agent).',
            style: TextStyle(fontSize: 14, height: 1.7),
            textAlign: TextAlign.start,
          ),
        ],
      ),
    ),
    Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400.0),
            child: _buildDropdownField<SearchTarget>(
              label: 'Business',
              value: vm.selectedSearchTarget,
              items:
                  vm.searchTargets
                      .map((i) => DropdownMenuItem(value: i, child: Text(i.name)))
                      .toList(),
              onChanged: (i) => vm.selectedSearchTarget = i,
            ),
          ),
          // SizedBox(height: 14),
          TextButton(
            onPressed: () => _showCreateTargetDialog(context, vm),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14.0, color: Colors.black87),
                children: [
                  TextSpan(text: "Can't see your business? "),
                  TextSpan(
                    text: "Add your business here!",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
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
            'The locations that you wish to report on (you can select up to 10). Each location will be added to the below AI prompt.',
            style: TextStyle(fontSize: 14, height: 1.7),
            textAlign: TextAlign.start,
          ),

          if (vm.selectedPromptType?.isNotEmpty == true &&
              vm.selectedSearchTarget != null)
            SizedBox(height: 28),
          Text(
            '${vm.selectedPromptType} '
            '${vm.selectedSearchTarget!.entityType == EntityType.business ? 'real estate agencies' : 'real estate agents'} in ...',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    ),

    Align(
      alignment: Alignment.center,
      child: Column(
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
    ),
  ];
}

void _showCreateTargetDialog(BuildContext context, NewReportViewModel vm) {
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _personNameController = TextEditingController();
  // final TextEditingController _targetDescriptionController = TextEditingController();
  final TextEditingController _targetUrlController = TextEditingController();
  EntityType? _searchTargetType = EntityType.values.first;

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add your business details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Complete the form below to add your business details.",
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),

                    _buildDropdownField<Industry>(
                      label: 'Industry',
                      value: vm.selectedIndustry,
                      items:
                          vm.industries
                              .map(
                                (i) => DropdownMenuItem(
                                  value: i,
                                  child: Text(i.name),
                                ),
                              )
                              .toList(),
                      onChanged: (i) => vm.selectedIndustry = i,
                    ),

                    DropdownButtonFormField<EntityType>(
                      value: _searchTargetType,
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          EntityType.values.map((type) {
                            return DropdownMenuItem<EntityType>(
                              value: type,
                              child: Text(type.toValue()),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _searchTargetType = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 8),

                    TextField(
                      controller: _businessNameController,
                      decoration: const InputDecoration(
                        labelText: 'Business Name',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 8),

                    if (_searchTargetType == EntityType.person) ...[
                      TextField(
                        controller: _personNameController,
                        decoration: const InputDecoration(
                          labelText: 'Person Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],

                    // const SizedBox(height: 8),

                    // TextField(
                    //   controller: _targetDescriptionController,
                    //   decoration: const InputDecoration(
                    //     labelText: 'Description',
                    //     border: OutlineInputBorder(),
                    //   ),
                    // ),

                    // const SizedBox(height: 8),
                    TextField(
                      controller: _targetUrlController,
                      decoration: const InputDecoration(
                        labelText: 'URL (optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () => Navigator.of(dialogContext).pop(),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text("Create"),
                          onPressed: () {
                            final businessName =
                                _businessNameController.text.trim();
                            final personName =
                                _personNameController.text.trim();
                            final url = _targetUrlController.text.trim();
                            final type = _searchTargetType;
                            final industry = vm.selectedIndustry;

                            if (type == null) {
                              debugPrint("⚠️ Type is required");
                              return;
                            }

                            if (type == EntityType.business &&
                                businessName.isEmpty) {
                              debugPrint("⚠️ Business name is required");
                              return;
                            }

                            if (type == EntityType.person &&
                                (personName.isEmpty || businessName.isEmpty)) {
                              debugPrint(
                                "⚠️ Both person and business names are required",
                              );
                              return;
                            }

                            final newTarget = SearchTarget(
                              id: '',
                              userId: '', // Populate later if needed
                              name:
                                  type == EntityType.business
                                      ? businessName
                                      : personName,
                              industry: industry,
                              entityType: type,
                              description:
                                  type == EntityType.business
                                      ? 'Real estate agency.'
                                      : 'Real estate agent at $businessName.',
                              url: url,
                              dbTimestamps: DbTimestamps.now(),
                            );

                            vm.createSearchTarget(newTarget);
                            Navigator.of(dialogContext).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );
    },
  );
}
