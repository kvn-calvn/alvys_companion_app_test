import 'package:flutter/material.dart';

class TripCard extends StatelessWidget {
  const TripCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/loaddetails');
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 2,
                color: Color(0x3416202A),
                offset: Offset(0, 1),
              )
            ],
            borderRadius: BorderRadius.circular(12),
            shape: BoxShape.rectangle,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 5, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Trip# 1000047',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                      Text(
                        '\$45000.00',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.arrow_upward_outlined,
                        color: Color(0XFFF08080),
                        size: 24,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: Text(
                                '4820 E Main St Russellville, AR',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              'Jan 27, 2022 @ 10:05',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.arrow_downward_outlined,
                        color: Color(0XFF2991C2),
                        size: 24,
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: Text(
                                '609 S Grant St  Amarillo, TX',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              'Jan 28, 2022 @ 15:00',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 5, 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'DH (mi)',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '0.00',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'TRIP (mi)',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '827.7',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'STOPS',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '2',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Text(
                            'WEIGHT',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '_',
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
