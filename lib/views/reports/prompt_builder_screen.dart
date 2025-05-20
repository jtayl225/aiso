import 'package:aiso/models/db_timestamps_model.dart';
import 'package:aiso/models/prompt_model.dart';
import 'package:aiso/models/prompt_template_model.dart';
import 'package:aiso/view_models/reports_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PromptBuilderScreen extends StatefulWidget {
  const PromptBuilderScreen({super.key});

  @override
  State<PromptBuilderScreen> createState() => _PromptBuilderScreenState();
}

class _PromptBuilderScreenState extends State<PromptBuilderScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Prompt> _createdPrompts = [];
  List<String> _subjects = [];
  List<String> _contexts = [];
  PromptTemplate? _selectedTemplate;
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _contextController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _contextController.dispose();
    super.dispose();
  }

  // void _validateForm() {
  //   setState(() {
  //     _isFormValid = _subjectController.text.trim().isNotEmpty;
  //   });
  // }

  void _addContext() {
    final newContext = _contextController.text.trim();
    if (newContext.isNotEmpty && !_contexts.contains(newContext)) {
      setState(() {
        _contexts.add(newContext);
        _contextController.clear();
      });
    }
  }

  void _removeContext(int index) {
    setState(() {
      _contexts.removeAt(index);
    });
  }

  void _addSubject() {
    final newSubject = _subjectController.text.trim();
    if (newSubject.isNotEmpty && !_subjects.contains(newSubject)) {
      setState(() {
        _subjects.add(newSubject);
        _subjectController.clear();
      });
    }
  }

  void _removeSubject(int index) {
    setState(() {
      _subjects.removeAt(index);
    });
  }

  void _createPrompts() {

    if (_selectedTemplate == null || _subjects.isEmpty || _contexts.isEmpty) {
      // Optional: show a snackbar or dialog for feedback
      debugPrint("Cannot create prompts: Missing template, subject, or contexts.");
      return;
    }

    List<Prompt> createdPrompts = [];

    for (var subject in _subjects) {
      for (var context in _contexts) {
        PromptTemplate newPrompt = _selectedTemplate!.copyWith(subject: subject, context: context);
        createdPrompts.add(
          Prompt(
            id: '',
            // templateId: _selectedTemplate!.id,
            reportId: '',
            prompt: newPrompt.formattedPrompt,
            dbTimestamps: DbTimestamps.now(),
            lastRunAt: null,
          ),
        );
      }
    }

    setState(() {
      _createdPrompts = createdPrompts;
    });
  }


  @override
  Widget build(BuildContext context) {
    final _templates = context.watch<ReportViewModel>().promptTemplates;
    return Scaffold(
      appBar: AppBar(
        title: Text('Prompt Builder'),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.save),
        //     onPressed: _saveTask,
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                Text(
                  'Select a Prompt Template',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<PromptTemplate>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Template',
                  ),
                  value: _selectedTemplate,
                  items: _templates.map((template) {
                    return DropdownMenuItem<PromptTemplate>(
                      value: template,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(template.rawPrompt, style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            template.formattedPrompt, 
                            style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    );
                  }).toList(),

                  selectedItemBuilder: (BuildContext context) {
                    return _templates.map((template) {
                      return Text(template.rawPrompt);
                    }).toList();
                  },

                  onChanged: (value) {
                    setState(() {
                      _selectedTemplate = value!;
                    });
                  },
                ),

                SizedBox(height: 8),

                // TextField(
                //   controller: _subjectController,
                //   decoration: InputDecoration(
                //     labelText: 'Subject',
                //     border: OutlineInputBorder(),
                //   ),
                // ),
        
                // SizedBox(height: 8),

                // TextField(
                //   controller: _contextController,
                //   decoration: InputDecoration(
                //     labelText: 'Context',
                //     border: OutlineInputBorder(),
                //   ),
                // ),

                // SizedBox(height: 8),

                Row(
                  children: [

                    Expanded(
                      child: TextFormField(
                        controller: _subjectController,
                        decoration: const InputDecoration(labelText: 'New Subject', border: OutlineInputBorder()),
                        onFieldSubmitted: (_) => _addSubject(), // Add on Enter
                      ),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: _addSubject,
                      child: const Text('Add'),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [

                    Expanded(
                      child: TextFormField(
                        controller: _contextController,
                        decoration: const InputDecoration(labelText: 'New Context', border: OutlineInputBorder()),
                        onFieldSubmitted: (_) => _addContext(), // Add on Enter
                      ),
                    ),

                    const SizedBox(width: 10),

                    ElevatedButton(
                      onPressed: _addContext,
                      child: const Text('Add'),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                if (_subjects.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Subjects:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(), // To disable scrolling of the list itself
                        itemCount: _subjects.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_subjects[index]),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _removeSubject(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                const SizedBox(height: 8),
            
                if (_contexts.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Contexts:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(), // To disable scrolling of the list itself
                        itemCount: _contexts.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_contexts[index]),
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _removeContext(index),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),

                const SizedBox(height: 8),

                ElevatedButton(
                  // onPressed: _isFormValid ? _submitForm : null,
                  onPressed: _contexts.isEmpty
                    ? null
                    : () {
                        _createPrompts();
                        Navigator.pop(context, _createdPrompts);
                      },
                  child: Text('Build Prompts'),
                ),

              ]
            )
            )
          ),
        )

    );
  }
}