import 'package:flutter/material.dart';
import 'package:radial_button/bloc/bloc_controller.dart';
import 'dart:math' as math;
import 'circle_button.dart';

class CircleFloatingButton extends StatefulWidget {
  final List<Widget> items;
  final double radius;
  final Position position;
  // final double right;
  // final double top;
  final bool completeCircle;
  final CircleType type;
  final Duration duration;
  final Color? buttonColor;
  final IconData buttonIcon;
  final Curve curve ;
  final bool opacity;
  final Widget? child;

  CircleFloatingButton(
      {Key? key,
      required this.items,
      this.radius = 100,
      this.position = Position.right,
      // required this.right,
      // required this.top,
      this.completeCircle = false,
      this.duration = const Duration(milliseconds: 300),
      required this.type,
      required this.buttonColor,
      required this.buttonIcon,
      this.curve = Curves.elasticOut,
      required this.opacity,
      this.child})
      : super(key: key ?? UniqueKey());

  factory CircleFloatingButton.floatingActionButton(
      {required List<Widget> items,
      double radius = 100,
      Duration duration = const Duration(microseconds: 200),
      required IconData icon,
      Color? color,
      Curve curveAnim = Curves.elasticOut,
      bool useOpacity = false,
      Key? key,
      Widget? child}) {
    return CircleFloatingButton(
      items: items,
      key: key,
      radius: radius,
      position: Position.bottom,
      type: CircleType.quarterPart,
      duration: duration,
      buttonIcon: icon,
      buttonColor: color,
      curve: curveAnim,
      opacity: useOpacity,
      child: child
    );
  }

  factory CircleFloatingButton.completeCircle(
      {required List<Widget> items,
      double radius = 100,
      Duration? duration,
      required IconData icon,
      Color? color,
      Curve? curveAnim,
      bool? useOpacity,
      Key? key, required Widget child}) {
    return CircleFloatingButton(
      items: items,
      radius: radius,
      position: Position.bottom,
      type: CircleType.complete,
      duration: duration ?? const Duration(microseconds: 100),
      buttonIcon: icon,
      buttonColor: color,
      curve: curveAnim ??  Curves.elasticOut,
      opacity: useOpacity ?? false,
      key: key,
      child: child,
    );
  }

  factory CircleFloatingButton.semiCircle({
    required List<Widget> items,
    Key? key,
    double radius = 100,
    Position? position,
    Duration duration = const Duration(milliseconds: 100),
    required IconData icon,
    Color? color,
    Curve? curveAnim ,
    bool? useOpacity,
    Widget? child
  }) {
    return CircleFloatingButton(
      items: items,
      radius: radius,
      position: position ?? Position.right,
      type: CircleType.semi,
      duration: duration,
      buttonIcon: icon,
      buttonColor: color,
      curve: curveAnim = Curves.elasticOut,
      opacity: useOpacity ?? true,
      key: key,
      child: child,
    );
  }

  @override
  CircleFloatingButtonState createState() => CircleFloatingButtonState();
}

class CircleFloatingButtonState extends State<CircleFloatingButton> {
  BlocController _bloc = BlocController();
  GlobalKey containerKey = GlobalKey();

  close() {
    _bloc.close();
  }

  toggle(){
	  _bloc.toggle();
  }

  @override
  initState() {
    super.initState();
  }

  Offset _getOffset(double angle, double radius) {
    final double radians = math.pi * angle / 180.0;
    final double x = radius * math.cos(radians) * -1;
    final double y = radius * math.sin(radians) * -1;
    return Offset(x, y);
  }

  getRotatePosition(Position position) {
    switch (position) {
      case Position.right:
        return 90;
      case Position.bottom:
        return 180;
      case Position.left:
        return 270;
      case Position.top:
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case CircleType.semi:
        return semi();
      case CircleType.complete:
        return complete();
      case CircleType.quarterPart:
        return quarterPart();
    }
  }

