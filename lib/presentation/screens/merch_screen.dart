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
            style: GoogleFonts.sora(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),
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
                      // crossAxisCount: 2,
                      // mainAxisSpacing: 10,
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
                        return getMerchCard(merchList[index], context);
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
  return GestureDetector(
    onTap: () {
      showPopUpMerch(merch, context);
    },
    child: Padding(
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
              )
            ),
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
    ),
  );
}



showPopUpMerch(Merch merch, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: EdgeInsets.only(
            top: 0.0,
          ),
          content: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 400,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: CachedNetworkImage(
                          height: 400,
                          imageUrl: merch.url.toString(),
                          imageBuilder: (context, imageProvider) => Container(
                            height: 400,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.fitHeight),
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
                        )
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(8, 8, 10, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          merch.name,
                          style: GoogleFonts.sora(
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 20),
                        ),
                        Text(
                          "Rs ${merch.price}",
                          style: GoogleFonts.sora(
                              color: AppColors.highlightColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 2, 8, 8),
                    child: Text(
                      merch.desc,
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _launchURLBrowser("https://vtop.vit.ac.in/vtop/login", context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primaryColor,
                        // fixedSize: Size(250, 50),
                      ),
                      child: Text(
                        "BUY NOW",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
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

