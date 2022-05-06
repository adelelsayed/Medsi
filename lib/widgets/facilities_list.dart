import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:medsi/widgets/facility_widget.dart';
import 'package:medsi/provider_utils/facilities_provider.dart';

class FacilitiesListAndroid extends StatelessWidget {
  const FacilitiesListAndroid({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final facilitiesListObj = Provider.of<FacilitiesProvider>(context);
    //log(facilitiesListObj.facilities.length.toString());
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) => FacilityWidget(
              facilityObj: facilitiesListObj.facilities[index],
              facilitiesListObjProv: facilitiesListObj,
            ),
            itemCount: facilitiesListObj.facilities.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
          ),
        ),
      ],
    );
  }
}
