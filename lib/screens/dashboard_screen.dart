import 'package:flutter/material.dart';
import 'package:flutter_future_builder_sample/constants/colors.dart';
import 'package:flutter_future_builder_sample/models/summary_data.dart';
import 'package:flutter_future_builder_sample/repo/covid_repo.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreenState createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final COVIDDataRepository covidDataRepo = COVIDDataRepositoryImpl();
  Future<SummaryResponse> summaryResponse;

  @override
  void initState() {
    super.initState();
    summaryResponse = covidDataRepo.getSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dashboardScreenBackground,
      body: SafeArea(
        child: dashBoardBody(),
      ),
    );
  }

  Widget dashBoardBody() {
    return FutureBuilder<SummaryResponse>(
      future: summaryResponse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<String> titles = List<String>();
          titles.add("New Confirmed");
          titles.add("Total Confirmed");
          titles.add("New Deaths");
          titles.add("Total Deaths");
          titles.add("New Recovered");
          titles.add("Total Recovered");
          List<int> counts = List<int>();
          counts.add(snapshot.data.global.newConfirmed);
          counts.add(snapshot.data.global.totalConfirmed);
          counts.add(snapshot.data.global.newDeaths);
          counts.add(snapshot.data.global.totalDeaths);
          counts.add(snapshot.data.global.newRecovered);
          counts.add(snapshot.data.global.totalRecovered);
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Global Statistics',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                  child: GridView.builder(
                      itemCount: 6,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 16.0,
                      ),
                      itemBuilder: (context, index) {
                        return StatisticsWidget(
                          color: dashboardColors[index],
                          title: titles[index],
                          count: counts[index],
                        );
                      }),
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Failed to fetch COVID-19 summary',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: color2,
            ),
          );
        }
      },
    );
  }
}

class StatisticsWidget extends StatelessWidget {
  final Color color;
  final String title;
  final int count;

  const StatisticsWidget({
    Key key,
    this.color,
    this.title,
    this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: color),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '$count',
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
