import 'package:flutter/material.dart';

class StopCard extends StatelessWidget {
  const StopCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              blurRadius: 2,
              color: Color(0x3416202A),
              offset: Offset(0, 1),
            )
          ],
        ),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                  ),
                  width: 5,
                  height: 120,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: Text(
                                'Russellville TVDC',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              '4820 E Main St',
                              style: TextStyle(
                                  color: Color(0XFF57636C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Russellville AR 72802',
                              style: TextStyle(
                                  color: Color(0XFF57636C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
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
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: Text(
                                'Appointment',
                                style: TextStyle(
                                    color: Color(0XFF57636C),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              'Jan 28, 2022 @ 15:00',
                              style: TextStyle(
                                  color: Color(0XFF57636C),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 5, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              debugPrint("Check In");
                            },
                            style: ElevatedButton.styleFrom(
                              //minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Check In',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              debugPrint("Check Out");
                            },
                            style: ElevatedButton.styleFrom(
                              //minimumSize: const Size.fromHeight(50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            child: const Text(
                              'Check Out',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            debugPrint("E-Check");
                          },
                          style: ElevatedButton.styleFrom(
                            //minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Text(
                            'E-Check',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
