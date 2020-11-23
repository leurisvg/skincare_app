import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import 'package:skincare_products/state_provider.dart';

import 'package:skincare_products/checkout_page.dart';
import 'package:skincare_products/products.dart';

const Color _backgroundColor = Color(0xffeae9e4);
const Color _textColor = Color(0xff32312d);
const Color _cardColor = Color(0xfff6f4f2);

const _cartButtonSize = 70.0;
const _animationDuration = const Duration(milliseconds: 700);

const IconData settings = const IconData(
  0xf7dc,
  fontFamily: CupertinoIcons.iconFont,
  fontPackage: CupertinoIcons.iconFontPackage,
);

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final stateProvider = Provider.of<StateProvider>(context);

    return Scaffold(
      backgroundColor: _backgroundColor,
      extendBody: true,
      appBar: CustomAppBar(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 50),
            child: ShaderMask(
              shaderCallback: (Rect rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, _backgroundColor],
                  stops: [0.85, 1.0], // 10% purple, 80% transparent, 10% purple
                ).createShader(rect);
              },
              blendMode: BlendMode.dstOut,
              child: SizedBox(
                height: MediaQuery.of(context).size.height - kToolbarHeight - 50,
                child: StaggeredDualView(
                  itemCount: products.length,
                  aspectRatio: 0.7,
                  spacing: 15,
                  itemBuilder: (context, index) {
                    final item = products[index];

                    return ItemCard(item: item);
                  },
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
              child: Row(
                children: [
                  Filter(label: 'hydrate'),
                  const SizedBox(width: 10),
                  Filter(label: 'treat & masque'),
                ],
              ),
            ),
          ),
          if (stateProvider.initAnimation || stateProvider.homeOpacity) DragOpacity(),
          TweenAnimationBuilder(
            duration: _animationDuration,
            tween: Tween<double>(begin: _cartButtonSize, end: stateProvider.initAnimation ? (MediaQuery.of(context).size.width * 1.7) : _cartButtonSize),
            curve: Curves.easeOutCubic,
            builder: (BuildContext context, double size, Widget child) {
              final position = (-size / 2) + (_cartButtonSize / 2) + 20;

              return Positioned(
                right: position,
                bottom: position,
                child: Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    color: Color(0xffe5e1db).withOpacity(0.65),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          TweenAnimationBuilder(
            duration: _animationDuration,
            tween: Tween<double>(begin: _cartButtonSize, end: stateProvider.initAnimation ? (MediaQuery.of(context).size.width * 0.9) : _cartButtonSize),
            curve: Curves.easeOutCubic,
            builder: (BuildContext context, double size, Widget child) {
              final position = (-size / 2) + (_cartButtonSize / 2) + 20;

              return Positioned(
                right: position,
                bottom: position,
                child: Container(
                  height: size,
                  width: size,
                  decoration: BoxDecoration(
                    color: Color(0xffd8d4cc).withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final position = ((((25 + 70) / 2) - 30) / 2) - 1;

              return AnimatedPositioned(
                duration: _animationDuration,
                right: stateProvider.initAnimation ? position : 20,
                bottom: stateProvider.initAnimation ? position : 20,
                child: CartButton(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ItemCard extends StatefulWidget {
  final SkinProduct item;

  const ItemCard({@required this.item});

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    final stateProvider = Provider.of<StateProvider>(context);

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _backgroundColor,
            _cardColor,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Draggable(
                data: widget.item,
                feedback: Transform.translate(
                  offset: Offset((constraints.maxWidth / 2) - 25, 0),
                  child: TweenAnimationBuilder(
                    duration: _animationDuration,
                    tween: Tween<double>(begin: 0.0, end: 1.0),
                    builder: (BuildContext context, double value, Widget child) {
                      return Transform.rotate(
                        angle: vector.radians(-15 * value),
                        child: Image.asset(
                          widget.item.image,
                          height: 125,
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
                childWhenDragging: Center(
                  child: Container(
                    width: 125,
                    height: 125,
                    color: Colors.transparent,
                  ),
                ),
                onDragStarted: () {
                  stateProvider.initAnimation = true;
                },
                onDraggableCanceled: (_, __) {
                  stateProvider.initAnimation = false;
                },
                child: TweenAnimationBuilder(
                  duration: Duration(milliseconds: stateProvider.initAnimation ? 200 : 0),
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  curve: Curves.easeOutCubic,
                  builder: (BuildContext context, double value, Widget child) {
                    return SizedBox(
                      height: 125,
                      width: constraints.maxWidth,
                      child: Align(
                        alignment: Alignment.center,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: value,
                          child: Image.asset(
                            widget.item.image,
                            height: 125 * value,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
                text: '${widget.item.price}',
                style: Theme.of(context).textTheme.headline5.copyWith(
                      color: _textColor,
                      fontWeight: FontWeight.bold,
                    ),
                children: [
                  TextSpan(
                    text: ' \$',
                    style: Theme.of(context).textTheme.headline6.copyWith(
                          fontSize: 17,
                          color: _textColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ]),
          ),
          const SizedBox(height: 10),
          Text(
            widget.item.name,
            style: Theme.of(context).textTheme.subtitle2.copyWith(color: _textColor, fontSize: 15),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 5),
          Text(
            widget.item.volume,
            style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class Filter extends StatelessWidget {
  final String label;

  const Filter({@required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Color(0xfff6f4f2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            this.label,
            style: Theme.of(context).textTheme.subtitle2.copyWith(
                  color: _textColor,
                  fontSize: 17,
                ),
          ),
          const SizedBox(width: 5),
          Icon(
            Icons.clear,
            size: 18,
            color: Colors.grey[700],
          ),
        ],
      ),
    );
  }
}

class StaggeredDualView extends StatelessWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final double spacing;
  final double aspectRatio;

  const StaggeredDualView({
    @required this.itemBuilder,
    @required this.itemCount,
    this.spacing = 0.0,
    this.aspectRatio = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final width = constraints.maxWidth;
        final itemHeight = (width * 0.5) / aspectRatio;
        final height = constraints.maxHeight + itemHeight;

        return OverflowBox(
          maxWidth: width,
          minWidth: width,
          maxHeight: height,
          minHeight: height,
          child: GridView.builder(
            padding: EdgeInsets.only(top: itemHeight / 2, bottom: itemHeight),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: this.aspectRatio,
              crossAxisSpacing: this.spacing,
              mainAxisSpacing: this.spacing,
            ),
            itemCount: this.itemCount,
            itemBuilder: (context, index) {
              return Transform.translate(
                offset: Offset(0.0, index.isEven ? itemHeight * 0.1 : 0.0),
                child: itemBuilder(context, index),
              );
            },
          ),
        );
      },
    );
  }
}

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stateProvider = Provider.of<StateProvider>(context);

    return DragTarget(
      onAccept: (SkinProduct item) {
        stateProvider.initAnimation = false;

        stateProvider.addItem(item);
      },
      builder: (BuildContext context, List candidateData, List<dynamic> rejectedData) {
        return GestureDetector(
          onTap: () async {
            stateProvider.homeOpacity = true;
            await Navigator.of(context).push(
              PageRouteBuilder(
                opaque: false,
                transitionDuration: const Duration(milliseconds: 300),
                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                  return CheckoutPage();
                },
                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                  return ScaleTransition(
                    alignment: Alignment(0.8, 0.9),
                    child: child,
                    scale: animation,
                  );
                },
              ),
            );
          },
          child: AnimatedContainer(
            duration: _animationDuration,
            height: stateProvider.initAnimation ? _cartButtonSize + 25 : _cartButtonSize,
            width: stateProvider.initAnimation ? _cartButtonSize + 25 : _cartButtonSize,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: Stack(
              children: [
                Center(
                  child: Icon(Icons.shopping_bag, color: Colors.white, size: 30),
                ),
                AnimatedPositioned(
                  duration: _animationDuration,
                  top: stateProvider.initAnimation ? 22 : 13,
                  right: stateProvider.initAnimation ? 22 : 13,
                  child: AnimatedContainer(
                    duration: _animationDuration,
                    height: stateProvider.initAnimation ? 25 : 20,
                    width: stateProvider.initAnimation ? 25 : 20,
                    decoration: BoxDecoration(
                      color: Color(0xff938773),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        stateProvider.cart.length.toString(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class DragOpacity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
        child: Container(
          height: size.height,
          width: size.width,
          color: _cardColor.withOpacity(0.5),
        ),
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final stateProvider = Provider.of<StateProvider>(context);

    return PreferredSize(
      preferredSize: Size(double.infinity, kToolbarHeight),
      child: Stack(
        children: [
          AppBar(
            backgroundColor: _backgroundColor,
            elevation: 0,
            brightness: Brightness.light,
            title: Text(
              'Skin',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: _textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            leading: Icon(
              Icons.arrow_back_ios_outlined,
              color: _textColor,
            ),
            actions: [
              Icon(
                settings,
                size: 30,
                color: _textColor,
              ),
              const SizedBox(width: 25),
            ],
          ),
          if (stateProvider.initAnimation || stateProvider.homeOpacity) DragOpacity(),
        ],
      ),
    );
  }
}
