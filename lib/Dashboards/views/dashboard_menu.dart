// import 'package:aiso/Dashboards/view_models/dashboard_view_model.dart';
import 'package:aiso/Dashboards/views/dashboard_screen.dart';
import 'package:flutter/material.dart';

class Dashboard {
  final IconData icon;
  final String title;
  final String description;
  final int number;

  Dashboard({
    required this.icon,
    required this.title,
    required this.description,
    required this.number,
  });
}

class DashboardMenu extends StatelessWidget {
  
  const DashboardMenu({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Dashboard> dashboards = [
    Dashboard(
      icon: Icons.analytics,
      title: 'Marketing Overview',
      description: 'Track your advertising campaigns, performance metrics, and ROAS.',
      number: 0
    ),
    Dashboard(
      icon: Icons.shopping_cart,
      title: 'E-Commerce Sales',
      description: 'Daily and monthly sales summaries, top-performing products, and conversion rates.',
      number: 1
    ),
    Dashboard(
      icon: Icons.people,
      title: 'User Retention',
      description: 'Monitor user churn, engagement trends, and cohort analysis.',
      number: 2
    ),
  ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboards'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: dashboards.length,
        itemBuilder: (context, index) {
          return DashboardCard(dashboard: dashboards[index]);
        },
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final Dashboard dashboard;
  final VoidCallback? onTap;

  const DashboardCard({super.key, required this.dashboard, this.onTap,});

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        // onTap: () async {
        //   // final viewModel = DashboardViewModel();
        //   // final url = await viewModel.generateDashUrl();
        //   final url = 'http://metabase-6fvc.onrender.com/embed/dashboard/eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyZXNvdXJjZSI6eyJkYXNoYm9hcmQiOjJ9LCJwYXJhbXMiOnsicmVwb3J0X2lkIjpbIjFhM2JiYjA3LTRjMDAtNDkxYy1iOTI5LTNiMDY3NDg4MTk2YiJdfSwiZXhwIjoxNzQ5MTA3NTg3fQ.k8z8eW8QDwD0O9VMxd-dKUFoqWb7tPJsHFPkyrH05Pc#bordered=true&titled=true';
        //   if (!context.mounted) return;  
        //   Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => DashboardScreen(url: url),
        //     ),
        //   );
        // },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(dashboard.icon, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dashboard.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dashboard.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.open_in_new),
            ],
          ),
        ),
      ),
    );
  }
}
