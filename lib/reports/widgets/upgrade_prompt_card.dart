import 'package:flutter/material.dart';

class UpgradePromptCard extends StatelessWidget {
  final VoidCallback onSubscribe;

  const UpgradePromptCard({super.key, required this.onSubscribe});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.all(24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Upgrade to view',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // const Text(
              //   'Recommendations to become #1',
              //   textAlign: TextAlign.center,
              //   style: TextStyle(fontSize: 16, color: Colors.black54),
              // ),

              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Recommendations to become #1',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.black, // or any color you want
                              ),
                          ),
                        ],
                      ),
                  
                      Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        // 'Up to 10 reports / month',
                        'Up to 10 suburb reports / month', 
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black, // or any color you want
                          ),
                      ),
                    ],
                  ),
                  
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Automated monthly report updates',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black, // or any color you want
                          ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Interactive dashboards',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.black, // or any color you want
                          ),
                      ),
                    ],
                  ),
                  
                    ],
                  ),
                ),
              ),

               



              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onSubscribe,
                child: const Text('Subscribe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
