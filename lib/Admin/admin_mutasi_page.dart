import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:komas_latihan/utils/client_request.dart';
import 'package:komas_latihan/utils/settings.dart';

class AdminMtsi {
  bool readiable = false;
  bool tolak = false;
  String nama;
  String nokamar;
  String harga;
  Color warna;
  int waktutinggal;

  String tanggl = DateFormat("dd-MM-yyyy").format(DateTime.now());
  String bulanini = DateFormat("dd-MM").format(DateTime.now());
  String bulandepan = DateFormat("dd-MM-yyyy")
      .format(DateTime.now().add(const Duration(days: 30)));

  String jam = DateFormat("HH-mm").format(DateTime.now());

  AdminMtsi(
      {required this.nama,
      required this.nokamar,
      required this.harga,
      required this.warna,
      required this.waktutinggal});
}

class UserData {
  String? username,
      roomNumber,
      floorNumber,
      roomPrice,
      days,
      startDate,
      endDate;
  bool? isVerified, isPaid;
  bool isDenied = false;

  // UserData(
  //     {this.username,
  //     this.roomNumber,
  //     this.floorNumber,
  //     this.days,
  //     this.isVerified});

  UserData.fromJson(Map<String, dynamic> json) {
    username = json["userName"];
    roomNumber = json["roomNumber"];
    floorNumber = json["floorNumber"];
    roomPrice = json["roomPrice"];
    startDate = json["startDate"];
    endDate = json["endDate"];
    days = json["daysLeft"];
    isVerified = json["isVerified"];
    isPaid = json["isPaid"];
  }
}

class AdminMutasiPage extends StatefulWidget {
  const AdminMutasiPage({super.key});

  @override
  State<AdminMutasiPage> createState() => _AdminMutasiPageState();
}

class _AdminMutasiPageState extends State<AdminMutasiPage> {
  int selectedIndex = 0;

  bool perip = true;

  String ending = '...';

  bool gambar = true;

  String tanggal = DateFormat("dd-MM-yyyy").format(DateTime.now());

  List<AdminMtsi> mutasi = List.empty(growable: true);
  // List<AdminMtsi> mutasi = ([
  //   AdminMtsi(
  //     nama: 'rafli',
  //     nokamar: 'Kamar No 5 Lt 1',
  //     harga: '500.000 - 30 hari',
  //     warna: Colors.orange,
  //     waktutinggal: 30,
  //   ),
  //   AdminMtsi(
  //     nama: 'afdal',
  //     nokamar: 'Kamar No 2 Lt 2',
  //     harga: '450.000 - 30 hari',
  //     warna: Colors.orange,
  //     waktutinggal: 49,
  //   ),
  //   AdminMtsi(
  //     nama: 'anan',
  //     nokamar: 'Kamar No 9 Lt 1',
  //     harga: '600.000 - 60 hari',
  //     warna: Colors.orange,
  //     waktutinggal: 60,
  //   ),
  // ]);

  Color warna1 = Colors.brown.shade200;
  Color warna2 = Colors.brown;

  Future<List<UserData>>? futureUsers;
  Future<List<UserData>>? fetchAllRentData(String url) async {
    List<UserData> listOfUserRent = [];
    final response = await ClientRequest.getAll(url);
    response.forEach((v) {
      print(v);
      listOfUserRent.add(UserData.fromJson(<String, dynamic>{
        "userName": v["user"]["user_name"],
        "roomNumber": v["room"]["room_number"],
        "floorNumber": v["room"]["floorId"].toString(),
        "roomPrice": v["room"]["room_price"],
        "startDate": v["start_date"],
        "endDate": v["end_date"],
        "daysLeft": "30",
        "isVerified": v["is_verified"] >= 1 ? true : false,
        "isPaid": v["paid"] >= 1 ? true : false
      }));
    });

    return listOfUserRent;
  }

