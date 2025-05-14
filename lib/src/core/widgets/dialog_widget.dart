import 'package:flutter/material.dart';

import 'button.dart';

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key,
    required this.title,
    this.onlyClose = false,
    this.body,
    required this.onYes,
  });

  final String title;
  final bool onlyClose;
  final Widget? body;
  final VoidCallback onYes;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.greenAccent,
      child: SizedBox(
        height: 150,
        width: 200,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'w700',
              ),
            ),
            const Spacer(),
            body ?? Container(),
            if (onlyClose)
              _Button(
                title: 'Close',
                onPressed: () {
                  Navigator.pop(context);
                  onYes;
                },
              )
            else
              Row(
                children: [
                  const SizedBox(width: 20),
                  _Button(
                    title: 'No',
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                  _Button(
                    title: 'Yes',
                    onPressed: () {
                      Navigator.pop(context);
                      onYes();
                    },
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Button(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontFamily: 'w700',
            ),
          ),
        ],
      ),
    );
  }
}
