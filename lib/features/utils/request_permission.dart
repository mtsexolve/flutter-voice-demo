import 'package:permission_handler/permission_handler.dart';

Future<PermissionStatus> requestPermission(Permission permission) async {
  if (!await permission.isGranted) {
    if (await permission.request().isGranted) {
      return PermissionStatus.granted;
    } else {
      return PermissionStatus.denied;
    }
  } else {
    return PermissionStatus.granted;
  }
}

Future<PermissionStatus> checkPermission(Permission permission) async {
  if (!await permission.isGranted) {
    return PermissionStatus.denied;
  } else {
    return PermissionStatus.granted;
  }
}
