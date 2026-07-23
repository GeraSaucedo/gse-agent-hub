#!/bin/bash
set -e

KEYSTORE_PATH="android/app/upload-keystore.jks"
KEY_PROPS_PATH="android/key.properties"
KEY_ALIAS="upload"
DNAME="CN=GSE, OU=Dev, O=IENTC, L=City, ST=State, C=MX"

# ===== Ask for password =====
read -sp "Enter keystore password: " STORE_PASS
echo ""

if [ -z "$STORE_PASS" ]; then
    echo "ERROR: Password cannot be empty."
    exit 1
fi

# ===== Find keytool =====
KEYTOOL=""

# 1. JAVA_HOME
if [ -n "$JAVA_HOME" ] && [ -x "$JAVA_HOME/bin/keytool" ]; then
    KEYTOOL="$JAVA_HOME/bin/keytool"
    echo "Found keytool in JAVA_HOME: $KEYTOOL"
fi

# 2. Android Studio bundled JDK (macOS)
if [ -z "$KEYTOOL" ]; then
    for dir in \
        "/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin/keytool" \
        "$HOME/Library/Application Support/Google/AndroidStudio/jbr/bin/keytool"; do
        if [ -x "$dir" ]; then
            KEYTOOL="$dir"
            echo "Found keytool in Android Studio: $KEYTOOL"
            break
        fi
    done
fi

# 3. System PATH
if [ -z "$KEYTOOL" ] && command -v keytool &>/dev/null; then
    KEYTOOL="keytool"
    echo "Found keytool in PATH."
fi

if [ -z "$KEYTOOL" ]; then
    echo "ERROR: keytool not found."
    echo "Install a JDK or set JAVA_HOME."
    exit 1
fi

# ===== Generate keystore =====
if [ -f "$KEYSTORE_PATH" ]; then
    echo "Keystore already exists, skipping."
else
    echo "Generating keystore..."
    "$KEYTOOL" -genkey -v \
        -keystore "$KEYSTORE_PATH" \
        -storetype JKS \
        -keyalg RSA \
        -keysize 2048 \
        -validity 10000 \
        -alias "$KEY_ALIAS" \
        -storepass "$STORE_PASS" \
        -keypass "$STORE_PASS" \
        -dname "$DNAME"
    echo "Keystore created successfully."
fi

# ===== Generate key.properties =====
if [ -f "$KEY_PROPS_PATH" ]; then
    echo "key.properties already exists, skipping."
else
    echo "Generating key.properties..."
    cat > "$KEY_PROPS_PATH" <<EOF
storePassword=$STORE_PASS
keyPassword=$STORE_PASS
keyAlias=$KEY_ALIAS
storeFile=../app/upload-keystore.jks
EOF
    echo "key.properties created successfully."
fi

echo "Done."