  Future<bool> verifyUserPayment(String url, UserData user) async {
    if (user.isVerified!) {
      print("User is already verified!");
      return false;
    } else {
      Map<String, dynamic> uploadBody = {
        "userName": user.username,
        "roomNumber": user.roomNumber,
        "floorNumber": user.floorNumber,
        "verify": "1"
      };
      final response = await ClientRequest.updateData(url, uploadBody);
      print(response);
      return (response["status"] == "OK") ? true : false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureUsers = fetchAllRentData(MySettings.getUrl() + ("rents"));
    // fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: warna2,
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                alignment: Alignment.center,
                child: perip
                    ? const Text(
                        "Verifikasi",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      )
                    : const Text(
                        "Verifikasi Transaksi",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data!.isNotEmpty &&
              snapshot.data! != []) {
            print(
                "DATA: isPaid: ${snapshot.data![0].isPaid} isVerified: ${snapshot.data![0].isVerified}");
            return perip
                ? verifyList(snapshot.data)
                : verifwidget(selectedIndex, snapshot.data!);
          } else {
            print("Data is Empty");
            return emptyHistory();
            // return perip
            //     ? daftarWidget()
            //     : verifwidget(selectedIndex, snapshot.data!);
          }
        },
      ),
      // body: perip? daftarWidget(): verifwidget(selectedIndex)
    );
  }

  Widget emptyHistory() {
    return const Center(
        child: Text(
      "Belum ada mutasi",
      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
    ));
  }

  Widget verifyList(List<UserData>? users) {
    return ListView.builder(
        itemCount: users!.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;
                print(
                    "IS PAID: ${users[index].isPaid} || IS VERIFIED: ${users[index].isVerified}");

                perip = false;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(
                  left: 15, top: 10, right: 15, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kamar No ${users[index].roomNumber} Lt ${users[index].floorNumber}",
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            users[index].username!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          users[index].isDenied
                              ? const Text(
                                  'Verifikasi Ditolak',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                              : users[index].isPaid! == true &&
                                      users[index].isVerified! == true
                                  ? const Text(
                                      'Lunas',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : const Text(
                                      'Verifikasi',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold),
                                    ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Masa Aktif',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          '${users[index].days} hari',
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget daftarWidget() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedIndex = index;

                perip = false;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(
                  left: 15, top: 10, right: 15, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mutasi[index].nokamar,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            mutasi[index].nama,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          mutasi[index].tolak
                              ? const Text(
                                  'Verifikasi Ditolak',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
                                )
                              : mutasi[index].readiable
                                  ? const Text(
                                      'lunas',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Text(
                                      'Verifikasi',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: mutasi[index].warna,
                                          fontWeight: FontWeight.bold),
                                    ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Masa Aktif',
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          '${mutasi[index].waktutinggal} hari',
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 0,
          );
        },
        itemCount: mutasi.length);
  }

  Widget verifwidget(int index, List<UserData> users) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ListView(children: [
        const SizedBox(
          height: 15,
        ),
        Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 5, top: 13),
                  child: Text(
                    'Profil',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w200),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      height: 35,
                      width: 35,
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('lib/src/images/3.jpeg'),
                        radius: 1,
                      ),
                      // decoration: const BoxDecoration(
                      //   shape: BoxShape.circle,
                      //   image: DecorationImage(
                      //       image: AssetImage('lib/src/images/3.jpeg'),
                      //       fit: BoxFit.cover),
                      // ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (users[index].roomNumber == null ||
                                    users[index].roomNumber!.isEmpty)
                                ? mutasi[index].nokamar
                                : "Kamar No. ${users[index].roomNumber} Lt. ${users[index].floorNumber}",
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (users[index].username == null ||
                                    users[index].username!.isEmpty)
                                ? mutasi[index].nama
                                : users[index].username!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  thickness: 1,
                  color: Colors.black,
                )
                // garispemabatas()
              ],
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Bukti Transaksi',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pembayaran',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Rp.${users[index].roomPrice!}',
                  style: const TextStyle(
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                gambar
                    ? Container(
                        alignment: Alignment.center,
                        height: 80,
                        width: MediaQuery.of(context).size.width,
                        child: ClientRequest.getPaymnentProofImageFromNetwork(
                            MySettings.getUrl(),
                            "room/payment/proof/user/${users[index].roomNumber}/${users[index].floorNumber}/${users[index].username!}",
                            <String, dynamic>{
                              "fit": BoxFit.cover,
                              "width": 300.0,
                              "height": 300.0,
                            })
                        // decoration: const BoxDecoration(
                        //   image: DecorationImage(
                        //       image: AssetImage(
                        //           'lib/src/images/dashboardkos.jpeg'),
                        //       fit: BoxFit.cover),
                        // ),
                        )
                    : Container(
                        alignment: Alignment.center,
                        child: ClientRequest.getPaymnentProofImageFromNetwork(
                            MySettings.getUrl(),
                            "room/payment/proof/user/${users[index].roomNumber}/${users[index].floorNumber}/${users[index].username!}",
                            <String, dynamic>{
                              "fit": BoxFit.contain,
                              "width": 500.0,
                              "height": 500.0
                            }),
                        // decoration: const BoxDecoration(
                        //   image: DecorationImage(
                        //       image: AssetImage(
                        //           'lib/src/images/dashboardkos.jpeg'),
                        //       fit: BoxFit.fitWidth),
                        // ),
                      ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (gambar == true) {
                            gambar = false;
                          } else {
                            gambar = true;
                          }
                        });
                      },
                      child: const Text(
                        'Lihat Detail',
                        style: TextStyle(
                            fontSize: 10, decoration: TextDecoration.underline),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(thickness: 1, color: Colors.black),
            // garispemabatas(),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Waktu Tinggal',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w200),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // "${DateFormat('MM/dd/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(users[index].startDate!)))} s/d ${DateFormat('MM/dd/yyyy').format(DateTime.fromMicrosecondsSinceEpoch(int.parse(users[index].endDate!)))}",
                  // '${mutasi[index].bulanini} s/d ${mutasi[index].bulandepan}',
                  // '${DateTime.fromMicrosecondsSinceEpoch(int.parse(users[index].startDate!))} s/d ${DateTime.fromMillisecondsSinceEpoch(int.parse(users[index].endDate!))}',
                  "${users[index].startDate} s/d ${users[index].endDate}",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // GestureDetector(
                //     onTap: () {
                //       setState(() {
                //         showDialog(
                //             context: context,
                //             builder: (context) => AlertDialog(
                //                   contentPadding: EdgeInsets.zero,
                //                   shape: RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(30),
                //                   ),
                //                   actions: [
                //                     Center(
                //                       child: Padding(
                //                         padding: const EdgeInsets.only(top: 25),
                //                         child: TextButton(
                //                             onPressed: () {
                //                               setState(() {});
                //                               Navigator.of(context).pop();
                //                             },
                //                             child: Text(
                //                               'oke',
                //                               style: TextStyle(
                //                                   fontSize: 12, color: warna2),
                //                             )),
                //                       ),
                //                     ),
                //                   ],
                //                 ));
                //       });
                //     },
                //     child: const Text(
                //       'Edit',
                //       style: TextStyle(
                //           fontSize: 10,
                //           color: Colors.red,
                //           fontWeight: FontWeight.bold,
                //           decoration: TextDecoration.underline,
                //           decorationColor: Colors.red),
                //     )),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        users.isNotEmpty ? accORdenie(index, users) : savecancel(index),
        // users[index].isDenied ||
        //         users[index].isPaid! && users[index].isVerified!
        //     ? Padding(
        //         padding: const EdgeInsets.only(top: 20),
        //         child: InkWell(
        //             onTap: () {
        //               setState(() {
        //                 perip = true;
        //                 users[index].isDenied = false;
        //                 // mutasi[index].readiable = false;
        //               });
        //             },
        //             borderRadius: BorderRadius.circular(15),
        //             child: Container(
        //               alignment: Alignment.center,
        //               height: 30,
        //               width: 90,
        //               decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(15),
        //                   color: Colors.red.shade400),
        //               child: const Text(
        //                 textAlign: TextAlign.center,
        //                 'Batalkan',
        //                 style: TextStyle(fontSize: 11, color: Colors.white),
        //               ),
        //             )),
        //       )
        //     : const SizedBox(
        //         height: 0,
        //         width: 0,
        //       ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: InkWell(
            onTap: () {
              setState(() {
                perip = true;
              });
            },
            borderRadius: BorderRadius.circular(15),
            child: Container(
              alignment: Alignment.center,
              height: 30,
              width: 90,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15), color: warna2),
              child: const Text(
                textAlign: TextAlign.center,
                'Kembali',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 100,
        )
      ]),
    );
  }

  void deleteDeniedRent(String url) {
    ClientRequest.deleteData(url).then((response) {
      if (response["status"] == "OK") {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          title: 'Ditolak',
          text: "\nTransaksi Berhasil Ditolak\n",
        );
        setState(() {
          futureUsers = fetchAllRentData(MySettings.getUrl() + ("rents"));
        });
      } else {
        CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          title: 'Ditolak',
          text: "\nTransaksi Gagal Ditolak\n",
        );
        setState(() {});
      }
    });
  }

  //Copied from savecancel and used for FutureBuilder
  Widget accORdenie(int index, List<UserData> users) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          (users[index].isPaid! && users[index].isVerified!)
          ? const SizedBox()
          : OutlinedButton(
            onPressed: () {
              setState(() {
                users[index].isDenied = true;
                perip = true;
                deleteDeniedRent(
                    "${MySettings.getUrl()}rent/delete/${users[index].roomNumber}/${users[index].floorNumber}/${users[index].username}");
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              "Tolak",
              style: TextStyle(
                  fontSize: 10, letterSpacing: 2, color: Colors.black),
            ),
          ),
          (users[index].isVerified!)
              ? const Text(
                  "Lunas",
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 2,
                    color: Colors.green,
                    fontWeight: FontWeight.bold
                  ),
                )
              : ElevatedButton(
                  onPressed: () {
                    verifyUserPayment(
                            MySettings.getUrl() +
                                ("room/payment/proof/user/verify"),
                            users[index])
                        .then((value) {
                      if (value) {
                        setState(() {
                          perip = true;
                          users[index].isPaid = true;
                          users[index].isVerified = true;
                          CoolAlert.show(
                            context: context,
                            type: CoolAlertType.success,
                            title: 'Diverifikasi',
                            text: "\nTransaksi Berhasil Diverifikasi\n",
                          );
                          // mutasi[index].readiable = true;
                        });
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: warna2,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20))),
                  child: const Text(
                    "Terima",
                    style: TextStyle(
                      fontSize: 10,
                      letterSpacing: 2,
                      color: Colors.white,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget savecancel(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton(
            onPressed: () {
              setState(() {
                perip = true;
                mutasi[index].tolak
                    ? null
                    : CoolAlert.show(
                        context: context,
                        type: CoolAlertType.error,
                        title: 'Ditolak',
                        text: "\nTransaksi Berhasil Ditolak\n",
                      );

                mutasi[index].tolak = true;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text(
              "Tolak",
              style: TextStyle(
                  fontSize: 10, letterSpacing: 2, color: Colors.black),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                perip = true;
                mutasi[index].readiable
                    ? null
                    : CoolAlert.show(
                        context: context,
                        type: CoolAlertType.success,
                        title: 'Diverifikasi',
                        text: "\nTransaksi Berhasil Terverifikasi\n",
                      );
                mutasi[index].readiable = true;
              });
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: warna2,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: const Text(
              "Terima",
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 2,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //INFO: Deprecated - Do not use this user Divider Widget instead
  Widget garispemabatas() {
    return Container(
      alignment: Alignment.center,
      child: const Text(
        '_________________________________________',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
