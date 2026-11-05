# Work Zone Activity Manager

This application allows authenticated personnel to report work zone-based activities from the field. This includes the following:

- Reports: Reporting ongoing one-off work in the field, ex. lighting repair
  - static - non-moving events
  - mobile - dynamic events, tied to a license plate number of on-device location syncing
- Recordings: Mapping a work zone road section or activity area by driving through and recording signage/worker presence
- Uploading and downloading reports/recordings

This application was built off the [Work Zone Data Collection Tool](https://github.com/TonyEnglish/Work_Zone_Data_Collection_Toolset)


## Installation
This project requires flutter version 3.24.5 or above. To ugprade an existing version of flutter, simply run:
```sh
flutter upgrade v3.24.5
```

### fvm
Installing
```
dart pub global activate fvm
fvm use
fvm flutter --version
fvm flutter clean
fvm flutter pub get
fvm flutter run # or run it through vscode
```

Changing Version

```
fvm install 3.24.5
fvm use 3.24.5
```

### Protobuf
Install protoc compiler: [Protoc Installation](https://grpc.io/docs/protoc-installation/)

Verify installation
```sh
protoc --version
```

## Build Runner
The build_runner is used to generate json serializers and deserializers. To run the build_runner, use the following command:
```sh
dart run build_runner build --delete-conflicting-outputs
```

### Generating Protobuf Files
To re-generate protobuf classes from the shared `wz-datahub-schemas` project (a sibling folder in this repo), run:
```sh
./generate_proto.sh
```