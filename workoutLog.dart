import 'package:flutter/material.dart';

void main() {
  runApp(FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange)
            .copyWith(secondary: Colors.redAccent),
      ),
      home: WorkoutLogScreen(),
    );
  }
}

class Workout {
  final String activity;
  final int duration; // minutes
  final double calories;

  Workout({
    required this.activity,
    required this.duration,
    required this.calories,
  });
}

class WorkoutLogScreen extends StatefulWidget {
  @override
  _WorkoutLogScreenState createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final List<Workout> _workouts = [];

  final Map<String, double> metValues = {
    "Running": 9.8,
    "Cycling": 7.5,
    "Walking": 3.5,
    "Yoga": 3.0,
    "Strength Training": 6.0,
    "HIIT": 8.0,
    "Swimming": 6.0,
  };

  final Map<String, IconData> activityIcons = {
    "Running": Icons.directions_run,
    "Cycling": Icons.pedal_bike,
    "Walking": Icons.directions_walk,
    "Yoga": Icons.self_improvement,
    "Strength Training": Icons.fitness_center,
    "HIIT": Icons.flash_on,
    "Swimming": Icons.pool,
  };

  String _selectedActivity = "Running";
  int _duration = 30;
  double _weight = 70;

  void _addWorkout() {
    final met = metValues[_selectedActivity] ?? 1.0;
    final durationHours = _duration / 60.0;
    final calories = met * _weight * durationHours;

    if (_duration <= 0 || _weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter valid weight and duration.")),
      );
      return;
    }

    setState(() {
      _workouts.add(Workout(
        activity: _selectedActivity,
        duration: _duration,
        calories: calories,
      ));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Workout logged successfully.")),
    );
  }

  void _deleteWorkout(int index) {
    final removed = _workouts[index];
    setState(() {
      _workouts.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Deleted ${removed.activity} - ${removed.duration} min")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade200, Colors.red.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Hero Banner
              Container(
                height: 160,
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepOrange, Colors.redAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 6),
                    )
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_fire_department,
                          size: 56, color: Colors.white),
                      SizedBox(height: 10),
                      Text(
                        "Workout Tracker",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        "Log workouts • Burn calories",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _glassCard(
                      child: DropdownButtonFormField<String>(
                        value: _selectedActivity,
                        items: metValues.keys.map((activity) {
                          return DropdownMenuItem(
                            value: activity,
                            child: Row(
                              children: [
                                Icon(activityIcons[activity], color: primary),
                                SizedBox(width: 10),
                                Text(activity),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() {
                          _selectedActivity = value!;
                        }),
                        decoration: InputDecoration(
                          labelText: "Select activity",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),

                    _glassCard(
                      child: TextFormField(
                        initialValue: _duration.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Duration (minutes)",
                          prefixIcon: Icon(Icons.timer, color: primary),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          _duration = int.tryParse(value) ?? 30;
                        },
                      ),
                    ),
                    SizedBox(height: 12),

                    _glassCard(
                      child: TextFormField(
                        initialValue: _weight.toString(),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "Weight (kg)",
                          prefixIcon: Icon(Icons.monitor_weight, color: primary),
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          _weight = double.tryParse(value) ?? 70;
                        },
                      ),
                    ),
                    SizedBox(height: 16),

                    // Log button
                    GestureDetector(
                      onTap: _addWorkout,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.deepOrange, Colors.redAccent],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Log workout",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // History header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Workout history",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_workouts.isNotEmpty)
                          Chip(
                            label: Text("${_workouts.length}"),
                            backgroundColor: Colors.orange.shade100,
                          ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Workout list
                    _workouts.isEmpty
                        ? _emptyState()
                        : Column(
                            children: _workouts.asMap().entries.map((entry) {
                              final index = entry.key;
                              final workout = entry.value;
                              final icon = activityIcons[workout.activity] ?? Icons.fitness_center;

                              return Card(
                                elevation: 3,
                                margin: EdgeInsets.symmetric(vertical: 6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.orange.shade100,
                                    child: Icon(icon, color: Colors.deepOrange),
                                  ),
                                  title: Text(
                                    "${workout.activity} • ${workout.duration} min",
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                    "Calories: ${workout.calories.toStringAsFixed(2)} kcal",
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () => _deleteWorkout(index),
                                    tooltip: "Delete",
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

    Widget _glassCard({required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(2, 4),
          ),
        ],
        border: Border.all(color: Colors.deepOrange.shade100, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.event_note, color: Colors.deepOrange, size: 40),
          SizedBox(height: 8),
          Text(
            "No workouts logged yet",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 4),
          Text(
            "Add your first workout to begin tracking",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
