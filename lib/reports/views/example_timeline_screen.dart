// import 'dart:math';

// import 'package:aiso/constants/buttons_constants.dart';
import 'package:aiso/reports/views/timeline.dart';
import 'package:flutter/material.dart';

/// A demo screen that shows the Timeline widget in action.
/// You can advance the “current step” using the buttons at the bottom.
class ExampleTimelineScreen extends StatefulWidget {
  const ExampleTimelineScreen({super.key});

  @override
  State<ExampleTimelineScreen> createState() => _ExampleTimelineScreenState();
}

class _ExampleTimelineScreenState extends State<ExampleTimelineScreen> {
  // Sample data for the timeline.
  // final List<StepData> _steps = [
  //   StepData(title: 'Step 1', description: 'Register your account'),
  //   StepData(title: 'Step 2', description: 'Verify email address'),
  //   StepData(title: 'Step 3', description: 'Complete profile setup'),
  //   StepData(title: 'Step 4', description: 'Choose subscription plan'),
  //   StepData(title: 'Step 5', description: 'Start using the service'),
  // ];

    final List<StepData> _steps = [
    StepData(title: 'Initialising', description: 'Setting up our services.'),
    StepData(title: 'Generating results', description: 'Generating results from LLMs.'),
    StepData(title: 'Searching for you business', description: 'Searching the LLM results for your business.'),
    StepData(title: 'Done!', description: 'Woohoo! :rocket:'),
  ];

  // The index of the currently highlighted step.
  int _currentStep = 1;

  @override
  Widget build(BuildContext context) {

    // double screenWidth = MediaQuery.of(context).size.width;
    // double buttonWidth = ButtonDimensions.getWidth(ButtonSize.large);
    // // double buttonHeight = ButtonDimensions.getHeight(ButtonSize.small);
    // double maxButtonWidth = min(buttonWidth, screenWidth);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline Cards Example'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              Expanded(
                child: Timeline(
                  steps: _steps,
                  currentStep: _currentStep,
                  highlightColor: Colors.green,
                  defaultColor: Colors.grey.shade300,
                ),
              ),
          
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _currentStep > 0
                          ? () {
                              setState(() {
                                _currentStep--;
                              });
                            }
                          : null,
                      child: const Text('Previous'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: _currentStep < _steps.length - 1
                          ? () {
                              setState(() {
                                _currentStep++;
                              });
                            }
                          : null,
                      child: const Text('Next'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}