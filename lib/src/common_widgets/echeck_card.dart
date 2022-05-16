import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EcheckCard extends StatelessWidget {
  const EcheckCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              blurRadius: 5,
              color: Color(0x3B000000),
              offset: Offset(0, 2),
            )
          ],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '408251113064137591',
                      style: GoogleFonts.oxygenMono(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        textStyle: const TextStyle(
                            color: Color(0xFF090F13), letterSpacing: 1.5),
                      ),
                    )
                  ],
                ),
              ),
              Text(
                'Funds Available',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  textStyle: const TextStyle(color: Color(0xFF090F13)),
                ),
              ),
              Text(
                '\$30.00',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  textStyle: const TextStyle(color: Color(0xFF090F13)),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trailer Wash',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                        textStyle: const TextStyle(color: Color(0xFF95A1AC)),
                      ),
                    )
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
