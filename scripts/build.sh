#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# ---------- 版本配置 ----------
MARKETING_VERSION="${APP_VERSION:-1.2.3}"

if [ -n "${CI_BUILD_NUMBER:-}" ]; then
  CURRENT_PROJECT_VERSION="$CI_BUILD_NUMBER"
else
  CURRENT_PROJECT_VERSION="$(git rev-list --count HEAD)"
fi

# ---------- 认证环境变量检测 ----------
MISSING_VARS=()
[ -z "${AUTH_KEY_ID:-}" ]        && MISSING_VARS+=("AUTH_KEY_ID")
[ -z "${AUTH_KEY_ISSUER_ID:-}" ] && MISSING_VARS+=("AUTH_KEY_ISSUER_ID")

if [ ${#MISSING_VARS[@]} -gt 0 ]; then
  echo "❌ Missing required environment variables: ${MISSING_VARS[*]}" >&2
  echo "   Please export them before running this script." >&2
  exit 1
fi

AUTH_KEY_P8_PATH="$PROJECT_ROOT/.private_keys/AuthKey_${AUTH_KEY_ID}.p8"
if [ ! -f "$AUTH_KEY_P8_PATH" ]; then
  echo "❌ Auth key not found: $AUTH_KEY_P8_PATH" >&2
  echo "   Place your App Store Connect API key (.p8) at the path above." >&2
  exit 1
fi

ARCHIVE_PATH="$PROJECT_ROOT/build/ScriptWidget.xcarchive"
EXPORT_PATH="$PROJECT_ROOT/build/output"
EXPORT_OPTIONS="$PROJECT_ROOT/scripts/ExportOptions.plist"

echo "📦 Building:"
echo "   MARKETING_VERSION=$MARKETING_VERSION"
echo "   CURRENT_PROJECT_VERSION=$CURRENT_PROJECT_VERSION"

# ---------- 前置依赖 ----------
echo "📦 Installing dependencies and building tools..."
cd "$PROJECT_ROOT"
pnpm install
pnpm build:tools

cd "$PROJECT_ROOT/Editor/editorfe"
pnpm run build

# ---------- 构建输出目录 ----------
mkdir -p "$PROJECT_ROOT/build"

# ---------- Archive ----------
echo "📦 Archiving..."
xcodebuild \
  -project "$PROJECT_ROOT/iOS/ScriptWidget.xcodeproj" \
  -scheme "ScriptWidget" \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  clean archive \
  -archivePath "$ARCHIVE_PATH" \
  MARKETING_VERSION="$MARKETING_VERSION" \
  CURRENT_PROJECT_VERSION="$CURRENT_PROJECT_VERSION" \
  CODE_SIGN_STYLE=Automatic \
  DEVELOPMENT_TEAM="T68XK6867P"

# ---------- 导出 IPA ----------
echo "📦 Exporting IPA..."
xcodebuild \
  -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportOptionsPlist "$EXPORT_OPTIONS" \
  -exportPath "$EXPORT_PATH" \
  -allowProvisioningUpdates \
  -authenticationKeyPath "$AUTH_KEY_P8_PATH" \
  -authenticationKeyID "$AUTH_KEY_ID" \
  -authenticationKeyIssuerID "$AUTH_KEY_ISSUER_ID" \

echo "✅ Done! IPA exported to: $EXPORT_PATH"
