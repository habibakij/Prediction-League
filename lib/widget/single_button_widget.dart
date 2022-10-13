
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SingleButton extends StatelessWidget {
  final String title;
  final Function()? onPress;
  final Color bgColor;
  final Color sideColor;
  final Color textColor;
  final double fontSize;
  final bool loading;
  const SingleButton({Key? key,required this.title,required this.onPress,required this.bgColor,required this.textColor,required this.loading,required this.sideColor,required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
          style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(1),
              foregroundColor: MaterialStateProperty.all<Color>(bgColor),
              backgroundColor: MaterialStateProperty.all<Color>(bgColor),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(27),
                  side: BorderSide(color: sideColor,width: 1)

              ))

          ),
          onPressed: onPress,
          child:  Center(
              child: loading==false?Text(
                title,
                  style: GoogleFonts.poppins(textStyle: TextStyle(color: textColor,fontWeight: FontWeight.w500,fontSize: fontSize))
              ):const SizedBox(height:25,width:25,child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3,))),
      ),
    );
  }
}
