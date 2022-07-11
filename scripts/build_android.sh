cd ..;
build_arm64(){
  mkdir -p android/src/main/jniLibs/arm64-v8a
  cargo build --target aarch64-linux-android --release;
  cp target/aarch64-linux-android/release/liblamber.so  android/src/main/jniLibs/arm64-v8a/liblamber.so
}

build_armv7(){
  mkdir -p android/src/main/jniLibs/armeabi-v7a
  cargo build --target armv7-linux-androideabi --release;
  cp target/armv7-linux-androideabi/release/liblamber.so  android/src/main/jniLibs/armeabi-v7a/liblamber.so
}
build_x86_64(){
  mkdir -p android/src/main/jniLibs/x86_64
  cargo build --target x86_64-linux-android --release;
  cp target/x86_64-linux-android/release/liblamber.so  android/src/main/jniLibs/x86_64/liblamber.so
}

build_arm64
build_armv7
build_x86_64