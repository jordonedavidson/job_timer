import 'package:flutter/material.dart';

class Timer extends StatelessWidget {
  const Timer({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: Center(
        child: Column(
          children: [
            const Text(
              '00:00:00',
              style: TextStyle(fontSize: 80),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_arrow,
                      size: 50,
                    )),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.stop,
                      size: 50,
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
