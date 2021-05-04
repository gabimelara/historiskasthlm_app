import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:historiskasthlm_app/guidedTour/guideData.dart';
import 'package:historiskasthlm_app/main.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  final _controller = DataPage();

  Expanded Widget;
  build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,// guideLayout
      body: SafeArea(
        child: Stack(children: [
          PageView.builder(
              controller: _controller.pageController,
              onPageChanged: _controller.selectedPageIndex,
              itemCount: _controller.dataPage.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(_controller.dataPage[index].image),
                      SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 0, top: 0), //RUBRIK
                        child: Text(
                          //RUBRIK
                          _controller.dataPage[index].title,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ),
                      SizedBox(height: 32),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 0, top: 0),
                        child: Text(
                          _controller.dataPage[index].description,
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22), //BESKRIVNING
                        ),
                      ),
                    ],
                  ),
                );
              }),
          Positioned(
            //PRICKARNA
            bottom: 20,
            left: 150,
            height: 20,

            child: Row(
              children: List.generate(
                _controller.dataPage.length,
                (index) => Obx(() {
                  return Container(
                    margin: const EdgeInsets.all(3),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: _controller.selectedPageIndex.value == index
                          ? Colors.orange
                          : Colors.white,
                      shape: BoxShape.circle,
                    ),
                  );
                }),
              ),
            ),
          ),
          Positioned(
            // NEXT/START KNAPP
            right: 30,
            bottom: 5,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13)),
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: _controller.forwardAction,
              child: Obx(() {
                return Text(_controller.isLastPage ? 'Start' : 'Next'); //BUG
              }),
            ),
          ),
          Positioned(
              //SKIP KNAPP
              left: 10,
              bottom: 10,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                    primary: Color.fromRGBO(0, 0, 0, 0.0),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9))),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyNavigationBar()),
                  );
                },
                child: new Text('skip',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ))
        ]),
      ),
    );
  }
}
