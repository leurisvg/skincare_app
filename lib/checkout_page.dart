import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:skincare_products/state_provider.dart';

import 'package:skincare_products/home_page.dart';
import 'package:skincare_products/products.dart';

const _animationDuration = const Duration(milliseconds: 1000);

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animationOpacity;
  Animation _animationTextMovementUp;
  Animation _animationButtonMovementUp;

  @override
  void initState() {
    this._animationController = AnimationController(vsync: this, duration: _animationDuration);
    _animationOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        curve: Interval(0.0, 0.25),
        parent: _animationController,
      ),
    );

    _animationTextMovementUp = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        curve: Interval(0.30, 0.7),
        parent: _animationController,
      ),
    );

    _animationButtonMovementUp = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        curve: Interval(0.7, 1.0),
        parent: _animationController,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final stateProvider = Provider.of<StateProvider>(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      this._animationController.forward(from: 0.0);
    });

    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Stack(
            children: [
              Positioned(
                top: kToolbarHeight + MediaQuery.of(context).padding.top,
                child: Container(
                  height: size.height - kToolbarHeight - MediaQuery.of(context).padding.top,
                  width: size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                    color: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Opacity(
                              opacity: _animationOpacity.value,
                              child: IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onPressed: () async {
                                  stateProvider.homeOpacity = false;

                                  await Navigator.of(context).push(
                                    PageRouteBuilder(
                                      opaque: false,
                                      transitionDuration: const Duration(milliseconds: 300),
                                      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
                                        return CheckoutPage();
                                      },
                                      transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
                                        return FadeTransition(
                                          child: HomePage(),
                                          opacity: animation,
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Opacity(
                          opacity: _animationOpacity.value,
                          child: Text(
                            'Cart',
                            style: Theme.of(context).textTheme.headline4.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              ...List.generate(stateProvider.cart.length, (index) {
                                final item = stateProvider.cart[index];

                                return CartItem(
                                  item: item,
                                  duration: Duration(milliseconds: 200 + (150 * (index + 1))),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Transform.translate(
                            offset: Offset(0.0, 50 * _animationTextMovementUp.value),
                            child: Opacity(
                              opacity: (1 - _animationTextMovementUp.value),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Delivery:',
                                        style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.grey, fontSize: 17),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: '${stateProvider.delivery.toStringAsFixed(2)}',
                                          style: Theme.of(context).textTheme.headline6.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                          children: [
                                            TextSpan(
                                              text: ' \$',
                                              style: Theme.of(context).textTheme.headline6.copyWith(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    color: Colors.white,
                                    height: 50,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total:',
                                        style: Theme.of(context).textTheme.subtitle2.copyWith(color: Colors.grey, fontSize: 20),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          text: '${stateProvider.total.toStringAsFixed(2)}',
                                          style: Theme.of(context).textTheme.headline6.copyWith(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 23,
                                              ),
                                          children: [
                                            TextSpan(
                                              text: ' \$',
                                              style: Theme.of(context).textTheme.headline6.copyWith(
                                                    fontSize: 16,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: Offset(0.0, 40 * _animationButtonMovementUp.value),
                          child: Opacity(
                            opacity: (1 - _animationButtonMovementUp.value),
                            child: RawMaterialButton(
                              onPressed: () {},
                              child: Text(
                                'CHECKOUT',
                                style: TextStyle(color: Colors.white, letterSpacing: 1.1, fontSize: 15),
                              ),
                              fillColor: Color(0xff938773),
                              shape: StadiumBorder(),
                              padding: const EdgeInsets.all(22),
                              constraints: BoxConstraints(
                                minWidth: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class CartItem extends StatelessWidget {
  final SkinProduct item;
  final Duration duration;

  const CartItem({@required this.item, @required this.duration});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: this.duration,
      tween: Tween<double>(begin: 1, end: 0),
      builder: (context, value, _) {
        return Transform.translate(
          offset: Offset(0.0, 150 * value),
          child: AnimatedOpacity(
            duration: this.duration,
            opacity: (1 - value),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                    ),
                    child: Image.asset(
                      this.item.image,
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: SizedBox(
                      height: 120,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.volume,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                  fontSize: 13,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w200,
                                ),
                          ),
                          Spacer(),
                          ItemQuantity(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  RichText(
                    text: TextSpan(
                      text: '${item.price}',
                      style: Theme.of(context).textTheme.headline6.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                      children: [
                        TextSpan(
                          text: ' \$',
                          style: Theme.of(context).textTheme.headline6.copyWith(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ItemQuantity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      width: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey,
          style: BorderStyle.solid,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.remove, color: Colors.grey, size: 18),
          Text(
            '1',
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          Icon(Icons.add, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}
