import 'package:aiso/constants/string_constants.dart';
import 'package:aiso/locator.dart';
import 'package:aiso/models/industry_model.dart';
import 'package:aiso/models/location_models.dart';
import 'package:aiso/reports/view_models/free_report_view_model.dart';
import 'package:aiso/reports/views/free_report_timeline_screen.dart';
import 'package:aiso/reports/views/locality_type_ahead.dart';
import 'package:aiso/routing/route_names.dart';
import 'package:aiso/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:aiso/routing/app_router.dart';

class FreeReportForm extends StatefulWidget {
  const FreeReportForm({super.key});

  @override
  State<FreeReportForm> createState() => _FreeReportFormState();
}

class _FreeReportFormState extends State<FreeReportForm> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FreeReportViewModel>(context, listen: false).init();
    });
  }

  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  void _updateField(String value, void Function(String) updateFn) {
    setState(() {
      updateFn(value);
    });
  }

  @override
  Widget build(BuildContext context) {

    final vm = Provider.of<FreeReportViewModel>(context);
    // final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    // final currentUserId = authViewModel.anonSignIn();

    return Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Center(
                    //   child: Image.asset(
                    //     logoImage,
                    //     height: 100,
                    //   ),
                    // ),
                    // const SizedBox(height: 20),
                    // _buildTextField("First Name", (val) => _updateField(val, (v) => firstName = v)),
                    // _buildTextField("Last Name", (val) => _updateField(val, (v) => lastName = v)),
                    _buildTextField("Email", (val) => _updateField(val, (v) => vm.email = v), 
                      keyboardType: TextInputType.emailAddress, 
                      autofillHints: [AutofillHints.email],
                      isEmail: true
                    ),
      
                    const SizedBox(height: 16),
                
                    _buildDropdownField<Industry>(
                      label: 'Industry',
                      value: vm.selectedIndustry,
                      items: vm.industries.map((i) => DropdownMenuItem(
                        value: i,
                        child: Text(i.name),
                      )).toList(),
                      onChanged: (i) => vm.selectedIndustry = i,
                    ),
                
                    _buildTextField("Business Name", (val) => _updateField(val, (v) => vm.entityName = v)),
      
                    const SizedBox(height: 16),
                
                    _buildDropdownField<Country>(
                      label: 'Country',
                      value: vm.selectedCountry,
                      items: vm.countries.map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(c.name),
                      )).toList(),
                      onChanged: (c) => vm.selectedCountry = c,
                    ),
                
                    _buildDropdownField<Region>(
                      label: 'State',
                      value: vm.selectedRegion,
                      items: (vm.selectedCountry?.regions ?? []).map((r) => DropdownMenuItem(
                        value: r,
                        child: Text(r.name),
                      )).toList(),
                      onChanged: (r) => vm.selectedRegion = r,
                    ),
                
                    LocalityField(), // type ahead field
                    
                    // _buildTextField("Suburb", (val) => _updateField(val, (v) => localityName = v)),
                    
                    const SizedBox(height: 20),
      
                    ElevatedButton(
                      onPressed: vm.isFormValid
                        ? () {
                            if (_formKey.currentState!.validate()) {
                              vm.createAndRunFreeReport();
                              // locator<NavigationService>().navigateTo(freeReportTimelineRoute);
                              appRouter.go(freeReportTimelineRoute);

                            }
                          }
                        : null,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text("Generate free report!"),
                    ),
      
                  ],
                ),
              ),
            ),
          ),
        ),
      );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      {
        TextInputType keyboardType = TextInputType.text,
        List<String>? autofillHints,
        bool obscureText = false,
        bool isEmail = false,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        autofillHints: autofillHints,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Required';
          }
          if (isEmail && !value.contains('@')) return 'Enter a valid email';
          return null;
        },
      ),
    );
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
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        value: value,
        items: items,
        onChanged: onChanged,
        validator: (val) => val == null ? 'Required' : null,
      ),
    );
  }

}
