cd compiler || goto :error

:: Disable unexpected_cfg warning
echo [lints.rust] >> crates\intern\Cargo.toml || goto :error
echo unexpected_cfgs = { level = 'warn', check-cfg = ['cfg(memory_consistency_assertions)'] } >> crates\intern\Cargo.toml || goto :error

set CARGO_PROFILE_RELEASE_STRIP=symbols
set CARGO_PROFILE_RELEASE_LTO=fat

:: check licenses
cargo-bundle-licenses --format yaml --output %SRC_DIR%\THIRDPARTY.yml || goto :error

:: build
cargo install --bins --no-track --locked --root "%LIBRARY_PREFIX%" --path crates\relay-bin || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit 1
