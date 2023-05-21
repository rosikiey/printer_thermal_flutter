import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<BluetoothDevice> devices = [];
  BluetoothDevice? selectedDevice;
  BlueThermalPrinter printer  = BlueThermalPrinter.instance;
  String status_print  = "Print Disconnected";
  String? datetoday;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDevice();
    getHariini();
  }

  void getDevice() async {
    devices = await printer.getBondedDevices();
    setState(() {});
  }

  void getStatusPrint() async {
    if ((await printer.isConnected)!){
      setState(() {
        status_print =  "Print Connected";
      });
    }
  }

  void getStatusPrintD() async {
    setState(() {
      status_print =  "Print Disconnected";
    });
  }

  void getHariini(){
    datetoday = DateFormat.yMd().add_Hm().format(DateTime.now());
        setState(() {});
  }

  String? valueChoose;
  List listItem = [
    "Item 1", "Item 2", "Item 3"
  ];

  @override
  Widget build(BuildContext context) {
    final mqWidth = MediaQuery.of(context).size.width;
    final mqHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Color(0XFFbed5fa),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:mqHeight*0.07),
              child: Container(
                width: mqWidth*0.95,
                height: mqHeight * 0.25,
                child: Image(image: AssetImage("images/printtx.png"),),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top:mqHeight*0.01),
                child: Container(
                    child: Text('QR CODE',
                      style: GoogleFonts.notoSansJavanese(
                        textStyle: TextStyle(
                          fontSize: mqHeight*0.04
                        ),
                      )
                    ),
                ),
            ),
            Padding(
              padding: EdgeInsets.only(left :mqWidth*0.09, right: mqWidth*0.09, top :mqHeight*0.005, bottom :mqHeight*0.005),
              child: Center(
                child:
                Container(
                  width: mqWidth*0.95,
                  padding: EdgeInsets.only(left: mqWidth*0.1, right: mqWidth*0.1),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width:1),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  child: DropdownButton(
                      hint: Text('Select Devices'),
                      onChanged: (device){
                        setState(() {
                          selectedDevice = device;
                        });
                      },
                      dropdownColor: Colors.grey,
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: mqHeight*0.03,
                      underline: SizedBox(),
                      isExpanded: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: mqHeight*0.025,
                      ),
                      value: selectedDevice,
                      items: devices.map((e) => DropdownMenuItem(child: Text(e.name!),value: e,)).toList()
                  ),
                ),
              ),
            ),
            SizedBox(
              width: mqWidth*0.01,
              height: mqHeight*0.01,
            ),
            ElevatedButton(onPressed: (){
               printer.connect(selectedDevice!);
               getStatusPrint();
            }, child: Text('Connect'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(mqWidth*0.8 , mqHeight*0.06),
                backgroundColor: Colors.teal,
                elevation: 0,
                shape : const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  )
                ),
                  textStyle: TextStyle(
                      color: Colors.white54,
                      fontSize: mqHeight*0.025
                  )
              )),
            SizedBox(
              width: mqWidth*0.01,
              height: mqHeight*0.01,
            ),
            ElevatedButton(onPressed: (){
              printer.disconnect();
              getStatusPrintD();
            }, child: Text('Disconnect'),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(mqWidth*0.8 , mqHeight*0.06),
                    backgroundColor: Colors.teal,
                    elevation: 0,
                    shape : const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        )
                    ),
                  textStyle: TextStyle(
                    color: Colors.white54,
                    fontSize: mqHeight*0.025
                  )
                )),
            SizedBox(
              width: mqWidth*0.05,
              height: mqHeight*0.05,
            ),
            ElevatedButton(onPressed: () async{
              getHariini();
              if ((await printer.isConnected)!){
                printer.printCustom(datetoday!, 0, 1);
                printer.printQRcode(datetoday!, 200, 200, 1);
                printer.printNewLine();
                printer.printNewLine();
              }
            }, child: Text('Print'),
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(mqWidth*0.8 , mqHeight*0.06),
                    backgroundColor: Colors.deepOrangeAccent,
                    elevation: 0,
                    shape : const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        )
                    ),
                    textStyle: TextStyle(
                        color: Colors.white54,
                        fontSize: mqHeight*0.025
                    )
                )),
            SizedBox(
              width: mqWidth*0.01,
              height: mqHeight*0.05,
            ),
            Padding(
              padding: EdgeInsets.only(top:mqHeight*0.005),
              child: Container(
                child: Text(status_print,
                    style: GoogleFonts.notoSansJavanese(
                      textStyle: TextStyle(
                          fontSize: mqHeight*0.03
                      ),
                    )
                ),
              ),
            ),
          ],
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


