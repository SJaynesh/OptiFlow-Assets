import 'dart:developer';
import 'dart:io';

import 'package:app_code/modules/utils/helpers/fcm_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../globals/routes.dart';
import '../helpers/firebase_auth_helper.dart';

class HomePageComponet extends StatelessWidget {
  const HomePageComponet({super.key});

  @override
  Widget build(BuildContext context) {
    TextScaler textScaler = MediaQuery.of(context).textScaler;
    Size size = MediaQuery.of(context).size;
    double h = size.height;
    double w = size.width;
    bool isChart = true;
    return StreamBuilder(
        stream: FCMHelper.fcmHelper.getTotalEarningAndSales(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error : ${snapshot.error}"),
            );
          } else if (snapshot.hasData) {
            DocumentSnapshot<Map<String, dynamic>>? data = snapshot.data;
            Map<String, dynamic> summary = data?.data() ?? {};

            // int items = 0;
            //
            // String email =
            //     FireBaseAuthHelper.firebaseAuth.firebase.currentUser!.email!;
            //
            // for (int i = 0; i < departmentList.length; i++) {
            //   FCMHelper.fcmHelper.firestore
            //       .collection("Inventory-Management")
            //       .doc(email)
            //       .collection("Department")
            //       .doc(departmentList[i])
            //       .get()
            //       .then((value) {
            //     Map<String, dynamic> data = value.data() ?? {};
            //     List myItems = data[departmentList[i]] ?? [];
            //     items += myItems.length;
            //
            //     log("ITEMS : $items");
            //   });
            // }
            return Padding(
              padding: EdgeInsets.all(h * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"Automate Your Inventory, ',
                    style: GoogleFonts.vollkorn(
                      textStyle: TextStyle(
                        fontSize: textScaler.scale(20),
                        letterSpacing: 0.8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        ' Simplify Your Life.',
                        style: GoogleFonts.vollkorn(
                          textStyle: TextStyle(
                            fontSize: textScaler.scale(20),
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      Text(
                        '"',
                        style: GoogleFonts.vollkorn(
                          textStyle: TextStyle(
                            fontSize: textScaler.scale(23),
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff181657),
                      borderRadius: BorderRadius.circular(w * 0.03),
                    ),
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: h * 0.025,
                            left: w * 0.03,
                          ),
                          child: Text(
                            "Summary",
                            style: TextStyle(
                              fontSize: textScaler.scale(20),
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: h * 0.03,
                            left: w * 0.035,
                            right: w * 0.035,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Department",
                                style: TextStyle(
                                  fontSize: textScaler.scale(16),
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xffaeaddf),
                                ),
                              ),
                              Text(
                                "Items",
                                style: TextStyle(
                                  fontSize: textScaler.scale(16),
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xffaeaddf),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: w * 0.035,
                            right: w * 0.035,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "ALL Departments",
                                style: TextStyle(
                                  fontSize: textScaler.scale(16),
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffFFFFFF),
                                ),
                              ),
                              Text(
                                "${summary['items']}",
                                style: TextStyle(
                                  fontSize: textScaler.scale(16),
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffFFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: h * 0.015,
                            left: w * 0.035,
                            right: w * 0.035,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Earning",
                                style: TextStyle(
                                  fontSize: textScaler.scale(16),
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xffaeaddf),
                                ),
                              ),
                              Text(
                                "Sales",
                                style: TextStyle(
                                  fontSize: textScaler.scale(16),
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xffaeaddf),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: w * 0.035,
                            right: w * 0.035,
                            bottom: h * 0.025,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${summary['earning']}",
                                style: TextStyle(
                                  fontSize: textScaler.scale(16),
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffFFFFFF),
                                ),
                              ),
                              Text(
                                "${summary['sales']}",
                                style: TextStyle(
                                  fontSize: textScaler.scale(16),
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffFFFFFF),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: h * 0.38,
                    padding: EdgeInsets.all(w * 0.03),
                    margin: EdgeInsets.only(
                      top: w * 0.03,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xff3c325f).withOpacity(0.6),
                          const Color(0xff271e44),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(
                        w * 0.05,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                "Unfold Shop 2018",
                                style: TextStyle(
                                  color: Colors.white38,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                "Monthly Sales",
                                style: TextStyle(
                                  fontSize: textScaler.scale(30),
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: h * 0.015,
                        ),
                        Expanded(
                          flex: 2,
                          child: LineChart(
                            (isChart)
                                ? LineChartData(
                                    lineTouchData: LineTouchData(
                                      handleBuiltInTouches: true,
                                      touchTooltipData: LineTouchTooltipData(
                                        getTooltipColor: (touchedSpot) =>
                                            Colors.blueGrey.withOpacity(0.8),
                                      ),
                                    ),
                                    gridData: const FlGridData(show: true),
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 32,
                                          interval: 1,
                                          getTitlesWidget: (value, meta) {
                                            final style = TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: textScaler.scale(16),
                                              color: Colors.grey,
                                            );
                                            Widget text;
                                            switch (value.toInt()) {
                                              case 2:
                                                text = Text(
                                                  'JAN',
                                                  style: style,
                                                );
                                                break;
                                              case 7:
                                                text = Text(
                                                  'FEB',
                                                  style: style,
                                                );
                                                break;
                                              case 12:
                                                text = Text(
                                                  'MAR',
                                                  style: style,
                                                );
                                                break;
                                              default:
                                                text = const Text('');
                                                break;
                                            }

                                            return SideTitleWidget(
                                              axisSide: meta.axisSide,
                                              space: 10,
                                              child: text,
                                            );
                                          },
                                        ),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          getTitlesWidget: (value, meta) {
                                            final style = TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: textScaler.scale(14),
                                              color: const Color(0xff8383D7FF),
                                            );
                                            String text;
                                            switch (value.toInt()) {
                                              case 1:
                                                text = '1m';
                                                break;
                                              case 2:
                                                text = '2m';
                                                break;
                                              case 3:
                                                text = '3m';
                                                break;
                                              case 4:
                                                text = '5m';
                                                break;
                                              case 5:
                                                text = '6m';
                                                break;
                                              default:
                                                return Container();
                                            }

                                            return Text(
                                              text,
                                              style: style,
                                              textAlign: TextAlign.center,
                                            );
                                          },
                                          showTitles: true,
                                          interval: 1,
                                          reservedSize: 40,
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        bottom: BorderSide(
                                          color: const Color(0xFF50E4FF)
                                              .withOpacity(0.2),
                                          width: 4,
                                        ),
                                        left: const BorderSide(
                                            color: Colors.transparent),
                                        right: const BorderSide(
                                            color: Colors.transparent),
                                        top: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                    lineBarsData: [
                                      LineChartBarData(
                                        isCurved: true,
                                        color: const Color(0xFF3BFF49),
                                        barWidth: 8,
                                        isStrokeCapRound: true,
                                        dotData: const FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: false,
                                        ),
                                        spots: const [
                                          FlSpot(1, 1),
                                          FlSpot(3, 1.5),
                                          FlSpot(5, 1.4),
                                          FlSpot(7, 3.4),
                                          FlSpot(10, 2),
                                          FlSpot(12, 2.2),
                                          FlSpot(13, 1.8),
                                        ],
                                      ),
                                      LineChartBarData(
                                        isCurved: true,
                                        color: const Color(0xFFFF3AF2)
                                            .withOpacity(0.5),
                                        barWidth: 8,
                                        isStrokeCapRound: true,
                                        dotData: const FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: const Color(0xFFFF3AF2)
                                              .withOpacity(0.2),
                                        ),
                                        spots: const [
                                          FlSpot(1, 1),
                                          FlSpot(3, 2.8),
                                          FlSpot(7, 1.2),
                                          FlSpot(10, 2.8),
                                          FlSpot(12, 2.6),
                                          FlSpot(13, 3.9),
                                        ],
                                      ),
                                      LineChartBarData(
                                        isCurved: true,
                                        // curveSmoothness: 0,
                                        color: const Color(0xFF50E4FF)
                                            .withOpacity(0.5),
                                        barWidth: 8,
                                        isStrokeCapRound: true,
                                        dotData: const FlDotData(show: true),
                                        belowBarData: BarAreaData(show: false),
                                        spots: const [
                                          FlSpot(1, 3.8),
                                          FlSpot(3, 1.9),
                                          FlSpot(6, 5),
                                          FlSpot(10, 3.3),
                                          FlSpot(13, 4.5),
                                        ],
                                      ),
                                    ],
                                    minX: 0,
                                    maxX: 14,
                                    maxY: 4,
                                    minY: 0,
                                    // lineTouchData: const LineTouchData(enabled: false),
                                  )
                                : LineChartData(
                                    lineTouchData: const LineTouchData(
                                      enabled: false,
                                    ),
                                    gridData: const FlGridData(show: false),
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          reservedSize: 32,
                                          interval: 1,
                                          getTitlesWidget: (value, meta) {
                                            const style = TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            );
                                            Widget text;
                                            switch (value.toInt()) {
                                              case 2:
                                                text = const Text('SEPT',
                                                    style: style);
                                                break;
                                              case 7:
                                                text = const Text('OCT',
                                                    style: style);
                                                break;
                                              case 12:
                                                text = const Text('DEC',
                                                    style: style);
                                                break;
                                              default:
                                                text = const Text('');
                                                break;
                                            }

                                            return SideTitleWidget(
                                              axisSide: meta.axisSide,
                                              space: 10,
                                              child: text,
                                            );
                                          },
                                        ),
                                      ),
                                      rightTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      topTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false),
                                      ),
                                      leftTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          getTitlesWidget: (value, meta) {
                                            const style = TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            );
                                            String text;
                                            switch (value.toInt()) {
                                              case 1:
                                                text = '1m';
                                                break;
                                              case 2:
                                                text = '2m';
                                                break;
                                              case 3:
                                                text = '3m';
                                                break;
                                              case 4:
                                                text = '5m';
                                                break;
                                              case 5:
                                                text = '6m';
                                                break;
                                              default:
                                                return Container();
                                            }

                                            return Text(
                                              text,
                                              style: style,
                                              textAlign: TextAlign.center,
                                            );
                                          },
                                          showTitles: true,
                                          interval: 1,
                                          reservedSize: 40,
                                        ),
                                      ),
                                    ),
                                    borderData: FlBorderData(
                                      show: true,
                                      border: Border(
                                        bottom: BorderSide(
                                            color: const Color(0xFF50E4FF)
                                                .withOpacity(0.2),
                                            width: 4),
                                        left: const BorderSide(
                                            color: Colors.transparent),
                                        right: const BorderSide(
                                            color: Colors.transparent),
                                        top: const BorderSide(
                                            color: Colors.transparent),
                                      ),
                                    ),
                                    lineBarsData: [
                                      LineChartBarData(
                                        isCurved: true,
                                        // curveSmoothness: 0,
                                        color: const Color(0xFF3BFF49)
                                            .withOpacity(0.5),
                                        barWidth: 4,
                                        isStrokeCapRound: true,
                                        dotData: const FlDotData(show: false),
                                        belowBarData: BarAreaData(show: false),
                                        spots: const [
                                          FlSpot(1, 1),
                                          FlSpot(3, 4),
                                          FlSpot(5, 1.8),
                                          FlSpot(7, 5),
                                          FlSpot(10, 2),
                                          FlSpot(12, 2.2),
                                          FlSpot(13, 1.8),
                                        ],
                                      ),
                                      LineChartBarData(
                                        isCurved: true,
                                        color: const Color(0xFFFF3AF2)
                                            .withOpacity(0.5),
                                        barWidth: 4,
                                        isStrokeCapRound: true,
                                        dotData: const FlDotData(show: false),
                                        belowBarData: BarAreaData(
                                          show: true,
                                          color: const Color(0xFFFF3AF2)
                                              .withOpacity(0.2),
                                        ),
                                        spots: const [
                                          FlSpot(1, 1),
                                          FlSpot(3, 2.8),
                                          FlSpot(7, 1.2),
                                          FlSpot(10, 2.8),
                                          FlSpot(12, 2.6),
                                          FlSpot(13, 3.9),
                                        ],
                                      ),
                                      LineChartBarData(
                                        isCurved: true,
                                        // curveSmoothness: 0,
                                        color: const Color(0xFF50E4FF)
                                            .withOpacity(0.5),
                                        barWidth: 4,
                                        isStrokeCapRound: true,
                                        dotData: const FlDotData(show: true),
                                        belowBarData: BarAreaData(show: false),
                                        spots: const [
                                          FlSpot(1, 3.8),
                                          FlSpot(3, 1.9),
                                          FlSpot(6, 5),
                                          FlSpot(10, 3.3),
                                          FlSpot(13, 4.5),
                                        ],
                                      )
                                    ],
                                    minX: 0,
                                    maxX: 14,
                                    maxY: 6,
                                    minY: 0,
                                    // lineTouchData: const LineTouchData(enabled: false),
                                  ),
                            duration: const Duration(milliseconds: 250),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
