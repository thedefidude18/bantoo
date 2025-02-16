import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flexx_bet/constants/colors.dart';
import 'package:flexx_bet/constants/images.dart';
import 'package:flexx_bet/ui/wallet/widget/pay_confirm_bottom_sheet.dart';
import 'package:flexx_bet/ui/components/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui' as ui;
// ignore: depend_on_referenced_packages
import 'package:image/image.dart' as image;
import 'package:flutter/services.dart';

Future<double> paymentBottomSheet(int selectedIndex) async {
  print('Selected Index: $selectedIndex');
  double currentSliderValue = 0;
  double exchangeRate = 0;
  String selectedCrypto = ''; // Default cryptocurrency
  bool isFetchingRate = false; // To handle loading state for exchange rate

  if (selectedIndex == 1) {
    isFetchingRate = true;
    selectedCrypto = 'USDT';
    exchangeRate = await fetchExchangeRate(selectedCrypto);
    isFetchingRate = false;
    print("${selectedCrypto} to NGN/ETH Rate: $exchangeRate");
  }


  await Get.bottomSheet(Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      width: Get.width,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8.0, top: 8, left: 16, right: 16),
        child: StatefulBuilder(
          builder: (context, setState) {
            // Helper function to get currency symbol
            String getCurrencySymbol(String crypto) {
              switch (crypto) {
                case 'USDT':
                case 'USDC':
                  return '\$';
                case 'ETH':
                  return 'Ξ';
                default:
                  return '\$';
              }
            }

            // Helper function to create predefined amount buttons
            Widget predefinedAmountButton(double value) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (selectedIndex == 1) {
                      if (selectedCrypto == 'ETH') {
                        // For ETH, set slider value based on USD to ETH conversion
                        currentSliderValue = value;
                      } else {
                        // For USDT/USDC, set slider value as USD amount
                        currentSliderValue = value;
                      }
                    } else {
                      // For NGN, set slider value based on NGN amount divided by 10
                      currentSliderValue = value / 10;
                    }
                  });
                },
                child: Container(
                  margin: const EdgeInsets.all(4),
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(15)),
                  child: Center(
                    child: selectedIndex == 1
                        ? Text(
                            selectedCrypto == 'ETH' ? "\$ ${value.toInt()}" : "\$ ${value.toInt()}",
                            style: TextStyle(fontSize: 18, fontFamily: 'Inter', color: ColorConstant.primaryColor, fontWeight: FontWeight.w600),
                          )
                        : Text(
                            "₦${value.toInt()}",
                            style: TextStyle(fontSize: 18, fontFamily: 'Inter', color: ColorConstant.primaryColor, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              );
            }


              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  // Title
                  const Center(
                    child: Text(
                      "Top Up Amount",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Inter'),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Dropdown for Cryptocurrency Selection
                  if (selectedIndex == 1)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Select Crypto: ",
                          style: TextStyle(fontSize: 16, fontFamily: 'Inter'),
                        ),
                        DropdownButton<String>(
                          value: selectedCrypto,
                          items: <String>['USDT', 'USDC', 'ETH'].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: const TextStyle(fontSize: 16, fontFamily: 'Inter')),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async {
                            if (newValue != null) {
                              setState(() {
                                selectedCrypto = newValue;
                                exchangeRate = 0;
                                isFetchingRate = true;
                                currentSliderValue = 0;
                              });
                              exchangeRate = await fetchExchangeRate(newValue);
                              print("${selectedCrypto} to NGN/ETH Rate: $exchangeRate");
                              setState(() {
                                isFetchingRate = false;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  if (selectedIndex == 1)
                    const SizedBox(
                      height: 10,
                    ),
                  const Text(
                    "Amount",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, fontFamily: 'Inter'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Display Amount with Currency Symbol
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(
                        Icons.minimize,
                        color: Colors.grey,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (selectedIndex == 1)
                            Text(
                              getCurrencySymbol(selectedCrypto),
                              style: const TextStyle(color: Colors.grey, fontSize: 15, fontFamily: 'Inter'),
                            )
                          else
                            const Text(
                              "",
                              style: TextStyle(color: Colors.grey, fontSize: 15, fontFamily: 'Inter'),
                            ),
                          Text(
                            selectedIndex == 1 ? (selectedCrypto == 'ETH' ? (currentSliderValue * exchangeRate).toStringAsFixed(4) : " ${currentSliderValue.toStringAsFixed(2)}") : "₦${(currentSliderValue * 10).toInt()}",
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: 'Inter',),
                          ),
                        ],
                      ),
                      const Icon(Icons.add, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // Slider with Custom Thumb
                  FutureBuilder(
                    future: getUiImage(ImageConstant.sliderButton, 15, 20),
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? SliderTheme(
                              data: SliderThemeData(
                                activeTrackColor: ColorConstant.primaryColor,
                                thumbShape: SliderThumbImage(image: snapshot.data!),
                              ),
                              child: Slider(
                                value: currentSliderValue,
                                min: selectedIndex == 1 ? 0.0 : 0.0, // Adjust if needed
                                max: selectedIndex == 1
                                    ? 1000.0 // Max USD amount for crypto
                                    : 1000.0, // Max NGN amount divided by 10
                                divisions: selectedIndex == 1 ? 1000 : 1000, // Adjust divisions as needed
                                label: selectedIndex == 1
                                    ? selectedCrypto == 'ETH'
                                        ? currentSliderValue.toStringAsFixed(2)
                                        : "\$${currentSliderValue.toStringAsFixed(2)}"
                                    : (currentSliderValue * 10).round().toString(),
                                onChanged: (double value) {
                                  setState(() {
                                    currentSliderValue = value;
                                  });
                                },
                              ),
                            )
                          : Container();
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Predefined Amount Buttons
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 3,
                    runSpacing: 8,
                    children: [
                      predefinedAmountButton(5.0),
                      predefinedAmountButton(10.0),
                      predefinedAmountButton(15.0),
                      predefinedAmountButton(20.0),
                      predefinedAmountButton(50.0),
                      predefinedAmountButton(100.0),
                      predefinedAmountButton(200.0),
                      predefinedAmountButton(500.0),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Topup Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        width: Get.width / 1.1,
                        padding: ButtonPadding.PaddingAll4,
                        text: "Topup",
                        fontStyle: ButtonFontStyle.PoppinsMedium16,
                        onTap: () async {
                          if (selectedIndex == 1 && exchangeRate == 0) {
                            Get.snackbar("Error", "Failed to fetch the exchange rate.", snackPosition: SnackPosition.BOTTOM);
                            return;
                          }

                          Get.back();

                          double topupAmount;
                          if (selectedIndex == 1) {
                            if (selectedCrypto == 'ETH') {
                              topupAmount = (currentSliderValue * exchangeRate);
                            } else {
                              topupAmount = currentSliderValue;
                            }
                          } else {
                            topupAmount = (currentSliderValue * 10).roundToDouble();
                          }

                          await paymentConfirmBottomSheet(topupAmount, selectedIndex, exchangeRate,selectedCrypto);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              );

          },
        ),
      )));
  return currentSliderValue;
}

/// Fetches the exchange rate based on the selected cryptocurrency.
/// For ETH: Fetches ETH per USD.
/// For USDT/USDC: Fetches NGN per USD.
Future<double> fetchExchangeRate(String crypto) async {
  String url;
  if (crypto == 'ETH') {
    // Fetch ETH per USD
    url = 'https://api.coinbase.com/v2/exchange-rates?currency=USD';
  } else if (crypto == 'USDT' || crypto == 'USDC') {
    // Fetch NGN per USD
    url = 'https://api.coinbase.com/v2/exchange-rates?currency=USD';
  } else {
    // Default to USD to NGN
    url = 'https://api.coinbase.com/v2/exchange-rates?currency=USD';
  }

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (crypto == 'ETH') {
        double ethRate = double.parse(data['data']['rates']['ETH']);
        return ethRate; // ETH per USD
      } else {
        double ngnRate = double.parse(data['data']['rates']['NGN']);
        return ngnRate; // NGN per USD
      }
    } else {
      print("Failed to fetch the exchange rate.");
      return 0;
    }
  } catch (e) {
    print("Error: $e");
    return 0;
  }
}

/// Converts asset image to ui.Image
Future<ui.Image> getUiImage(String imageAssetPath, int height, int width) async {
  final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
  image.Image? baseSizeImage = image.decodeImage(assetImageByteData.buffer.asUint8List());
  if (baseSizeImage == null) {
    throw Exception("Failed to decode image");
  }
  image.Image resizeImage = image.copyResize(baseSizeImage, height: height, width: width);
  ui.Codec codec = await ui.instantiateImageCodec(image.encodePng(resizeImage));
  ui.FrameInfo frameInfo = await codec.getNextFrame();
  return frameInfo.image;
}

/// Custom Slider Thumb with Image
class SliderThumbImage extends SliderComponentShape {
  final ui.Image image;

  SliderThumbImage({required this.image});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required Size sizeWithOverflow,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double textScaleFactor,
    required double value,
  }) {
    final canvas = context.canvas;
    final imageWidth = image.width.toDouble();
    final imageHeight = image.height.toDouble();

    Offset imageOffset = Offset(
      center.dx - (imageWidth / 2),
      center.dy - (imageHeight / 2),
    );

    Paint paint = Paint()..filterQuality = FilterQuality.high;

    canvas.drawImage(image, imageOffset, paint);
  }
}
