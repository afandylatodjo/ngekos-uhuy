import "package:cool_alert/cool_alert.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:komas_latihan/pages/login_page.dart";
import "package:komas_latihan/pages/otp_page.dart";
import "package:komas_latihan/utils/client_request.dart";
import "package:komas_latihan/utils/settings.dart";
import "package:komas_latihan/utils/shared_pref.dart";

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});


  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

//controller
final TextEditingController _emailController = TextEditingController();
final TextEditingController _usernameController = TextEditingController();
final TextEditingController _nomorController = TextEditingController();
final TextEditingController _pwController = TextEditingController();
final TextEditingController _confirmController = TextEditingController();

 //method register
 void register(String email, String username, String phonenumber, String password){
  Map<String, dynamic> postBody = {
    "email": email,
    "userName": username,
    "phoneNumber": phonenumber,
    "password": password 
    
  };
  String url = MySettings.getUrl()+"register";
  final response = ClientRequest.postData(url, postBody).then((value){
    if(value["status"]=="OK"){
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => otp()));
    }
    else{
      debugPrint("Cant register!");
    }
  });

 }

  String sanitizedNumber(String phoneNumber){
    List<String> sanitized = phoneNumber.split("");
    int start = 0; 
    int end = sanitized.first == "0" ? 1 : 2;
    sanitized.fillRange(start, end, "62");
    phoneNumber = sanitized.join("");
    return phoneNumber;
    // debugPrint(phoneNumber);
    // debugPrint("Sanitized"+sanitized.join("").toString());
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
                "Mohon isi data dengan benar",
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


            //email textfield
             SizedBox(
              width: MediaQuery.of(context).size.width*0.8,
              child: Column(
                children: [
                  TextField(
                    controller: _emailController,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9@.]'))],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(bottom: 5, left: 15),
                        hintFadeDuration: Duration(milliseconds: 300),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Masukkan Email',
                          hintStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.dotted,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 221, 210, 210),
                          ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: _usernameController,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9@.]'))],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(bottom: 5, left: 15),
                        hintFadeDuration: Duration(milliseconds: 300),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Masukkan Username',
                          hintStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.dotted,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 221, 210, 210),
                          ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                TextField(
                    controller: _nomorController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.only(bottom: 5, left: 15),
                        hintFadeDuration: Duration(milliseconds: 300),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Masukkan Nomor Telepon',
                          hintStyle: TextStyle(
                            decorationStyle: TextDecorationStyle.dotted,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 221, 210, 210),
                          ),
                    ),
                  ),
                const SizedBox(
                  height: 20,
                ),
                  TextField(
                    controller: _pwController,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]')), ],
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5,left: 15),
                        border: OutlineInputBorder(),
                        hintFadeDuration: Duration(milliseconds: 300),
                        alignLabelWithHint: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Masukkan Password',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 221, 210, 210),
                          ),
                    ),
                  ),
                  const SizedBox(
                  height: 20,
                ),
                  TextField(
                    controller: _confirmController,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]'))],
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 5,left: 15),
                        border: OutlineInputBorder(),
                        hintFadeDuration: Duration(milliseconds: 300),
                        alignLabelWithHint: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: 'Konfirmasi Password',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 221, 210, 210),
                          ),
                    ),
                  ),
                ],
              ),
            ),
              const SizedBox(
                height: 20,
              ),

            //login button
             Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child:  Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                    fixedSize: MaterialStatePropertyAll(const Size(110, 40)),
                    alignment: Alignment.center,
                    backgroundColor: MaterialStateColor.resolveWith((states) {
                        return Colors.brown;
                    })
                  ),
                  onPressed: () {
                    String email = _emailController.text.trim();
                    String username = _usernameController.text.trim();
                    String telepon = _nomorController.text.trim();
                    String password = _pwController.text.trim();
                    String konfirm = _confirmController.text.trim();
                    
                    telepon = sanitizedNumber(telepon);
                    
                    if (email.isNotEmpty && username.isNotEmpty && password.isNotEmpty && konfirm.isNotEmpty && telepon.isNotEmpty) {
                      if (konfirm == password) {
                          register(email, username, telepon, konfirm);
                      } else{
                        CoolAlert.show(
                            context: context,
                            type: CoolAlertType.error,
                            title: 'Gagal',
                            text: "\n Password Tidak sama \n",
                          );
                      }
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
                height: 20,
              ),
            //login now
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Text(
                "sudah punya akun?",
                ),

              GestureDetector(
                onTap: () {
                setState(() {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(admin: true,),));
                });
                },
                child: Text("Masuk di sini",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                
                ),
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