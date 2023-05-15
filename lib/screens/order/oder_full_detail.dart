import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../utils/constant.dart';

class OrderStatusScrn extends StatefulWidget {
  static String routeName = '/OrderStatusScrn';
  const OrderStatusScrn({Key? key}) : super(key: key);

  @override
  State<OrderStatusScrn> createState() => _OrderStatusScrnState();
}

class _OrderStatusScrnState extends State<OrderStatusScrn> {
  double? getRating;

  //cancel order bottom sheet

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Order Full Details',
          style: headline1(context: context),
        ),
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                'HELP',
                style: bodyText2Bold(context: context, color: primary),
              )),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Order',
                style: bodyText1Bold(context: context),
              ),
              const SizedBox(
                height: 10,
              ),
              //ordered card
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  trailing: Container(
                    margin: const EdgeInsets.only(right: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: boxDecoration(),
                    child: Text(
                      'Qty-2',
                      style: bodyText2Bold(context: context),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        '900gms I Net: 450gms',
                        style:
                            bodyText3(context: context, color: textLightColor),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            style: bodyText2Bold(context: context),
                            text: 'Rs.250'),
                      ])),
                    ],
                  ),
                  title: Text(
                    'Polutry Chicken',
                    style: bodyText2(context: context),
                  ),
                  leading: Image.asset('assets/images/chicken.png'),
                ),
              ),
             const Divider(color: textLightColor,),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  trailing: Container(
                    margin: const EdgeInsets.only(right: 5),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: boxDecoration(),
                    child: Text(
                      'Qty-2',
                      style: bodyText2Bold(context: context),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 3,
                      ),
                      Text(
                        '900gms I Net: 450gms',
                        style:
                            bodyText3(context: context, color: textLightColor),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Text.rich(TextSpan(children: [
                        TextSpan(
                            style: bodyText2Bold(context: context),
                            text: 'Rs.250'),
                      ])),
                    ],
                  ),
                  title: Text(
                    'Polutry Chicken',
                    style: bodyText2(context: context),
                  ),
                  leading: Image.asset('assets/images/chicken.png'),
                ),
              ),
             
              //price card
              Container(
                decoration: boxDecoration(),
                child: ExpansionTile(
                  iconColor: primary,
                  title: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: ListTile.divideTiles(
                        color: textLightColor,
                        tiles: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Item Total',
                                  style: bodyText2Bold(context: context),
                                ),
                                Text(
                                  'Rs.400',
                                  style: bodyText2Bold(context: context),
                                ),
                              ],
                            ),
                          ),
                        
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total',
                                  style: bodyText1Bold(context: context),
                                ),
                                Text(
                                  'Rs.440',
                                  style: bodyText1Bold(
                                      color: primary, context: context),
                                ),
                              ],
                            ),
                          ),
                        ]).toList(),
                  ),
                  children: [
                    //order tracking detail
                    const Divider(color: textLightColor,),
                    const OrderTimeLine(),
                    const Divider(color: textLightColor,),

                    //delivery boy
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5),
                      child: Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Image.asset(
                                'assets/images/profile.png',
                                scale: 1.4,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                  style: bodyText2Bold(
                                    context: context,
                                  ),
                                  text: 'Rajesh Kumar '),
                              TextSpan(
                                  style: bodyText2(
                                    context: context,
                                  ),
                                  text:
                                      'is delivery boy contact him for any query '),
                            ])),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/images/phone-call.png',
                                scale: 1.5,
                              )),
                        ],
                      ),
                    ),
                    //costomer
                    Container(
                      margin: const EdgeInsets.only(left: 5, right: 5, top: 10),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5),
                      child: Row(
                        children: [
                          CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Image.asset(
                                'assets/images/profile.png',
                                scale: 1.4,
                              )),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text.rich(TextSpan(children: [
                              TextSpan(
                                  style: bodyText2Bold(
                                    context: context,
                                  ),
                                  text: 'Rahul '),
                              TextSpan(
                                  style: bodyText2(
                                    context: context,
                                  ),
                                  text:
                                      'is your customer contact him if you have query about order'),
                            ])),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: Image.asset(
                                'assets/images/phone-call.png',
                                scale: 1.5,
                              )),
                        ],
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
  }
}

class OrderTimeLine extends StatefulWidget {
  const OrderTimeLine({Key? key}) : super(key: key);

  @override
  State<OrderTimeLine> createState() => _OrderTimeLineState();
}

class _OrderTimeLineState extends State<OrderTimeLine> {
  int totalSteps = 3;
  String? selectReason;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          // padding: EdgeInsets.all(5),
          child: _buildTimelineTile(index, context),
        );
      },
    );
  }

  Widget _buildTimelineTile(int index, context) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.4,
      isFirst: index == 0 ? false : true,
      isLast: index == totalSteps - 1 ? true : false,
      indicatorStyle: IndicatorStyle(
        width: 20,
        height: 20,
        indicator: _buildIndicator(),
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        indicatorXY: 0,
      ),
      afterLineStyle: const LineStyle(
        thickness: 3,
        color: secondary1,
      ),
      beforeLineStyle: const LineStyle(
        thickness: 3,
        color: secondary1,
      ),
      startChild: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text("Wed, 07 Aug", style: bodyText2(context: context)),
            const SizedBox(height: 5),
            Text("2:35 AM",
                style: bodyText3(context: context, color: textLightColor)),
          ],
        ),
      ),
      endChild: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order Confirmed", style: bodyText2(context: context)),
            const SizedBox(height: 5),
            InkWell(
                onTap: () {},
                child: Text("cancel Order",
                    style: bodyText3(context: context, color: primary))),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator() {
    return Container(
      width: 25,
      height: 25,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.green,
      ),
      child: const Center(
        child: Icon(
          Icons.check,
          color: Colors.white,
          size: 15,
        ),
      ),
    );
  }
}
