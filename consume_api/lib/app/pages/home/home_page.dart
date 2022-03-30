import 'package:consume_api/app/models/device_model.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;
import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../app_controller.dart';
import '../../repositories/device_repository.dart';
import '../../services/client_http_service.dart';
import '../../shared/molecules/custom_switch_widget.dart';
import '../../viewmodels/api_viewmodel.dart';
import 'home_page_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = HomeController(
    ApiViewModel(
      ApiRepository(
        ClientHttpService(),
      ),
    ),
  );

  bool isLoading = false;
  bool isPressed = false;
  String name = '';
  DeviceModel deviceModel = DeviceModel();

  init() async {
    deviceModel = await controller.getGetState();
    setState(() {
      isLoading = true;
      if (deviceModel.state == "off") {
        isPressed = false;
      } else {
        isPressed = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFE7ECEF);
    Offset distance = isPressed ? const Offset(10, 10) : const Offset(28, 28);
    double blur = isPressed ? 5.0 : 30.0;
    return ValueListenableBuilder<bool>(
      valueListenable: AppController.instance.themeSwitch,
      builder: (context, isDark, child) {
        return Scaffold(
          appBar: AppBar(
            title: Card(
              child: TextFormField(
                decoration: const InputDecoration(
                  hintText: ' Procurar...',
                ),
                onChanged: (val) {
                  setState(() {
                    name = val;
                  });
                },
              ),
            ),
            toolbarHeight: 100,
            flexibleSpace: Image.asset(
              isDark ? "assets/images/night.jpg" : "assets/images/light.jpg",
              fit: BoxFit.cover,
            ),
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                  onPressed: () {
                    init();
                  },
                  icon: const Icon(FontAwesomeIcons.search)),
              CustomSwitchWidget(),
            ],
          ),
          body: Center(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isPressed = !isPressed;
                  if (isPressed == true) {
                    controller.getSetState("off");
                  } else {
                    controller.getSetState("on");
                  }
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 100),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: blur,
                      offset: -distance,
                      color: Colors.white,
                      inset: isPressed,
                    ),
                    BoxShadow(
                      blurRadius: blur,
                      offset: distance,
                      color: const Color(0xFFA7A9AF),
                      inset: isPressed,
                    ),
                  ],
                ),
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: isPressed
                      ? const Icon(
                          Icons.lightbulb_outline,
                          size: 55,
                          color: Colors.yellow,
                        )
                      : const Icon(
                          Icons.lightbulb_outline,
                          size: 55,
                          color: Colors.grey,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
