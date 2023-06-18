import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/cubit/merch/merch_cubit.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/models/merch_model.dart';
import '../methods/custom_flushbar.dart';

class MerchScreen extends StatefulWidget {
  @override
  State<MerchScreen> createState() => _MerchScreenState();
}

class _MerchScreenState extends State<MerchScreen> {
  var showSizeChart = false;

  @override
  void initState() {
    super.initState();
    showSizeChart = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.primaryColor,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          title: Text(
            'Merchandise',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 20,
                fontFamily: 'Axis'),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<MerchCubit, MerchState>(
          builder: (context, state) {
            if (state is MerchSuccess) {
              var merchList = state.merchsList;
              return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: merchList.length,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        childAspectRatio: (MediaQuery.of(context).size.width) /
                            (MediaQuery.of(context).size.height * 0.7),
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              setState(() {
                                showSizeChart = false;
                              });
                              showBottomMerchScreen(
                                  context, merchList[index], showSizeChart);
                            },
                            child: getMerchCard(merchList[index], context));
                      }));
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
          },
        ));
  }
}

Widget getMerchCard(Merch merch, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      children: [
        Container(
          height: 160,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: CachedNetworkImage(
                height: 160,
                imageUrl: merch.url.toString(),
                imageBuilder: (context, imageProvider) => Container(
                  height: 160,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.primaryColor,
                  highlightColor: Colors.grey,
                  child: Container(
                    color: Colors.grey,
                  ),
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/placeholder.png',
                  fit: BoxFit.fitWidth,
                ),
              )),
        ),
        SizedBox(height: 10),
        Text(
          merch.name,
          style: GoogleFonts.sora(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
        ),
        Text(
          "Rs ${merch.price}",
          style: GoogleFonts.sora(
              color: AppColors.highlightColor,
              fontWeight: FontWeight.w500,
              fontSize: 12),
        )
      ],
    ),
  );
}

void showBottomMerchScreen(BuildContext context, Merch merch, showSizeChart) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              color: AppColors.cardBgColor,
            ),
            height: MediaQuery.of(context).size.height * 0.92,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Container(
                    height: 5,
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Stack(
                        children: [
                          ShaderMask(
                            shaderCallback: (rect) {
                              return const LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.center,
                                colors: [Colors.black, Colors.transparent],
                              ).createShader(
                                  Rect.fromLTRB(0, 0, rect.width, rect.height));
                            },
                            blendMode: BlendMode.dstOut,
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width,
                                child: showSizeChart
                                    ? Container(
                                        height: 250,
                                        width: 200,
                                        child: Image.asset("assets/size.jpg"),
                                      )
                                    : CachedNetworkImage(
                                        height: 250,
                                        width: 200,
                                        imageUrl: merch.url.toString(),
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: AppColors.primaryColor,
                                          highlightColor: Colors.grey,
                                          child: Container(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                                "assets/placeholder.png"),
                                        fit: BoxFit.cover,
                                      )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              merch.name.toString().toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 25,
                                  color: AppColors.secondaryColor,
                                  fontFamily: GoogleFonts.sora.toString()),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  showSizeChart = !showSizeChart;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(right: 20),
                                child: Text(
                                  "Size Chart",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 15,
                                      color: showSizeChart
                                          ? AppColors.highlightColor
                                          : AppColors.secondaryColor,
                                      fontFamily: GoogleFonts.sora.toString()),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Description",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: AppColors.secondaryColor,
                              fontFamily: GoogleFonts.sora.toString()),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: Text(
                          merch.desc.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 15,
                              color: Colors.grey,
                              fontFamily: GoogleFonts.sora.toString()),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                        child: Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Text(
                                      "\u{20B9}${merch.price}",
                                      style: TextStyle(
                                        color: AppColors.highlightColor,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(10, 4, 10, 4),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.highlightColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {
                                    _launchURLBrowser(
                                        "https://vtop.vit.ac.in/vtop", context);
                                  },
                                  child: Text(
                                    'BUY NOW',
                                    style: TextStyle(
                                      color: AppColors.secondaryColor,
                                      fontSize: 15,
                                      fontFamily: GoogleFonts.sora.toString(),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
      });
}

void _launchURLBrowser(_url, BuildContext context) async {
  final Uri _uri = Uri.parse(_url);
  try {
    await canLaunchUrl(_uri)
        ? await launchUrl(_uri, mode: LaunchMode.externalApplication)
        : throw 'Could not launch $_uri';
  } catch (e) {
    print(e.toString());
    showCustomFlushbar("Can't Open Link",
        "The link may be null or may have some issues.", context);
  }
}
