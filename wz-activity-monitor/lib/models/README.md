## JSON Serialization

The [json_annotation](https://pub.dev/packages/json_annotation) and [build_runner](https://pub.dev/packages/build_runner) packages are used automatically generate JSON serialization/deserialization methods. The build_runner will generate new files, named "\*class_name\*.g.dart". After any changes to the data classes, make sure to run the build runner to regenerate the serialization/deserialization methods.

### Running the build runner

To run the build_runner once:

```
dart run build_runner build --delete-conflicting-outputs
```

To run the build_runner in watch mode:

```
dart run build_runner watch
```