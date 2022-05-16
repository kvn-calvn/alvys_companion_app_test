import 'package:alvys3/src/common_widgets/stop_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadDetailsPage extends StatefulWidget {
  const LoadDetailsPage({Key? key}) : super(key: key);

  @override
  _LoadDetailsPageState createState() => _LoadDetailsPageState();
}

class _LoadDetailsPageState extends State<LoadDetailsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Text(
          '1000047',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            /* borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,*/
            icon: const Icon(
              Icons.map_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              debugPrint('IconButton pressed ...');
            },
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF1F4F8),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 0),
                child: Container(
                  width: double.infinity,
                  height: 60,
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
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 8, 5, 5),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/echecks');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Text(
                              'E-Checks',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0.9, 0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFF95A1AC),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/loaddocs');
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
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
                      padding: const EdgeInsetsDirectional.fromSTEB(5, 8, 5, 8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                            child: Text(
                              'Documents',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: AlignmentDirectional(0.9, 0),
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Color(0xFF95A1AC),
                                size: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(15, 10, 15, 0),
                    child: Wrap(
                      spacing: 5,
                      runSpacing: 8,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFBBDEFB),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Flatbed/Reefer/Van 45\''),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFBBDEFB),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('21,000lbs'),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFBBDEFB),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('41.0°F'),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFFBBDEFB),
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('1564mi'),
                          ),
                        ),
                        Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFBBDEFB),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Trailer#TL104'),
                            )),
                        Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFBBDEFB),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Payable \$4566'),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              const StopCard()
            ],
          ),
        ],
      ),
    );
  }
}
