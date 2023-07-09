import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:riviera23/cubit/merch/merch_cubit.dart';
import 'package:riviera23/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';
import '../../data/models/merch_model.dart';
import '../../utils/constants/strings/asset_paths.dart';
import '../../utils/constants/strings/strings.dart';
import '../methods/launch_url.dart';

class MerchScreen extends StatefulWidget {
  const MerchScreen({super.key});

  @override
  State<MerchScreen> createState() => _MerchScreenState();
}

class _MerchScreenState extends State<MerchScreen> {
  bool showSizeChart = false;

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
        appBar: buildAppBar(),
        body: buildBody());
  }

  BlocBuilder<MerchCubit, MerchState> buildBody() {
    return BlocBuilder<MerchCubit, MerchState>(
      builder: (context, state) {
        if (state is MerchSuccess) {
          List<Merch> merchList = state.merchsList;
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
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      elevation: 0,
      title: const Text(
        Strings.merchTitle,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 20,
            fontFamily: 'Axis'),
      ),
      centerTitle: true,
    );
  }
}

Widget getMerchCard(Merch merch, BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Column(
      children: [
        SizedBox(
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
                  AssetPaths.placeholder,
                  fit: BoxFit.fitWidth,
                ),
              )),
        ),
        const SizedBox(height: 10),
        Text(
          merch.name,
          style: GoogleFonts.sora(
              color: Colors.white, fontWeight: FontWeight.w500, fontSize: 17),
        ),
        Text(
          Strings.getMerchPrice(merch.price),
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
                const SizedBox(
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
                const SizedBox(
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
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: MediaQuery.of(context).size.width,
                                child: showSizeChart
                                    ? SizedBox(
                                        height: 250,
                                        width: 200,
                                        child:
                                            Image.asset(AssetPaths.sizeChart),
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
                                            Image.asset(AssetPaths.placeholder),
                                        fit: BoxFit.cover,
                                      )),
                          ),
                        ],
                      ),
                      const SizedBox(
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
                                  Strings.sizeChart,
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
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          Strings.description,
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
                      const SizedBox(
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
                                      Strings.getMerchPrice(merch.price),
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
                                child: SizedBox(
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
                                    launchURL(Strings.vtopLink, context, true);
                                  },
                                  child: Text(
                                    Strings.buyNow,
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
                      const SizedBox(
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
