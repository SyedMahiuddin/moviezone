import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:moviezone/Controller/map_controller.dart';
import 'package:moviezone/Helpers/common_components.dart';
import 'package:moviezone/Helpers/space_helper.dart';

import '../Helpers/color_helper.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  _MapScreenState createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {

MapController mapController=Get.put(MapController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SizedBox( height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,),
            Align(
              alignment: Alignment.center,
              child: Obx(()=>SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child:
                GoogleMap(
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onMapCreated: mapController.onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: mapController.initialPosition.value,
                    zoom: 12,
                  ),
                  markers: mapController.allMarkers.cast<Marker>().toSet(),
                  polylines: {
                    Polyline(
                        polylineId: const PolylineId("route"),
                        points: mapController.polylineCoordinates.value
                            .map((geoPoint) =>
                            LatLng(geoPoint.latitude, geoPoint.longitude))
                            .toList(),
                        color: ColorHelper.primaryTheme,
                        width: 7)
                  },
                ),
              )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildBottomCard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCard(){
    return Obx(()=>Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: ColorHelper.darkGrey,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10.r,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: mapController.selectedMarker.isNotEmpty? Row(
        children: [
          SizedBox(
            width: 145.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mapController.selectedMarker[0].name,
                  style: TextStyle(
                    color: ColorHelper.primaryText,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SpaceHelper.verticalSpace10,
                Text(
                  'Distance: 3.2 km',
                  style: TextStyle(
                    color: ColorHelper.primaryText,
                    fontSize: 14.sp,
                  ),
                ),
                SpaceHelper.verticalSpace10,
                SizedBox(

                  child: CommonComponents().commonButton(color:ColorHelper.secondryTheme,
                      text:mapController.polylineCoordinates.isNotEmpty?"Cancel": "Get Direction", onPressed: (){
                        if(mapController.polylineCoordinates.isNotEmpty)
                        {
                          mapController.polylineCoordinates.clear();
                          mapController.polyLines.clear();
                          mapController.mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                            target: mapController.initialPosition.value,
                            zoom: 12,
                          ),));
                        }
                        else{
                          mapController.polylineCoordinates.clear();
                          mapController.polyLines.clear();
                          mapController.getPolyline();

                        }

                      }),
                ),



              ],
            ),
          ),
          SpaceHelper.horizontalSpace10,
          Container(
            height: 80.h,
            width: 130.w,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(width:1,color: ColorHelper.secondryTheme.withOpacity(0.5))
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14.r),
              child: Image.network(
                height: 80.h,
                width: 130.w,mapController.selectedMarker[0].imageUrl,fit: BoxFit.cover,),
            ),
          )
        ],
      ):
      SizedBox(
        height: 150.h,
        width: 200.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 40.r,
              backgroundImage:mapController.allMarkers.isEmpty?
              const AssetImage("assets/images/finding.gif"):const AssetImage("assets/images/found.gif"),
            )
            ,SpaceHelper.verticalSpace15,
            CommonComponents().printText(fontSize: 18,
                textData:mapController.allMarkers.isEmpty?"Searching for you in 10Km":
                "${mapController.allMarkers.length.toString()} theater found nearby", color:Colors.green,fontWeight: FontWeight.bold)
          ],
        ),
      ),
    ));
  }
}
