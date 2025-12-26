class AppUpdateVersion {
  final String version;
  final String apkUrl;

  AppUpdateVersion({
    required this.version,
    required this.apkUrl,
  });

  factory AppUpdateVersion.fromJson(Map<String, dynamic> json) {
    return AppUpdateVersion(
      version: json['version'] as String,
      apkUrl: json['apk_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'apk_url': apkUrl,
    };
  }

  bool isNewerThan(String currentVersion) {
    List<int> current = _parseVersion(currentVersion);
    List<int> remote = _parseVersion(version);

    for (int i = 0; i < 3; i++) {
      if (remote[i] > current[i]) return true;
      if (remote[i] < current[i]) return false;
    }
    return false;
  }

  List<int> _parseVersion(String version) {
    List<String> parts = version.split('.');
    return [
      parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0,
      parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
      parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0,
    ];
  }
}
