target=aarch64-apple-darwin
cd ..
cargo build --target "$target" --release
cp target/"$target"/release/liblamber.a macos/liblamber.a