  Widget quarterPart() {
    var quantity = widget.items.length;
    return Container(
      width: 60 + widget.radius,
      height: 60 + widget.radius,
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(
          quantity,
          (index) {
            var angulo = (90) / (quantity - 1) * (index);

            return CircleButton(
              finalRight: _getOffset(
                          angulo + getRotatePosition(widget.position),
                          -widget.radius)
                      .dy +
                  widget.radius,
              finalTop: _getOffset(angulo + getRotatePosition(widget.position),
                          -widget.radius)
                      .dx +
                  widget.radius,
              initState: widget.radius,
              bloc: _bloc,
              widget: widget.items[index],
              duration: widget.duration,
              curve: widget.curve,
              opacity: widget.opacity,
            );
          },
        )..add(
            Positioned(
              top: widget.radius,
              left: widget.radius,
              child:  widget.child != null
              ? Material(
                  child: InkWell(
                    child: widget.child,
                    onTap: () {
                      _bloc.toggle();
                    },
                  ),
                )
              : FloatingActionButton(
                heroTag: UniqueKey(),
                backgroundColor: widget.buttonColor,
                onPressed: () {
                  _bloc.toggle();
                },
                child: Icon(widget.buttonIcon),
              ),
            ),
          ),
      ),
    );
  }

  Widget complete() {
    var quantity = widget.items.length;
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(
          quantity,
          (index) {
            var angulo = (360) / (quantity) * (index);

            return CircleButton(
                finalRight: _getOffset(
                            angulo + getRotatePosition(widget.position),
                            -widget.radius)
                        .dy +
                    widget.radius,
                finalTop: _getOffset(
                            angulo + getRotatePosition(widget.position),
                            -widget.radius)
                        .dx +
                    widget.radius,
                initState: widget.radius,
                bloc: _bloc,
                duration: widget.duration,
                curve: widget.curve,
                opacity: widget.opacity,
                widget: widget.items[index]);
          },
        )..add(
            Positioned(
              top: widget.radius,
              left: widget.radius,
              child:  Container(
                child: widget.child != null
                    ? Material(
                        child: Center(
                          child: InkWell(
                            child: widget.child,
                            onTap: () {
                              _bloc.toggle();
                            },
                          ),
                        ),
                      )
                : FloatingActionButton(
                  heroTag: UniqueKey(),
                  backgroundColor: widget.buttonColor,
                  onPressed: () {
                    _bloc.toggle();
                  },
                  child: Icon(widget.buttonIcon),
                ),
              ),
            ),
          ),
      ),
    );
  }

  Widget semi() {
    var quantity = widget.items.length;

    return Container(
      child: Stack(
        clipBehavior: Clip.none, children: List.generate(
          quantity,
          (index) {
            var angulo = (180) / (quantity - 1) * (index);

            return CircleButton(
              finalRight: _getOffset(
                          angulo + getRotatePosition(widget.position),
                          -widget.radius)
                      .dy +
                  widget.radius,
              finalTop: _getOffset(angulo + getRotatePosition(widget.position),
                          -widget.radius)
                      .dx +
                  widget.radius,
              initState: widget.radius,
              bloc: _bloc,
              curve: widget.curve,
              duration: widget.duration,
              opacity: widget.opacity,
              widget: widget.items[index],
            );
          },
        )..add(
            Positioned(
              top: widget.radius,
              left: widget.radius,
              child: widget.child != null
                  ? Material(
                      child: InkWell(
                        child: widget.child,
                        onTap: () {
                          _bloc.toggle();
                        },
                      ),
                    )
              : FloatingActionButton(
                heroTag: UniqueKey(),
                backgroundColor: widget.buttonColor,
                onPressed: () {
                  _bloc.toggle();
                },
                child: Icon(widget.buttonIcon),
              ),
            ),
          ),
      ),
    );
  }
}

enum CircleType {
  semi,
  complete,
  quarterPart,
}

enum Position {
  right,
  left,
  top,
  bottom,
}
