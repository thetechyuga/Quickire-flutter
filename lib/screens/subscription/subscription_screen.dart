import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickhire/constants/colors.dart';
import 'package:quickhire/models/subscription_plan.dart';
import 'package:quickhire/services/user/subscription_api_service.dart';
import 'package:quickhire/utlities.dart';
import 'package:quickhire/widgets/custom_app_bar.dart';
import 'package:quickhire/widgets/subscription_card.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  final bool isUser;

  const SubscriptionPlanScreen({super.key, this.isUser = true});

  @override
  _SubscriptionPlanScreenState createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  String _selectedSubscription = '';
  double _selectedSubscriptionPrice = 0;
  SubscriptionApiService subscriptionApiService = SubscriptionApiService();
  late Future<List<dynamic>> subscriptionPlansFuture;

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    fetchInitData();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  fetchInitData() {
    subscriptionPlansFuture = widget.isUser
        ? subscriptionApiService.fetchSubscriptionPlans()
        : subscriptionApiService.fetchCompanySubscriptionPlans();
  }

  onContinue() async {
    if (_selectedSubscription == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kindly select one of the plans')),
      );
      return;
    }
    debugPrint(_selectedSubscriptionPrice.toString());
    double orderAmount = _selectedSubscriptionPrice * 100;
    var options = {
      'key': 'rzp_test_VpplcwngWugLBf',
      'amount': orderAmount,
      'name': 'Quick Hire',
      'description': '$_selectedSubscription Subscription',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'theme': {'color': '#8A5BF6'},
    };

    _razorpay.open(options);
  }

  Map<String, dynamic> createSubscription(int duration, String paymentId) {
    DateTime startDate = DateTime.now();
    DateTime endDate = startDate.add(Duration(days: duration));
    String startDateString = generateDate(startDate);
    String endDateString = generateDate(endDate);
    Map<String, dynamic> jsonData = {
      'start_date': startDateString,
      'end_date': endDateString,
      'payment_id': paymentId,
    };
    return jsonData;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    Fluttertoast.showToast(msg: 'Payment Succesful');
    int duration = 0;
    if (_selectedSubscription == 'Weekly') duration = 7;
    if (_selectedSubscription == 'Monthly') duration = 30;
    if (_selectedSubscription == 'Yearly') duration = 365;
    if (response.paymentId == null) {
      Fluttertoast.showToast(
          msg: "Payment Failed! Kindly try again later.",
          toastLength: Toast.LENGTH_SHORT);
      return;
    }
    bool apiResponse = widget.isUser
        ? await subscriptionApiService.createSubscription(
            createSubscription(
              duration,
              response.paymentId.toString(),
            ),
          )
        : await subscriptionApiService.createCompanySubscription(
            createSubscription(
              duration,
              response.paymentId.toString(),
            ),
          );
    if (apiResponse) {
      Navigator.pop(context, true);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: ${response.code} - ${response.message!}",
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    debugPrint('Wallet reposne: $response');
  }

  String formatType(String type) {
    switch (type) {
      case 'Weekly':
        return 'week';
      case 'Monthly':
        return 'month';
      case 'Yearly':
        return 'year';
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar('Subscription Plans'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
            future: subscriptionPlansFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No user data available.'));
              } else {
                List<SubscriptionPlan> plans =
                    snapshot.data! as List<SubscriptionPlan>;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: plans.length,
                          itemBuilder: (context, index) {
                            final plan = plans[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 16,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedSubscription = plan.type;
                                    _selectedSubscriptionPrice =
                                        double.parse(plan.price);
                                  });
                                },
                                child: SubscriptionCard(
                                  title: plan.subscriptionName,
                                  price:
                                      '₹ ${plan.price} / ${formatType(plan.type)}',
                                  isSelected:
                                      _selectedSubscription == plan.type,
                                ),
                              ),
                            );
                          }),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 44),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: onContinue,
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: whiteText,
                        ),
                      ),
                    ),
                  ],
                );
              }
            }
            // child: Column(
            //   crossAxisAlignment: CrossAxisAlignment.stretch,
            //   children: [
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           _selectedSubscription = 'Weekly';
            //         });
            //       },
            //       child: SubscriptionCard(
            //         title: 'Weekly Subscription',
            //         price: '\₹ 9 / week',
            //         isSelected: _selectedSubscription == 'Weekly',
            //       ),
            //     ),
            //     SizedBox(height: 16.0),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           _selectedSubscription = 'Monthly';
            //         });
            //       },
            //       child: SubscriptionCard(
            //         title: 'Monthly Subscription',
            //         price: '\₹ 99 / month',
            //         isSelected: _selectedSubscription == 'Monthly',
            //       ),
            //     ),
            //     SizedBox(height: 16.0),
            //     GestureDetector(
            //       onTap: () {
            //         setState(() {
            //           _selectedSubscription = 'Yearly';
            //         });
            //       },
            //       child: SubscriptionCard(
            //         title: 'Yearly Subscription',
            //         price: '\₹ 999 / year',
            //         isSelected: _selectedSubscription == 'Yearly',
            //       ),
            //     ),
            //     Spacer(),
            //     ElevatedButton(
            //       style: ElevatedButton.styleFrom(
            //         minimumSize: const Size(double.infinity, 44),
            //         backgroundColor: primaryColor,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(8),
            //         ),
            //       ),
            //       onPressed: onContinue,
            //       child: const Text(
            //         'Continue',
            //         style: TextStyle(
            //           fontWeight: FontWeight.w600,
            //           fontSize: 16.0,
            //           color: whiteText,
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            ),
      ),
    );
  }
}
