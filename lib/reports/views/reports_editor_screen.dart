import 'package:aiso/models/cadence_enum.dart';
import 'package:aiso/models/db_timestamps_model.dart';
import 'package:aiso/models/entity_model.dart';
import 'package:aiso/models/industry_model.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/Reports/models/report_model.dart';
import 'package:aiso/models/search_target_model.dart';
// import 'package:aiso/models/search_target_type_enum.dart';
import 'package:aiso/view_models/auth_view_model.dart';
import 'package:aiso/Reports/view_models/reports_view_model.dart';
import 'package:aiso/Reports/views/prompt_builder_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReportEditorScreen extends StatefulWidget {
   final Report? report; // Pass existing report if editing, null for new report

  const ReportEditorScreen({super.key,this.report});

  @override
  State<ReportEditorScreen> createState() => _ReportEditorScreenState();
}

class _ReportEditorScreenState extends State<ReportEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late bool _isEditMode;
  late Report _report;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Cadence _cadence;
  late EntityType _searchTargetType;
  late TextEditingController _targetNameController;
  late TextEditingController _targetDescriptionController;
  late TextEditingController _targetUrlController;
  late TextEditingController _manualPromptController;

  @override
  void initState() {
    super.initState();
    
    if (widget.report != null) {
      _report = widget.report!.copyWith();
      _isEditMode = true;
    } else {
      final authViewModel = context.read<AuthViewModel>();
      final creatorUserId = authViewModel.currentUser?.id ?? '';
      _report = Report(
        id: '', 
        userId: creatorUserId,
        searchTargetId: '',
        title: '', 
        // isPaid: true,
        // description: '', 
        cadence: Cadence.month, 
        dbTimestamps: DbTimestamps.now()
        );
      _isEditMode = false;
    }

    _titleController = TextEditingController(text: _report.title);
    // _descriptionController = TextEditingController(text: _report.description);
    _cadence = _report.cadence;
    _searchTargetType = _report.searchTarget?.entityType ?? EntityType.business;
    _targetNameController = TextEditingController(text: _report.searchTarget?.name ?? '');
    _targetDescriptionController = TextEditingController(text: _report.searchTarget?.description ?? '');
    _targetUrlController = TextEditingController(text: _report.searchTarget?.url ?? '');
    _manualPromptController = TextEditingController(text: '');

  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _targetNameController.dispose();
    _targetDescriptionController.dispose();
    _targetUrlController.dispose();
    super.dispose();
  }

  SearchTarget _buildSearchTarget() {
    return SearchTarget(
      id: '',
      // reportId: _isEditMode ? _report.id : '',
      userId: '',
      name: _targetNameController.text.trim(),
      entityType: _searchTargetType,
      industry: Industry(id: '', name: ''),
      description: _targetDescriptionController.text.trim(),
      url: _targetUrlController.text.trim(),
      dbTimestamps: _isEditMode && _report.searchTarget != null
        ? _report.searchTarget!.dbTimestamps.copyWith(updatedAt: DateTime.now())
        : DbTimestamps.now(),
    );
  }

  Report _buildReport() {

    final searchTarget = _buildSearchTarget();

    return Report(
      id: _isEditMode ? _report.id : '', // Empty ID if creating new
      userId: _report.userId,
      searchTargetId: '',
      title: _titleController.text.trim(),
      // description: _descriptionController.text.trim(),
      // isPaid: true,
      cadence: _cadence,
      prompts: _report.prompts,
      searchTarget: searchTarget,
      dbTimestamps: _isEditMode
          ? _report.dbTimestamps.copyWith(updatedAt: DateTime.now())
          : DbTimestamps.now(),
    );
  }


  void _saveTask() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return; // Exit early if form is not valid
    }

    final report = _buildReport();

    if (_isEditMode) {
      _updateReport(report);
    } else {
      _createReport(report);
    }
    Navigator.of(context).pop();
  }

  void _createReport(Report report) {
    debugPrint('DEBUG: ReportEditorScreen creating new report: ${report.title}');
    final reportViewModel = Provider.of<ReportViewModel>(context, listen: false);
    reportViewModel.createReport(report);
  }

  void _updateReport(Report report) {
    debugPrint('DEBUG: ReportEditorScreen updating report: ${report.id}');
    final reportViewModel = Provider.of<ReportViewModel>(context, listen: false);
    reportViewModel.updateReport(report);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Report' : 'Create Report'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save Report',
            onPressed: _saveTask,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                // DETAILS
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Details',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                SizedBox(height: 8),

                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
        
                // SizedBox(height: 8),

                // TextField(
                //   controller: _descriptionController,
                //   decoration: InputDecoration(
                //     labelText: 'Description',
                //     border: OutlineInputBorder(),
                //   ),
                // ),

                // SizedBox(height: 8),

                // DropdownButtonFormField<Cadence>(
                //   value: _cadence,
                //   decoration: const InputDecoration(
                //     labelText: 'Cadence',
                //     border: OutlineInputBorder(),
                //   ),
                //   items: Cadence.values.map((cadence) {
                //     return DropdownMenuItem<Cadence>(
                //       value: cadence,
                //       child: Text(cadence.label),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       _cadence = value!;
                //     });
                //   },
                // ),

                SizedBox(height: 16),

                // SEARCH TARGET
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Search Target',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),

                // SizedBox(height: 8),

                // DropdownButtonFormField<SearchTargetType>(
                //   value: _searchTargetType,
                //   decoration: const InputDecoration(
                //     labelText: 'Type',
                //     border: OutlineInputBorder(),
                //   ),
                //   items: SearchTargetType.values.map((cadence) {
                //     return DropdownMenuItem<SearchTargetType>(
                //       value: cadence,
                //       child: Text(cadence.label),
                //     );
                //   }).toList(),
                //   onChanged: (value) {
                //     setState(() {
                //       _searchTargetType = value!;
                //     });
                //   },
                // ),

                SizedBox(height: 8),

                TextField(
                  controller: _targetNameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 8),

                TextField(
                  controller: _targetDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 8),

                TextField(
                  controller: _targetUrlController,
                  decoration: InputDecoration(
                    labelText: 'URL (optional)',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 16),

                // PROMPTS

                // Row(
                //   children: [
                //     Expanded(
                //       child: Text(
                //         'Prompts',
                //         style: Theme.of(context).textTheme.titleMedium,
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     ElevatedButton.icon(
                //       onPressed: () async {
                //         final List<Prompt>? newPrompts = await Navigator.push(
                //           context,
                //           MaterialPageRoute(
                //             builder: (context) => PromptBuilderScreen(),
                //           ),
                //         );

                //         if (newPrompts != null && newPrompts.isNotEmpty) {
                //           // Handle the new prompts, e.g., add to report or update state
                //           setState(() {
                //             _report.prompts = [...?_report.prompts, ...newPrompts];
                //           });
                //         }
                //       },

                //       icon: const Icon(Icons.add),
                //       label: const Text('New Prompt'),
                //     ),
                //   ],
                // ),

                // PROMPTS SECTION

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Prompts',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 10),

                    // Free text input for adding a single prompt manually
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _manualPromptController,
                            decoration: const InputDecoration(
                              labelText: 'Add a prompt manually',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            final text = _manualPromptController.text.trim();
                            if (text.isNotEmpty) {
                              setState(() {
                                _report.prompts = [
                                  ...?_report.prompts,
                                  Prompt(
                                    id: '',
                                    // templateId: '',
                                    // reportId: '',
                                    prompt: text,
                                    dbTimestamps: DbTimestamps.now(),
                                    // lastRunAt: null,
                                  ),
                                ];
                                _manualPromptController.clear();
                              });
                            }
                          },
                          child: const Text('Add'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // PromptBuilder tool
                    ElevatedButton.icon(
                      onPressed: () async {
                        final List<Prompt>? newPrompts = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PromptBuilderScreen(),
                          ),
                        );

                        if (newPrompts != null && newPrompts.isNotEmpty) {
                          setState(() {
                            _report.prompts = [...?_report.prompts, ...newPrompts];
                          });
                        }
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Use Prompt Builder'),
                    ),

                    // const SizedBox(height: 16),

                    // // Display current prompts
                    // if (_report.prompts != null && _report.prompts!.isNotEmpty)
                    //   ..._report.prompts!.asMap().entries.map((entry) {
                    //     final index = entry.key;
                    //     final prompt = entry.value;

                    //     return ListTile(
                    //       contentPadding: EdgeInsets.zero,
                    //       title: Text(prompt.prompt ?? '[No prompt text]'),
                    //       trailing: IconButton(
                    //         icon: const Icon(Icons.delete),
                    //         onPressed: () {
                    //           setState(() {
                    //             _report.prompts!.removeAt(index);
                    //           });
                    //         },
                    //       ),
                    //     );
                    //   }).toList(),
                  ],
                ),


                SizedBox(height: 8),

                // Display prompts
                if (_report.prompts != null && _report.prompts!.isNotEmpty)
                ..._report.prompts!.asMap().entries.map((entry) {
                  final index = entry.key;
                  final prompt = entry.value;

                  return Card(
                    child: ListTile(
                      title: Text(prompt.prompt),
                      // subtitle: Text('Subject: ${prompt.subject}, Context: ${prompt.context}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _report.prompts!.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                }),


                if (_report.prompts == null || _report.prompts!.isEmpty)
                  const Text('No prompts yet.'),

              ]
            )
            )
          ),
        )

    );
  }
}