import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {

  static Future<bool> requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    await _permissionHandler.shouldShowRequestPermissionRationale(permission);
    final Map<PermissionGroup, PermissionStatus> result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  static Future<bool> hasPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var permissionStatus = await _permissionHandler.checkPermissionStatus(permission);
    return permissionStatus == PermissionStatus.granted;
  }
}
