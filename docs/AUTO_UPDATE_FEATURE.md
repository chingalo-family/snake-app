# Android Auto-Update Feature

## Overview

This feature enables automatic update checking and installation for Android devices. The app checks for updates from a DHIS2 datastore during launch and prompts users to download and install new versions.

## Architecture

### Components

1. **AppUpdateVersion Model** (`lib/core/models/app_update_version.dart`)
   - Represents version information from the server
   - Provides version comparison logic
   - Parses JSON from the datastore

2. **AppUpdateService** (`lib/core/services/app_update_service.dart`)
   - Checks for updates from DHIS2 datastore
   - Downloads APK files with progress tracking
   - Handles all update-related network operations

3. **AppUpdateState** (`lib/core/app_state/app_update_state/app_update_state.dart`)
   - Manages update flow states (checking, downloading, etc.)
   - Provides download progress information
   - Follows the app's Provider pattern for state management

4. **AppUpdateDialog** (`lib/core/components/app_update_dialog.dart`)
   - Displays update confirmation dialog
   - Shows download progress
   - Triggers Android system installer

## Update Flow

```
1. App Launch (Splash Screen)
   ↓
2. Check if user is logged in
   ↓ (if logged in)
3. Query DHIS2 Datastore (namespace: "snake_app_update", key: "app_release")
   ↓
4. Compare remote version with current version (1.0.1)
   ↓ (if newer version available)
5. Show update dialog to user
   ↓ (if user confirms)
6. Download APK with progress indicator
   ↓
7. Trigger Android System Installer
   ↓
8. User installs via Android system UI
```

## Server Setup

### DHIS2 Datastore Configuration

The server must maintain a `version.json` file in the DHIS2 datastore:

- **Namespace**: `snake_app_update`
- **Key**: `app_release`

**Example JSON structure:**
```json
{
  "version": "1.2.0",
  "apk_url": "https://example.com/app-release.apk"
}
```

### Creating the Datastore Entry

Using DHIS2 API:
```bash
curl -X POST "https://your-dhis2-instance/api/dataStore/snake_app_update/app_release" \
  -H "Content-Type: application/json" \
  -u username:password \
  -d '{
    "version": "1.2.0",
    "apk_url": "https://example.com/app-release.apk"
  }'
```

### Updating the Datastore Entry

```bash
curl -X PUT "https://your-dhis2-instance/api/dataStore/snake_app_update/app_release" \
  -H "Content-Type: application/json" \
  -u username:password \
  -d '{
    "version": "1.3.0",
    "apk_url": "https://example.com/app-release-v1.3.0.apk"
  }'
```

## Android Permissions

The following permissions are required and have been added to `AndroidManifest.xml`:

- `android.permission.INTERNET` - Already present, required for network operations
- `android.permission.REQUEST_INSTALL_PACKAGES` - Required to install APK files

## Dependencies

Added to `pubspec.yaml`:

- `path_provider: ^2.1.5` - For accessing device storage directories
- `install_plugin: ^2.1.0` - For triggering Android APK installation

## Security Considerations

1. **HTTPS Only**: The APK URL should always use HTTPS to prevent man-in-the-middle attacks
2. **Authentication**: Update checks are only performed for logged-in users with valid DHIS2 credentials
3. **Version Validation**: The app validates version numbers before prompting for updates
4. **User Confirmation**: Updates require explicit user confirmation before downloading
5. **Android System Installer**: Final installation is handled by Android's system installer, which verifies APK signatures

## Version Comparison Logic

The version comparison follows semantic versioning (MAJOR.MINOR.PATCH):

- `1.2.0` is newer than `1.1.9`
- `2.0.0` is newer than `1.9.9`
- `1.0.2` is newer than `1.0.1`

## User Experience

### Update Available Dialog
- Shows new version number and current version
- Provides "Later" and "Download & Install" buttons
- Uses app's color scheme (cyan) for consistency

### Download Progress
- Shows linear progress indicator
- Displays percentage completion
- Non-dismissible during download

### Installation
- Automatically triggers Android system installer
- User must approve installation through Android system UI
- App closes the dialog after triggering installer

## Testing

### Manual Testing Steps

1. **Test with no update available:**
   - Set datastore version to current or lower version
   - Launch app as logged-in user
   - App should proceed to game without showing dialog

2. **Test with update available:**
   - Set datastore version higher than current (e.g., "1.2.0")
   - Launch app as logged-in user
   - Verify update dialog appears with correct version info

3. **Test download and install:**
   - Confirm download in dialog
   - Verify progress indicator shows
   - Verify Android installer launches after download

4. **Test "Later" option:**
   - Click "Later" in update dialog
   - Verify app proceeds to game normally

5. **Test offline scenario:**
   - Disable network
   - Launch app
   - Verify app proceeds normally without errors

## Troubleshooting

### Update Check Fails Silently
- Check network connectivity
- Verify DHIS2 credentials are correct
- Verify datastore namespace and key exist
- Check server URL configuration

### Download Fails
- Verify APK URL is accessible
- Check network permissions
- Verify sufficient storage space

### Installation Fails
- Verify REQUEST_INSTALL_PACKAGES permission
- Check if "Install from Unknown Sources" is enabled for the app
- Verify APK file is not corrupted

## Future Enhancements

Potential improvements for future versions:

1. **Forced Updates**: Add support for mandatory updates that prevent app usage
2. **Release Notes**: Display changelog in update dialog
3. **Background Downloads**: Download updates in background while user uses app
4. **Rollback Support**: Track previous version for rollback capability
5. **Update Scheduling**: Allow users to schedule updates for later
6. **Delta Updates**: Download only changed files instead of full APK
