
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:komas_latihan/User/home_page.dart";

// ignore: must_be_immutable
class otp extends StatefulWidget {

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {

//controller
final TextEditingController _otpController = TextEditingController();

 //method register
 void register(){

 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade200,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const SizedBox(
              height: 40,
            ),

            //logo
            Image.asset('lib/src/images/register.png', width: 350, fit: BoxFit.cover,),

            const SizedBox(
              height: 50,
            ),


            //welcome back message
            Center(
              child: Text(
                "Mohon isi Kode dengan benar",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 16, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            
            const SizedBox(
              height: 40,
            ),
            Container(
              width: MediaQuery.of(context).size.width*0.8,
              child: Column(
                children: [
                  TextField(
                    controller: _otpController,
                    maxLength: 8,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly, ],
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5,left: 15),
                        border: OutlineInputBorder(),
                        hintFadeDuration: Duration(milliseconds: 300),
                        alignLabelWithHint: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Masukkan OTP',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 221, 210, 210),
                          ),
                    ),
                  ),
                ]
              ),
            ),
              const SizedBox(
                height: 10,
              ),

            //login button
             Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child:  Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStatePropertyAll(Size(110, 40)),
                    alignment: Alignment.center,
                    backgroundColor: MaterialStateColor.resolveWith((states) {
                        return Colors.brown;
                    })
                  ),
                  onPressed: () {
                    String otp = _otpController.text.trim();
                    
                    if (otp.isNotEmpty) {
                        Navigator.of(context).pop();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(),));
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                
                        ),
                      ),
                    ],
                  ),
                  ),
              )
            ),

            const SizedBox(
                height: 30,
              ),
            //login now
            
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Text(
                "Kode OTP sudah dikirim",
                ),
            ],
            ),

            const SizedBox(
              height: 50,
            ),
          
          ],
        ),
      ),
    );
  }
}